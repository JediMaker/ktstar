import 'package:star/models/cart_selected_goods_total_price_entity.dart';

cartSelectedGoodsTotalPriceEntityFromJson(
    CartSelectedGoodsTotalPriceEntity data, Map<String, dynamic> json) {
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
    data.data = new CartSelectedGoodsTotalPriceData().fromJson(json['data']);
  }
  return data;
}

Map<String, dynamic> cartSelectedGoodsTotalPriceEntityToJson(
    CartSelectedGoodsTotalPriceEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  return data;
}

cartSelectedGoodsTotalPriceDataFromJson(
    CartSelectedGoodsTotalPriceData data, Map<String, dynamic> json) {
  if (json['total_price'] != null) {
    data.totalPrice = json['total_price']?.toString();
  }
  return data;
}

Map<String, dynamic> cartSelectedGoodsTotalPriceDataToJson(
    CartSelectedGoodsTotalPriceData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['total_price'] = entity.totalPrice;
  return data;
}
