import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedVersionInfoEntity with JsonConvert<KeTaoFeaturedVersionInfoEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  KeTaoFeaturedVersionInfoData data;
}

class KeTaoFeaturedVersionInfoData with JsonConvert<KeTaoFeaturedVersionInfoData> {
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
  @JSONField(name: "pgsd_check")
  bool iosCheck;
  @JSONField(name: "build_number")
  String buildNumber;
  @JSONField(name: "build_number_desc")
  String buildNumberDesc;
}
