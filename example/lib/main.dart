import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:xfyy_demo/xfyy_demo.dart';

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

  @override
  void initState() {
    super.initState();

    /// 连接
  }

  AudioPlayer audioPlayer = AudioPlayer();

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
                        _playAudio(path);
                      });
                    },
                    child: const Text("播放")),
              )
            ],
          ),
        ));
  }

  void _playAudio(String filePath) async {
    var i = await audioPlayer.play(filePath, isLocal: true);

    debugPrint("lxp $i");
  }
}
