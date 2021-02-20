import 'package:star/ktxxmodels/ktxx_fans_total_entity.dart';

fansTotalEntityFromJson(KeTaoFeaturedFansTotalEntity data, Map<String, dynamic> json) {
  if (json['status'] != null) {
    data.status = json['status'];
  }
  if (json['err_code'] != null) {
    data.errCode = json['err_code']?.toInt();
  }
  if (json['err_msg'] != null) {
    data.errMsg = json['err_msg'];
  }
  if (json['data'] != null) {
    try {
      data.data = new KeTaoFeaturedFansTotalData().fromJson(json['data']);
    } catch (e) {}
  }
  return data;
}

Map<String, dynamic> fansTotalEntityToJson(KeTaoFeaturedFansTotalEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  return data;
}

fansTotalDataFromJson(KeTaoFeaturedFansTotalData data, Map<String, dynamic> json) {
  if (json['agent_info'] != null) {
    try {
      data.agentInfo =
          new KeTaoFeaturedFansTotalDataAgentInfo().fromJson(json['agent_info']);
    } catch (e) {}
  }
  if (json['count_info'] != null) {
    try {
      data.countInfo =
          new KeTaoFeaturedFansTotalDataCountInfo().fromJson(json['count_info']);
    } catch (e) {}
  }
  return data;
}

Map<String, dynamic> fansTotalDataToJson(KeTaoFeaturedFansTotalData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (entity.agentInfo != null) {
    data['agent_info'] = entity.agentInfo.toJson();
  }
  if (entity.countInfo != null) {
    data['count_info'] = entity.countInfo.toJson();
  }
  return data;
}

fansTotalDataAgentInfoFromJson(
    KeTaoFeaturedFansTotalDataAgentInfo data, Map<String, dynamic> json) {
  if (json['avatar'] != null) {
    data.avatar = json['avatar']?.toString();
  }
  if (json['username'] != null) {
    data.username = json['username']?.toString();
  }
  if (json['tel'] != null) {
    data.tel = json['tel']?.toString();
  }
  if (json['wx_no'] != null) {
    data.wxNo = json['wx_no']?.toString();
  }
  return data;
}

Map<String, dynamic> fansTotalDataAgentInfoToJson(
    KeTaoFeaturedFansTotalDataAgentInfo entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['avatar'] = entity.avatar;
  data['username'] = entity.username;
  data['tel'] = entity.tel;
  data['wx_no'] = entity.wxNo;
  return data;
}

fansTotalDataCountInfoFromJson(
    KeTaoFeaturedFansTotalDataCountInfo data, Map<String, dynamic> json) {
  if (json['total'] != null) {
    try {
      data.total = json['total']?.toInt();
    } catch (e) {}
  }
  if (json['vip'] != null) {
    try {
      data.vip = json['vip']?.toInt();
    } catch (e) {}
  }
  if (json['experience'] != null) {
    try {
      data.experience = json['experience']?.toInt();
    } catch (e) {}
  }
  if (json['noviciate'] != null) {
    try {
      data.noviciate = json['noviciate']?.toInt();
    } catch (e) {}
  }
  if (json['ordinary'] != null) {
    try {
      data.ordinary = json['ordinary']?.toInt();
    } catch (e) {}
  }
  if (json['diamond'] != null) {
    try {
      data.diamond = json['diamond']?.toInt();
    } catch (e) {}
  }
  return data;
}

Map<String, dynamic> fansTotalDataCountInfoToJson(
    KeTaoFeaturedFansTotalDataCountInfo entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['total'] = entity.total;
  data['vip'] = entity.vip;
  data['experience'] = entity.experience;
  data['noviciate'] = entity.noviciate;
  data['ordinary'] = entity.ordinary;
  data['diamond'] = entity.diamond;
  return data;
}
