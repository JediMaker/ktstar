import 'package:star/models/task_other_submit_info_entity.dart';

taskOtherSubmitInfoEntityFromJson(TaskOtherSubmitInfoEntity data, Map<String, dynamic> json) {
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
			data.data = new TaskOtherSubmitInfoData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> taskOtherSubmitInfoEntityToJson(TaskOtherSubmitInfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

taskOtherSubmitInfoDataFromJson(TaskOtherSubmitInfoData data, Map<String, dynamic> json) {
	if (json['com_id'] != null) {
		data.comId = json['com_id']?.toString();
	}
	if (json['img_id'] != null) {
		data.imgId = json['img_id']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['task_id'] != null) {
		data.taskId = json['task_id']?.toString();
	}
	if (json['img_url'] != null) {
		data.imgUrl = json['img_url']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['img_num'] != null) {
		data.imgNum = json['img_num']?.toInt();
	}
	return data;
}

Map<String, dynamic> taskOtherSubmitInfoDataToJson(TaskOtherSubmitInfoData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['com_id'] = entity.comId;
	data['img_id'] = entity.imgId;
	data['task_id'] = entity.taskId;
	data['img_url'] = entity.imgUrl;
	data['img_num'] = entity.imgNum;
	return data;
}