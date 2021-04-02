import 'package:star/models/cart_create_order_entity.dart';

cartCreateOrderEntityFromJson(
    CartCreateOrderEntity data, Map<String, dynamic> json) {
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
    data.data = new CartCreateOrderData().fromJson(json['data']);
  }
  return data;
}

Map<String, dynamic> cartCreateOrderEntityToJson(CartCreateOrderEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  return data;
}

cartCreateOrderDataFromJson(
    CartCreateOrderData data, Map<String, dynamic> json) {
  if (json['order_attach_id'] != null) {
    data.orderAttachId = json['order_attach_id']?.toString();
  }
  return data;
}

Map<String, dynamic> cartCreateOrderDataToJson(CartCreateOrderData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['order_attach_id'] = entity.orderAttachId;
  return data;
}
