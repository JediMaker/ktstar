import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class FansListEntity with JsonConvert<FansListEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	FansListData data;
}

class FansListData with JsonConvert<FansListData> {
	@JSONField(name: "list")
	List<FansListDataList> xList;
	int page;
	@JSONField(name: "page_size")
	int pageSize;
}

class FansListDataList with JsonConvert<FansListDataList> {
	@JSONField(name: "is_vip")
	String isVip;
	String avatar;
	String username;
	@JSONField(name: "created_time")
	String createdTime;
}
