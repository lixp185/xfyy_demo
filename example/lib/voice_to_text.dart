import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';
import 'package:xfyy_demo/xfyy_demo.dart';

import 'canvas/voice_animtor.dart';

/// 作者： lixp
/// 创建时间： 2022/6/17 10:21
/// 类介绍：语音转文本
class VoiceText extends StatefulWidget {
  const VoiceText({Key? key}) : super(key: key);

  @override
  _VoiceTextState createState() => _VoiceTextState();
}

class _VoiceTextState extends State<VoiceText> {
  final FlutterSoundRecorder _mRecorder =
      FlutterSoundRecorder(logLevel: Level.debug);

  /// 实时语音听写
  /// 最长支持1分钟即使语音听写
  /// 超出1分钟请参考语音转写
  Timer? _timer;
  int currentTime = 60;

  XfSocket? xfSocket;

  /// 识别文本
  String text = "";

  /// 是否在说话
  bool isTalking = false;

  /// 声音大小 0 - 120
  ValueNotifier<double> voiceNum = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();

    initRecorder();
  }

  /// 初始化录音
  Future<void> initRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await _mRecorder.openRecorder();

    // 设置音频音量获取频率
    _mRecorder.setSubscriptionDuration(
      const Duration(milliseconds: 100),
    );
    _mRecorder.onProgress!.listen((event) {
      // 0 - 120
      voiceNum.value = event.decibels ?? 0;
    });

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
  }

  StreamSubscription? _mRecordingDataSubscription;

  Future<void> stopRecorder() async {
    await _mRecorder.stopRecorder();
    voiceNum.value = 0.0;
    if (_mRecordingDataSubscription != null) {
      await _mRecordingDataSubscription!.cancel();
      _mRecordingDataSubscription = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('语音识别'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsetsDirectional.only(
                start: 20, end: 20, top: 100, bottom: 50),
            child: Text(
              "识别结果：$text",
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
          VoiceAnimation(voiceNum: voiceNum),
          Container(
              margin: const EdgeInsetsDirectional.only(top: 60),
              width: double.infinity,
              padding: const EdgeInsetsDirectional.all(20),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: isTalking ? Colors.red : Colors.black87, width: 2),
                  // color: Colors.blue,
                  shape: BoxShape.circle),
              child: GestureDetector(
                onLongPressStart: (d) {
                  setState(() {
                    isTalking = true;
                  });
                  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                    currentTime--;
                    if (currentTime == 0) {
                      _timer?.cancel();
                      // 时间结束
                    }
                  });
                  xfSocket = XfSocket.connectVoice(onTextResult: (text) {
                    setState(() {
                      this.text = text;
                    });
                  });
                  state = 0;
                  startRecord();
                },
                child: Icon(
                  Icons.keyboard_voice_rounded,
                  color: isTalking ? Colors.red : Colors.black87,
                  size: 60,
                ),
                onLongPressEnd: (d) {
                  _timer?.cancel();
                  state = 2;
                  setState(() {
                    isTalking = false;
                  });
                  stopRecorder();
                },
              )),
          Container(
            margin: const EdgeInsetsDirectional.only(top: 10),
            child: const Text(
              "长按录音",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  /// 0 :第一帧音频
  /// 1 :中间的音频
  /// 2 :最后一帧音频，最后一帧必须要发送
  int state = 0;

  Future<void> startRecord() async {
    var recordingDataController = StreamController<FoodData>();
    _mRecordingDataSubscription =
        recordingDataController.stream.listen((buffer) {
      if (state == 0) {
        xfSocket?.sendVoice(buffer.data!, state: state);
        state = 1;
      } else if (state == 1) {
        xfSocket?.sendVoice(buffer.data!, state: state);
      } else if (state == 2) {
        xfSocket?.sendVoice(buffer.data!, state: state);
        state = -1;
      }
    });
    await _mRecorder.startRecorder(
      // toFile: "filePath",
      toStream: recordingDataController.sink,
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: 16000,
    );
  }
}
