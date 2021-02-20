import 'package:star/ktxxmodels/ktxx_region_data_entity.dart';

regionDataEntityFromJson(KeTaoFeaturedRegionDataEntity data, Map<String, dynamic> json) {
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
		data.data = new List<KeTaoFeaturedRegionDataData>();
		(json['data'] as List).forEach((v) {
			try {
				data.data.add(new KeTaoFeaturedRegionDataData().fromJson(v));
			} catch (e) {
			}
		});
	}
	return data;
}

Map<String, dynamic> regionDataEntityToJson(KeTaoFeaturedRegionDataEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	return data;
}

regionDataDataFromJson(KeTaoFeaturedRegionDataData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toInt();
	}
	if (json['value'] != null) {
		data.value = json['value']?.toString();
	}
	if (json['children'] != null) {
		data.children = new List<KeTaoFeaturedRegionDataData>();
		(json['children'] as List).forEach((v) {
			data.children.add(new KeTaoFeaturedRegionDataData().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> regionDataDataToJson(KeTaoFeaturedRegionDataData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['value'] = entity.value;
	if (entity.children != null) {
		data['children'] =  entity.children.map((v) => v.toJson()).toList();
	}
	return data;
}

regionDataDatachildFromJson(KeTaoFeaturedRegionDataDatachild data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toInt();
	}
	if (json['value'] != null) {
		data.value = json['value']?.toString();
	}
	if (json['children'] != null) {
		data.children = new List<KeTaoFeaturedRegionDataDatachildchild>();
		(json['children'] as List).forEach((v) {
			data.children.add(new KeTaoFeaturedRegionDataDatachildchild().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> regionDataDatachildToJson(KeTaoFeaturedRegionDataDatachild entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['value'] = entity.value;
	if (entity.children != null) {
		data['children'] =  entity.children.map((v) => v.toJson()).toList();
	}
	return data;
}

regionDataDatachildchildFromJson(KeTaoFeaturedRegionDataDatachildchild data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toInt();
	}
	if (json['value'] != null) {
		data.value = json['value']?.toString();
	}
	return data;
}

Map<String, dynamic> regionDataDatachildchildToJson(KeTaoFeaturedRegionDataDatachildchild entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['value'] = entity.value;
	return data;
}