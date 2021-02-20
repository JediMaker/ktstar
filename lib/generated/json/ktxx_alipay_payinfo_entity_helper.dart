import 'package:star/ktxxmodels/ktxx_alipay_payinfo_entity.dart';

alipayPayinfoEntityFromJson(KeTaoFeaturedAlipayPayinfoEntity data, Map<String, dynamic> json) {
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
			data.data = new KeTaoFeaturedAlipayPayinfoData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> alipayPayinfoEntityToJson(KeTaoFeaturedAlipayPayinfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

alipayPayinfoDataFromJson(KeTaoFeaturedAlipayPayinfoData data, Map<String, dynamic> json) {
	if (json['pay_no'] != null) {
		data.payNo = json['pay_no']?.toString();
	}
	if (json['pay_info'] != null) {
		data.payInfo = json['pay_info']?.toString();
	}
	if (json['finish'] != null) {
		data.finish = json['finish'];
	}
	return data;
}

Map<String, dynamic> alipayPayinfoDataToJson(KeTaoFeaturedAlipayPayinfoData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['pay_no'] = entity.payNo;
	data['pay_info'] = entity.payInfo;
	data['finish'] = entity.finish;
	return data;
}