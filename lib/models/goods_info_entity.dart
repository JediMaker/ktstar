import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';
import 'package:star/models/goods_spec_info_entity.dart';

class GoodsInfoEntity with JsonConvert<GoodsInfoEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  GoodsInfoData data;
}

class GoodsInfoData with JsonConvert<GoodsInfoData> {
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
  @JSONField(name: "spec_info")
  GoodsSpecInfoSpecInfo specInfo;
}
