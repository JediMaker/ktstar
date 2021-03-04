import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class AddressInfoEntity with JsonConvert<AddressInfoEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  AddressInfoData data;
}

class AddressInfoData with JsonConvert<AddressInfoData> {
  String id;
  String consignee;
  String mobile;
  @JSONField(name: "province_id")
  String provinceId;
  String province;
  @JSONField(name: "city_id")
  String cityId;
  String city;
  @JSONField(name: "county_id")
  String countyId;
  String county;
  String address;
  @JSONField(name: "is_default")
  String isDefault;
}
