import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class LotteryAttackedUserEntity with JsonConvert<LotteryAttackedUserEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  LotteryAttackedUserData data;
}

class LotteryAttackedUserData with JsonConvert<LotteryAttackedUserData> {
  List<LotteryAttackedUserDataUser> users;
  String times;
}

class LotteryAttackedUserDataUser
    with JsonConvert<LotteryAttackedUserDataUser> {
  String uid;
}
