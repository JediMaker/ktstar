import 'package:star/models/lottery_attack_result_entity.dart';

lotteryAttackResultEntityFromJson(
    LotteryAttackResultEntity data, Map<String, dynamic> json) {
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
      data.data = new LotteryAttackResultData().fromJson(json['data']);
    } catch (e) {}
  }
  return data;
}

Map<String, dynamic> lotteryAttackResultEntityToJson(
    LotteryAttackResultEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  return data;
}

lotteryAttackResultDataFromJson(
    LotteryAttackResultData data, Map<String, dynamic> json) {
  if (json['a_status'] != null) {
    data.aStatus = json['a_status']?.toString();
  }
  if (json['a_avatar'] != null) {
    data.aAvatar = json['a_avatar']?.toString();
  }
  if (json['a_title'] != null) {
    data.aTitle = json['a_title']?.toString();
  }
  if (json['a_desc'] != null) {
    data.aDesc = json['a_desc']?.toString();
  }
  if (json['a_result'] != null) {
    data.aResult = json['a_result']?.toString();
  }
  return data;
}

Map<String, dynamic> lotteryAttackResultDataToJson(
    LotteryAttackResultData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['a_status'] = entity.aStatus;
  data['a_avatar'] = entity.aAvatar;
  data['a_title'] = entity.aTitle;
  data['a_desc'] = entity.aDesc;
  data['a_result'] = entity.aResult;
  return data;
}