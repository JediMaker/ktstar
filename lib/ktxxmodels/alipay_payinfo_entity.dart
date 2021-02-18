import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class AlipayPayinfoEntity with JsonConvert<AlipayPayinfoEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	AlipayPayinfoData data;
}

class AlipayPayinfoData with JsonConvert<AlipayPayinfoData> {
	@JSONField(name: "pay_no")
	String payNo;
	@JSONField(name: "pay_info")
	String payInfo;
	bool finish;
}
