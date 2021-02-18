import 'package:star/ktxxmodels/goods_spec_info_entity.dart';

goodsSpecInfoEntityFromJson(GoodsSpecInfoEntity data, Map<String, dynamic> json) {
	if (json['spec_info'] != null) {
		data.specInfo = new GoodsSpecInfoSpecInfo().fromJson(json['spec_info']);
	}
	return data;
}

Map<String, dynamic> goodsSpecInfoEntityToJson(GoodsSpecInfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.specInfo != null) {
		data['spec_info'] = entity.specInfo.toJson();
	}
	return data;
}

goodsSpecInfoSpecInfoFromJson(GoodsSpecInfoSpecInfo data, Map<String, dynamic> json) {
	if (json['spec_item'] != null) {
		data.specItem = new List<GoodsSpecInfoSpecInfoSpecItem>();
		(json['spec_item'] as List).forEach((v) {
			data.specItem.add(new GoodsSpecInfoSpecInfoSpecItem().fromJson(v));
		});
	}
	if (json['spec_price'] != null) {
		data.specPrice = json['spec_price'];
	}
	return data;
}

Map<String, dynamic> goodsSpecInfoSpecInfoToJson(GoodsSpecInfoSpecInfo entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.specItem != null) {
		data['spec_item'] =  entity.specItem.map((v) => v.toJson()).toList();
	}
	data['spec_price'] = entity.specPrice;
	return data;
}

goodsSpecInfoSpecInfoSpecItemFromJson(GoodsSpecInfoSpecInfoSpecItem data, Map<String, dynamic> json) {
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	if (json['list'] != null) {
		data.xList = json['list']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	return data;
}

Map<String, dynamic> goodsSpecInfoSpecInfoSpecItemToJson(GoodsSpecInfoSpecInfoSpecItem entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['name'] = entity.name;
	data['list'] = entity.xList;
	return data;
}

goodsSpecInfoSpecInfoSpecPriceFromJson(GoodsSpecInfoSpecInfoSpecPrice data, Map<String, dynamic> json) {
	if (json['ids_0_0'] != null) {
		data.ids00 = new GoodsSpecInfoSpecInfoSpecPriceIds().fromJson(json['ids_0_0']);
	}
	if (json['ids_0_1'] != null) {
		data.ids01 = new GoodsSpecInfoSpecInfoSpecPriceIds01().fromJson(json['ids_0_1']);
	}
	if (json['ids_1_0'] != null) {
		data.ids10 = new GoodsSpecInfoSpecInfoSpecPriceIds10().fromJson(json['ids_1_0']);
	}
	if (json['ids_1_1'] != null) {
		data.ids11 = new GoodsSpecInfoSpecInfoSpecPriceIds11().fromJson(json['ids_1_1']);
	}
	return data;
}

Map<String, dynamic> goodsSpecInfoSpecInfoSpecPriceToJson(GoodsSpecInfoSpecInfoSpecPrice entity) {
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

goodsSpecInfoSpecInfoSpecPriceIdsFromJson(GoodsSpecInfoSpecInfoSpecPriceIds data, Map<String, dynamic> json) {
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

Map<String, dynamic> goodsSpecInfoSpecInfoSpecPriceIdsToJson(GoodsSpecInfoSpecInfoSpecPriceIds entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['spec_id'] = entity.specId;
	data['spec_img'] = entity.specImg;
	data['spec_price'] = entity.specPrice;
	return data;
}

goodsSpecInfoSpecInfoSpecPriceIds01FromJson(GoodsSpecInfoSpecInfoSpecPriceIds01 data, Map<String, dynamic> json) {
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

Map<String, dynamic> goodsSpecInfoSpecInfoSpecPriceIds01ToJson(GoodsSpecInfoSpecInfoSpecPriceIds01 entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['spec_id'] = entity.specId;
	data['spec_img'] = entity.specImg;
	data['spec_price'] = entity.specPrice;
	return data;
}

goodsSpecInfoSpecInfoSpecPriceIds10FromJson(GoodsSpecInfoSpecInfoSpecPriceIds10 data, Map<String, dynamic> json) {
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

Map<String, dynamic> goodsSpecInfoSpecInfoSpecPriceIds10ToJson(GoodsSpecInfoSpecInfoSpecPriceIds10 entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['spec_id'] = entity.specId;
	data['spec_img'] = entity.specImg;
	data['spec_price'] = entity.specPrice;
	return data;
}

goodsSpecInfoSpecInfoSpecPriceIds11FromJson(GoodsSpecInfoSpecInfoSpecPriceIds11 data, Map<String, dynamic> json) {
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

Map<String, dynamic> goodsSpecInfoSpecInfoSpecPriceIds11ToJson(GoodsSpecInfoSpecInfoSpecPriceIds11 entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['spec_id'] = entity.specId;
	data['spec_img'] = entity.specImg;
	data['spec_price'] = entity.specPrice;
	return data;
}