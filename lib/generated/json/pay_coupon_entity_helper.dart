import 'package:star/models/pay_coupon_entity.dart';

payCouponEntityFromJson(PayCouponEntity data, Map<String, dynamic> json) {
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
		data.data = new PayCouponData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> payCouponEntityToJson(PayCouponEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

payCouponDataFromJson(PayCouponData data, Map<String, dynamic> json) {
	if (json['money'] != null) {
		data.money = json['money']?.toString();
	}
	if (json['condition'] != null) {
		data.condition = json['condition']?.toString();
	}
	if (json['start_time'] != null) {
		data.startTime = json['start_time']?.toString();
	}
	if (json['end_time'] != null) {
		data.endTime = json['end_time']?.toString();
	}
	return data;
}

Map<String, dynamic> payCouponDataToJson(PayCouponData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['money'] = entity.money;
	data['condition'] = entity.condition;
	data['start_time'] = entity.startTime;
	data['end_time'] = entity.endTime;
	return data;
}