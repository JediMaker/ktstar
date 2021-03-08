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
}