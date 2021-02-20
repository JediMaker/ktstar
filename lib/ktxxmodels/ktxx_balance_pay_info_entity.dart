import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedBalancePayInfoEntity with JsonConvert<KeTaoFeaturedBalancePayInfoEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	KeTaoFeaturedBalancePayInfoData data;
}

class KeTaoFeaturedBalancePayInfoData with JsonConvert<KeTaoFeaturedBalancePayInfoData> {
	@JSONField(name: "pay_no")
	String payNo;
	@JSONField(name: "pay_info")
	List<dynamic> payInfo;
}
