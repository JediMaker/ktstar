import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedTaskRecordListEntity with JsonConvert<KeTaoFeaturedTaskRecordListEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  KeTaoFeaturedTaskRecordListData data;
}

class KeTaoFeaturedTaskRecordListData with JsonConvert<KeTaoFeaturedTaskRecordListData> {
  @JSONField(name: "list")
  List<KeTaoFeaturedTaskRecordListDataList> xList;
  int page;
  @JSONField(name: "page_size")
  int pageSize;
}

class KeTaoFeaturedTaskRecordListDataList with JsonConvert<KeTaoFeaturedTaskRecordListDataList> {
  String title;
  String price;
  String status;
  @JSONField(name: "reject_reason")
  String rejectReason;
  @JSONField(name: "submit_time")
  String submitTime;
  @JSONField(name: "check_time")
  String checkTime;
  @JSONField(name: "task_id")
  String taskId;
  @JSONField(name: "re_submit")
  String reSubmit;
  @JSONField(name: "com_id")
  String comId;
  String category;
}
