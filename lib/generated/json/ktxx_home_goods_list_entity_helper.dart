import 'package:star/ktxxmodels/ktxx_home_goods_list_entity.dart';

homeGoodsListEntityFromJson(KeTaoFeaturedHomeGoodsListEntity data, Map<String, dynamic> json) {
	if (json['goods_list'] != null) {
		data.goodsList = new List<KeTaoFeaturedHomeGoodsListGoodsList>();
		(json['goods_list'] as List).forEach((v) {
			data.goodsList.add(new KeTaoFeaturedHomeGoodsListGoodsList().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> homeGoodsListEntityToJson(KeTaoFeaturedHomeGoodsListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.goodsList != null) {
		data['goods_list'] =  entity.goodsList.map((v) => v.toJson()).toList();
	}
	return data;
}

homeGoodsListGoodsListFromJson(KeTaoFeaturedHomeGoodsListGoodsList data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['goods_name'] != null) {
		data.goodsName = json['goods_name']?.toString();
	}
	if (json['goods_img'] != null) {
		data.goodsImg = json['goods_img']?.toString();
	}
	if (json['original_price'] != null) {
		data.originalPrice = json['original_price']?.toString();
	}
	if (json['sale_price'] != null) {
		data.salePrice = json['sale_price']?.toString();
	}
	if (json['bt_price'] != null) {
		data.btPrice = json['bt_price']?.toString();
	}
	return data;
}

Map<String, dynamic> homeGoodsListGoodsListToJson(KeTaoFeaturedHomeGoodsListGoodsList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['goods_name'] = entity.goodsName;
	data['goods_img'] = entity.goodsImg;
	data['original_price'] = entity.originalPrice;
	data['sale_price'] = entity.salePrice;
	data['bt_price'] = entity.btPrice;
	return data;
}