import 'package:star/ktxxmodels/ktxx_vip_price_info_entity.dart';

vipPriceInfoEntityFromJson(KeTaoFeaturedVipPriceInfoEntity data, Map<String, dynamic> json) {
	if (json['vip'] != null) {
		data.vip = new KeTaoFeaturedVipPriceInfoVip().fromJson(json['vip']);
	}
	if (json['diamond'] != null) {
		data.diamond = new KeTaoFeaturedVipPriceInfoDiamond().fromJson(json['diamond']);
	}
	return data;
}

Map<String, dynamic> vipPriceInfoEntityToJson(KeTaoFeaturedVipPriceInfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.vip != null) {
		data['vip'] = entity.vip.toJson();
	}
	if (entity.diamond != null) {
		data['diamond'] = entity.diamond.toJson();
	}
	return data;
}

vipPriceInfoVipFromJson(KeTaoFeaturedVipPriceInfoVip data, Map<String, dynamic> json) {
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
		data.iconDesc = new List<KeTaoFeaturedVipPriceInfoVipIconDesc>();
		(json['icon_desc'] as List).forEach((v) {
			data.iconDesc.add(new KeTaoFeaturedVipPriceInfoVipIconDesc().fromJson(v));
		});
	}
	if (json['money_list'] != null) {
		data.moneyList = new List<KeTaoFeaturedVipPriceInfoVipMoneyList>();
		(json['money_list'] as List).forEach((v) {
			data.moneyList.add(new KeTaoFeaturedVipPriceInfoVipMoneyList().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> vipPriceInfoVipToJson(KeTaoFeaturedVipPriceInfoVip entity) {
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

vipPriceInfoVipIconDescFromJson(KeTaoFeaturedVipPriceInfoVipIconDesc data, Map<String, dynamic> json) {
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

Map<String, dynamic> vipPriceInfoVipIconDescToJson(KeTaoFeaturedVipPriceInfoVipIconDesc entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['icon'] = entity.icon;
	data['desc'] = entity.desc;
	data['subdesc'] = entity.subdesc;
	data['ssubdesc'] = entity.ssubdesc;
	return data;
}

vipPriceInfoVipMoneyListFromJson(KeTaoFeaturedVipPriceInfoVipMoneyList data, Map<String, dynamic> json) {
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
	if (json['original_price'] != null) {
		data.originalPrice = json['original_price']?.toString();
	}
	return data;
}

Map<String, dynamic> vipPriceInfoVipMoneyListToJson(KeTaoFeaturedVipPriceInfoVipMoneyList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['type'] = entity.type;
	data['desc'] = entity.desc;
	data['price'] = entity.price;
	data['flag'] = entity.flag;
	data['next_price'] = entity.nextPrice;
	data['money_price'] = entity.moneyPrice;
	data['original_price'] = entity.originalPrice;
	return data;
}

vipPriceInfoDiamondFromJson(KeTaoFeaturedVipPriceInfoDiamond data, Map<String, dynamic> json) {
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
		data.iconDesc = new List<KeTaoFeaturedVipPriceInfoDiamondIconDesc>();
		(json['icon_desc'] as List).forEach((v) {
			data.iconDesc.add(new KeTaoFeaturedVipPriceInfoDiamondIconDesc().fromJson(v));
		});
	}
	if (json['money_list'] != null) {
		data.moneyList = new List<KeTaoFeaturedVipPriceInfoDiamondMoneyList>();
		(json['money_list'] as List).forEach((v) {
			data.moneyList.add(new KeTaoFeaturedVipPriceInfoDiamondMoneyList().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> vipPriceInfoDiamondToJson(KeTaoFeaturedVipPriceInfoDiamond entity) {
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

vipPriceInfoDiamondIconDescFromJson(KeTaoFeaturedVipPriceInfoDiamondIconDesc data, Map<String, dynamic> json) {
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

Map<String, dynamic> vipPriceInfoDiamondIconDescToJson(KeTaoFeaturedVipPriceInfoDiamondIconDesc entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['icon'] = entity.icon;
	data['desc'] = entity.desc;
	data['subdesc'] = entity.subdesc;
	data['ssubdesc'] = entity.ssubdesc;
	return data;
}

vipPriceInfoDiamondMoneyListFromJson(KeTaoFeaturedVipPriceInfoDiamondMoneyList data, Map<String, dynamic> json) {
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
	if (json['original_price'] != null) {
		data.originalPrice = json['original_price']?.toString();
	}
	return data;
}

Map<String, dynamic> vipPriceInfoDiamondMoneyListToJson(KeTaoFeaturedVipPriceInfoDiamondMoneyList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['type'] = entity.type;
	data['desc'] = entity.desc;
	data['price'] = entity.price;
	data['flag'] = entity.flag;
	data['next_price'] = entity.nextPrice;
	data['money_price'] = entity.moneyPrice;
	data['original_price'] = entity.originalPrice;
	return data;
}