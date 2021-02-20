import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedHomeIconListEntity with JsonConvert<KeTaoFeaturedHomeIconListEntity> {
	@JSONField(name: "icon_list")
	List<KeTaoFeaturedHomeIconListIconList> iconList;
}

class KeTaoFeaturedHomeIconListIconList with JsonConvert<KeTaoFeaturedHomeIconListIconList> {
	String id;
	String position;
	String icon;
	String name;
	String type;
	String uri;
	@JSONField(name: "app_id")
	String appId;
	@JSONField(name: "app_path")
	String appPath;
	String path;
	String params;
	String subtitle;
	String flag;
	@JSONField(name: "img_path")
	String imgPath;
	@JSONField(name: "toast_info")
	String toastInfo;
	@JSONField(name: "need_login")
	bool needLogin;
}
