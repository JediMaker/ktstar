import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class PddGoodsListEntity with JsonConvert<PddGoodsListEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  PddGoodsListData data;
}

class PddGoodsListData with JsonConvert<PddGoodsListData> {
  @JSONField(name: "list")
  List<PddGoodsListDataList> xList;
  @JSONField(name: "list_id")
  String listId;
  int page;
}

class PddGoodsListDataList with JsonConvert<PddGoodsListDataList> {
  @JSONField(name: "g_id")
  int gId;
  @JSONField(name: "g_title")
  String gTitle;
  @JSONField(name: "g_pic")
  String gPic;
  @JSONField(name: "g_thumbnail")
  String gThumbnail;
  @JSONField(name: "g_group_price")
  String gGroupPrice;
  @JSONField(name: "g_normal_price")
  String gNormalPrice;
  @JSONField(name: "goods_sign")
  String goodsSign;
  @JSONField(name: "search_id")
  String searchId;
  @JSONField(name: "sales_tip")
  String salesTip;
  @JSONField(name: "mall_name")
  String mallName;
  @JSONField(name: "g_bonus")
  String gBonus;
  PddGoodsListDataListCoupons coupons;
}

class PddGoodsListDataListCoupons
    with JsonConvert<PddGoodsListDataListCoupons> {
  @JSONField(name: "coupon_discount")
  String couponDiscount;
  @JSONField(name: "coupon_remain_quantity")
  String couponRemainQuantity;
  @JSONField(name: "coupon_total_quantity")
  String couponTotalQuantity;
}
