import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:xfyy_demo/src/bean/xf_res.dart';
import 'package:xfyy_demo/src/bean/xf_text_req.dart';
import 'package:xfyy_demo/src/bean/xf_voice_req.dart';
import 'package:xfyy_demo/src/bean/xf_voice_res.dart';
import 'package:xfyy_demo/src/utils/xf_util.dart';
import 'package:web_socket_channel/status.dart' as status;

/// 配置参数
const String _appId = "83836aa0";
const String _apiKey = "445f5702911ec04cfc9155e1350b2a53";
const String _apiSecret = "Y2M5OTI1MmZjY2NkNWYzZWY5OGJkMDRk";

const String _host = "tts-api.xfyun.cn";
const String _host2 = "iat-api.xfyun.cn";

/// 作者： lixp
/// 创建时间： 2022/6/1 15:57
/// 类介绍：讯飞Socket连接
class XfSocket {
  IOWebSocketChannel? _channel;

  ValueChanged<String>? onFilePath;
  ValueChanged<String>? onTextResult;

  /// 创建连接
  /// listen 转化完成后的回调
  /// 因为鉴权时间戳原因 每次请求都必须重新鉴权连接
  XfSocket.connect(String text, {this.onFilePath}) {
    String u = XfUtil.getAuthUrl(_host, _apiKey, _apiSecret);
    debugPrint('创建连接url = $u');
    close();
    _channel = IOWebSocketChannel.connect(u);
    //创建监听
    _channel?.stream.listen((message) {
      _onMessage(message);
    }, onError: (e) {
      debugPrint(" init error $e");
    });
    sendText(text);
  }

  /// 创建连接 发送语音
  /// listen 转化完成后的回调
  XfSocket.connectVoice({this.onTextResult}) {
    String u = XfUtil.getAuthUrl(_host2, _apiKey, _apiSecret, type: "iat");
    debugPrint('创建连接url = $u');
    close();
    _channel = IOWebSocketChannel.connect(u);
    //创建监听
    _channel?.stream.listen((message) {
      _onMessage(message, type: 2);
    }, onError: (e) {
      debugPrint(" init error $e");
    });
  }

  ///关闭连接
  close([int status = status.goingAway]) {
    debugPrint('关闭连接');
    _channel?.sink.close(status);
  }

  void _onMessage(dynamic data, {int type = 1}) {
    debugPrint("result = $data");
    if (type == 1) {
      var xfRes = XfRes.fromJson(jsonDecode(data));
      var decode = base64.decode(xfRes.data!.audio!);
      debugPrint("result222 = $decode");
      _writeCounter(decode);
    } else {
      var xfVoiceRes = XfVoiceRes.fromJson(jsonDecode(data));
      var code = xfVoiceRes.code;
      var status = xfVoiceRes.data?.status;
      if (code == 0 && status != 2) {
        var result = xfVoiceRes.data?.result;
        var ws = result?.ws;
        StringBuffer resultText = StringBuffer();
        if (ws != null) {
          for (int i = 0; i < ws.length; i++) {
            var cw = ws[i].cw;
            if (cw != null) {
              resultText.write(cw[0].w);
            }
          }
          onTextResult?.call(resultText.toString());
        }
      } else if (status == 2) {
        // 结束
        close();
      } else {
        onTextResult?.call("数据有误:${xfVoiceRes.message}");
      }
    }
  }

  /// 获取文件路径
  Future<String> _getLocalFileDir() async {
    Directory? tempDir = await getExternalStorageDirectory();
    return tempDir!.path;
  }

  /// 获取文件
  Future<File> _getLocalFile() async {
    String dir = await _getLocalFileDir();
    return File("$dir/demo.mp3");
  }

  /// 写入内容
  void _writeCounter(Uint8List decode) async {
    File file = await _getLocalFile();
    file.writeAsBytes(decode, mode: FileMode.write).then((value) {
      debugPrint("result写入文件 $value");
      onFilePath?.call(value.path);
    });
  }

  ///语音转文字
  sendText(String text) {
    XfTextReq xfTextReq = XfTextReq();

    ///设置appId
    Common common = Common();
    common.appId = _appId;
    xfTextReq.common = common;

    Business business = Business();
    business.aue = "lame"; // 音频编码
    business.tte = "UTF8";
    business.pitch = 50;
    business.speed = 40;
    business.vcn = "xiaoyan";
    business.volume = 50; //音量
    business.sfl = 0;
    business.auf = "audio/L16;rate=16000";
    business.bgs = 0;
    business.reg = "0";
    business.rdn = "0";
    xfTextReq.business = business;
    DataReq dataReq = DataReq();
    dataReq.status = 2; //固定
    dataReq.text = base64.encode(utf8.encode(text));
    xfTextReq.data = dataReq;

    debugPrint("input == ${jsonEncode(xfTextReq)}");

    /// 这里一定要jsonEncode转化成字符串json  formJson对象不可以
    _channel?.sink.add(jsonEncode(xfTextReq));
  }

  void sendVoice(Uint8List voice, {int state = 1}) {
    XfVoiceReq xfVoiceReq = XfVoiceReq();

    ///设置appId
    CommonV common = CommonV();
    common.appId = _appId;
    xfVoiceReq.common = common;

    BusinessV business = BusinessV();
    business.language = "zh_cn";
    business.domain = "iat";
    business.accent = "mandarin";
    business.vadEos = 3000;
    business.dwa = "wpgs";
    business.pd = "game";
    business.ptt = 0;
    business.rlang = "zh-cn";
    business.vinfo = 1;
    business.nunum = 0;
    business.speexSize = 70;
    business.nbest = 3;
    business.wbest = 5;

    xfVoiceReq.business = business;
    DataV dataReq = DataV();
    //0 :第一帧音频
    // 1 :中间的音频
    // 2 :最后一帧音频，最后一帧必须要发送
    dataReq.status = state;
    dataReq.format = "audio/L16;rate=16000";
    dataReq.encoding = "raw";
    dataReq.audio = base64.encode(voice);
    xfVoiceReq.data = dataReq;

    String req = jsonEncode(xfVoiceReq);
    _channel?.sink.add(req);
    debugPrint("inputV == $req}");
  }
}
