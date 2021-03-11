import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class ShopDetailEntity with JsonConvert<ShopDetailEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  ShopDetailData data;
}

class ShopDetailData with JsonConvert<ShopDetailData> {
  @JSONField(name: "store_id")
  String storeId;
  @JSONField(name: "store_uid")
  String storeUid;
  @JSONField(name: "store_name")
  String storeName;
  @JSONField(name: "store_img")
  String storeImg;
  @JSONField(name: "store_img_url")
  String storeImgUrl;
  @JSONField(name: "store_logo")
  String storeLogo;
  @JSONField(name: "store_logo_url")
  String storeLogoUrl;
  @JSONField(name: "trade_id")
  String tradeId;
  @JSONField(name: "trade_name")
  String tradeName;
  @JSONField(name: "store_desc")
  String storeDesc;
  @JSONField(name: "store_tel")
  String storeTel;
  @JSONField(name: "store_lat")
  String storeLat;
  @JSONField(name: "store_lng")
  String storeLng;
  @JSONField(name: "store_province")
  String storeProvince;
  @JSONField(name: "store_city")
  String storeCity;
  @JSONField(name: "store_district")
  String storeDistrict;
  @JSONField(name: "store_addr")
  String storeAddr;
  @JSONField(name: "store_distance")
  String storeDistance;
  @JSONField(name: "store_ratio")
  String storeRatio;
  @JSONField(name: "store_code")
  String storeCode;
  @JSONField(name: "store_status")
  String storeStatus;
  @JSONField(name: "store_reject_msg")
  String storeRejectMsg;
  @JSONField(name: "store_apply_time")
  String storeApplyTime;
  @JSONField(name: "store_check_time")
  String storeCheckTime;
}
