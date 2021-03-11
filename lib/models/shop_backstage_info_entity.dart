import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class ShopBackstageInfoEntity with JsonConvert<ShopBackstageInfoEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  ShopBackstageInfoData data;
}

class ShopBackstageInfoData with JsonConvert<ShopBackstageInfoData> {
  @JSONField(name: "today_orders")
  String todayOrders;
  @JSONField(name: "today_amount")
  String todayAmount;
  @JSONField(name: "store_qrcode")
  String storeQrcode;
}
