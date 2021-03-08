import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class RechargeExtraEntity with JsonConvert<RechargeExtraEntity> {
  @JSONField(name: "s_rechage_list")
  List<RechargeExtraSRechageList> sRechageList;
  RechargeExtraRatio ratio;
}

class RechargeExtraSRechageList with JsonConvert<RechargeExtraSRechageList> {
  String id;
  @JSONField(name: "face_money")
  String faceMoney;
  @JSONField(name: "use_money")
  String useMoney;
  bool flag;
  @JSONField(name: "pay_money")
  String payMoney;
  String coin;
  @JSONField(name: "coin_desc")
  String coinDesc;
  @JSONField(name: "rebate_money")
  String rebateMoney;
  @JSONField(name: "money_desc")
  String moneyDesc;
}

class RechargeExtraRatio with JsonConvert<RechargeExtraRatio> {
  String fast;
  String slow;
}
