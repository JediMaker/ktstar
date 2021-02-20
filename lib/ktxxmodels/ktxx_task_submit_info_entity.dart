import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedTaskSubmitInfoEntity with JsonConvert<KeTaoFeaturedTaskSubmitInfoEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	KeTaoFeaturedTaskSubmitInfoData data;
}

class KeTaoFeaturedTaskSubmitInfoData with JsonConvert<KeTaoFeaturedTaskSubmitInfoData> {
	@JSONField(name: "task_id")
	String taskId;
	String status;
	@JSONField(name: "img_id")
	String imgId;
	@JSONField(name: "img_url")
	String imgUrl;
	@JSONField(name: "com_id")
	String comId;
}
