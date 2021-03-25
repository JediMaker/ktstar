import 'package:star/models/search_goods_list_entity.dart';
import 'package:star/models/home_goods_list_entity.dart';

searchGoodsListEntityFromJson(
    SearchGoodsListEntity data, Map<String, dynamic> json) {
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
      data.data = new SearchGoodsListData().fromJson(json['data']);
    } catch (e) {}
  }
  return data;
}

Map<String, dynamic> searchGoodsListEntityToJson(SearchGoodsListEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  return data;
}

searchGoodsListDataFromJson(
    SearchGoodsListData data, Map<String, dynamic> json) {
  if (json['total'] != null) {
    data.total = json['total']?.toString();
  }
  if (json['page'] != null) {
    data.page = json['page']?.toInt();
  }
  if (json['list'] != null) {
    data.goodsList = new List<HomeGoodsListGoodsList>();
    (json['list'] as List).forEach((v) {
      data.goodsList.add(new HomeGoodsListGoodsList().fromJson(v));
    });
  }
  return data;
}

Map<String, dynamic> searchGoodsListDataToJson(SearchGoodsListData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['total'] = entity.total;
  data['page'] = entity.page;
  if (entity.goodsList != null) {
    data['list'] = entity.goodsList.map((v) => v.toJson()).toList();
  }
  return data;
}

searchGoodsListDataListFromJson(
    SearchGoodsListDataList data, Map<String, dynamic> json) {
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

Map<String, dynamic> searchGoodsListDataListToJson(
    SearchGoodsListDataList entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = entity.id;
  data['goods_name'] = entity.goodsName;
  data['goods_img'] = entity.goodsImg;
  data['original_price'] = entity.originalPrice;
  data['sale_price'] = entity.salePrice;
  data['bt_price'] = entity.btPrice;
  return data;
}
