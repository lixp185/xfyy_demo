import 'dart:async';
import 'dart:typed_data';

import 'package:audio_session/audio_session.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:xfyy_demo/xfyy_demo.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '讯飞语音demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _editingController = TextEditingController();

  String text = "";

  XfSocket? xfSocket;

  @override
  void initState() {
    super.initState();

    initPlay();
    initRecorder();
  }

  final FlutterSoundRecorder _mRecorder =
      FlutterSoundRecorder(logLevel: Level.debug);

  final FlutterSoundPlayer playerModule = FlutterSoundPlayer();
  AudioPlayer audioPlayer = AudioPlayer();

   double? vo = 0.0;
  /// 初始化录音
  Future<void> initRecorder() async {
    // var status = await Permission.microphone.request();
    // if (status != PermissionStatus.granted) {
    //   throw RecordingPermissionException('Microphone permission not granted');
    // }
    await _mRecorder.openRecorder();

    print("音量111 : ${_mRecorder.onProgress}");

    // 设置音频音量获取频率
    _mRecorder.setSubscriptionDuration(
      const Duration(milliseconds: 500),
    );
    _mRecorder.onProgress!.listen((event) {
      // 0 - 120
      print("音量 : ${event.decibels}");
      vo = event.decibels;
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

  /// 初始化播放
  initPlay() async {
    await playerModule.closePlayer();
    await playerModule.openPlayer();
    await playerModule
        .setSubscriptionDuration(const Duration(milliseconds: 10));
  }

  StreamSubscription? _mRecordingDataSubscription;

  Future<void> stopRecorder() async {
    await _mRecorder.stopRecorder();
    if (_mRecordingDataSubscription != null) {
      await _mRecordingDataSubscription!.cancel();
      _mRecordingDataSubscription = null;
    }
  }

  /// 0 :第一帧音频
  /// 1 :中间的音频
  /// 2 :最后一帧音频，最后一帧必须要发送
  int state = 0;

  Future<void> record() async {
    var recordingDataController = StreamController<FoodData>();
    _mRecordingDataSubscription =
        recordingDataController.stream.listen((buffer) {
      if (state == 0) {
        xfSocket?.sendVoice(buffer.data!, state: state);
        state = 1;
      } else {
        xfSocket?.sendVoice(buffer.data!, state: state);
        state = 0;
      }
    });
    await _mRecorder.startRecorder(
      toStream: recordingDataController.sink,
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: 16000,
    );

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(hintText: "输入需要转换的语音文本"),
                controller: _editingController,
              ),
              Container(
                child: ElevatedButton(
                    onPressed: () {
                      var text = _editingController.text;
                      XfSocket.connect(text, onFilePath: (path) {
                        // _playAudio(path);
                        _play(path);
                      });
                    },
                    child: const Text("播放")),
              ),
              Container(
                  padding: EdgeInsetsDirectional.all(20),
                  color: Colors.blue,
                  child: GestureDetector(
                    onLongPressStart: (d) {
                      xfSocket = XfSocket.connectVoice(onTextResult: (text) {
                        setState(() {
                          this.text = text;
                        });
                      });
                      record();
                    },
                    child: Text("长按录音"),
                    onTap: () {},
                    onLongPressEnd: (d) {
                      state = 2;
                      stopRecorder();
                    },
                  )),
              Text(text),
              Text("音量：$vo"),
            ],
          ),
        ));
  }

  void _playAudio(String filePath) async {
    var i = await audioPlayer.play(filePath, isLocal: true);

    debugPrint("lxp $i");
  }

  void _play(String path) async {
    await playerModule.startPlayer(fromURI: path);
  }
}
