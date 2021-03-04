import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';
import 'package:star/ktxxmodels/ktxx_pdd_goods_list_entity.dart';

class KeTaoFeaturedSearchPddGoodsListEntity
    with JsonConvert<KeTaoFeaturedSearchPddGoodsListEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  KeTaoFeaturedSearchPddGoodsListData data;
}

class KeTaoFeaturedSearchPddGoodsListData
    with JsonConvert<KeTaoFeaturedSearchPddGoodsListData> {
  int total;
  int page;
  @JSONField(name: "list_id")
  String listId;
  @JSONField(name: "list")
  List<PddGoodsListDataList> xList;
}

class KeTaoFeaturedSearchPddGoodsListDataList
    with JsonConvert<KeTaoFeaturedSearchPddGoodsListDataList> {
  @JSONField(name: "g_id")
  int gId;
  @JSONField(name: "g_title")
  String gTitle;
  @JSONField(name: "g_pic")
  String gPic;
  @JSONField(name: "g_thumbnail")
  String gThumbnail;
  @JSONField(name: "g_group_price")
  double gGroupPrice;
  @JSONField(name: "g_normal_price")
  int gNormalPrice;
  @JSONField(name: "sales_tip")
  String salesTip;
  @JSONField(name: "goods_sign")
  String goodsSign;
  @JSONField(name: "search_id")
  String searchId;
  @JSONField(name: "mall_name")
  String mallName;
  @JSONField(name: "g_bonus")
  String gBonus;
  KeTaoFeaturedSearchPddGoodsListDataListCoupons coupons;
}

class KeTaoFeaturedSearchPddGoodsListDataListCoupons
    with JsonConvert<KeTaoFeaturedSearchPddGoodsListDataListCoupons> {
  @JSONField(name: "coupon_discount")
  int couponDiscount;
  @JSONField(name: "coupon_remain_quantity")
  int couponRemainQuantity;
  @JSONField(name: "coupon_total_quantity")
  int couponTotalQuantity;
}
