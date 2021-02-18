import 'package:star/ktxxmodels/withdrawal_info_entity.dart';

withdrawalInfoEntityFromJson(WithdrawalInfoEntity data, Map<String, dynamic> json) {
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
			data.data = new WithdrawalInfoData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> withdrawalInfoEntityToJson(WithdrawalInfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

withdrawalInfoDataFromJson(WithdrawalInfoData data, Map<String, dynamic> json) {
	if (json['user'] != null) {
		data.user = new WithdrawalInfoDataUser().fromJson(json['user']);
	}
	if (json['useModel'] != null) {
		data.useModel = new WithdrawalInfoDataUseModel().fromJson(json['useModel']);
	}
	return data;
}

Map<String, dynamic> withdrawalInfoDataToJson(WithdrawalInfoData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.user != null) {
		data['user'] = entity.user.toJson();
	}
	if (entity.useModel != null) {
		data['useModel'] = entity.useModel.toJson();
	}
	return data;
}

withdrawalInfoDataUserFromJson(WithdrawalInfoDataUser data, Map<String, dynamic> json) {
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

Map<String, dynamic> withdrawalInfoDataUserToJson(WithdrawalInfoDataUser entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['zfb_account'] = entity.zfbAccount;
	data['zfb_name'] = entity.zfbName;
	data['price'] = entity.price;
	return data;
}

withdrawalInfoDataUseModelFromJson(WithdrawalInfoDataUseModel data, Map<String, dynamic> json) {
	if (json['price'] != null) {
		data.price = json['price']?.toString();
	}
	if (json['apply_price'] != null) {
		data.applyPrice = json['apply_price']?.toString();
	}
	if (json['service_fee'] != null) {
		data.serviceFee = json['service_fee']?.toString();
	}
	return data;
}

Map<String, dynamic> withdrawalInfoDataUseModelToJson(WithdrawalInfoDataUseModel entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['price'] = entity.price;
	data['apply_price'] = entity.applyPrice;
	data['service_fee'] = entity.serviceFee;
	return data;
}