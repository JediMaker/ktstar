import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class MessageListEntity with JsonConvert<MessageListEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	MessageListData data;
}

class MessageListData with JsonConvert<MessageListData> {
	@JSONField(name: "list")
	List<MessageListDataList> xList;
	int page;
	@JSONField(name: "page_size")
	int pageSize;
}

class MessageListDataList with JsonConvert<MessageListDataList> {
	String id;
	String title;
	String desc;
	@JSONField(name: "notice_time")
	String noticeTime;
	String type;
	@JSONField(name: "read_status")
	String readStatus;
}
