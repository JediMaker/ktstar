import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class VersionInfoEntity with JsonConvert<VersionInfoEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  VersionInfoData data;
}

class VersionInfoData with JsonConvert<VersionInfoData> {
  @JSONField(name: "version_no")
  String versionNo;
  String desc;
  @JSONField(name: "android_url")
  String androidUrl;
  @JSONField(name: "ios_url")
  String iosUrl;
  @JSONField(name: "wx_login")
  String wxLogin;
  @JSONField(name: "wh_check")
  bool whCheck;
  @JSONField(name: "ios_check")
  bool iosCheck;
}
