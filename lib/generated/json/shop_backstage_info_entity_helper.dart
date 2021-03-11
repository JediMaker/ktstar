import 'package:star/models/shop_backstage_info_entity.dart';

shopBackstageInfoEntityFromJson(
    ShopBackstageInfoEntity data, Map<String, dynamic> json) {
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
    data.data = new ShopBackstageInfoData().fromJson(json['data']);
  }
  return data;
}

Map<String, dynamic> shopBackstageInfoEntityToJson(
    ShopBackstageInfoEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  return data;
}

shopBackstageInfoDataFromJson(
    ShopBackstageInfoData data, Map<String, dynamic> json) {
  if (json['today_orders'] != null) {
    data.todayOrders = json['today_orders']?.toString();
  }
  if (json['today_amount'] != null) {
    data.todayAmount = json['today_amount']?.toString();
  }
  if (json['store_qrcode'] != null) {
    data.storeQrcode = json['store_qrcode']?.toString();
  }
  return data;
}

Map<String, dynamic> shopBackstageInfoDataToJson(ShopBackstageInfoData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['today_orders'] = entity.todayOrders;
  data['today_amount'] = entity.todayAmount;
  data['store_qrcode'] = entity.storeQrcode;
  return data;
}
