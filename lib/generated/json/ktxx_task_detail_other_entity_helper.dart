import 'package:star/ktxxmodels/ktxx_task_detail_other_entity.dart';

taskDetailOtherEntityFromJson(KeTaoFeaturedTaskDetailOtherEntity data, Map<String, dynamic> json) {
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
			data.data = new KeTaoFeaturedTaskDetailOtherData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> taskDetailOtherEntityToJson(KeTaoFeaturedTaskDetailOtherEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

taskDetailOtherDataFromJson(KeTaoFeaturedTaskDetailOtherData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['title'] != null) {
		data.title = json['title']?.toString();
	}
	if (json['desc_json'] != null) {
		data.descJson = new List<KeTaoFeaturedTaskDetailOtherDataDescJson>();
		(json['desc_json'] as List).forEach((v) {
			data.descJson.add(new KeTaoFeaturedTaskDetailOtherDataDescJson().fromJson(v));
		});
	}
	if (json['show_btn'] != null) {
		data.showBtn = json['show_btn'];
	}
	return data;
}

Map<String, dynamic> taskDetailOtherDataToJson(KeTaoFeaturedTaskDetailOtherData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['title'] = entity.title;
	if (entity.descJson != null) {
		data['desc_json'] =  entity.descJson.map((v) => v.toJson()).toList();
	}
	data['show_btn'] = entity.showBtn;
	return data;
}

taskDetailOtherDataDescJsonFromJson(KeTaoFeaturedTaskDetailOtherDataDescJson data, Map<String, dynamic> json) {
	if (json['text'] != null) {
		data.text = json['text']?.toString();
	}
	if (json['img'] != null) {
		data.img = json['img']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	return data;
}

Map<String, dynamic> taskDetailOtherDataDescJsonToJson(KeTaoFeaturedTaskDetailOtherDataDescJson entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['text'] = entity.text;
	data['img'] = entity.img;
	return data;
}