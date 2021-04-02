import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class CartSettlementEntity with JsonConvert<CartSettlementEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  CartSettlementData data;
}

class CartSettlementData with JsonConvert<CartSettlementData> {
  @JSONField(name: "is_coupon")
  String isCoupon;
  @JSONField(name: "total_price")
  String totalPrice;
  @JSONField(name: "usable_deduct")
  String usableDeduct;
  @JSONField(name: "deduct_price")
  String deductPrice;
  @JSONField(name: "list")
  List<CartSettlemantDataList> xList;
}

class CartSettlemantDataList with JsonConvert<CartSettlemantDataList> {
  @JSONField(name: "cart_id")
  String cartId;
  @JSONField(name: "goods_id")
  String goodsId;
  @JSONField(name: "goods_spec_id")
  String goodsSpecId;
  @JSONField(name: "goods_num")
  String goodsNum;
  @JSONField(name: "goods_name")
  String goodsName;
  @JSONField(name: "is_coupon")
  String isCoupon;
  @JSONField(name: "spec_item")
  String specItem;
  @JSONField(name: "goods_img")
  String goodsImg;
  @JSONField(name: "goods_price")
  String goodsPrice;
  @JSONField(name: "goods_coin")
  String goodsCoin;
}
