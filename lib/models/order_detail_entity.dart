import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class OrderDetailEntity with JsonConvert<OrderDetailEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	OrderDetailData data;
}

class OrderDetailData with JsonConvert<OrderDetailData> {
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
	List<OrderDetailDataGoodsList> goodsList;
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
}

class OrderDetailDataGoodsList with JsonConvert<OrderDetailDataGoodsList> {
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
}
