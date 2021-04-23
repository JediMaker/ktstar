import 'package:star/models/lottery_attacked_user_entity.dart';

lotteryAttackedUserEntityFromJson(
    LotteryAttackedUserEntity data, Map<String, dynamic> json) {
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
      data.data = new LotteryAttackedUserData().fromJson(json['data']);
    } catch (e) {}
  }
  return data;
}

Map<String, dynamic> lotteryAttackedUserEntityToJson(
    LotteryAttackedUserEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  return data;
}

lotteryAttackedUserDataFromJson(
    LotteryAttackedUserData data, Map<String, dynamic> json) {
  if (json['users'] != null) {
    data.users = new List<LotteryAttackedUserDataUser>();
    (json['users'] as List).forEach((v) {
      data.users.add(new LotteryAttackedUserDataUser().fromJson(v));
    });
  }
  if (json['times'] != null) {
    data.times = json['times']?.toString();
  }
  return data;
}

Map<String, dynamic> lotteryAttackedUserDataToJson(
    LotteryAttackedUserData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (entity.users != null) {
    data['users'] = entity.users.map((v) => v.toJson()).toList();
  }
  data['times'] = entity.times;
  return data;
}

lotteryAttackedUserDataUserFromJson(
    LotteryAttackedUserDataUser data, Map<String, dynamic> json) {
  if (json['uid'] != null) {
    data.uid = json['uid']?.toString();
  }
  return data;
}

Map<String, dynamic> lotteryAttackedUserDataUserToJson(
    LotteryAttackedUserDataUser entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['uid'] = entity.uid;
  return data;
}
