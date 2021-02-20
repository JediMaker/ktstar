import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedTaskOtherSubmitInfoEntity with JsonConvert<KeTaoFeaturedTaskOtherSubmitInfoEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	KeTaoFeaturedTaskOtherSubmitInfoData data;
}

class KeTaoFeaturedTaskOtherSubmitInfoData with JsonConvert<KeTaoFeaturedTaskOtherSubmitInfoData> {
	@JSONField(name: "com_id")
	String comId;
	@JSONField(name: "img_id")
	List<String> imgId;
	@JSONField(name: "task_id")
	String taskId;
	@JSONField(name: "img_url")
	List<String> imgUrl;
	@JSONField(name: "img_num")
	int imgNum;
	@JSONField(name: "need_remark")
	String needRemark;
}
