import 'package:star/ktxxmodels/ktxx_home_entity.dart';
import 'package:star/ktxxmodels/ktxx_home_goods_list_entity.dart';
import 'package:star/ktxxmodels/ktxx_home_icon_list_entity.dart';

homeEntityFromJson(KeTaoFeaturedHomeEntity data, Map<String, dynamic> json) {
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
			data.data = new KeTaoFeaturedHomeData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> homeEntityToJson(KeTaoFeaturedHomeEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

homeDataFromJson(KeTaoFeaturedHomeData data, Map<String, dynamic> json) {
	if (json['banner'] != null) {
		data.banner = new List<KeTaoFeaturedHomeIconListIconList>();
		(json['banner'] as List).forEach((v) {
			data.banner.add(new KeTaoFeaturedHomeIconListIconList().fromJson(v));
		});
	}
	if (json['task_list'] != null) {
		data.taskList = new List<KeTaoFeaturedHomeDataTaskList>();
		(json['task_list'] as List).forEach((v) {
			data.taskList.add(new KeTaoFeaturedHomeDataTaskList().fromJson(v));
		});
	}
	if (json['links'] != null) {
		data.links = json['links']?.toString();
	}
	if (json['goods_list'] != null) {
		data.goodsList = new List<KeTaoFeaturedHomeGoodsListGoodsList>();
		(json['goods_list'] as List).forEach((v) {
			data.goodsList.add(new KeTaoFeaturedHomeGoodsListGoodsList().fromJson(v));
		});
	}
	if (json['icon_list'] != null) {
		data.iconList = new List<KeTaoFeaturedHomeIconListIconList>();
		(json['icon_list'] as List).forEach((v) {
			data.iconList.add(new KeTaoFeaturedHomeIconListIconList().fromJson(v));
		});
	}
	if (json['ad_list'] != null) {
		data.adList = new List<KeTaoFeaturedHomeIconListIconList>();
		(json['ad_list'] as List).forEach((v) {
			data.adList.add(new KeTaoFeaturedHomeIconListIconList().fromJson(v));
		});
	}
	if (json['user_level'] != null) {
		data.userLevel = json['user_level']?.toString();
	}
	return data;
}

Map<String, dynamic> homeDataToJson(KeTaoFeaturedHomeData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.banner != null) {
		data['banner'] =  entity.banner.map((v) => v.toJson()).toList();
	}
	if (entity.taskList != null) {
		data['task_list'] =  entity.taskList.map((v) => v.toJson()).toList();
	}
	data['links'] = entity.links;
	if (entity.goodsList != null) {
		data['goods_list'] =  entity.goodsList.map((v) => v.toJson()).toList();
	}
	if (entity.iconList != null) {
		data['icon_list'] =  entity.iconList.map((v) => v.toJson()).toList();
	}
	if (entity.adList != null) {
		data['ad_list'] =  entity.adList.map((v) => v.toJson()).toList();
	}
	data['user_level'] = entity.userLevel;
	return data;
}

homeDataBannerFromJson(KeTaoFeaturedHomeDataBanner data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['img_path'] != null) {
		data.imgPath = json['img_path']?.toString();
	}
	if (json['uri'] != null) {
		data.uri = json['uri'];
	}
	return data;
}

Map<String, dynamic> homeDataBannerToJson(KeTaoFeaturedHomeDataBanner entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['img_path'] = entity.imgPath;
	data['uri'] = entity.uri;
	return data;
}

homeDataTaskListFromJson(KeTaoFeaturedHomeDataTaskList data, Map<String, dynamic> json) {
	if (json['data'] != null) {
		data.xList = new List<KeTaoFeaturedHomeDataTaskListList>();
		(json['data'] as List).forEach((v) {
			data.xList.add(new KeTaoFeaturedHomeDataTaskListList().fromJson(v));
		});
	}
	if (json['task_total'] != null) {
		data.taskTotal = json['task_total']?.toString();
	}
	if (json['use_task_total'] != null) {
		data.useTaskTotal = json['use_task_total']?.toString();
	}
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	return data;
}

Map<String, dynamic> homeDataTaskListToJson(KeTaoFeaturedHomeDataTaskList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.xList != null) {
		data['data'] =  entity.xList.map((v) => v.toJson()).toList();
	}
	data['task_total'] = entity.taskTotal;
	data['use_task_total'] = entity.useTaskTotal;
	data['name'] = entity.name;
	return data;
}

homeDataTaskListListFromJson(KeTaoFeaturedHomeDataTaskListList data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['share_price'] != null) {
		data.sharePrice = json['share_price']?.toString();
	}
	if (json['title'] != null) {
		data.title = json['title']?.toString();
	}
	if (json['task_status'] != null) {
		data.taskStatus = json['task_status']?.toInt();
	}
	if (json['icons'] != null) {
		data.icons = json['icons']?.toString();
	}
	if (json['status_desc'] != null) {
		data.statusDesc = json['status_desc']?.toString();
	}
	if (json['type'] != null) {
		data.type = json['type']?.toString();
	}
	if (json['subtitle'] != null) {
		data.subtitle = json['subtitle']?.toString();
	}
	if (json['num'] != null) {
		data.num = json['num']?.toString();
	}
	if (json['category'] != null) {
		data.category = json['category']?.toString();
	}
	if (json['ratio'] != null) {
		data.ratio = json['ratio']?.toString();
	}
	if (json['diamonds_ratio'] != null) {
		data.diamondsRatio = json['diamonds_ratio']?.toString();
	}
	if (json['is_higher'] != null) {
		data.isHigher = json['is_higher']?.toString();
	}
	if (json['is_new'] != null) {
		data.isNew = json['is_new']?.toString();
	}
	if (json['last_simple_id'] != null) {
		data.lastSimpleId = json['last_simple_id']?.toString();
	}
	return data;
}

Map<String, dynamic> homeDataTaskListListToJson(KeTaoFeaturedHomeDataTaskListList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['share_price'] = entity.sharePrice;
	data['title'] = entity.title;
	data['task_status'] = entity.taskStatus;
	data['icons'] = entity.icons;
	data['status_desc'] = entity.statusDesc;
	data['type'] = entity.type;
	data['subtitle'] = entity.subtitle;
	data['num'] = entity.num;
	data['category'] = entity.category;
	data['ratio'] = entity.ratio;
	data['diamonds_ratio'] = entity.diamondsRatio;
	data['is_higher'] = entity.isHigher;
	data['is_new'] = entity.isNew;
	data['last_simple_id'] = entity.lastSimpleId;
	return data;
}