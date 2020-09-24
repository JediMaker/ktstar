import 'package:star/models/login_entity.dart';

loginEntityFromJson(LoginEntity data, Map<String, dynamic> json) {
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
		data.data = new LoginData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> loginEntityToJson(LoginEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

loginDataFromJson(LoginData data, Map<String, dynamic> json) {
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

Map<String, dynamic> loginDataToJson(LoginData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['token'] = entity.token;
	data['refertoken'] = entity.refertoken;
	data['expire_time'] = entity.expireTime;
	data['username'] = entity.username;
	data['tel'] = entity.tel;
	data['avatar'] = entity.avatar;
	return data;
}