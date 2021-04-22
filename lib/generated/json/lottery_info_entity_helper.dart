import 'package:star/models/lottery_info_entity.dart';

lotteryInfoEntityFromJson(LotteryInfoEntity data, Map<String, dynamic> json) {
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
      data.data = new LotteryInfoData().fromJson(json['data']);
    } catch (e) {}
  }
  return data;
}

Map<String, dynamic> lotteryInfoEntityToJson(LotteryInfoEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  return data;
}

lotteryInfoDataFromJson(LotteryInfoData data, Map<String, dynamic> json) {
  if (json['prize_id'] != null) {
    data.prizeId = json['prize_id']?.toInt();
  }
  if (json['prize_name'] != null) {
    data.prizeName = json['prize_name']?.toString();
  }
  if (json['lottery_msg'] != null) {
    data.lotteryMsg = json['lottery_msg']?.toString();
  }
  if (json['play_times'] != null) {
    data.playTimes = json['play_times']?.toString();
  }
  if (json['need_power_num'] != null) {
    data.needPowerNum = json['need_power_num']?.toString();
  }
  if (json['user_power_num'] != null) {
    data.userPowerNum = json['user_power_num']?.toString();
  }
  if (json['user_card_num'] != null) {
    data.userCardNum =
        new LotteryInfoDataUserCardNum().fromJson(json['user_card_num']);
  }
  if (json['card_config'] != null) {
    data.cardConfig =
        new LotteryInfoDataCardConfig().fromJson(json['card_config']);
  }
  if (json['prize_list'] != null) {
    data.prizeList = new List<LotteryInfoDataPrizeList>();
    (json['prize_list'] as List).forEach((v) {
      data.prizeList.add(new LotteryInfoDataPrizeList().fromJson(v));
    });
  }
  return data;
}

Map<String, dynamic> lotteryInfoDataToJson(LotteryInfoData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['prize_id'] = entity.prizeId;
  data['prize_name'] = entity.prizeName;
  data['lottery_msg'] = entity.lotteryMsg;
  data['play_times'] = entity.playTimes;
  data['need_power_num'] = entity.needPowerNum;
  data['user_power_num'] = entity.userPowerNum;
  if (entity.userCardNum != null) {
    data['user_card_num'] = entity.userCardNum.toJson();
  }
  if (entity.cardConfig != null) {
    data['card_config'] = entity.cardConfig.toJson();
  }
  if (entity.prizeList != null) {
    data['prize_list'] = entity.prizeList.map((v) => v.toJson()).toList();
  }
  return data;
}

lotteryInfoDataUserCardNumFromJson(
    LotteryInfoDataUserCardNum data, Map<String, dynamic> json) {
  if (json['card_total'] != null) {
    data.cardTotal = json['card_total']?.toString();
  }
  if (json['magic_num'] != null) {
    data.magicNum = json['magic_num']?.toString();
  }
  if (json['attack_num'] != null) {
    data.attackNum = json['attack_num']?.toString();
  }
  if (json['protect_num'] != null) {
    data.protectNum = json['protect_num']?.toString();
  }
  return data;
}

Map<String, dynamic> lotteryInfoDataUserCardNumToJson(
    LotteryInfoDataUserCardNum entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['card_total'] = entity.cardTotal;
  data['magic_num'] = entity.magicNum;
  data['attack_num'] = entity.attackNum;
  data['protect_num'] = entity.protectNum;
  return data;
}

lotteryInfoDataCardConfigFromJson(
    LotteryInfoDataCardConfig data, Map<String, dynamic> json) {
  if (json['protect_num'] != null) {
    data.protectNum = json['protect_num']?.toString();
  }
  return data;
}

Map<String, dynamic> lotteryInfoDataCardConfigToJson(
    LotteryInfoDataCardConfig entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['protect_num'] = entity.protectNum;
  return data;
}

lotteryInfoDataPrizeListFromJson(
    LotteryInfoDataPrizeList data, Map<String, dynamic> json) {
  if (json['id'] != null) {
    data.id = json['id']?.toString();
  }
  if (json['num'] != null) {
    data.num = json['num']?.toString();
  }
  if (json['type'] != null) {
    data.type = json['type']?.toString();
  }
  if (json['prize'] != null) {
    data.prize = json['prize']?.toString();
  }
  return data;
}

Map<String, dynamic> lotteryInfoDataPrizeListToJson(
    LotteryInfoDataPrizeList entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = entity.id;
  data['num'] = entity.num;
  data['type'] = entity.type;
  data['prize'] = entity.prize;
  return data;
}
