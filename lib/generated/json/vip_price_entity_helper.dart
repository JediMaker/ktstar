import 'package:star/models/vip_price_entity.dart';

vipPriceEntityFromJson(VipPriceEntity data, Map<String, dynamic> json) {
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
		data.data = new VipPriceData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> vipPriceEntityToJson(VipPriceEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

vipPriceDataFromJson(VipPriceData data, Map<String, dynamic> json) {
	if (json['now_price'] != null) {
		data.nowPrice = json['now_price']?.toInt();
	}
	if (json['y_price'] != null) {
		data.yPrice = json['y_price']?.toInt();
	}
	return data;
}

Map<String, dynamic> vipPriceDataToJson(VipPriceData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['now_price'] = entity.nowPrice;
	data['y_price'] = entity.yPrice;
	return data;
}