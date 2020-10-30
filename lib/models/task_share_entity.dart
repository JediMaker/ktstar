import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class TaskShareEntity with JsonConvert<TaskShareEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	TaskShareData data;
}

class TaskShareData with JsonConvert<TaskShareData> {
	String id;
	@JSONField(name: "file_id")
	List<String> fileId;
	String title;
	String text;
	@JSONField(name: "comment_desc")
	String commentDesc;
	@JSONField(name: "require_desc")
	String requireDesc;
	String username;
	String avatar;
	@JSONField(name: "share_info")
	TaskShareDataShareInfo shareInfo;
	@JSONField(name: "footer_img")
	TaskShareDataFooterImg footerImg;
}

class TaskShareDataShareInfo with JsonConvert<TaskShareDataShareInfo> {
	String title;
	String icon;
	String link;
	String desc;
}

class TaskShareDataFooterImg with JsonConvert<TaskShareDataFooterImg> {
	String image;
	String link;
}
