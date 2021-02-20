import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedVipPriceInfoEntity with JsonConvert<KeTaoFeaturedVipPriceInfoEntity> {
	KeTaoFeaturedVipPriceInfoVip vip;
	KeTaoFeaturedVipPriceInfoDiamond diamond;
}

class KeTaoFeaturedVipPriceInfoVip with JsonConvert<KeTaoFeaturedVipPriceInfoVip> {
	String name;
	@JSONField(name: "profit_day")
	String profitDay;
	String desc;
	@JSONField(name: "year_money")
	String yearMoney;
	@JSONField(name: "b_year_money")
	String bYearMoney;
	@JSONField(name: "icon_desc")
	List<KeTaoFeaturedVipPriceInfoVipIconDesc> iconDesc;
	@JSONField(name: "money_list")
	List<KeTaoFeaturedVipPriceInfoVipMoneyList> moneyList;
}

class KeTaoFeaturedVipPriceInfoVipIconDesc with JsonConvert<KeTaoFeaturedVipPriceInfoVipIconDesc> {
	String icon;
	String desc;
	String subdesc;
	String ssubdesc;
}

class KeTaoFeaturedVipPriceInfoVipMoneyList with JsonConvert<KeTaoFeaturedVipPriceInfoVipMoneyList> {
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

class KeTaoFeaturedVipPriceInfoDiamond with JsonConvert<KeTaoFeaturedVipPriceInfoDiamond> {
	String name;
	@JSONField(name: "profit_day")
	String profitDay;
	String desc;
	@JSONField(name: "year_money")
	String yearMoney;
	@JSONField(name: "b_year_money")
	String bYearMoney;
	@JSONField(name: "icon_desc")
	List<KeTaoFeaturedVipPriceInfoDiamondIconDesc> iconDesc;
	@JSONField(name: "money_list")
	List<KeTaoFeaturedVipPriceInfoDiamondMoneyList> moneyList;
}

class KeTaoFeaturedVipPriceInfoDiamondIconDesc with JsonConvert<KeTaoFeaturedVipPriceInfoDiamondIconDesc> {
	String icon;
	String desc;
	String subdesc;
	String ssubdesc;
}

class KeTaoFeaturedVipPriceInfoDiamondMoneyList with JsonConvert<KeTaoFeaturedVipPriceInfoDiamondMoneyList> {
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
