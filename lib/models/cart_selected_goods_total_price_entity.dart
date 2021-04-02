import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class CartSelectedGoodsTotalPriceEntity
    with JsonConvert<CartSelectedGoodsTotalPriceEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  CartSelectedGoodsTotalPriceData data;
}

class CartSelectedGoodsTotalPriceData
    with JsonConvert<CartSelectedGoodsTotalPriceData> {
  @JSONField(name: "total_price")
  String totalPrice;
}
