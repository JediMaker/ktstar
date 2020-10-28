import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class VipPriceInfoEntity with JsonConvert<VipPriceInfoEntity> {
	VipPriceInfoVip vip;
	VipPriceInfoDiamond diamond;
}

class VipPriceInfoVip with JsonConvert<VipPriceInfoVip> {
	String name;
	@JSONField(name: "profit_day")
	String profitDay;
	String desc;
	@JSONField(name: "year_money")
	String yearMoney;
	@JSONField(name: "b_year_money")
	String bYearMoney;
	@JSONField(name: "icon_desc")
	List<VipPriceInfoVipIconDesc> iconDesc;
	@JSONField(name: "money_list")
	List<VipPriceInfoVipMoneyList> moneyList;
}

class VipPriceInfoVipIconDesc with JsonConvert<VipPriceInfoVipIconDesc> {
	String icon;
	String desc;
	String subdesc;
	String ssubdesc;
}

class VipPriceInfoVipMoneyList with JsonConvert<VipPriceInfoVipMoneyList> {
	String type;
	String desc;
	String price;
	bool flag;
	@JSONField(name: "next_price")
	String nextPrice;
	@JSONField(name: "money_price")
	String moneyPrice;
	@JSONField(name: "original_price")
	String originalPrice;
}

class VipPriceInfoDiamond with JsonConvert<VipPriceInfoDiamond> {
	String name;
	@JSONField(name: "profit_day")
	String profitDay;
	String desc;
	@JSONField(name: "year_money")
	String yearMoney;
	@JSONField(name: "b_year_money")
	String bYearMoney;
	@JSONField(name: "icon_desc")
	List<VipPriceInfoDiamondIconDesc> iconDesc;
	@JSONField(name: "money_list")
	List<VipPriceInfoDiamondMoneyList> moneyList;
}

class VipPriceInfoDiamondIconDesc with JsonConvert<VipPriceInfoDiamondIconDesc> {
	String icon;
	String desc;
	String subdesc;
	String ssubdesc;
}

class VipPriceInfoDiamondMoneyList with JsonConvert<VipPriceInfoDiamondMoneyList> {
	String type;
	String desc;
	String price;
	bool flag;
	@JSONField(name: "next_price")
	String nextPrice;
	@JSONField(name: "money_price")
	String moneyPrice;
	@JSONField(name: "original_price")
	String originalPrice;
}
