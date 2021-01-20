import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class PddHomeEntity with JsonConvert<PddHomeEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	PddHomeData data;
}

class PddHomeData with JsonConvert<PddHomeData> {
	List<PddHomeDataCat> cats;
	List<PddHomeDataBanner> banner;
	List<PddHomeDataTool> tools;
	List<PddHomeDataAd> ads;
}

class PddHomeDataCat with JsonConvert<PddHomeDataCat> {
	@JSONField(name: "cat_id")
	String catId;
	@JSONField(name: "cat_name")
	String catName;
}

class PddHomeDataBanner with JsonConvert<PddHomeDataBanner> {
	String img;
	String url;
}

class PddHomeDataTool with JsonConvert<PddHomeDataTool> {
	String type;
	String name;
	String icon;
	String link;
}

class PddHomeDataAd with JsonConvert<PddHomeDataAd> {
	String img;
	String url;
}
