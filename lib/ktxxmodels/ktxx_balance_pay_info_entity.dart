import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class BalancePayInfoEntity with JsonConvert<BalancePayInfoEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  BalancePayInfoData data;
}

class BalancePayInfoData
    with JsonConvert<BalancePayInfoData> {
  @JSONField(name: "pay_no")
  String payNo;
  @JSONField(name: "pay_info")
  List<dynamic> payInfo;
}
