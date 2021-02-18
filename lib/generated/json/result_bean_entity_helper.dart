import 'package:star/ktxxmodels/result_bean_entity.dart';

resultBeanEntityFromJson(ResultBeanEntity data, Map<String, dynamic> json) {
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
			data.data = json['data'];
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> resultBeanEntityToJson(ResultBeanEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	data['data'] = entity.data;
	return data;
}