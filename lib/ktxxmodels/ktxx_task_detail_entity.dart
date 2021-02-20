import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedTaskDetailEntity with JsonConvert<KeTaoFeaturedTaskDetailEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	KeTaoFeaturedTaskDetailData data;
}

class KeTaoFeaturedTaskDetailData with JsonConvert<KeTaoFeaturedTaskDetailData> {
	String id;
	@JSONField(name: "file_id")
	List<String> fileId;
	@JSONField(name: "share_price")
	String sharePrice;
	String title;
	String text;
}
