import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedGoodsQueuePersionalEntity with JsonConvert<KeTaoFeaturedGoodsQueuePersionalEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	List<KeTaoFeaturedGoodsQueuePersionalData> data;
}

class KeTaoFeaturedGoodsQueuePersionalData with JsonConvert<KeTaoFeaturedGoodsQueuePersionalData> {
	@JSONField(name: "goods_id")
	String goodsId;
	@JSONField(name: "goods_img")
	String goodsImg;
	@JSONField(name: "goods_name")
	String goodsName;
	@JSONField(name: "create_time")
	String createTime;
	@JSONField(name: "sale_price")
	String goodsPrice;
	@JSONField(name: "power_num")
	String powerNum;
	int rank;
	String status;
}
