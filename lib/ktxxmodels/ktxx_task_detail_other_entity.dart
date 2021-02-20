import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedTaskDetailOtherEntity with JsonConvert<KeTaoFeaturedTaskDetailOtherEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	KeTaoFeaturedTaskDetailOtherData data;
}

class KeTaoFeaturedTaskDetailOtherData with JsonConvert<KeTaoFeaturedTaskDetailOtherData> {
	String id;
	String title;
	@JSONField(name: "desc_json")
	List<KeTaoFeaturedTaskDetailOtherDataDescJson> descJson;
	@JSONField(name: "show_btn")
	bool showBtn;
}

class KeTaoFeaturedTaskDetailOtherDataDescJson with JsonConvert<KeTaoFeaturedTaskDetailOtherDataDescJson> {
	String text;
	List<String> img;
}
