import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedAlipayPayinfoEntity with JsonConvert<KeTaoFeaturedAlipayPayinfoEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	KeTaoFeaturedAlipayPayinfoData data;
}

class KeTaoFeaturedAlipayPayinfoData with JsonConvert<KeTaoFeaturedAlipayPayinfoData> {
	@JSONField(name: "pay_no")
	String payNo;
	@JSONField(name: "pay_info")
	String payInfo;
	bool finish;
}
