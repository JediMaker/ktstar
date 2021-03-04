import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';
import 'package:star/ktxxmodels/ktxx_home_goods_list_entity.dart';

class KeTaoFeaturedSearchGoodsListEntity
    with JsonConvert<KeTaoFeaturedSearchGoodsListEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  KeTaoFeaturedSearchGoodsListData data;
}

class KeTaoFeaturedSearchGoodsListData
    with JsonConvert<KeTaoFeaturedSearchGoodsListData> {
  String total;
  int page;
  @JSONField(name: "list")
  List<HomeGoodsListGoodsList> goodsList;
}

class KeTaoFeaturedSearchGoodsListDataList
    with JsonConvert<KeTaoFeaturedSearchGoodsListDataList> {
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
