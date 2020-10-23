import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class IncomeListEntity with JsonConvert<IncomeListEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	IncomeListData data;
}

class IncomeListData with JsonConvert<IncomeListData> {
	@JSONField(name: "list")
	List<IncomeListDataList> xList;
	int page;
	@JSONField(name: "page_size")
	int pageSize;
}

class IncomeListDataList with JsonConvert<IncomeListDataList> {
	String type;
	String price;
	@JSONField(name: "create_time")
	String createTime;
	@JSONField(name: "time_desc")
	String timeDesc;
	@JSONField(name: "reject_reason")
	String rejectReason;
	@JSONField(name: "profit_type")
	String profitType;
	String desc;
	String status;
}
