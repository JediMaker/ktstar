import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class ShoppingCardInfoEntity with JsonConvert<ShoppingCardInfoEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  ShoppingCardInfoData data;
}

class ShoppingCardInfoData with JsonConvert<ShoppingCardInfoData> {
  List<String> money;
  @JSONField(name: "now_money")
  String nowMoney;
  List<String> rules;
}
