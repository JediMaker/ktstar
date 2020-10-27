import 'package:star/models/vip_price_info_entity.dart';

vipPriceInfoEntityFromJson(VipPriceInfoEntity data, Map<String, dynamic> json) {
	if (json['vip'] != null) {
		data.vip = new VipPriceInfoVip().fromJson(json['vip']);
	}
	if (json['diamond'] != null) {
		data.diamond = new VipPriceInfoDiamond().fromJson(json['diamond']);
	}
	return data;
}

Map<String, dynamic> vipPriceInfoEntityToJson(VipPriceInfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.vip != null) {
		data['vip'] = entity.vip.toJson();
	}
	if (entity.diamond != null) {
		data['diamond'] = entity.diamond.toJson();
	}
	return data;
}

vipPriceInfoVipFromJson(VipPriceInfoVip data, Map<String, dynamic> json) {
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	if (json['profit_day'] != null) {
		data.profitDay = json['profit_day']?.toString();
	}
	if (json['desc'] != null) {
		data.desc = json['desc']?.toString();
	}
	if (json['year_money'] != null) {
		data.yearMoney = json['year_money']?.toString();
	}
	if (json['b_year_money'] != null) {
		data.bYearMoney = json['b_year_money']?.toString();
	}
	if (json['icon_desc'] != null) {
		data.iconDesc = new List<VipPriceInfoVipIconDesc>();
		(json['icon_desc'] as List).forEach((v) {
			data.iconDesc.add(new VipPriceInfoVipIconDesc().fromJson(v));
		});
	}
	if (json['money_list'] != null) {
		data.moneyList = new List<VipPriceInfoVipMoneyList>();
		(json['money_list'] as List).forEach((v) {
			data.moneyList.add(new VipPriceInfoVipMoneyList().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> vipPriceInfoVipToJson(VipPriceInfoVip entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['name'] = entity.name;
	data['profit_day'] = entity.profitDay;
	data['desc'] = entity.desc;
	data['year_money'] = entity.yearMoney;
	data['b_year_money'] = entity.bYearMoney;
	if (entity.iconDesc != null) {
		data['icon_desc'] =  entity.iconDesc.map((v) => v.toJson()).toList();
	}
	if (entity.moneyList != null) {
		data['money_list'] =  entity.moneyList.map((v) => v.toJson()).toList();
	}
	return data;
}

vipPriceInfoVipIconDescFromJson(VipPriceInfoVipIconDesc data, Map<String, dynamic> json) {
	if (json['icon'] != null) {
		data.icon = json['icon']?.toString();
	}
	if (json['desc'] != null) {
		data.desc = json['desc']?.toString();
	}
	if (json['subdesc'] != null) {
		data.subdesc = json['subdesc']?.toString();
	}
	if (json['ssubdesc'] != null) {
		data.ssubdesc = json['ssubdesc']?.toString();
	}
	return data;
}

Map<String, dynamic> vipPriceInfoVipIconDescToJson(VipPriceInfoVipIconDesc entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['icon'] = entity.icon;
	data['desc'] = entity.desc;
	data['subdesc'] = entity.subdesc;
	data['ssubdesc'] = entity.ssubdesc;
	return data;
}

vipPriceInfoVipMoneyListFromJson(VipPriceInfoVipMoneyList data, Map<String, dynamic> json) {
	if (json['type'] != null) {
		data.type = json['type']?.toString();
	}
	if (json['desc'] != null) {
		data.desc = json['desc']?.toString();
	}
	if (json['price'] != null) {
		data.price = json['price']?.toString();
	}
	if (json['flag'] != null) {
		data.flag = json['flag'];
	}
	if (json['next_price'] != null) {
		data.nextPrice = json['next_price']?.toString();
	}
	if (json['money_price'] != null) {
		data.moneyPrice = json['money_price']?.toString();
	}
	return data;
}

Map<String, dynamic> vipPriceInfoVipMoneyListToJson(VipPriceInfoVipMoneyList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['type'] = entity.type;
	data['desc'] = entity.desc;
	data['price'] = entity.price;
	data['flag'] = entity.flag;
	data['next_price'] = entity.nextPrice;
	data['money_price'] = entity.moneyPrice;
	return data;
}

vipPriceInfoDiamondFromJson(VipPriceInfoDiamond data, Map<String, dynamic> json) {
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	if (json['profit_day'] != null) {
		data.profitDay = json['profit_day']?.toString();
	}
	if (json['desc'] != null) {
		data.desc = json['desc']?.toString();
	}
	if (json['year_money'] != null) {
		data.yearMoney = json['year_money']?.toString();
	}
	if (json['b_year_money'] != null) {
		data.bYearMoney = json['b_year_money']?.toString();
	}
	if (json['icon_desc'] != null) {
		data.iconDesc = new List<VipPriceInfoDiamondIconDesc>();
		(json['icon_desc'] as List).forEach((v) {
			data.iconDesc.add(new VipPriceInfoDiamondIconDesc().fromJson(v));
		});
	}
	if (json['money_list'] != null) {
		data.moneyList = new List<VipPriceInfoDiamondMoneyList>();
		(json['money_list'] as List).forEach((v) {
			data.moneyList.add(new VipPriceInfoDiamondMoneyList().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> vipPriceInfoDiamondToJson(VipPriceInfoDiamond entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['name'] = entity.name;
	data['profit_day'] = entity.profitDay;
	data['desc'] = entity.desc;
	data['year_money'] = entity.yearMoney;
	data['b_year_money'] = entity.bYearMoney;
	if (entity.iconDesc != null) {
		data['icon_desc'] =  entity.iconDesc.map((v) => v.toJson()).toList();
	}
	if (entity.moneyList != null) {
		data['money_list'] =  entity.moneyList.map((v) => v.toJson()).toList();
	}
	return data;
}

vipPriceInfoDiamondIconDescFromJson(VipPriceInfoDiamondIconDesc data, Map<String, dynamic> json) {
	if (json['icon'] != null) {
		data.icon = json['icon']?.toString();
	}
	if (json['desc'] != null) {
		data.desc = json['desc']?.toString();
	}
	if (json['subdesc'] != null) {
		data.subdesc = json['subdesc']?.toString();
	}
	if (json['ssubdesc'] != null) {
		data.ssubdesc = json['ssubdesc']?.toString();
	}
	return data;
}

Map<String, dynamic> vipPriceInfoDiamondIconDescToJson(VipPriceInfoDiamondIconDesc entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['icon'] = entity.icon;
	data['desc'] = entity.desc;
	data['subdesc'] = entity.subdesc;
	data['ssubdesc'] = entity.ssubdesc;
	return data;
}

vipPriceInfoDiamondMoneyListFromJson(VipPriceInfoDiamondMoneyList data, Map<String, dynamic> json) {
	if (json['type'] != null) {
		data.type = json['type']?.toString();
	}
	if (json['desc'] != null) {
		data.desc = json['desc']?.toString();
	}
	if (json['price'] != null) {
		data.price = json['price']?.toString();
	}
	if (json['flag'] != null) {
		data.flag = json['flag'];
	}
	if (json['next_price'] != null) {
		data.nextPrice = json['next_price']?.toString();
	}
	if (json['money_price'] != null) {
		data.moneyPrice = json['money_price']?.toString();
	}
	return data;
}

Map<String, dynamic> vipPriceInfoDiamondMoneyListToJson(VipPriceInfoDiamondMoneyList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['type'] = entity.type;
	data['desc'] = entity.desc;
	data['price'] = entity.price;
	data['flag'] = entity.flag;
	data['next_price'] = entity.nextPrice;
	data['money_price'] = entity.moneyPrice;
	return data;
}