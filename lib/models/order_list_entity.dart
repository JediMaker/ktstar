import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class OrderListEntity with JsonConvert<OrderListEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  OrderListData data;
}

class OrderListData with JsonConvert<OrderListData> {
  @JSONField(name: "list")
  List<OrderListDataList> xList;
  int page;
  @JSONField(name: "page_size")
  int pageSize;
}

class OrderListDataList with JsonConvert<OrderListDataList> {
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
  List<OrderListDataListGoodsList> goodsList;
  @JSONField(name: "face_money")
  String faceMoney;
  @JSONField(name: "order_source")
  String orderSource;
  String mobile;
  String phone;
}

class OrderListDataListGoodsList with JsonConvert<OrderListDataListGoodsList> {
  @JSONField(name: "goods_id")
  int goodsId;
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
}
