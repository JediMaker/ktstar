import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';
import 'package:star/ktxxmodels/ktxx_order_user_info_entity.dart';

class KeTaoFeaturedOrderDetailEntity with JsonConvert<KeTaoFeaturedOrderDetailEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  KeTaoFeaturedOrderDetailData data;
}

class KeTaoFeaturedOrderDetailData with JsonConvert<KeTaoFeaturedOrderDetailData> {
  int id;
  @JSONField(name: "pay_price")
  String payPrice;
  String payment;
  int status;
  String orderno;
  String consignee;
  String mobile;
  String address;
  @JSONField(name: "goods_list")
  List<KeTaoFeaturedOrderDetailDataGoodsList> goodsList;
  @JSONField(name: "total_price")
  String totalPrice;
  @JSONField(name: "create_time")
  String createTime;
  @JSONField(name: "pay_time")
  String payTime;
  @JSONField(name: "send_time")
  String sendTime;
  @JSONField(name: "confirm_time")
  String confirmTime;
  @JSONField(name: "send_name")
  String sendName;
  @JSONField(name: "send_number")
  String sendNumber;
  @JSONField(name: "usable_deduct")
  String usableDeduct;
  @JSONField(name: "is_coupon")
  String isCoupon;
  @JSONField(name: "deduct_price")
  String deductPrice;
  @JSONField(name: "user_info")
  KeTaoFeaturedOrderUserInfoUserInfo userInfo;
}

class KeTaoFeaturedOrderDetailDataGoodsList with JsonConvert<KeTaoFeaturedOrderDetailDataGoodsList> {
  @JSONField(name: "goods_id")
  String goodsId;
  @JSONField(name: "goods_name")
  String goodsName;
  @JSONField(name: "goods_img")
  String goodsImg;
  @JSONField(name: "goods_num")
  String goodsNum;
  @JSONField(name: "sale_price")
  String salePrice;
  @JSONField(name: "spec_item")
  String specItem;
}
