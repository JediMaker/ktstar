import 'package:star/models/recharge_entity.dart';

rechargeEntityFromJson(RechargeEntity data, Map<String, dynamic> json) {
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
		data.data = new RechargeData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> rechargeEntityToJson(RechargeEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

rechargeDataFromJson(RechargeData data, Map<String, dynamic> json) {
	if (json['rechage_list'] != null) {
		data.rechageList = new List<RechargeDataRechageList>();
		(json['rechage_list'] as List).forEach((v) {
			data.rechageList.add(new RechargeDataRechageList().fromJson(v));
		});
	}
	if (json['coupon_list'] != null) {
		data.couponList = new List<RechargeDatacouponList>();
		(json['coupon_list'] as List).forEach((v) {
			data.couponList.add(new RechargeDatacouponList().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> rechargeDataToJson(RechargeData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.rechageList != null) {
		data['rechage_list'] =  entity.rechageList.map((v) => v.toJson()).toList();
	}
	if (entity.couponList != null) {
		data['coupon_list'] =  entity.couponList.map((v) => v.toJson()).toList();
	}
	return data;
}

rechargeDataRechageListFromJson(RechargeDataRechageList data, Map<String, dynamic> json) {
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
	return data;
}

Map<String, dynamic> rechargeDataRechageListToJson(RechargeDataRechageList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['face_money'] = entity.faceMoney;
	data['use_money'] = entity.useMoney;
	data['coupon_money'] = entity.couponMoney;
	data['pay_money'] = entity.payMoney;
	return data;
}

rechargeDatacouponListFromJson(RechargeDatacouponList data, Map<String, dynamic> json) {
	if (json['money'] != null) {
		data.money = json['money']?.toString();
	}
	if (json['condition'] != null) {
		data.condition = json['condition']?.toString();
	}
	return data;
}

Map<String, dynamic> rechargeDatacouponListToJson(RechargeDatacouponList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['money'] = entity.money;
	data['condition'] = entity.condition;
	return data;
}