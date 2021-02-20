import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedPosterEntity with JsonConvert<KeTaoFeaturedPosterEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	KeTaoFeaturedPosterData data;
}

class KeTaoFeaturedPosterData with JsonConvert<KeTaoFeaturedPosterData> {
	String code;
	List<String> imgs;
	String url;
}
