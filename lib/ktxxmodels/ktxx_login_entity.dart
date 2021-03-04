import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class LoginEntity with JsonConvert<LoginEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  LoginData data;
}

class LoginData with JsonConvert<LoginData> {
  String token;
  String refertoken;
  @JSONField(name: "expire_time")
  int expireTime;
  String username;
  dynamic tel;
  String avatar;
}
