import 'package:star/ktxxmodels/poster_entity.dart';

posterEntityFromJson(PosterEntity data, Map<String, dynamic> json) {
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
			data.data = new PosterData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> posterEntityToJson(PosterEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

posterDataFromJson(PosterData data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code']?.toString();
	}
	if (json['imgs'] != null) {
		data.imgs = json['imgs']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['url'] != null) {
		data.url = json['url']?.toString();
	}
	return data;
}

Map<String, dynamic> posterDataToJson(PosterData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['imgs'] = entity.imgs;
	data['url'] = entity.url;
	return data;
}