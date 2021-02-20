import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';
import 'package:star/ktxxmodels/ktxx_home_icon_list_entity.dart';

class KeTaoFeaturedPddHomeEntity with JsonConvert<KeTaoFeaturedPddHomeEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	KeTaoFeaturedPddHomeData data;
}

class KeTaoFeaturedPddHomeData with JsonConvert<KeTaoFeaturedPddHomeData> {
	List<KeTaoFeaturedPddHomeDataCat> cats;
	List<KeTaoFeaturedHomeIconListIconList> banner;
	List<KeTaoFeaturedHomeIconListIconList> tools;
	List<KeTaoFeaturedHomeIconListIconList> ads;
}

class KeTaoFeaturedPddHomeDataCat with JsonConvert<KeTaoFeaturedPddHomeDataCat> {
	@JSONField(name: "cat_id")
	String catId;
	@JSONField(name: "cat_name")
	String catName;
}

class KeTaoFeaturedPddHomeDataBanner with JsonConvert<KeTaoFeaturedPddHomeDataBanner> {
	String img;
	String url;
}

class KeTaoFeaturedPddHomeDataTool with JsonConvert<KeTaoFeaturedPddHomeDataTool> {
	String type;
	String name;
	String icon;
	String link;
}

class KeTaoFeaturedPddHomeDataAd with JsonConvert<KeTaoFeaturedPddHomeDataAd> {
	String img;
	String url;
}
