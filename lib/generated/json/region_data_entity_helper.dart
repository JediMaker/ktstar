import 'package:star/models/region_data_entity.dart';

regionDataEntityFromJson(RegionDataEntity data, Map<String, dynamic> json) {
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
		data.data = new List<RegionDataData>();
		(json['data'] as List).forEach((v) {
			try {
				data.data.add(new RegionDataData().fromJson(v));
			} catch (e) {
			}
		});
	}
	return data;
}

Map<String, dynamic> regionDataEntityToJson(RegionDataEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	return data;
}

regionDataDataFromJson(RegionDataData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toInt();
	}
	if (json['value'] != null) {
		data.value = json['value']?.toString();
	}
	if (json['children'] != null) {
		data.children = new List<RegionDataData>();
		(json['children'] as List).forEach((v) {
			data.children.add(new RegionDataData().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> regionDataDataToJson(RegionDataData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['value'] = entity.value;
	if (entity.children != null) {
		data['children'] =  entity.children.map((v) => v.toJson()).toList();
	}
	return data;
}

regionDataDatachildFromJson(RegionDataDatachild data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toInt();
	}
	if (json['value'] != null) {
		data.value = json['value']?.toString();
	}
	if (json['children'] != null) {
		data.children = new List<RegionDataDatachildchild>();
		(json['children'] as List).forEach((v) {
			data.children.add(new RegionDataDatachildchild().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> regionDataDatachildToJson(RegionDataDatachild entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['value'] = entity.value;
	if (entity.children != null) {
		data['children'] =  entity.children.map((v) => v.toJson()).toList();
	}
	return data;
}

regionDataDatachildchildFromJson(RegionDataDatachildchild data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toInt();
	}
	if (json['value'] != null) {
		data.value = json['value']?.toString();
	}
	return data;
}

Map<String, dynamic> regionDataDatachildchildToJson(RegionDataDatachildchild entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['value'] = entity.value;
	return data;
}