import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class WechatPayinfoEntity with JsonConvert<WechatPayinfoEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  WechatPayinfoData data;
}

class WechatPayinfoData with JsonConvert<WechatPayinfoData> {
  @JSONField(name: "pay_no")
  String payNo;
  @JSONField(name: "pay_info")
  WechatPayinfoDataPayInfo payInfo;
  bool finish;
}

class WechatPayinfoDataPayInfo with JsonConvert<WechatPayinfoDataPayInfo> {
  String appid;
  String noncestr;
  String package;
  String partnerid;
  String prepayid;
  int timestamp;
  String sign;
}
