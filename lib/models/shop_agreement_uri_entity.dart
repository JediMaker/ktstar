import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class ShopAgreementUriEntity with JsonConvert<ShopAgreementUriEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  ShopAgreementUriData data;
}

class ShopAgreementUriData with JsonConvert<ShopAgreementUriData> {
  String sjrz;
}
