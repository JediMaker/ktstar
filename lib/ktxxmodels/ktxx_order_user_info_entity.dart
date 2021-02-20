import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedOrderUserInfoEntity with JsonConvert<KeTaoFeaturedOrderUserInfoEntity> {
	@JSONField(name: "user_info")
	KeTaoFeaturedOrderUserInfoUserInfo userInfo;
}

class KeTaoFeaturedOrderUserInfoUserInfo with JsonConvert<KeTaoFeaturedOrderUserInfoUserInfo> {
	String price;
	@JSONField(name: "pay_pwd_flag")
	bool payPwdFlag;
}
