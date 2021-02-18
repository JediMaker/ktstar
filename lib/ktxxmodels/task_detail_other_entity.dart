import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class TaskDetailOtherEntity with JsonConvert<TaskDetailOtherEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	TaskDetailOtherData data;
}

class TaskDetailOtherData with JsonConvert<TaskDetailOtherData> {
	String id;
	String title;
	@JSONField(name: "desc_json")
	List<TaskDetailOtherDataDescJson> descJson;
	@JSONField(name: "show_btn")
	bool showBtn;
}

class TaskDetailOtherDataDescJson with JsonConvert<TaskDetailOtherDataDescJson> {
	String text;
	List<String> img;
}
