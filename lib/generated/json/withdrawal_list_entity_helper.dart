import 'package:star/models/withdrawal_list_entity.dart';

withdrawalListEntityFromJson(WithdrawalListEntity data, Map<String, dynamic> json) {
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
		data.data = new WithdrawalListData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> withdrawalListEntityToJson(WithdrawalListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

withdrawalListDataFromJson(WithdrawalListData data, Map<String, dynamic> json) {
	if (json['list'] != null) {
		data.xList = new List<WithdrawalListDataList>();
		(json['list'] as List).forEach((v) {
			data.xList.add(new WithdrawalListDataList().fromJson(v));
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

Map<String, dynamic> withdrawalListDataToJson(WithdrawalListData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.xList != null) {
		data['list'] =  entity.xList.map((v) => v.toJson()).toList();
	}
	data['page'] = entity.page;
	data['page_size'] = entity.pageSize;
	return data;
}

withdrawalListDataListFromJson(WithdrawalListDataList data, Map<String, dynamic> json) {
	if (json['price'] != null) {
		data.price = json['price']?.toString();
	}
	if (json['type'] != null) {
		data.type = json['type']?.toString();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	if (json['reject_reason'] != null) {
		data.rejectReason = json['reject_reason']?.toString();
	}
	if (json['create_time'] != null) {
		data.createTime = json['create_time']?.toString();
	}
	if (json['time_desc'] != null) {
		data.timeDesc = json['time_desc']?.toString();
	}
	return data;
}

Map<String, dynamic> withdrawalListDataListToJson(WithdrawalListDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['price'] = entity.price;
	data['type'] = entity.type;
	data['status'] = entity.status;
	data['reject_reason'] = entity.rejectReason;
	data['create_time'] = entity.createTime;
	data['time_desc'] = entity.timeDesc;
	return data;
}