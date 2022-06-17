import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:xfyy_demo/xfyy_demo.dart';

/// 作者： lixp
/// 创建时间： 2022/6/17 10:21
/// 类介绍：文本转语音
class TextToVoice extends StatefulWidget {
  const TextToVoice({Key? key}) : super(key: key);

  @override
  _TextToVoiceState createState() => _TextToVoiceState();
}

class _TextToVoiceState extends State<TextToVoice> {



  final FlutterSoundPlayer playerModule = FlutterSoundPlayer();


  final TextEditingController _editingController = TextEditingController();



  @override
  void initState() {
    super.initState();

    initPlay();
  }




  /// 初始化播放
  initPlay() async {
    await playerModule.closePlayer();
    await playerModule.openPlayer();
    await playerModule
        .setSubscriptionDuration(const Duration(milliseconds: 10));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('语音合成'),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
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
                    _play(path);
                  });
                },
                child: const Text("播放")),
          ),

        ],
      ),
    );
  }


  void _play(String path) async {
    await playerModule.startPlayer(fromURI: path);
  }
}
