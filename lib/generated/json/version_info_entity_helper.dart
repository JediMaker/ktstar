import 'package:star/ktxxmodels/version_info_entity.dart';

versionInfoEntityFromJson(VersionInfoEntity data, Map<String, dynamic> json) {
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
			data.data = new VersionInfoData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> versionInfoEntityToJson(VersionInfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

versionInfoDataFromJson(VersionInfoData data, Map<String, dynamic> json) {
	if (json['version_no'] != null) {
		data.versionNo = json['version_no']?.toString();
	}
	if (json['desc'] != null) {
		data.desc = json['desc']?.toString();
	}
	if (json['android_url'] != null) {
		data.androidUrl = json['android_url']?.toString();
	}
	if (json['ios_url'] != null) {
		data.iosUrl = json['ios_url']?.toString();
	}
	if (json['wx_login'] != null) {
		data.wxLogin = json['wx_login']?.toString();
	}
	if (json['wh_check'] != null) {
		data.whCheck = json['wh_check'];
	}
	if (json['ios_check'] != null) {
		data.iosCheck = json['ios_check'];
	}
	return data;
}

Map<String, dynamic> versionInfoDataToJson(VersionInfoData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['version_no'] = entity.versionNo;
	data['desc'] = entity.desc;
	data['android_url'] = entity.androidUrl;
	data['ios_url'] = entity.iosUrl;
	data['wx_login'] = entity.wxLogin;
	data['wh_check'] = entity.whCheck;
	data['ios_check'] = entity.iosCheck;
	return data;
}