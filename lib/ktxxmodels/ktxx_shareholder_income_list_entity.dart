import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';
import 'package:star/ktxxmodels/ktxx_income_list_entity.dart';

class KeTaoFeaturedShareholderIncomeListEntity
    with JsonConvert<KeTaoFeaturedShareholderIncomeListEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  List<IncomeListDataList> data;
}
