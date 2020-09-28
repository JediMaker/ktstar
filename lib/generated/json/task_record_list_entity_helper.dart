import 'package:star/models/task_record_list_entity.dart';

taskRecordListEntityFromJson(TaskRecordListEntity data, Map<String, dynamic> json) {
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
		data.data = new TaskRecordListData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> taskRecordListEntityToJson(TaskRecordListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

taskRecordListDataFromJson(TaskRecordListData data, Map<String, dynamic> json) {
	if (json['list'] != null) {
		data.xList = new List<TaskRecordListDataList>();
		(json['list'] as List).forEach((v) {
			data.xList.add(new TaskRecordListDataList().fromJson(v));
		});
	}
	if (json['page'] != null) {
		data.page = json['page']?.toInt();
	}
	if (json['page_size'] != null) {
		data.pageSize = json['page_size']?.toInt();
	}
	return data;
}

Map<String, dynamic> taskRecordListDataToJson(TaskRecordListData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.xList != null) {
		data['list'] =  entity.xList.map((v) => v.toJson()).toList();
	}
	data['page'] = entity.page;
	data['page_size'] = entity.pageSize;
	return data;
}

taskRecordListDataListFromJson(TaskRecordListDataList data, Map<String, dynamic> json) {
	if (json['title'] != null) {
		data.title = json['title']?.toString();
	}
	if (json['price'] != null) {
		data.price = json['price']?.toString();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	if (json['reject_reason'] != null) {
		data.rejectReason = json['reject_reason']?.toString();
	}
	if (json['submit_time'] != null) {
		data.submitTime = json['submit_time']?.toString();
	}
	if (json['check_time'] != null) {
		data.checkTime = json['check_time']?.toString();
	}
	return data;
}

Map<String, dynamic> taskRecordListDataListToJson(TaskRecordListDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['title'] = entity.title;
	data['price'] = entity.price;
	data['status'] = entity.status;
	data['reject_reason'] = entity.rejectReason;
	data['submit_time'] = entity.submitTime;
	data['check_time'] = entity.checkTime;
	return data;
}