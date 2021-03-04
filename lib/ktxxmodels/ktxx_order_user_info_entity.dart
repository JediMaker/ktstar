import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class OrderUserInfoEntity with JsonConvert<OrderUserInfoEntity> {
  @JSONField(name: "user_info")
  OrderUserInfoUserInfo userInfo;
}

class OrderUserInfoUserInfo with JsonConvert<OrderUserInfoUserInfo> {
  String price;
  @JSONField(name: "pay_pwd_flag")
  bool payPwdFlag;
}
