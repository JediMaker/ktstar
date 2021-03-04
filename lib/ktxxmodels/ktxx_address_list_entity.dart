import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class AddressListEntity with JsonConvert<AddressListEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  List<AddressListData> data;
}

class AddressListData with JsonConvert<AddressListData> {
  String id;
  String consignee;
  String mobile;
  String address;
  @JSONField(name: "is_default")
  String isDefault;
}
