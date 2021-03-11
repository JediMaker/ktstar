import 'package:star/models/shop_agreement_uri_entity.dart';

shopAgreementUriEntityFromJson(
    ShopAgreementUriEntity data, Map<String, dynamic> json) {
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
    data.data = new ShopAgreementUriData().fromJson(json['data']);
  }
  return data;
}

Map<String, dynamic> shopAgreementUriEntityToJson(
    ShopAgreementUriEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  return data;
}

shopAgreementUriDataFromJson(
    ShopAgreementUriData data, Map<String, dynamic> json) {
  if (json['sjrz'] != null) {
    data.sjrz = json['sjrz']?.toString();
  }
  return data;
}

Map<String, dynamic> shopAgreementUriDataToJson(ShopAgreementUriData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['sjrz'] = entity.sjrz;
  return data;
}
