import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class ShopTypeEntity with JsonConvert<ShopTypeEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  ShopTypeData data;
}

class ShopTypeData with JsonConvert<ShopTypeData> {
  @JSONField(name: "list")
  List<ShopTypeDataList> xList;
}

class ShopTypeDataList with JsonConvert<ShopTypeDataList> {
  String id;
  String name;
  String profit;
  String coin;
}
