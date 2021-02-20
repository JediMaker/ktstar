import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedPayCouponEntity with JsonConvert<KeTaoFeaturedPayCouponEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	KeTaoFeaturedPayCouponData data;
}

class KeTaoFeaturedPayCouponData with JsonConvert<KeTaoFeaturedPayCouponData> {
	String money;
	String condition;
	@JSONField(name: "start_time")
	String startTime;
	@JSONField(name: "end_time")
	String endTime;
}
