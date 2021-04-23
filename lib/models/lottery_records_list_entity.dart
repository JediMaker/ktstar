import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class LotteryRecordsListEntity with JsonConvert<LotteryRecordsListEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  LotteryRecordsListData data;
}

class LotteryRecordsListData with JsonConvert<LotteryRecordsListData> {
  @JSONField(name: "list")
  List<LotteryRecordsListDataList> xList;
  int page;
  @JSONField(name: "page_size")
  int pageSize;
}

class LotteryRecordsListDataList with JsonConvert<LotteryRecordsListDataList> {
  String id;
  @JSONField(name: "p_type")
  String pType;
  @JSONField(name: "p_num")
  String pNum;
  @JSONField(name: "p_source")
  String pSource;
  @JSONField(name: "p_genre")
  String pGenre;
  @JSONField(name: "p_status")
  String pStatus;
  @JSONField(name: "p_desc")
  String pDesc;
  @JSONField(name: "l_type")
  String lType;
  @JSONField(name: "l_num")
  String lNum;
  @JSONField(name: "l_desc")
  String lDesc;
  @JSONField(name: "c_status")
  String cStatus;
  @JSONField(name: "c_source")
  String cSource;
  @JSONField(name: "c_type")
  String cType;
  @JSONField(name: "c_num")
  String cNum;
  @JSONField(name: "c_desc")
  String cDesc;
  @JSONField(name: "c_protect_status")
  String cProtectStatus;
  @JSONField(name: "c_protect_expire")
  String cProtectExpire;
  @JSONField(name: "create_time")
  String createTime;
  @JSONField(name: "expire_time")
  String expireTime;
}
