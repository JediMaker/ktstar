import 'package:star/ktxxmodels/task_detail_entity.dart';

taskDetailEntityFromJson(TaskDetailEntity data, Map<String, dynamic> json) {
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
			data.data = new TaskDetailData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> taskDetailEntityToJson(TaskDetailEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

taskDetailDataFromJson(TaskDetailData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['file_id'] != null) {
		data.fileId = json['file_id']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['share_price'] != null) {
		data.sharePrice = json['share_price']?.toString();
	}
	if (json['title'] != null) {
		data.title = json['title']?.toString();
	}
	if (json['text'] != null) {
		data.text = json['text']?.toString();
	}
	return data;
}

Map<String, dynamic> taskDetailDataToJson(TaskDetailData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['file_id'] = entity.fileId;
	data['share_price'] = entity.sharePrice;
	data['title'] = entity.title;
	data['text'] = entity.text;
	return data;
}