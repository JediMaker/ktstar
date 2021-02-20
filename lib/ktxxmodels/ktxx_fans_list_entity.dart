import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedFansListEntity with JsonConvert<KeTaoFeaturedFansListEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	KeTaoFeaturedFansListData data;
}

class KeTaoFeaturedFansListData with JsonConvert<KeTaoFeaturedFansListData> {
	@JSONField(name: "list")
	List<KeTaoFeaturedFansListDataList> xList;
	int page;
	@JSONField(name: "page_size")
	int pageSize;
}

class KeTaoFeaturedFansListDataList with JsonConvert<KeTaoFeaturedFansListDataList> {
	@JSONField(name: "is_partner")
	String isPartner;
	@JSONField(name: "is_vip")
	String isVip;
	String avatar;
	String username;
	@JSONField(name: "created_time")
	String createdTime;
	@JSONField(name: "total_count")
	String totalCount;
	@JSONField(name: "complete_status")
	String completeStatus;
	@JSONField(name: "complete_count")
	String completeCount;
}
