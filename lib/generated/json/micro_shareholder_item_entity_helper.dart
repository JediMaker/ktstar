import 'package:star/models/micro_shareholder_item_entity.dart';

microShareholderItemEntityFromJson(MicroShareholderItemEntity data, Map<String, dynamic> json) {
	if (json['annual_income'] != null) {
		data.annualIncome = json['annual_income']?.toString();
	}
	if (json['pay_price'] != null) {
		data.payPrice = json['pay_price']?.toString();
	}
	if (json['estimate'] != null) {
		data.estimate = new MicroShareholderItemEstimate().fromJson(json['estimate']);
	}
	if (json['interests'] != null) {
		data.interests = new MicroShareholderItemInterests().fromJson(json['interests']);
	}
	return data;
}

Map<String, dynamic> microShareholderItemEntityToJson(MicroShareholderItemEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['annual_income'] = entity.annualIncome;
	data['pay_price'] = entity.payPrice;
	if (entity.estimate != null) {
		data['estimate'] = entity.estimate.toJson();
	}
	if (entity.interests != null) {
		data['interests'] = entity.interests.toJson();
	}
	return data;
}

microShareholderItemEstimateFromJson(MicroShareholderItemEstimate data, Map<String, dynamic> json) {
	if (json['yesterday'] != null) {
		data.yesterday = json['yesterday']?.toString();
	}
	if (json['week'] != null) {
		data.week = json['week']?.toString();
	}
	if (json['month'] != null) {
		data.month = json['month']?.toString();
	}
	return data;
}

Map<String, dynamic> microShareholderItemEstimateToJson(MicroShareholderItemEstimate entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['yesterday'] = entity.yesterday;
	data['week'] = entity.week;
	data['month'] = entity.month;
	return data;
}

microShareholderItemInterestsFromJson(MicroShareholderItemInterests data, Map<String, dynamic> json) {
	if (json['bonus_description'] != null) {
		data.bonusDescription = json['bonus_description']?.toString();
	}
	if (json['daily_money_rate'] != null) {
		data.dailyMoneyRate = json['daily_money_rate']?.toString();
	}
	if (json['bonus_coin'] != null) {
		data.bonusCoin = json['bonus_coin']?.toString();
	}
	if (json['recommend_description'] != null) {
		data.recommendDescription = json['recommend_description']?.toString();
	}
	if (json['direct_bonus'] != null) {
		data.directBonus = json['direct_bonus']?.toString();
	}
	if (json['indirect_bonus'] != null) {
		data.indirectBonus = json['indirect_bonus']?.toString();
	}
	if (json['direct_upgrade'] != null) {
		data.directUpgrade = json['direct_upgrade']?.toString();
	}
	if (json['indirect_upgrade'] != null) {
		data.indirectUpgrade = json['indirect_upgrade']?.toString();
	}
	return data;
}

Map<String, dynamic> microShareholderItemInterestsToJson(MicroShareholderItemInterests entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['bonus_description'] = entity.bonusDescription;
	data['daily_money_rate'] = entity.dailyMoneyRate;
	data['bonus_coin'] = entity.bonusCoin;
	data['recommend_description'] = entity.recommendDescription;
	data['direct_bonus'] = entity.directBonus;
	data['indirect_bonus'] = entity.indirectBonus;
	data['direct_upgrade'] = entity.directUpgrade;
	data['indirect_upgrade'] = entity.indirectUpgrade;
	return data;
}