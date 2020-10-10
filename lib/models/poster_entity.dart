import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class PosterEntity with JsonConvert<PosterEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	PosterData data;
}

class PosterData with JsonConvert<PosterData> {
	String code;
	List<String> imgs;
	String url;
}
