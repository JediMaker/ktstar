import 'package:star/ktxxmodels/ktxx_order_user_info_entity.dart';

orderUserInfoEntityFromJson(KeTaoFeaturedOrderUserInfoEntity data, Map<String, dynamic> json) {
	if (json['user_info'] != null) {
		data.userInfo = new KeTaoFeaturedOrderUserInfoUserInfo().fromJson(json['user_info']);
	}
	return data;
}

Map<String, dynamic> orderUserInfoEntityToJson(KeTaoFeaturedOrderUserInfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.userInfo != null) {
		data['user_info'] = entity.userInfo.toJson();
	}
	return data;
}

orderUserInfoUserInfoFromJson(KeTaoFeaturedOrderUserInfoUserInfo data, Map<String, dynamic> json) {
	if (json['price'] != null) {
		data.price = json['price']?.toString();
	}
	if (json['pay_pwd_flag'] != null) {
		data.payPwdFlag = json['pay_pwd_flag'];
	}
	return data;
}

Map<String, dynamic> orderUserInfoUserInfoToJson(KeTaoFeaturedOrderUserInfoUserInfo entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['price'] = entity.price;
	data['pay_pwd_flag'] = entity.payPwdFlag;
	return data;
}