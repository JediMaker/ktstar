import 'package:star/models/alipay_payinfo_entity.dart';

alipayPayinfoEntityFromJson(AlipayPayinfoEntity data, Map<String, dynamic> json) {
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
			data.data = new AlipayPayinfoData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> alipayPayinfoEntityToJson(AlipayPayinfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

alipayPayinfoDataFromJson(AlipayPayinfoData data, Map<String, dynamic> json) {
	if (json['pay_no'] != null) {
		data.payNo = json['pay_no']?.toString();
	}
	if (json['pay_info'] != null) {
		data.payInfo = json['pay_info']?.toString();
	}
	return data;
}

Map<String, dynamic> alipayPayinfoDataToJson(AlipayPayinfoData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['pay_no'] = entity.payNo;
	data['pay_info'] = entity.payInfo;
	return data;
}