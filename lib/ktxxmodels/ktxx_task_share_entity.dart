import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedTaskShareEntity with JsonConvert<KeTaoFeaturedTaskShareEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	KeTaoFeaturedTaskShareData data;
}

class KeTaoFeaturedTaskShareData with JsonConvert<KeTaoFeaturedTaskShareData> {
	String id;
	@JSONField(name: "file_id")
	List<String> fileId;
	String title;
	String text;
	@JSONField(name: "comment_desc")
	String commentDesc;
	@JSONField(name: "require_desc")
	String requireDesc;
	String username;
	String avatar;
	@JSONField(name: "share_info")
	KeTaoFeaturedTaskShareDataShareInfo shareInfo;
	@JSONField(name: "footer_img")
	KeTaoFeaturedTaskShareDataFooterImg footerImg;
}

class KeTaoFeaturedTaskShareDataShareInfo with JsonConvert<KeTaoFeaturedTaskShareDataShareInfo> {
	String title;
	String icon;
	String link;
	String desc;
}

class KeTaoFeaturedTaskShareDataFooterImg with JsonConvert<KeTaoFeaturedTaskShareDataFooterImg> {
	String image;
	String link;
}
