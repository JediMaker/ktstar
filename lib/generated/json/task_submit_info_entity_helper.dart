import 'package:star/models/task_submit_info_entity.dart';

taskSubmitInfoEntityFromJson(TaskSubmitInfoEntity data, Map<String, dynamic> json) {
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
			data.data = new TaskSubmitInfoData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> taskSubmitInfoEntityToJson(TaskSubmitInfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

taskSubmitInfoDataFromJson(TaskSubmitInfoData data, Map<String, dynamic> json) {
	if (json['task_id'] != null) {
		data.taskId = json['task_id']?.toString();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	if (json['img_id'] != null) {
		data.imgId = json['img_id']?.toString();
	}
	if (json['img_url'] != null) {
		data.imgUrl = json['img_url']?.toString();
	}
	if (json['com_id'] != null) {
		data.comId = json['com_id']?.toString();
	}
	return data;
}

Map<String, dynamic> taskSubmitInfoDataToJson(TaskSubmitInfoData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['task_id'] = entity.taskId;
	data['status'] = entity.status;
	data['img_id'] = entity.imgId;
	data['img_url'] = entity.imgUrl;
	data['com_id'] = entity.comId;
	return data;
}