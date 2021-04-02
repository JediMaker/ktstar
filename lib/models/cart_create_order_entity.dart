import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class CartCreateOrderEntity with JsonConvert<CartCreateOrderEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  CartCreateOrderData data;
}

class CartCreateOrderData with JsonConvert<CartCreateOrderData> {
  @JSONField(name: "order_attach_id")
  String orderAttachId;
}
