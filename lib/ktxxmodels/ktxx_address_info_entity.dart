import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedAddressInfoEntity with JsonConvert<KeTaoFeaturedAddressInfoEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	KeTaoFeaturedAddressInfoData data;
}

class KeTaoFeaturedAddressInfoData with JsonConvert<KeTaoFeaturedAddressInfoData> {
	String id;
	String consignee;
	String mobile;
	@JSONField(name: "province_id")
	String provinceId;
	String province;
	@JSONField(name: "city_id")
	String cityId;
	String city;
	@JSONField(name: "county_id")
	String countyId;
	String county;
	String address;
	@JSONField(name: "is_default")
	String isDefault;
}
