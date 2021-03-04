import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class TaskSubmitInfoEntity with JsonConvert<TaskSubmitInfoEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  TaskSubmitInfoData data;
}

class TaskSubmitInfoData with JsonConvert<TaskSubmitInfoData> {
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
