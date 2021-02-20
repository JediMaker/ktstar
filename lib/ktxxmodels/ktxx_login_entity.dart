import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedLoginEntity with JsonConvert<KeTaoFeaturedLoginEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	KeTaoFeaturedLoginData data;
}

class KeTaoFeaturedLoginData with JsonConvert<KeTaoFeaturedLoginData> {
	String token;
	String refertoken;
	@JSONField(name: "expire_time")
	int expireTime;
	String username;
	dynamic tel;
	String avatar;
}
