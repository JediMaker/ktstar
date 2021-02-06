import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class PddCategoryListEntity with JsonConvert<PddCategoryListEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	List<PddCategoryListData> data;
}

class PddCategoryListData with JsonConvert<PddCategoryListData> {
	int level;
	@JSONField(name: "cat_name")
	String catName;
	@JSONField(name: "cat_id")
	String catId;
	@JSONField(name: "parent_cat_id")
	String parentCatId;
}
