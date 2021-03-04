import 'package:star/ktxxmodels/ktxx_recharge_entity.dart';
import 'package:star/ktxxmodels/ktxx_recharge_extra_entity.dart';

rechargeEntityFromJson(
    KeTaoFeaturedRechargeEntity data, Map<String, dynamic> json) {
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
      data.data = new KeTaoFeaturedRechargeData().fromJson(json['data']);
    } catch (e) {}
  }
  return data;
}

Map<String, dynamic> rechargeEntityToJson(KeTaoFeaturedRechargeEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  return data;
}

rechargeDataFromJson(
    KeTaoFeaturedRechargeData data, Map<String, dynamic> json) {
  if (json['rechage_list'] != null) {
    data.rechageList = new List<KeTaoFeaturedRechargeDataRechageList>();
    (json['rechage_list'] as List).forEach((v) {
      data.rechageList
          .add(new KeTaoFeaturedRechargeDataRechageList().fromJson(v));
    });
  }
  if (json['coupon_list'] != null) {
    data.couponList = new List<KeTaoFeaturedRechargeDatacouponList>();
    (json['coupon_list'] as List).forEach((v) {
      data.couponList
          .add(new KeTaoFeaturedRechargeDatacouponList().fromJson(v));
    });
  }
  if (json['s_rechage_list'] != null) {
    data.sRechageList = new List<KeTaoFeaturedRechargeDataRechageList>();
    (json['s_rechage_list'] as List).forEach((v) {
      data.sRechageList
          .add(new KeTaoFeaturedRechargeDataRechageList().fromJson(v));
    });
  }
  if (json['ratio'] != null) {
    data.ratio = new KeTaoFeaturedRechargeExtraRatio().fromJson(json['ratio']);
  }

  return data;
}

Map<String, dynamic> rechargeDataToJson(KeTaoFeaturedRechargeData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (entity.rechageList != null) {
    data['rechage_list'] = entity.rechageList.map((v) => v.toJson()).toList();
  }
  if (entity.couponList != null) {
    data['coupon_list'] = entity.couponList.map((v) => v.toJson()).toList();
  }
  if (entity.sRechageList != null) {
    data['s_rechage_list'] =
        entity.sRechageList.map((v) => v.toJson()).toList();
  }
  if (entity.ratio != null) {
    data['ratio'] = entity.ratio.toJson();
  }
  return data;
}

rechargeDataRechageListFromJson(
    KeTaoFeaturedRechargeDataRechageList data, Map<String, dynamic> json) {
  if (json['id'] != null) {
    data.id = json['id']?.toInt();
  }
  if (json['face_money'] != null) {
    data.faceMoney = json['face_money']?.toString();
  }
  if (json['use_money'] != null) {
    data.useMoney = json['use_money']?.toString();
  }
  if (json['coupon_money'] != null) {
    data.couponMoney = json['coupon_money']?.toString();
  }
  if (json['pay_money'] != null) {
    data.payMoney = json['pay_money']?.toString();
  }
  if (json['flag'] != null) {
    data.flag = json['flag'];
  }
  if (json['coin'] != null) {
    data.coin = json['coin']?.toString();
  }
  if (json['coin_desc'] != null) {
    data.coinDesc = json['coin_desc']?.toString();
  }
  return data;
}

Map<String, dynamic> rechargeDataRechageListToJson(
    KeTaoFeaturedRechargeDataRechageList entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = entity.id;
  data['face_money'] = entity.faceMoney;
  data['use_money'] = entity.useMoney;
  data['coupon_money'] = entity.couponMoney;
  data['pay_money'] = entity.payMoney;
  data['flag'] = entity.flag;
  data['coin'] = entity.coin;
  data['coin_desc'] = entity.coinDesc;
  return data;
}

rechargeDatacouponListFromJson(
    KeTaoFeaturedRechargeDatacouponList data, Map<String, dynamic> json) {
  if (json['money'] != null) {
    data.money = json['money']?.toString();
  }
  if (json['condition'] != null) {
    data.condition = json['condition']?.toString();
  }
  return data;
}

Map<String, dynamic> rechargeDatacouponListToJson(
    KeTaoFeaturedRechargeDatacouponList entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['money'] = entity.money;
  data['condition'] = entity.condition;
  return data;
}
