import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedRegionDataEntity with JsonConvert<KeTaoFeaturedRegionDataEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	List<KeTaoFeaturedRegionDataData> data;
}

class KeTaoFeaturedRegionDataData with JsonConvert<KeTaoFeaturedRegionDataData> {
	int id;
	String value;
	List<KeTaoFeaturedRegionDataData> children;
}

class KeTaoFeaturedRegionDataDatachild with JsonConvert<KeTaoFeaturedRegionDataDatachild> {
	int id;
	String value;
	List<KeTaoFeaturedRegionDataDatachildchild> children;
}

class KeTaoFeaturedRegionDataDatachildchild with JsonConvert<KeTaoFeaturedRegionDataDatachildchild> {
	int id;
	String value;
}
