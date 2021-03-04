import 'package:star/ktxxmodels/ktxx_recharge_extra_entity.dart';

rechargeExtraEntityFromJson(
    RechargeExtraEntity data, Map<String, dynamic> json) {
  if (json['s_rechage_list'] != null) {
    data.sRechageList = new List<RechargeExtraSRechageList>();
    (json['s_rechage_list'] as List).forEach((v) {
      data.sRechageList
          .add(new RechargeExtraSRechageList().fromJson(v));
    });
  }
  if (json['ratio'] != null) {
    data.ratio = new RechargeExtraRatio().fromJson(json['ratio']);
  }
  return data;
}

Map<String, dynamic> rechargeExtraEntityToJson(
    RechargeExtraEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (entity.sRechageList != null) {
    data['s_rechage_list'] =
        entity.sRechageList.map((v) => v.toJson()).toList();
  }
  if (entity.ratio != null) {
    data['ratio'] = entity.ratio.toJson();
  }
  return data;
}

rechargeExtraSRechageListFromJson(
    RechargeExtraSRechageList data, Map<String, dynamic> json) {
  if (json['id'] != null) {
    data.id = json['id']?.toString();
  }
  if (json['face_money'] != null) {
    data.faceMoney = json['face_money']?.toString();
  }
  if (json['use_money'] != null) {
    data.useMoney = json['use_money']?.toString();
  }
  if (json['flag'] != null) {
    data.flag = json['flag'];
  }
  if (json['pay_money'] != null) {
    data.payMoney = json['pay_money']?.toString();
  }
  if (json['coin'] != null) {
    data.coin = json['coin']?.toString();
  }
  if (json['coin_desc'] != null) {
    data.coinDesc = json['coin_desc']?.toString();
  }
  return data;
}

Map<String, dynamic> rechargeExtraSRechageListToJson(
    RechargeExtraSRechageList entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = entity.id;
  data['face_money'] = entity.faceMoney;
  data['use_money'] = entity.useMoney;
  data['flag'] = entity.flag;
  data['pay_money'] = entity.payMoney;
  data['coin'] = entity.coin;
  data['coin_desc'] = entity.coinDesc;
  return data;
}

rechargeExtraRatioFromJson(
    RechargeExtraRatio data, Map<String, dynamic> json) {
  if (json['fast'] != null) {
    data.fast = json['fast']?.toString();
  }
  if (json['slow'] != null) {
    data.slow = json['slow']?.toString();
  }
  return data;
}

Map<String, dynamic> rechargeExtraRatioToJson(
    RechargeExtraRatio entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['fast'] = entity.fast;
  data['slow'] = entity.slow;
  return data;
}
