import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedHomePddCategoryEntity with JsonConvert<KeTaoFeaturedHomePddCategoryEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	KeTaoFeaturedHomePddCategoryData data;
}

class KeTaoFeaturedHomePddCategoryData with JsonConvert<KeTaoFeaturedHomePddCategoryData> {
	List<KeTaoFeaturedHomePddCategoryDataCat> cats;
}

class KeTaoFeaturedHomePddCategoryDataCat with JsonConvert<KeTaoFeaturedHomePddCategoryDataCat> {
	@JSONField(name: "cat_id")
	int catId;
	@JSONField(name: "cat_name")
	String catName;
	String subtitle;
	String type;
}
