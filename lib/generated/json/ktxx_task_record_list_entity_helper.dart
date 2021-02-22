import 'package:star/ktxxmodels/ktxx_task_record_list_entity.dart';

taskRecordListEntityFromJson(KeTaoFeaturedTaskRecordListEntity data, Map<String, dynamic> json) {
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
			data.data = new KeTaoFeaturedTaskRecordListData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> taskRecordListEntityToJson(KeTaoFeaturedTaskRecordListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

taskRecordListDataFromJson(KeTaoFeaturedTaskRecordListData data, Map<String, dynamic> json) {
	if (json['list'] != null) {
		data.xList = new List<KeTaoFeaturedTaskRecordListDataList>();
		(json['list'] as List).forEach((v) {
			data.xList.add(new KeTaoFeaturedTaskRecordListDataList().fromJson(v));
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

Map<String, dynamic> taskRecordListDataToJson(KeTaoFeaturedTaskRecordListData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.xList != null) {
		data['list'] =  entity.xList.map((v) => v.toJson()).toList();
	}
	data['page'] = entity.page;
	data['page_size'] = entity.pageSize;
	return data;
}

taskRecordListDataListFromJson(KeTaoFeaturedTaskRecordListDataList data, Map<String, dynamic> json) {
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
	if (json['task_id'] != null) {
		data.taskId = json['task_id']?.toString();
	}
	if (json['re_submit'] != null) {
		data.reSubmit = json['re_submit']?.toString();
	}
	if (json['com_id'] != null) {
		data.comId = json['com_id']?.toString();
	}
	if (json['category'] != null) {
		data.category = json['category']?.toString();
	}
	return data;
}

Map<String, dynamic> taskRecordListDataListToJson(KeTaoFeaturedTaskRecordListDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['title'] = entity.title;
	data['price'] = entity.price;
	data['status'] = entity.status;
	data['reject_reason'] = entity.rejectReason;
	data['submit_time'] = entity.submitTime;
	data['check_time'] = entity.checkTime;
	data['task_id'] = entity.taskId;
	data['re_submit'] = entity.reSubmit;
	data['com_id'] = entity.comId;
	data['category'] = entity.category;
	return data;
}