import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';
import 'package:star/ktxxmodels/income_list_entity.dart';

class ShareholderIncomeListEntity with JsonConvert<ShareholderIncomeListEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  List<IncomeListDataList> data;
}
