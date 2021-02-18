import 'package:star/ktxxmodels/fans_list_entity.dart';

fansListEntityFromJson(FansListEntity data, Map<String, dynamic> json) {
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
			data.data = new FansListData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> fansListEntityToJson(FansListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

fansListDataFromJson(FansListData data, Map<String, dynamic> json) {
	if (json['list'] != null) {
		data.xList = new List<FansListDataList>();
		(json['list'] as List).forEach((v) {
			data.xList.add(new FansListDataList().fromJson(v));
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

Map<String, dynamic> fansListDataToJson(FansListData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.xList != null) {
		data['list'] =  entity.xList.map((v) => v.toJson()).toList();
	}
	data['page'] = entity.page;
	data['page_size'] = entity.pageSize;
	return data;
}

fansListDataListFromJson(FansListDataList data, Map<String, dynamic> json) {
	if (json['is_partner'] != null) {
		data.isPartner = json['is_partner']?.toString();
	}
	if (json['is_vip'] != null) {
		data.isVip = json['is_vip']?.toString();
	}
	if (json['avatar'] != null) {
		data.avatar = json['avatar']?.toString();
	}
	if (json['username'] != null) {
		data.username = json['username']?.toString();
	}
	if (json['created_time'] != null) {
		data.createdTime = json['created_time']?.toString();
	}
	if (json['total_count'] != null) {
		data.totalCount = json['total_count']?.toString();
	}
	if (json['complete_status'] != null) {
		data.completeStatus = json['complete_status']?.toString();
	}
	if (json['complete_count'] != null) {
		data.completeCount = json['complete_count']?.toString();
	}
	return data;
}

Map<String, dynamic> fansListDataListToJson(FansListDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['is_partner'] = entity.isPartner;
	data['is_vip'] = entity.isVip;
	data['avatar'] = entity.avatar;
	data['username'] = entity.username;
	data['created_time'] = entity.createdTime;
	data['total_count'] = entity.totalCount;
	data['complete_status'] = entity.completeStatus;
	data['complete_count'] = entity.completeCount;
	return data;
}