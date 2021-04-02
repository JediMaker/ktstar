import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class CartListEntity with JsonConvert<CartListEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  CartListData data;
}

class CartListData with JsonConvert<CartListData> {
  String count;
  String num;
  @JSONField(name: "list")
  List<CartListDataList> xList;
}

class CartListDataList with JsonConvert<CartListDataList> {
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
  @JSONField(name: "goods_status")
  String goodsStatus;
  @JSONField(name: "spec_item")
  String specItem;
  @JSONField(name: "goods_img")
  String goodsImg;
  @JSONField(name: "goods_price")
  String goodsPrice;
  @JSONField(name: "goods_coin")
  String goodsCoin;
}
