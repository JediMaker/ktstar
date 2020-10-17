import 'package:star/models/income_list_entity.dart';

incomeListEntityFromJson(IncomeListEntity data, Map<String, dynamic> json) {
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
		data.data = new IncomeListData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> incomeListEntityToJson(IncomeListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

incomeListDataFromJson(IncomeListData data, Map<String, dynamic> json) {
	if (json['list'] != null) {
		data.xList = new List<IncomeListDataList>();
		(json['list'] as List).forEach((v) {
			data.xList.add(new IncomeListDataList().fromJson(v));
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

Map<String, dynamic> incomeListDataToJson(IncomeListData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.xList != null) {
		data['list'] =  entity.xList.map((v) => v.toJson()).toList();
	}
	data['page'] = entity.page;
	data['page_size'] = entity.pageSize;
	return data;
}

incomeListDataListFromJson(IncomeListDataList data, Map<String, dynamic> json) {
	if (json['type'] != null) {
		data.type = json['type']?.toString();
	}
	if (json['price'] != null) {
		data.price = json['price']?.toString();
	}
	if (json['create_time'] != null) {
		data.createTime = json['create_time']?.toString();
	}
	if (json['time_desc'] != null) {
		data.timeDesc = json['time_desc']?.toString();
	}
	if (json['reject_reason'] != null) {
		data.rejectReason = json['reject_reason']?.toString();
	}
	if (json['desc'] != null) {
		data.desc = json['desc']?.toString();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	return data;
}

Map<String, dynamic> incomeListDataListToJson(IncomeListDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['type'] = entity.type;
	data['price'] = entity.price;
	data['create_time'] = entity.createTime;
	data['time_desc'] = entity.timeDesc;
	data['reject_reason'] = entity.rejectReason;
	data['desc'] = entity.desc;
	data['status'] = entity.status;
	return data;
}