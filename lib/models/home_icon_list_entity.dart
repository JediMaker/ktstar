import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class HomeIconListEntity with JsonConvert<HomeIconListEntity> {
	@JSONField(name: "icon_list")
	List<HomeIconListIconList> iconList;
}

class HomeIconListIconList with JsonConvert<HomeIconListIconList> {
	String icon;
	String name;
	String type;
	@JSONField(name: "app_id")
	String appId;
	String path;
	String subtitle;
}
