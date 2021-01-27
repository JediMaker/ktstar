import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class MicroShareholderItemEntity with JsonConvert<MicroShareholderItemEntity> {
	@JSONField(name: "annual_income")
	String annualIncome;
	@JSONField(name: "pay_price")
	int payPrice;
	MicroShareholderItemEstimate estimate;
	MicroShareholderItemInterests interests;
}

class MicroShareholderItemEstimate with JsonConvert<MicroShareholderItemEstimate> {
	int yesterday;
	int week;
	int month;
}

class MicroShareholderItemInterests with JsonConvert<MicroShareholderItemInterests> {
	@JSONField(name: "bonus_description")
	String bonusDescription;
	@JSONField(name: "daily_money_rate")
	int dailyMoneyRate;
	@JSONField(name: "bonus_coin")
	int bonusCoin;
	@JSONField(name: "recommend_description")
	String recommendDescription;
	@JSONField(name: "direct_bonus")
	int directBonus;
	@JSONField(name: "indirect_bonus")
	int indirectBonus;
	@JSONField(name: "direct_upgrade")
	int directUpgrade;
	@JSONField(name: "indirect_upgrade")
	int indirectUpgrade;
}
