import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class TaskDetailEntity with JsonConvert<TaskDetailEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	TaskDetailData data;
}

class TaskDetailData with JsonConvert<TaskDetailData> {
	String id;
	@JSONField(name: "file_id")
	List<String> fileId;
	@JSONField(name: "share_price")
	String sharePrice;
	String title;
	String text;
}
