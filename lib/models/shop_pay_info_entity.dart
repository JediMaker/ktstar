import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class ShopPayInfoEntity with JsonConvert<ShopPayInfoEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  ShopPayInfoData data;
}

class ShopPayInfoData with JsonConvert<ShopPayInfoData> {
  ShopPayInfoDataStore store;
  ShopPayInfoDataUser user;
}

class ShopPayInfoDataStore with JsonConvert<ShopPayInfoDataStore> {
  @JSONField(name: "store_name")
  String storeName;
  @JSONField(name: "store_code")
  String storeCode;
}

class ShopPayInfoDataUser with JsonConvert<ShopPayInfoDataUser> {
  String price;
  @JSONField(name: "pay_pwd_flag")
  bool payPwdFlag;
}
