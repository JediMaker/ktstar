import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';
import 'package:star/ktxxmodels/micro_shareholder_item_entity.dart';

class MicroShareholderEntity with JsonConvert<MicroShareholderEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  MicroShareholderData data;
}

class MicroShareholderData with JsonConvert<MicroShareholderData> {
  MicroShareholderItemEntity grade1;
  MicroShareholderItemEntity grade2;
  MicroShareholderItemEntity grade3;
}
