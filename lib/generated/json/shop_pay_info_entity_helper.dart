import 'package:star/models/shop_pay_info_entity.dart';

shopPayInfoEntityFromJson(ShopPayInfoEntity data, Map<String, dynamic> json) {
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
    data.data = new ShopPayInfoData().fromJson(json['data']);
  }
  return data;
}

Map<String, dynamic> shopPayInfoEntityToJson(ShopPayInfoEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  return data;
}

shopPayInfoDataFromJson(ShopPayInfoData data, Map<String, dynamic> json) {
  if (json['store'] != null) {
    data.store = new ShopPayInfoDataStore().fromJson(json['store']);
  }
  if (json['user'] != null) {
    data.user = new ShopPayInfoDataUser().fromJson(json['user']);
  }
  return data;
}

Map<String, dynamic> shopPayInfoDataToJson(ShopPayInfoData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (entity.store != null) {
    data['store'] = entity.store.toJson();
  }
  if (entity.user != null) {
    data['user'] = entity.user.toJson();
  }
  return data;
}

shopPayInfoDataStoreFromJson(
    ShopPayInfoDataStore data, Map<String, dynamic> json) {
  if (json['store_name'] != null) {
    data.storeName = json['store_name']?.toString();
  }
  if (json['store_code'] != null) {
    data.storeCode = json['store_code']?.toString();
  }
  return data;
}

Map<String, dynamic> shopPayInfoDataStoreToJson(ShopPayInfoDataStore entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['store_name'] = entity.storeName;
  data['store_code'] = entity.storeCode;
  return data;
}

shopPayInfoDataUserFromJson(
    ShopPayInfoDataUser data, Map<String, dynamic> json) {
  if (json['price'] != null) {
    data.price = json['price']?.toString();
  }
  if (json['pay_pwd_flag'] != null) {
    data.payPwdFlag = json['pay_pwd_flag'];
  }
  return data;
}

Map<String, dynamic> shopPayInfoDataUserToJson(ShopPayInfoDataUser entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['price'] = entity.price;
  data['pay_pwd_flag'] = entity.payPwdFlag;
  return data;
}
