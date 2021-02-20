import 'package:star/ktxxmodels/ktxx_pdd_home_entity.dart';
import 'package:star/ktxxmodels/ktxx_home_icon_list_entity.dart';

pddHomeEntityFromJson(KeTaoFeaturedPddHomeEntity data, Map<String, dynamic> json) {
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
		data.data = new KeTaoFeaturedPddHomeData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> pddHomeEntityToJson(KeTaoFeaturedPddHomeEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

pddHomeDataFromJson(KeTaoFeaturedPddHomeData data, Map<String, dynamic> json) {
	if (json['cats'] != null) {
		data.cats = new List<KeTaoFeaturedPddHomeDataCat>();
		(json['cats'] as List).forEach((v) {
			data.cats.add(new KeTaoFeaturedPddHomeDataCat().fromJson(v));
		});
	}
	if (json['banner'] != null) {
		data.banner = new List<KeTaoFeaturedHomeIconListIconList>();
		(json['banner'] as List).forEach((v) {
			data.banner.add(new KeTaoFeaturedHomeIconListIconList().fromJson(v));
		});
	}
	if (json['tools'] != null) {
		data.tools = new List<KeTaoFeaturedHomeIconListIconList>();
		(json['tools'] as List).forEach((v) {
			data.tools.add(new KeTaoFeaturedHomeIconListIconList().fromJson(v));
		});
	}
	if (json['ads'] != null) {
		data.ads = new List<KeTaoFeaturedHomeIconListIconList>();
		(json['ads'] as List).forEach((v) {
			data.ads.add(new KeTaoFeaturedHomeIconListIconList().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> pddHomeDataToJson(KeTaoFeaturedPddHomeData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.cats != null) {
		data['cats'] =  entity.cats.map((v) => v.toJson()).toList();
	}
	if (entity.banner != null) {
		data['banner'] =  entity.banner.map((v) => v.toJson()).toList();
	}
	if (entity.tools != null) {
		data['tools'] =  entity.tools.map((v) => v.toJson()).toList();
	}
	if (entity.ads != null) {
		data['ads'] =  entity.ads.map((v) => v.toJson()).toList();
	}
	return data;
}

pddHomeDataCatFromJson(KeTaoFeaturedPddHomeDataCat data, Map<String, dynamic> json) {
	if (json['cat_id'] != null) {
		data.catId = json['cat_id']?.toString();
	}
	if (json['cat_name'] != null) {
		data.catName = json['cat_name']?.toString();
	}
	return data;
}

Map<String, dynamic> pddHomeDataCatToJson(KeTaoFeaturedPddHomeDataCat entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['cat_id'] = entity.catId;
	data['cat_name'] = entity.catName;
	return data;
}

pddHomeDataBannerFromJson(KeTaoFeaturedPddHomeDataBanner data, Map<String, dynamic> json) {
	if (json['img'] != null) {
		data.img = json['img']?.toString();
	}
	if (json['url'] != null) {
		data.url = json['url']?.toString();
	}
	return data;
}

Map<String, dynamic> pddHomeDataBannerToJson(KeTaoFeaturedPddHomeDataBanner entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['img'] = entity.img;
	data['url'] = entity.url;
	return data;
}

pddHomeDataToolFromJson(KeTaoFeaturedPddHomeDataTool data, Map<String, dynamic> json) {
	if (json['type'] != null) {
		data.type = json['type']?.toString();
	}
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	if (json['icon'] != null) {
		data.icon = json['icon']?.toString();
	}
	if (json['link'] != null) {
		data.link = json['link']?.toString();
	}
	return data;
}

Map<String, dynamic> pddHomeDataToolToJson(KeTaoFeaturedPddHomeDataTool entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['type'] = entity.type;
	data['name'] = entity.name;
	data['icon'] = entity.icon;
	data['link'] = entity.link;
	return data;
}

pddHomeDataAdFromJson(KeTaoFeaturedPddHomeDataAd data, Map<String, dynamic> json) {
	if (json['img'] != null) {
		data.img = json['img']?.toString();
	}
	if (json['url'] != null) {
		data.url = json['url']?.toString();
	}
	return data;
}

Map<String, dynamic> pddHomeDataAdToJson(KeTaoFeaturedPddHomeDataAd entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['img'] = entity.img;
	data['url'] = entity.url;
	return data;
}