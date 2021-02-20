import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedUserHolderProfitEntity with JsonConvert<KeTaoFeaturedUserHolderProfitEntity> {
	@JSONField(name: "partner_bonus")
	KeTaoFeaturedUserHolderProfitPartnerBonus partnerBonus;
}

class KeTaoFeaturedUserHolderProfitPartnerBonus with JsonConvert<KeTaoFeaturedUserHolderProfitPartnerBonus> {
	@JSONField(name: "today_price")
	String todayPrice;
	@JSONField(name: "today_deserve")
	String todayDeserve;
	String yesterday;
	String week;
	String month;
	String total;
	String coin;
}
