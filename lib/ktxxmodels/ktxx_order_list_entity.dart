import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedOrderListEntity with JsonConvert<KeTaoFeaturedOrderListEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  KeTaoFeaturedOrderListData data;
}

class KeTaoFeaturedOrderListData with JsonConvert<KeTaoFeaturedOrderListData> {
  @JSONField(name: "list")
  List<KeTaoFeaturedOrderListDataList> xList;
  int page;
  @JSONField(name: "page_size")
  int pageSize;
}

class KeTaoFeaturedOrderListDataList with JsonConvert<KeTaoFeaturedOrderListDataList> {
  @JSONField(name: "order_type")
  String orderType;
  @JSONField(name: "order_id")
  String orderId;
  @JSONField(name: "pay_price")
  String payPrice;
  @JSONField(name: "total_price")
  String totalPrice;
  String orderno;
  String status;
  @JSONField(name: "create_time")
  String createTime;
  @JSONField(name: "goods_list")
  List<KeTaoFeaturedOrderListDataListGoodsList> goodsList;
  @JSONField(name: "face_money")
  String faceMoney;
  @JSONField(name: "order_source")
  String orderSource;
  @JSONField(name: "refund_status")
  String refundStatus;
  @JSONField(name: "refund_msg")
  String refundMsg;
  String mobile;
  String phone;
  String coin;
}

class KeTaoFeaturedOrderListDataListGoodsList with JsonConvert<KeTaoFeaturedOrderListDataListGoodsList> {
  @JSONField(name: "goods_id")
  String goodsId;
  @JSONField(name: "goods_name")
  String goodsName;
  @JSONField(name: "goods_img")
  String goodsImg;
  @JSONField(name: "goods_num")
  int goodsNum;
  @JSONField(name: "sale_price")
  String salePrice;
  @JSONField(name: "spec_item")
  String specItem;
  @JSONField(name: "goods_source")
  String goodsSource;
  @JSONField(name: "pdd_goods_id")
  String pddGoodsId;
  @JSONField(name: "goods_sign")
  String goodsSign;
}
