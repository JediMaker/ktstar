import 'package:star/ktxxmodels/ktxx_version_info_entity.dart';

versionInfoEntityFromJson(KeTaoFeaturedVersionInfoEntity data, Map<String, dynamic> json) {
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
			data.data = new KeTaoFeaturedVersionInfoData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> versionInfoEntityToJson(KeTaoFeaturedVersionInfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

versionInfoDataFromJson(KeTaoFeaturedVersionInfoData data, Map<String, dynamic> json) {
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
	if (json['pgsd_check'] != null) {
		data.iosCheck = json['pgsd_check'];
	}
	if (json['build_number'] != null) {
		data.buildNumber = json['build_number']?.toString();
	}
	if (json['build_number_desc'] != null) {
		data.buildNumberDesc = json['build_number_desc']?.toString();
	}
	return data;
}

Map<String, dynamic> versionInfoDataToJson(KeTaoFeaturedVersionInfoData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['version_no'] = entity.versionNo;
	data['desc'] = entity.desc;
	data['android_url'] = entity.androidUrl;
	data['ios_url'] = entity.iosUrl;
	data['wx_login'] = entity.wxLogin;
	data['wh_check'] = entity.whCheck;
	data['pgsd_check'] = entity.iosCheck;
	data['build_number'] = entity.buildNumber;
	data['build_number_desc'] = entity.buildNumberDesc;
	return data;
}