import 'package:star/models/home_icon_list_entity.dart';

homeIconListEntityFromJson(HomeIconListEntity data, Map<String, dynamic> json) {
	if (json['icon_list'] != null) {
		data.iconList = new List<HomeIconListIconList>();
		(json['icon_list'] as List).forEach((v) {
			data.iconList.add(new HomeIconListIconList().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> homeIconListEntityToJson(HomeIconListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.iconList != null) {
		data['icon_list'] =  entity.iconList.map((v) => v.toJson()).toList();
	}
	return data;
}

homeIconListIconListFromJson(HomeIconListIconList data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['position'] != null) {
		data.position = json['position']?.toString();
	}
	if (json['icon'] != null) {
		data.icon = json['icon']?.toString();
	}
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	if (json['type'] != null) {
		data.type = json['type']?.toString();
	}
	if (json['uri'] != null) {
		data.uri = json['uri']?.toString();
	}
	if (json['app_id'] != null) {
		data.appId = json['app_id']?.toString();
	}
	if (json['path'] != null) {
		data.path = json['path']?.toString();
	}
	if (json['params'] != null) {
		data.params = json['params']?.toString();
	}
	if (json['subtitle'] != null) {
		data.subtitle = json['subtitle']?.toString();
	}
	if (json['img_path'] != null) {
		data.imgPath = json['img_path']?.toString();
	}
	if (json['toast_info'] != null) {
		data.toastInfo = json['toast_info']?.toString();
	}
	return data;
}

Map<String, dynamic> homeIconListIconListToJson(HomeIconListIconList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['position'] = entity.position;
	data['icon'] = entity.icon;
	data['name'] = entity.name;
	data['type'] = entity.type;
	data['uri'] = entity.uri;
	data['app_id'] = entity.appId;
	data['path'] = entity.path;
	data['params'] = entity.params;
	data['subtitle'] = entity.subtitle;
	data['img_path'] = entity.imgPath;
	data['toast_info'] = entity.toastInfo;
	return data;
}