import 'package:star/models/home_goods_list_entity.dart';

homeGoodsListEntityFromJson(
    HomeGoodsListEntity data, Map<String, dynamic> json) {
  if (json['list'] != null) {
    data.goodsList = new List<HomeGoodsListGoodsList>();
    (json['list'] as List).forEach((v) {
      data.goodsList.add(new HomeGoodsListGoodsList().fromJson(v));
    });
  }
  return data;
}

Map<String, dynamic> homeGoodsListEntityToJson(HomeGoodsListEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (entity.goodsList != null) {
    data['list'] = entity.goodsList.map((v) => v.toJson()).toList();
  }
  return data;
}

homeGoodsListGoodsListFromJson(
    HomeGoodsListGoodsList data, Map<String, dynamic> json) {
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
  if (json['goods_rate'] != null) {
    data.goodsRate = json['goods_rate']?.toString();
  }
  if (json['goods_coin'] != null) {
    data.goodsCoin = json['goods_coin']?.toString();
  }
  if (json['is_coupon'] != null) {
    data.isCoupon = json['is_coupon']?.toString();
  }
  if (json['is_new'] != null) {
    data.isNew = json['is_new']?.toString();
  }
  if (json['sale_num'] != null) {
    data.saleNum = json['sale_num']?.toString();
  }
  if (json['try_coin'] != null) {
    data.tryCoin = json['try_coin']?.toString();
  }
  return data;
}

Map<String, dynamic> homeGoodsListGoodsListToJson(
    HomeGoodsListGoodsList entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = entity.id;
  data['goods_name'] = entity.goodsName;
  data['goods_img'] = entity.goodsImg;
  data['original_price'] = entity.originalPrice;
  data['sale_price'] = entity.salePrice;
  data['bt_price'] = entity.btPrice;
  data['goods_rate'] = entity.goodsRate;
  data['goods_coin'] = entity.goodsCoin;
  data['is_coupon'] = entity.isCoupon;
  data['is_new'] = entity.isNew;
  data['sale_num'] = entity.saleNum;
  data['try_coin'] = entity.tryCoin;
  return data;
}
