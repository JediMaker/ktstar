import 'package:star/models/pdd_category_list_entity.dart';

pddCategoryListEntityFromJson(PddCategoryListEntity data, Map<String, dynamic> json) {
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
		data.data = new List<PddCategoryListData>();
		(json['data'] as List).forEach((v) {
			data.data.add(new PddCategoryListData().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> pddCategoryListEntityToJson(PddCategoryListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	return data;
}

pddCategoryListDataFromJson(PddCategoryListData data, Map<String, dynamic> json) {
	if (json['level'] != null) {
		data.level = json['level']?.toInt();
	}
	if (json['cat_name'] != null) {
		data.catName = json['cat_name']?.toString();
	}
	if (json['cat_id'] != null) {
		data.catId = json['cat_id']?.toString();
	}
	if (json['parent_cat_id'] != null) {
		data.parentCatId = json['parent_cat_id']?.toString();
	}
	return data;
}

Map<String, dynamic> pddCategoryListDataToJson(PddCategoryListData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['level'] = entity.level;
	data['cat_name'] = entity.catName;
	data['cat_id'] = entity.catId;
	data['parent_cat_id'] = entity.parentCatId;
	return data;
}