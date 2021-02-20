import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedIncomeListEntity with JsonConvert<KeTaoFeaturedIncomeListEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  KeTaoFeaturedIncomeListData data;
}

class KeTaoFeaturedIncomeListData with JsonConvert<KeTaoFeaturedIncomeListData> {
  @JSONField(name: "list")
  List<KeTaoFeaturedIncomeListDataList> xList;
  int page;
  @JSONField(name: "page_size")
  int pageSize;
}

class KeTaoFeaturedIncomeListDataList with JsonConvert<KeTaoFeaturedIncomeListDataList> {
  String type;
  String price;
  @JSONField(name: "create_time")
  String createTime;
  @JSONField(name: "time_desc")
  String timeDesc;
  @JSONField(name: "reject_reason")
  String rejectReason;
  @JSONField(name: "profit_type")
  String profitType;
  String desc;
  String status;
  String bonus;
  String source;
  @JSONField(name: "attach_id")
  String attachId;
  String title;
}
