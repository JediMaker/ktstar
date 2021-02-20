import 'package:star/ktxxmodels/ktxx_home_icon_list_entity.dart';

homeIconListEntityFromJson(KeTaoFeaturedHomeIconListEntity data, Map<String, dynamic> json) {
	if (json['icon_list'] != null) {
		data.iconList = new List<KeTaoFeaturedHomeIconListIconList>();
		(json['icon_list'] as List).forEach((v) {
			data.iconList.add(new KeTaoFeaturedHomeIconListIconList().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> homeIconListEntityToJson(KeTaoFeaturedHomeIconListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.iconList != null) {
		data['icon_list'] =  entity.iconList.map((v) => v.toJson()).toList();
	}
	return data;
}

homeIconListIconListFromJson(KeTaoFeaturedHomeIconListIconList data, Map<String, dynamic> json) {
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
	if (json['app_path'] != null) {
		data.appPath = json['app_path']?.toString();
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
	if (json['flag'] != null) {
		data.flag = json['flag']?.toString();
	}
	if (json['img_path'] != null) {
		data.imgPath = json['img_path']?.toString();
	}
	if (json['toast_info'] != null) {
		data.toastInfo = json['toast_info']?.toString();
	}
	if (json['need_login'] != null) {
		data.needLogin = json['need_login'];
	}
	return data;
}

Map<String, dynamic> homeIconListIconListToJson(KeTaoFeaturedHomeIconListIconList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['position'] = entity.position;
	data['icon'] = entity.icon;
	data['name'] = entity.name;
	data['type'] = entity.type;
	data['uri'] = entity.uri;
	data['app_id'] = entity.appId;
	data['app_path'] = entity.appPath;
	data['path'] = entity.path;
	data['params'] = entity.params;
	data['subtitle'] = entity.subtitle;
	data['flag'] = entity.flag;
	data['img_path'] = entity.imgPath;
	data['toast_info'] = entity.toastInfo;
	data['need_login'] = entity.needLogin;
	return data;
}