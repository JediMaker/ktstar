import 'package:star/ktxxmodels/ktxx_goods_info_entity.dart';
import 'package:star/ktxxmodels/ktxx_goods_spec_info_entity.dart';

goodsInfoEntityFromJson(GoodsInfoEntity data, Map<String, dynamic> json) {
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
      data.data = new GoodsInfoData().fromJson(json['data']);
    } catch (e) {}
  }
  return data;
}

Map<String, dynamic> goodsInfoEntityToJson(GoodsInfoEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  return data;
}

goodsInfoDataFromJson(GoodsInfoData data, Map<String, dynamic> json) {
  if (json['id'] != null) {
    data.id = json['id']?.toString();
  }
  if (json['goods_name'] != null) {
    data.goodsName = json['goods_name']?.toString();
  }
  if (json['original_price'] != null) {
    try {
      data.originalPrice = json['original_price']?.toString();
    } catch (e) {}
  }
  if (json['sale_price'] != null) {
    try {
      data.salePrice = json['sale_price']?.toString();
    } catch (e) {}
  }
  if (json['banner_imgs'] != null) {
    try {
      data.bannerImgs = json['banner_imgs']
          ?.map((v) => v?.toString())
          ?.toList()
          ?.cast<String>();
    } catch (e) {}
  }
  if (json['detail_imgs'] != null) {
    try {
      data.detailImgs = json['detail_imgs']
          ?.map((v) => v?.toString())
          ?.toList()
          ?.cast<String>();
    } catch (e) {}
  }
  if (json['queue_count'] != null) {
    try {
      data.queueCount = json['queue_count']?.toString();
    } catch (e) {}
  }
  if (json['bt_price'] != null) {
    try {
      data.btPrice = json['bt_price']?.toString();
    } catch (e) {}
  }
  if (json['is_coupon'] != null) {
    try {
      data.isCoupon = json['is_coupon']?.toString();
    } catch (e) {}
  }
  if (json['min_power'] != null) {
    try {
      data.minPower = json['min_power']?.toString();
    } catch (e) {}
  }
  if (json['spec_info'] != null) {
    try {
      data.specInfo = new GoodsSpecInfoSpecInfo().fromJson(json['spec_info']);
    } catch (e) {}
  }
  return data;
}

Map<String, dynamic> goodsInfoDataToJson(GoodsInfoData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = entity.id;
  data['goods_name'] = entity.goodsName;
  data['original_price'] = entity.originalPrice;
  data['sale_price'] = entity.salePrice;
  data['banner_imgs'] = entity.bannerImgs;
  data['detail_imgs'] = entity.detailImgs;
  data['queue_count'] = entity.queueCount;
  data['bt_price'] = entity.btPrice;
  data['is_coupon'] = entity.isCoupon;
  data['min_power'] = entity.minPower;
  if (entity.specInfo != null) {
    data['spec_info'] = entity.specInfo.toJson();
  }
  return data;
}
