import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedWithdrawalListEntity with JsonConvert<KeTaoFeaturedWithdrawalListEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	KeTaoFeaturedWithdrawalListData data;
}

class KeTaoFeaturedWithdrawalListData with JsonConvert<KeTaoFeaturedWithdrawalListData> {
	@JSONField(name: "list")
	List<KeTaoFeaturedWithdrawalListDataList> xList;
	int page;
	@JSONField(name: "page_size")
	int pageSize;
}

class KeTaoFeaturedWithdrawalListDataList with JsonConvert<KeTaoFeaturedWithdrawalListDataList> {
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
