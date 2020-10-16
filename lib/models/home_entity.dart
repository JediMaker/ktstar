import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class HomeEntity with JsonConvert<HomeEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	HomeData data;
}

class HomeData with JsonConvert<HomeData> {
	List<HomeDataBanner> banner;
	@JSONField(name: "task_list")
	HomeDataTaskList taskList;
	String links;
}

class HomeDataBanner with JsonConvert<HomeDataBanner> {
	String id;
	@JSONField(name: "img_path")
	String imgPath;
	dynamic uri;
}

class HomeDataTaskList with JsonConvert<HomeDataTaskList> {
	@JSONField(name: "list")
	List<HomeDataTaskListList> xList;
	@JSONField(name: "task_total")
	String taskTotal;
	@JSONField(name: "use_task_total")
	String useTaskTotal;
}

class HomeDataTaskListList with JsonConvert<HomeDataTaskListList> {
	String id;
	@JSONField(name: "share_price")
	String sharePrice;
	String title;
	@JSONField(name: "task_status")
	int taskStatus;
	String icons;
	@JSONField(name: "status_desc")
	String statusDesc;
	String type;
	String category;
	String ratio;
	@JSONField(name: "diamonds_ratio")
	String diamondsRatio;
}
