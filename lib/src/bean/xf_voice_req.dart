/// common : {"app_id":"83836aa0"}
/// business : {"language":"zh_cn","domain":"iat","accent":"xiaoyan","vad_eos":0,"dwa":"","pd":"","ptt":0,"rlang":"zh","vinfo":0,"nunum":0,"speex_size":0,"nbest":0,"wbest":0}
/// data : {"status":2,"format":"iat","encoding":"","audio":""}

/// 作者： lixp
/// 创建时间： 2022/6/16 14:36
/// 类介绍：讯飞语音请求式实体类
class XfVoiceReq {
  XfVoiceReq({
      this.common, 
      this.business, 
      this.data,});

  XfVoiceReq.fromJson(dynamic json) {
    common = json['common'] != null ? CommonV.fromJson(json['common']) : null;
    business = json['business'] != null ? BusinessV.fromJson(json['business']) : null;
    data = json['data'] != null ? DataV.fromJson(json['data']) : null;
  }
  CommonV? common;
  BusinessV? business;
  DataV? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (common != null) {
      map['common'] = common?.toJson();
    }
    if (business != null) {
      map['business'] = business?.toJson();
    }
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

/// status : 2
/// format : "iat"
/// encoding : ""
/// audio : ""

class DataV {
  DataV({
      this.status, 
      this.format, 
      this.encoding, 
      this.audio,});

  DataV.fromJson(dynamic json) {
    status = json['status'];
    format = json['format'];
    encoding = json['encoding'];
    audio = json['audio'];
  }
  int? status;
  String? format;
  String? encoding;
  String? audio;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['format'] = format;
    map['encoding'] = encoding;
    map['audio'] = audio;
    return map;
  }

}

/// language : "zh_cn"
/// domain : "iat"
/// accent : "xiaoyan"
/// vad_eos : 0
/// dwa : ""
/// pd : ""
/// ptt : 0
/// rlang : "zh"
/// vinfo : 0
/// nunum : 0
/// speex_size : 0
/// nbest : 0
/// wbest : 0

class BusinessV {
  BusinessV({
      this.language, 
      this.domain, 
      this.accent, 
      this.vadEos, 
      this.dwa, 
      this.pd, 
      this.ptt, 
      this.rlang, 
      this.vinfo, 
      this.nunum, 
      this.speexSize, 
      this.nbest, 
      this.wbest,});

  BusinessV.fromJson(dynamic json) {
    language = json['language'];
    domain = json['domain'];
    accent = json['accent'];
    vadEos = json['vad_eos'];
    dwa = json['dwa'];
    pd = json['pd'];
    ptt = json['ptt'];
    rlang = json['rlang'];
    vinfo = json['vinfo'];
    nunum = json['nunum'];
    speexSize = json['speex_size'];
    nbest = json['nbest'];
    wbest = json['wbest'];
  }
  String? language;
  String? domain;
  String? accent;
  int? vadEos;
  String? dwa;
  String? pd;
  int? ptt;
  String? rlang;
  int? vinfo;
  int? nunum;
  int? speexSize;
  int? nbest;
  int? wbest;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['language'] = language;
    map['domain'] = domain;
    map['accent'] = accent;
    map['vad_eos'] = vadEos;
    map['dwa'] = dwa;
    map['pd'] = pd;
    map['ptt'] = ptt;
    map['rlang'] = rlang;
    map['vinfo'] = vinfo;
    map['nunum'] = nunum;
    map['speex_size'] = speexSize;
    map['nbest'] = nbest;
    map['wbest'] = wbest;
    return map;
  }

}

/// app_id : "83836aa0"

class CommonV {
  CommonV({
      this.appId,});

  CommonV.fromJson(dynamic json) {
    appId = json['app_id'];
  }
  String? appId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['app_id'] = appId;
    return map;
  }

}