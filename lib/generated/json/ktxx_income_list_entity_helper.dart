import 'package:star/ktxxmodels/ktxx_income_list_entity.dart';

incomeListEntityFromJson(KeTaoFeaturedIncomeListEntity data, Map<String, dynamic> json) {
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
			data.data = new KeTaoFeaturedIncomeListData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> incomeListEntityToJson(KeTaoFeaturedIncomeListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

incomeListDataFromJson(KeTaoFeaturedIncomeListData data, Map<String, dynamic> json) {
	if (json['list'] != null) {
		data.xList = new List<KeTaoFeaturedIncomeListDataList>();
		(json['list'] as List).forEach((v) {
			data.xList.add(new KeTaoFeaturedIncomeListDataList().fromJson(v));
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

Map<String, dynamic> incomeListDataToJson(KeTaoFeaturedIncomeListData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.xList != null) {
		data['list'] =  entity.xList.map((v) => v.toJson()).toList();
	}
	data['page'] = entity.page;
	data['page_size'] = entity.pageSize;
	return data;
}

incomeListDataListFromJson(KeTaoFeaturedIncomeListDataList data, Map<String, dynamic> json) {
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
	if (json['profit_type'] != null) {
		data.profitType = json['profit_type']?.toString();
	}
	if (json['desc'] != null) {
		data.desc = json['desc']?.toString();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	if (json['bonus'] != null) {
		data.bonus = json['bonus']?.toString();
	}
	if (json['source'] != null) {
		data.source = json['source']?.toString();
	}
	if (json['attach_id'] != null) {
		data.attachId = json['attach_id']?.toString();
	}
	if (json['title'] != null) {
		data.title = json['title']?.toString();
	}
	return data;
}

Map<String, dynamic> incomeListDataListToJson(KeTaoFeaturedIncomeListDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['type'] = entity.type;
	data['price'] = entity.price;
	data['create_time'] = entity.createTime;
	data['time_desc'] = entity.timeDesc;
	data['reject_reason'] = entity.rejectReason;
	data['profit_type'] = entity.profitType;
	data['desc'] = entity.desc;
	data['status'] = entity.status;
	data['bonus'] = entity.bonus;
	data['source'] = entity.source;
	data['attach_id'] = entity.attachId;
	data['title'] = entity.title;
	return data;
}