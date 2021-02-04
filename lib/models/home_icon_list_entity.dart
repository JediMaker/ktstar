import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class HomeIconListEntity with JsonConvert<HomeIconListEntity> {
	@JSONField(name: "icon_list")
	List<HomeIconListIconList> iconList;
}

class HomeIconListIconList with JsonConvert<HomeIconListIconList> {
	String id;
	String position;
	String icon;
	String name;
	String type;
	String uri;
	@JSONField(name: "app_id")
	String appId;
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
