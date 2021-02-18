import 'package:star/ktxxmodels/balance_pay_info_entity.dart';

balancePayInfoEntityFromJson(BalancePayInfoEntity data, Map<String, dynamic> json) {
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
			data.data = new BalancePayInfoData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> balancePayInfoEntityToJson(BalancePayInfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

balancePayInfoDataFromJson(BalancePayInfoData data, Map<String, dynamic> json) {
	if (json['pay_no'] != null) {
		data.payNo = json['pay_no']?.toString();
	}
	if (json['pay_info'] != null) {
		data.payInfo = new List<dynamic>();
		data.payInfo.addAll(json['pay_info']);
	}
	return data;
}

Map<String, dynamic> balancePayInfoDataToJson(BalancePayInfoData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['pay_no'] = entity.payNo;
	if (entity.payInfo != null) {
		data['pay_info'] =  [];
	}
	return data;
}