import 'package:star/ktxxmodels/user_holder_profit_entity.dart';

userHolderProfitEntityFromJson(UserHolderProfitEntity data, Map<String, dynamic> json) {
	if (json['partner_bonus'] != null) {
		data.partnerBonus = new UserHolderProfitPartnerBonus().fromJson(json['partner_bonus']);
	}
	return data;
}

Map<String, dynamic> userHolderProfitEntityToJson(UserHolderProfitEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.partnerBonus != null) {
		data['partner_bonus'] = entity.partnerBonus.toJson();
	}
	return data;
}

userHolderProfitPartnerBonusFromJson(UserHolderProfitPartnerBonus data, Map<String, dynamic> json) {
	if (json['today_price'] != null) {
		data.todayPrice = json['today_price']?.toString();
	}
	if (json['today_deserve'] != null) {
		data.todayDeserve = json['today_deserve']?.toString();
	}
	if (json['yesterday'] != null) {
		data.yesterday = json['yesterday']?.toString();
	}
	if (json['week'] != null) {
		data.week = json['week']?.toString();
	}
	if (json['month'] != null) {
		data.month = json['month']?.toString();
	}
	if (json['total'] != null) {
		data.total = json['total']?.toString();
	}
	if (json['coin'] != null) {
		data.coin = json['coin']?.toString();
	}
	return data;
}

Map<String, dynamic> userHolderProfitPartnerBonusToJson(UserHolderProfitPartnerBonus entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['today_price'] = entity.todayPrice;
	data['today_deserve'] = entity.todayDeserve;
	data['yesterday'] = entity.yesterday;
	data['week'] = entity.week;
	data['month'] = entity.month;
	data['total'] = entity.total;
	data['coin'] = entity.coin;
	return data;
}