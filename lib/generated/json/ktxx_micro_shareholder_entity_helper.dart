import 'package:star/ktxxmodels/ktxx_micro_shareholder_entity.dart';
import 'package:star/ktxxmodels/ktxx_micro_shareholder_item_entity.dart';

microShareholderEntityFromJson(KeTaoFeaturedMicroShareholderEntity data, Map<String, dynamic> json) {
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
		data.data = new KeTaoFeaturedMicroShareholderData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> microShareholderEntityToJson(KeTaoFeaturedMicroShareholderEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

microShareholderDataFromJson(KeTaoFeaturedMicroShareholderData data, Map<String, dynamic> json) {
	if (json['grade1'] != null) {
		data.grade1 = new KeTaoFeaturedMicroShareholderItemEntity().fromJson(json['grade1']);
	}
	if (json['grade2'] != null) {
		data.grade2 = new KeTaoFeaturedMicroShareholderItemEntity().fromJson(json['grade2']);
	}
	if (json['grade3'] != null) {
		data.grade3 = new KeTaoFeaturedMicroShareholderItemEntity().fromJson(json['grade3']);
	}
	return data;
}

Map<String, dynamic> microShareholderDataToJson(KeTaoFeaturedMicroShareholderData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.grade1 != null) {
		data['grade1'] = entity.grade1.toJson();
	}
	if (entity.grade2 != null) {
		data['grade2'] = entity.grade2.toJson();
	}
	if (entity.grade3 != null) {
		data['grade3'] = entity.grade3.toJson();
	}
	return data;
}