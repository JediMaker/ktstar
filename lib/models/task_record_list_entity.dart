import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class TaskRecordListEntity with JsonConvert<TaskRecordListEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	TaskRecordListData data;
}

class TaskRecordListData with JsonConvert<TaskRecordListData> {
	@JSONField(name: "list")
	List<TaskRecordListDataList> xList;
	int page;
	@JSONField(name: "page_size")
	int pageSize;
}

class TaskRecordListDataList with JsonConvert<TaskRecordListDataList> {
	String title;
	String price;
	String status;
	@JSONField(name: "reject_reason")
	String rejectReason;
	@JSONField(name: "submit_time")
	String submitTime;
	@JSONField(name: "check_time")
	String checkTime;
}
