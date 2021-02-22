import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedRechargeEntity with JsonConvert<KeTaoFeaturedRechargeEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	KeTaoFeaturedRechargeData data;
}

class KeTaoFeaturedRechargeData with JsonConvert<KeTaoFeaturedRechargeData> {
	@JSONField(name: "rechage_list")
	List<KeTaoFeaturedRechargeDataRechageList> rechageList;
	@JSONField(name: "coupon_list")
	List<KeTaoFeaturedRechargeDatacouponList> couponList;
}

class KeTaoFeaturedRechargeDataRechageList with JsonConvert<KeTaoFeaturedRechargeDataRechageList> {
	int id;
	@JSONField(name: "face_money")
	String faceMoney;
	@JSONField(name: "use_money")
	String useMoney;
	@JSONField(name: "coupon_money")
	String couponMoney;
	@JSONField(name: "pay_money")
	String payMoney;
}
class KeTaoFeaturedRechargeDatacouponList with JsonConvert<KeTaoFeaturedRechargeDatacouponList> {
	String money;
	String condition;
}