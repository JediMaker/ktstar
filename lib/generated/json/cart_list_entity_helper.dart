import 'package:star/models/cart_list_entity.dart';

cartListEntityFromJson(CartListEntity data, Map<String, dynamic> json) {
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
    data.data = new CartListData().fromJson(json['data']);
  }
  return data;
}

Map<String, dynamic> cartListEntityToJson(CartListEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  return data;
}

cartListDataFromJson(CartListData data, Map<String, dynamic> json) {
  if (json['count'] != null) {
    data.count = json['count']?.toString();
  }
  if (json['num'] != null) {
    data.num = json['num']?.toString();
  }
  if (json['list'] != null) {
    data.xList = new List<CartListDataList>();
    (json['list'] as List).forEach((v) {
      data.xList.add(new CartListDataList().fromJson(v));
    });
  }
  return data;
}

Map<String, dynamic> cartListDataToJson(CartListData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['count'] = entity.count;
  data['num'] = entity.num;
  if (entity.xList != null) {
    data['list'] = entity.xList.map((v) => v.toJson()).toList();
  }
  return data;
}

cartListDataListFromJson(CartListDataList data, Map<String, dynamic> json) {
  if (json['cart_id'] != null) {
    data.cartId = json['cart_id']?.toString();
  }
  if (json['goods_id'] != null) {
    data.goodsId = json['goods_id']?.toString();
  }
  if (json['goods_spec_id'] != null) {
    data.goodsSpecId = json['goods_spec_id']?.toString();
  }
  if (json['goods_num'] != null) {
    data.goodsNum = json['goods_num']?.toString();
  }
  if (json['goods_name'] != null) {
    data.goodsName = json['goods_name']?.toString();
  }
  if (json['goods_status'] != null) {
    data.goodsStatus = json['goods_status']?.toString();
  }
  if (json['spec_item'] != null) {
    data.specItem = json['spec_item']?.toString();
  }
  if (json['goods_img'] != null) {
    data.goodsImg = json['goods_img']?.toString();
  }
  if (json['goods_price'] != null) {
    data.goodsPrice = json['goods_price']?.toString();
  }
  if (json['goods_coin'] != null) {
    data.goodsCoin = json['goods_coin']?.toString();
  }
  return data;
}

Map<String, dynamic> cartListDataListToJson(CartListDataList entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['cart_id'] = entity.cartId;
  data['goods_id'] = entity.goodsId;
  data['goods_spec_id'] = entity.goodsSpecId;
  data['goods_num'] = entity.goodsNum;
  data['goods_name'] = entity.goodsName;
  data['goods_status'] = entity.goodsStatus;
  data['spec_item'] = entity.specItem;
  data['goods_img'] = entity.goodsImg;
  data['goods_price'] = entity.goodsPrice;
  data['goods_coin'] = entity.goodsCoin;
  return data;
}
