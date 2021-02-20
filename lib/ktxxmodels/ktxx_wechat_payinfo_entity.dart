import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedWechatPayinfoEntity with JsonConvert<KeTaoFeaturedWechatPayinfoEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	KeTaoFeaturedWechatPayinfoData data;
}

class KeTaoFeaturedWechatPayinfoData with JsonConvert<KeTaoFeaturedWechatPayinfoData> {
	@JSONField(name: "pay_no")
	String payNo;
	@JSONField(name: "pay_info")
	KeTaoFeaturedWechatPayinfoDataPayInfo payInfo;
	bool finish;
}

class KeTaoFeaturedWechatPayinfoDataPayInfo with JsonConvert<KeTaoFeaturedWechatPayinfoDataPayInfo> {
	String appid;
	String noncestr;
	String package;
	String partnerid;
	String prepayid;
	int timestamp;
	String sign;
}
