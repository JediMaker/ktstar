import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedMessageListEntity with JsonConvert<KeTaoFeaturedMessageListEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	KeTaoFeaturedMessageListData data;
}

class KeTaoFeaturedMessageListData with JsonConvert<KeTaoFeaturedMessageListData> {
	@JSONField(name: "list")
	List<KeTaoFeaturedMessageListDataList> xList;
	int page;
	@JSONField(name: "page_size")
	int pageSize;
}

class KeTaoFeaturedMessageListDataList with JsonConvert<KeTaoFeaturedMessageListDataList> {
	String id;
	String title;
	String desc;
	@JSONField(name: "notice_time")
	String noticeTime;
	String type;
	@JSONField(name: "read_status")
	String readStatus;
}
