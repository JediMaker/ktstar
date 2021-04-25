import 'package:star/models/lottery_msg_list_entity.dart';

lotteryMsgListEntityFromJson(
    LotteryMsgListEntity data, Map<String, dynamic> json) {
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
      data.data = new LotteryMsgListData().fromJson(json['data']);
    } catch (e) {}
  }
  return data;
}

Map<String, dynamic> lotteryMsgListEntityToJson(LotteryMsgListEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  return data;
}

lotteryMsgListDataFromJson(LotteryMsgListData data, Map<String, dynamic> json) {
  if (json['list'] != null) {
    data.xList = new List<LotteryMsgListDataList>();
    (json['list'] as List).forEach((v) {
      data.xList.add(new LotteryMsgListDataList().fromJson(v));
    });
  }
  if (json['page'] != null) {
    data.page = json['page']?.toInt();
  }
  if (json['page_size'] != null) {
    data.pageSize = json['page_size']?.toInt();
  }
  return data;
}

Map<String, dynamic> lotteryMsgListDataToJson(LotteryMsgListData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (entity.xList != null) {
    data['list'] = entity.xList.map((v) => v.toJson()).toList();
  }
  data['page'] = entity.page;
  data['page_size'] = entity.pageSize;
  return data;
}

lotteryMsgListDataListFromJson(
    LotteryMsgListDataList data, Map<String, dynamic> json) {
  if (json['id'] != null) {
    data.id = json['id']?.toString();
  }
  if (json['a_status'] != null) {
    data.aStatus = json['a_status']?.toString();
  }
  if (json['create_time'] != null) {
    data.createTime = json['create_time']?.toString();
  }
  if (json['a_desc'] != null) {
    data.aDesc = json['a_desc']?.toString();
  }
  if (json['a_avatar'] != null) {
    data.avatar = json['a_avatar']?.toString();
  }
  return data;
}

Map<String, dynamic> lotteryMsgListDataListToJson(
    LotteryMsgListDataList entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = entity.id;
  data['a_status'] = entity.aStatus;
  data['create_time'] = entity.createTime;
  data['a_desc'] = entity.aDesc;
  data['a_avatar'] = entity.avatar;
  return data;
}
