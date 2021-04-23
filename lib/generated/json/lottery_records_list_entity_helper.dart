import 'package:star/models/lottery_records_list_entity.dart';

lotteryRecordsListEntityFromJson(
    LotteryRecordsListEntity data, Map<String, dynamic> json) {
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
      data.data = new LotteryRecordsListData().fromJson(json['data']);
    } catch (e) {}
  }
  return data;
}

Map<String, dynamic> lotteryRecordsListEntityToJson(
    LotteryRecordsListEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  return data;
}

lotteryRecordsListDataFromJson(
    LotteryRecordsListData data, Map<String, dynamic> json) {
  if (json['list'] != null) {
    data.xList = new List<LotteryRecordsListDataList>();
    (json['list'] as List).forEach((v) {
      data.xList.add(new LotteryRecordsListDataList().fromJson(v));
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

Map<String, dynamic> lotteryRecordsListDataToJson(
    LotteryRecordsListData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (entity.xList != null) {
    data['list'] = entity.xList.map((v) => v.toJson()).toList();
  }
  data['page'] = entity.page;
  data['page_size'] = entity.pageSize;
  return data;
}

lotteryRecordsListDataListFromJson(
    LotteryRecordsListDataList data, Map<String, dynamic> json) {
  if (json['id'] != null) {
    data.id = json['id']?.toString();
  }
  if (json['p_type'] != null) {
    data.pType = json['p_type']?.toString();
  }
  if (json['p_num'] != null) {
    data.pNum = json['p_num']?.toString();
  }
  if (json['p_source'] != null) {
    data.pSource = json['p_source']?.toString();
  }
  if (json['p_genre'] != null) {
    data.pGenre = json['p_genre']?.toString();
  }
  if (json['p_status'] != null) {
    data.pStatus = json['p_status']?.toString();
  }
  if (json['p_desc'] != null) {
    data.pDesc = json['p_desc']?.toString();
  }
  if (json['l_type'] != null) {
    data.lType = json['l_type']?.toString();
  }
  if (json['l_num'] != null) {
    data.lNum = json['l_num']?.toString();
  }
  if (json['l_desc'] != null) {
    data.lDesc = json['l_desc']?.toString();
  }
  if (json['c_status'] != null) {
    data.cStatus = json['c_status']?.toString();
  }
  if (json['c_source'] != null) {
    data.cSource = json['c_source']?.toString();
  }
  if (json['c_type'] != null) {
    data.cType = json['c_type']?.toString();
  }
  if (json['c_num'] != null) {
    data.cNum = json['c_num']?.toString();
  }
  if (json['c_desc'] != null) {
    data.cDesc = json['c_desc']?.toString();
  }
  if (json['c_protect_status'] != null) {
    data.cProtectStatus = json['c_protect_status']?.toString();
  }
  if (json['c_protect_expire'] != null) {
    data.cProtectExpire = json['c_protect_expire']?.toString();
  }
  if (json['create_time'] != null) {
    data.createTime = json['create_time']?.toString();
  }
  if (json['expire_time'] != null) {
    data.expireTime = json['expire_time']?.toString();
  }
  return data;
}

Map<String, dynamic> lotteryRecordsListDataListToJson(
    LotteryRecordsListDataList entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = entity.id;
  data['p_type'] = entity.pType;
  data['p_num'] = entity.pNum;
  data['p_source'] = entity.pSource;
  data['p_genre'] = entity.pGenre;
  data['p_status'] = entity.pStatus;
  data['p_desc'] = entity.pDesc;
  data['l_type'] = entity.lType;
  data['l_num'] = entity.lNum;
  data['l_desc'] = entity.lDesc;
  data['c_status'] = entity.cStatus;
  data['c_source'] = entity.cSource;
  data['c_type'] = entity.cType;
  data['c_num'] = entity.cNum;
  data['c_desc'] = entity.cDesc;
  data['c_protect_status'] = entity.cProtectStatus;
  data['c_protect_expire'] = entity.cProtectExpire;
  data['create_time'] = entity.createTime;
  data['expire_time'] = entity.expireTime;
  return data;
}
