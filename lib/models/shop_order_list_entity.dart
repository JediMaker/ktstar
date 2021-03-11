import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class ShopOrderListEntity with JsonConvert<ShopOrderListEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  ShopOrderListData data;
}

class ShopOrderListData with JsonConvert<ShopOrderListData> {
  @JSONField(name: "list")
  List<ShopOrderListDataList> xList;
  int page;
  @JSONField(name: "page_size")
  int pageSize;
}

class ShopOrderListDataList with JsonConvert<ShopOrderListDataList> {
  String orderno;
  @JSONField(name: "pay_price")
  String payPrice;
  @JSONField(name: "pay_time")
  String payTime;
  String username;
}
