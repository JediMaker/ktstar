import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedAddressListEntity with JsonConvert<KeTaoFeaturedAddressListEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	List<KeTaoFeaturedAddressListData> data;
}

class KeTaoFeaturedAddressListData with JsonConvert<KeTaoFeaturedAddressListData> {
	String id;
	String consignee;
	String mobile;
	String address;
	@JSONField(name: "is_default")
	String isDefault;
}
