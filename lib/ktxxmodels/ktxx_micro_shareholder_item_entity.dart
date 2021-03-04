import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class MicroShareholderItemEntity with JsonConvert<MicroShareholderItemEntity> {
  @JSONField(name: "annual_income")
  String annualIncome;
  @JSONField(name: "pay_price")
  String payPrice;
  MicroShareholderItemEstimate estimate;
  MicroShareholderItemInterests interests;
}

class MicroShareholderItemEstimate
    with JsonConvert<MicroShareholderItemEstimate> {
  String yesterday;
  String week;
  String month;
}

class MicroShareholderItemInterests
    with JsonConvert<MicroShareholderItemInterests> {
  @JSONField(name: "bonus_description")
  String bonusDescription;
  @JSONField(name: "daily_money_rate")
  String dailyMoneyRate;
  @JSONField(name: "bonus_coin")
  String bonusCoin;
  @JSONField(name: "recommend_description")
  String recommendDescription;
  @JSONField(name: "direct_bonus")
  String directBonus;
  @JSONField(name: "indirect_bonus")
  String indirectBonus;
  @JSONField(name: "direct_upgrade")
  String directUpgrade;
  @JSONField(name: "indirect_upgrade")
  String indirectUpgrade;
}
