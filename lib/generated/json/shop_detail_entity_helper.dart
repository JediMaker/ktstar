import 'package:star/models/shop_detail_entity.dart';

shopDetailEntityFromJson(ShopDetailEntity data, Map<String, dynamic> json) {
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
    data.data = new ShopDetailData().fromJson(json['data']);
  }
  return data;
}

Map<String, dynamic> shopDetailEntityToJson(ShopDetailEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  return data;
}

shopDetailDataFromJson(ShopDetailData data, Map<String, dynamic> json) {
  if (json['store_id'] != null) {
    data.storeId = json['store_id']?.toString();
  }
  if (json['store_uid'] != null) {
    data.storeUid = json['store_uid']?.toString();
  }
  if (json['store_name'] != null) {
    data.storeName = json['store_name']?.toString();
  }
  if (json['store_img'] != null) {
    data.storeImg = json['store_img']?.toString();
  }
  if (json['store_img_url'] != null) {
    data.storeImgUrl = json['store_img_url']?.toString();
  }
  if (json['store_logo'] != null) {
    data.storeLogo = json['store_logo']?.toString();
  }
  if (json['store_logo_url'] != null) {
    data.storeLogoUrl = json['store_logo_url']?.toString();
  }
  if (json['trade_id'] != null) {
    data.tradeId = json['trade_id']?.toString();
  }
  if (json['trade_name'] != null) {
    data.tradeName = json['trade_name']?.toString();
  }
  if (json['store_desc'] != null) {
    data.storeDesc = json['store_desc']?.toString();
  }
  if (json['store_tel'] != null) {
    data.storeTel = json['store_tel']?.toString();
  }
  if (json['store_lat'] != null) {
    data.storeLat = json['store_lat']?.toString();
  }
  if (json['store_lng'] != null) {
    data.storeLng = json['store_lng']?.toString();
  }
  if (json['store_province'] != null) {
    data.storeProvince = json['store_province']?.toString();
  }
  if (json['store_city'] != null) {
    data.storeCity = json['store_city']?.toString();
  }
  if (json['store_district'] != null) {
    data.storeDistrict = json['store_district']?.toString();
  }
  if (json['store_addr'] != null) {
    data.storeAddr = json['store_addr']?.toString();
  }
  if (json['store_distance'] != null) {
    data.storeDistance = json['store_distance']?.toString();
  }
  if (json['store_ratio'] != null) {
    data.storeRatio = json['store_ratio']?.toString();
  }
  if (json['store_code'] != null) {
    data.storeCode = json['store_code']?.toString();
  }
  if (json['store_status'] != null) {
    data.storeStatus = json['store_status']?.toString();
  }
  if (json['store_reject_msg'] != null) {
    data.storeRejectMsg = json['store_reject_msg']?.toString();
  }
  if (json['store_apply_time'] != null) {
    data.storeApplyTime = json['store_apply_time']?.toString();
  }
  if (json['store_check_time'] != null) {
    data.storeCheckTime = json['store_check_time']?.toString();
  }
  return data;
}

Map<String, dynamic> shopDetailDataToJson(ShopDetailData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['store_id'] = entity.storeId;
  data['store_uid'] = entity.storeUid;
  data['store_name'] = entity.storeName;
  data['store_img'] = entity.storeImg;
  data['store_img_url'] = entity.storeImgUrl;
  data['store_logo'] = entity.storeLogo;
  data['store_logo_url'] = entity.storeLogoUrl;
  data['trade_id'] = entity.tradeId;
  data['trade_name'] = entity.tradeName;
  data['store_desc'] = entity.storeDesc;
  data['store_tel'] = entity.storeTel;
  data['store_lat'] = entity.storeLat;
  data['store_lng'] = entity.storeLng;
  data['store_province'] = entity.storeProvince;
  data['store_city'] = entity.storeCity;
  data['store_district'] = entity.storeDistrict;
  data['store_addr'] = entity.storeAddr;
  data['store_distance'] = entity.storeDistance;
  data['store_ratio'] = entity.storeRatio;
  data['store_code'] = entity.storeCode;
  data['store_status'] = entity.storeStatus;
  data['store_reject_msg'] = entity.storeRejectMsg;
  data['store_apply_time'] = entity.storeApplyTime;
  data['store_check_time'] = entity.storeCheckTime;
  return data;
}
