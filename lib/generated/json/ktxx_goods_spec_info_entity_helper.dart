import 'package:star/ktxxmodels/ktxx_goods_spec_info_entity.dart';

goodsSpecInfoEntityFromJson(KeTaoFeaturedGoodsSpecInfoEntity data, Map<String, dynamic> json) {
	if (json['spec_info'] != null) {
		data.specInfo = new KeTaoFeaturedGoodsSpecInfoSpecInfo().fromJson(json['spec_info']);
	}
	return data;
}

Map<String, dynamic> goodsSpecInfoEntityToJson(KeTaoFeaturedGoodsSpecInfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.specInfo != null) {
		data['spec_info'] = entity.specInfo.toJson();
	}
	return data;
}

goodsSpecInfoSpecInfoFromJson(KeTaoFeaturedGoodsSpecInfoSpecInfo data, Map<String, dynamic> json) {
	if (json['spec_item'] != null) {
		data.specItem = new List<KeTaoFeaturedGoodsSpecInfoSpecInfoSpecItem>();
		(json['spec_item'] as List).forEach((v) {
			data.specItem.add(new KeTaoFeaturedGoodsSpecInfoSpecInfoSpecItem().fromJson(v));
		});
	}
	if (json['spec_price'] != null) {
		data.specPrice = json['spec_price'];
	}
	return data;
}

Map<String, dynamic> goodsSpecInfoSpecInfoToJson(KeTaoFeaturedGoodsSpecInfoSpecInfo entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.specItem != null) {
		data['spec_item'] =  entity.specItem.map((v) => v.toJson()).toList();
	}
	data['spec_price'] = entity.specPrice;
	return data;
}

goodsSpecInfoSpecInfoSpecItemFromJson(KeTaoFeaturedGoodsSpecInfoSpecInfoSpecItem data, Map<String, dynamic> json) {
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	if (json['list'] != null) {
		data.xList = json['list']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	return data;
}

Map<String, dynamic> goodsSpecInfoSpecInfoSpecItemToJson(KeTaoFeaturedGoodsSpecInfoSpecInfoSpecItem entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['name'] = entity.name;
	data['list'] = entity.xList;
	return data;
}

goodsSpecInfoSpecInfoSpecPriceFromJson(KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPrice data, Map<String, dynamic> json) {
	if (json['ids_0_0'] != null) {
		data.ids00 = new KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds().fromJson(json['ids_0_0']);
	}
	if (json['ids_0_1'] != null) {
		data.ids01 = new KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds01().fromJson(json['ids_0_1']);
	}
	if (json['ids_1_0'] != null) {
		data.ids10 = new KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds10().fromJson(json['ids_1_0']);
	}
	if (json['ids_1_1'] != null) {
		data.ids11 = new KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds11().fromJson(json['ids_1_1']);
	}
	return data;
}

Map<String, dynamic> goodsSpecInfoSpecInfoSpecPriceToJson(KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPrice entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.ids00 != null) {
		data['ids_0_0'] = entity.ids00.toJson();
	}
	if (entity.ids01 != null) {
		data['ids_0_1'] = entity.ids01.toJson();
	}
	if (entity.ids10 != null) {
		data['ids_1_0'] = entity.ids10.toJson();
	}
	if (entity.ids11 != null) {
		data['ids_1_1'] = entity.ids11.toJson();
	}
	return data;
}

goodsSpecInfoSpecInfoSpecPriceIdsFromJson(KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds data, Map<String, dynamic> json) {
	if (json['spec_id'] != null) {
		data.specId = json['spec_id']?.toString();
	}
	if (json['spec_img'] != null) {
		data.specImg = json['spec_img']?.toString();
	}
	if (json['spec_price'] != null) {
		data.specPrice = json['spec_price']?.toString();
	}
	return data;
}

Map<String, dynamic> goodsSpecInfoSpecInfoSpecPriceIdsToJson(KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['spec_id'] = entity.specId;
	data['spec_img'] = entity.specImg;
	data['spec_price'] = entity.specPrice;
	return data;
}

goodsSpecInfoSpecInfoSpecPriceIds01FromJson(KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds01 data, Map<String, dynamic> json) {
	if (json['spec_id'] != null) {
		data.specId = json['spec_id']?.toString();
	}
	if (json['spec_img'] != null) {
		data.specImg = json['spec_img']?.toString();
	}
	if (json['spec_price'] != null) {
		data.specPrice = json['spec_price']?.toString();
	}
	return data;
}

Map<String, dynamic> goodsSpecInfoSpecInfoSpecPriceIds01ToJson(KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds01 entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['spec_id'] = entity.specId;
	data['spec_img'] = entity.specImg;
	data['spec_price'] = entity.specPrice;
	return data;
}

goodsSpecInfoSpecInfoSpecPriceIds10FromJson(KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds10 data, Map<String, dynamic> json) {
	if (json['spec_id'] != null) {
		data.specId = json['spec_id']?.toString();
	}
	if (json['spec_img'] != null) {
		data.specImg = json['spec_img']?.toString();
	}
	if (json['spec_price'] != null) {
		data.specPrice = json['spec_price']?.toString();
	}
	return data;
}

Map<String, dynamic> goodsSpecInfoSpecInfoSpecPriceIds10ToJson(KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds10 entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['spec_id'] = entity.specId;
	data['spec_img'] = entity.specImg;
	data['spec_price'] = entity.specPrice;
	return data;
}

goodsSpecInfoSpecInfoSpecPriceIds11FromJson(KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds11 data, Map<String, dynamic> json) {
	if (json['spec_id'] != null) {
		data.specId = json['spec_id']?.toString();
	}
	if (json['spec_img'] != null) {
		data.specImg = json['spec_img']?.toString();
	}
	if (json['spec_price'] != null) {
		data.specPrice = json['spec_price']?.toString();
	}
	return data;
}

Map<String, dynamic> goodsSpecInfoSpecInfoSpecPriceIds11ToJson(KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds11 entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['spec_id'] = entity.specId;
	data['spec_img'] = entity.specImg;
	data['spec_price'] = entity.specPrice;
	return data;
}