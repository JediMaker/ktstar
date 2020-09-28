import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class WithdrawalListEntity with JsonConvert<WithdrawalListEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	WithdrawalListData data;
}

class WithdrawalListData with JsonConvert<WithdrawalListData> {
	@JSONField(name: "list")
	List<WithdrawalListDataList> xList;
	int page;
	@JSONField(name: "page_size")
	int pageSize;
}

class WithdrawalListDataList with JsonConvert<WithdrawalListDataList> {
	String price;
	String type;
	String status;
	@JSONField(name: "reject_reason")
	String rejectReason;
	@JSONField(name: "create_time")
	String createTime;
	@JSONField(name: "time_desc")
	String timeDesc;
}
