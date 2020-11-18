import 'package:star/models/withdrawal_user_info_entity.dart';

withdrawalUserInfoEntityFromJson(WithdrawalUserInfoEntity data, Map<String, dynamic> json) {
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
			data.data = new WithdrawalUserInfoData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> withdrawalUserInfoEntityToJson(WithdrawalUserInfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

withdrawalUserInfoDataFromJson(WithdrawalUserInfoData data, Map<String, dynamic> json) {
	if (json['user'] != null) {
		data.user = new WithdrawalUserInfoDataUser().fromJson(json['user']);
	}
	if (json['start_flag'] != null) {
		data.startFlag = json['start_flag'];
	}
	if (json['last_date'] != null) {
		data.lastDate = json['last_date']?.toString();
	}
	return data;
}

Map<String, dynamic> withdrawalUserInfoDataToJson(WithdrawalUserInfoData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.user != null) {
		data['user'] = entity.user.toJson();
	}
	data['start_flag'] = entity.startFlag;
	data['last_date'] = entity.lastDate;
	return data;
}

withdrawalUserInfoDataUserFromJson(WithdrawalUserInfoDataUser data, Map<String, dynamic> json) {
	if (json['zfb_account'] != null) {
		data.zfbAccount = json['zfb_account']?.toString();
	}
	if (json['zfb_name'] != null) {
		data.zfbName = json['zfb_name']?.toString();
	}
	if (json['price'] != null) {
		data.price = json['price']?.toString();
	}
	return data;
}

Map<String, dynamic> withdrawalUserInfoDataUserToJson(WithdrawalUserInfoDataUser entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['zfb_account'] = entity.zfbAccount;
	data['zfb_name'] = entity.zfbName;
	data['price'] = entity.price;
	return data;
}