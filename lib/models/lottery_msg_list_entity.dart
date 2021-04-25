import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class LotteryMsgListEntity with JsonConvert<LotteryMsgListEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  LotteryMsgListData data;
}

class LotteryMsgListData with JsonConvert<LotteryMsgListData> {
  @JSONField(name: "list")
  List<LotteryMsgListDataList> xList;
  int page;
  @JSONField(name: "page_size")
  int pageSize;
}

class LotteryMsgListDataList with JsonConvert<LotteryMsgListDataList> {
  String id;
  @JSONField(name: "a_status")
  String aStatus;
  @JSONField(name: "create_time")
  String createTime;
  @JSONField(name: "a_desc")
  String aDesc;
}
