import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class LotteryAttackResultEntity with JsonConvert<LotteryAttackResultEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  LotteryAttackResultData data;
}

class LotteryAttackResultData with JsonConvert<LotteryAttackResultData> {
  @JSONField(name: "a_status")
  String aStatus;
  @JSONField(name: "a_avatar")
  String aAvatar;
  @JSONField(name: "a_title")
  String aTitle;
  @JSONField(name: "a_desc")
  String aDesc;
  @JSONField(name: "a_result")
  String aResult;
}
