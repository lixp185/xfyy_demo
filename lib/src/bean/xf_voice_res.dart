/// code : 0
/// message : "success"
/// sid : "iat000dbc43@gz1816be79edd1455802"
/// data : {"result":{"ws":[{"bg":0,"cw":[{"sc":0,"w":""}]}],"sn":1,"ls":true,"bg":0,"ed":0,"pgs":"apd"},"status":2}

/// 作者： lixp
/// 创建时间： 2022/6/16 17:48
/// 类介绍：讯飞语音识别结果
class XfVoiceRes {
  XfVoiceRes({
      int? code, 
      String? message, 
      String? sid, 
      Data? data,}){
    _code = code;
    _message = message;
    _sid = sid;
    _data = data;
}

  XfVoiceRes.fromJson(dynamic json) {
    _code = json['code'];
    _message = json['message'];
    _sid = json['sid'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  int? _code;
  String? _message;
  String? _sid;
  Data? _data;

  int? get code => _code;
  String? get message => _message;
  String? get sid => _sid;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['message'] = _message;
    map['sid'] = _sid;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// result : {"ws":[{"bg":0,"cw":[{"sc":0,"w":""}]}],"sn":1,"ls":true,"bg":0,"ed":0,"pgs":"apd"}
/// status : 2

class Data {
  Data({
      Result? result, 
      int? status,}){
    _result = result;
    _status = status;
}

  Data.fromJson(dynamic json) {
    _result = json['result'] != null ? Result.fromJson(json['result']) : null;
    _status = json['status'];
  }
  Result? _result;
  int? _status;

  Result? get result => _result;
  int? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_result != null) {
      map['result'] = _result?.toJson();
    }
    map['status'] = _status;
    return map;
  }

}

/// ws : [{"bg":0,"cw":[{"sc":0,"w":""}]}]
/// sn : 1
/// ls : true
/// bg : 0
/// ed : 0
/// pgs : "apd"

class Result {
  Result({
      List<Ws>? ws, 
      int? sn, 
      bool? ls, 
      int? bg, 
      int? ed, 
      String? pgs,}){
    _ws = ws;
    _sn = sn;
    _ls = ls;
    _bg = bg;
    _ed = ed;
    _pgs = pgs;
}

  Result.fromJson(dynamic json) {
    if (json['ws'] != null) {
      _ws = [];
      json['ws'].forEach((v) {
        _ws?.add(Ws.fromJson(v));
      });
    }
    _sn = json['sn'];
    _ls = json['ls'];
    _bg = json['bg'];
    _ed = json['ed'];
    _pgs = json['pgs'];
  }
  List<Ws>? _ws;
  int? _sn;
  bool? _ls;
  int? _bg;
  int? _ed;
  String? _pgs;

  List<Ws>? get ws => _ws;
  int? get sn => _sn;
  bool? get ls => _ls;
  int? get bg => _bg;
  int? get ed => _ed;
  String? get pgs => _pgs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_ws != null) {
      map['ws'] = _ws?.map((v) => v.toJson()).toList();
    }
    map['sn'] = _sn;
    map['ls'] = _ls;
    map['bg'] = _bg;
    map['ed'] = _ed;
    map['pgs'] = _pgs;
    return map;
  }

}

/// bg : 0
/// cw : [{"sc":0,"w":""}]

class Ws {
  Ws({
      int? bg, 
      List<Cw>? cw,}){
    _bg = bg;
    _cw = cw;
}

  Ws.fromJson(dynamic json) {
    _bg = json['bg'];
    if (json['cw'] != null) {
      _cw = [];
      json['cw'].forEach((v) {
        _cw?.add(Cw.fromJson(v));
      });
    }
  }
  int? _bg;
  List<Cw>? _cw;

  int? get bg => _bg;
  List<Cw>? get cw => _cw;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bg'] = _bg;
    if (_cw != null) {
      map['cw'] = _cw?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// sc : 0
/// w : ""

class Cw {
  Cw({
      int? sc, 
      String? w,}){
    _sc = sc;
    _w = w;
}

  Cw.fromJson(dynamic json) {
    _sc = json['sc'];
    _w = json['w'];
  }
  int? _sc;
  String? _w;

  int? get sc => _sc;
  String? get w => _w;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sc'] = _sc;
    map['w'] = _w;
    return map;
  }

}