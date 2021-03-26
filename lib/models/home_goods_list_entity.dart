import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class HomeGoodsListEntity with JsonConvert<HomeGoodsListEntity> {
  @JSONField(name: "list")
  List<HomeGoodsListGoodsList> goodsList;
}

class HomeGoodsListGoodsList with JsonConvert<HomeGoodsListGoodsList> {
  String id;
  @JSONField(name: "goods_name")
  String goodsName;
  @JSONField(name: "goods_img")
  String goodsImg;
  @JSONField(name: "original_price")
  String originalPrice;
  @JSONField(name: "sale_price")
  String salePrice;
  @JSONField(name: "bt_price")
  String btPrice;
  @JSONField(name: "goods_rate")
  String goodsRate;
  @JSONField(name: "goods_coin")
  String goodsCoin;
  @JSONField(name: "is_coupon")
  String isCoupon;
  @JSONField(name: "is_new")
  String isNew;
  @JSONField(name: "sale_num")
  String saleNum;
  @JSONField(name: "try_coin")
  String tryCoin;
}
