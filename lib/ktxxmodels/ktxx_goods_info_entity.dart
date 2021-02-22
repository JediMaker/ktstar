import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';
import 'package:star/ktxxmodels/ktxx_goods_spec_info_entity.dart';

class KeTaoFeaturedGoodsInfoEntity with JsonConvert<KeTaoFeaturedGoodsInfoEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  KeTaoFeaturedGoodsInfoData data;
}

class KeTaoFeaturedGoodsInfoData with JsonConvert<KeTaoFeaturedGoodsInfoData> {
  String id;
  @JSONField(name: "goods_name")
  String goodsName;
  @JSONField(name: "original_price")
  String originalPrice;
  @JSONField(name: "sale_price")
  String salePrice;
  @JSONField(name: "banner_imgs")
  List<String> bannerImgs;
  @JSONField(name: "detail_imgs")
  List<String> detailImgs;
  @JSONField(name: "queue_count")
  String queueCount;
  @JSONField(name: "bt_price")
  String btPrice;
  @JSONField(name: "is_coupon")
  String isCoupon;
  @JSONField(name: "min_power")
  String minPower;
  @JSONField(name: "spec_info")
  KeTaoFeaturedGoodsSpecInfoSpecInfo specInfo;
}