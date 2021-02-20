import 'package:star/ktxxmodels/ktxx_login_entity.dart';

loginEntityFromJson(KeTaoFeaturedLoginEntity data, Map<String, dynamic> json) {
	if (json['status'] != null) {
		data.status = json['status'];
	}
	if (json['err_code'] != null) {
		try {
			data.errCode = json['err_code']?.toInt();
		} catch (e) {
		}
	}
	if (json['err_msg'] != null) {
		data.errMsg = json['err_msg'];
	}
	if (json['data'] != null) {
		try {
			data.data = new KeTaoFeaturedLoginData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> loginEntityToJson(KeTaoFeaturedLoginEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

loginDataFromJson(KeTaoFeaturedLoginData data, Map<String, dynamic> json) {
	if (json['token'] != null) {
		data.token = json['token']?.toString();
	}
	if (json['refertoken'] != null) {
		data.refertoken = json['refertoken']?.toString();
	}
	if (json['expire_time'] != null) {
		data.expireTime = json['expire_time']?.toInt();
	}
	if (json['username'] != null) {
		data.username = json['username']?.toString();
	}
	if (json['tel'] != null) {
		data.tel = json['tel'];
	}
	if (json['avatar'] != null) {
		data.avatar = json['avatar']?.toString();
	}
	return data;
}

Map<String, dynamic> loginDataToJson(KeTaoFeaturedLoginData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['token'] = entity.token;
	data['refertoken'] = entity.refertoken;
	data['expire_time'] = entity.expireTime;
	data['username'] = entity.username;
	data['tel'] = entity.tel;
	data['avatar'] = entity.avatar;
	return data;
}