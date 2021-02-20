import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';
import 'package:star/ktxxmodels/ktxx_micro_shareholder_item_entity.dart';

class KeTaoFeaturedMicroShareholderEntity with JsonConvert<KeTaoFeaturedMicroShareholderEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  KeTaoFeaturedMicroShareholderData data;
}

class KeTaoFeaturedMicroShareholderData with JsonConvert<KeTaoFeaturedMicroShareholderData> {
  KeTaoFeaturedMicroShareholderItemEntity grade1;
  KeTaoFeaturedMicroShareholderItemEntity grade2;
  KeTaoFeaturedMicroShareholderItemEntity grade3;
}
