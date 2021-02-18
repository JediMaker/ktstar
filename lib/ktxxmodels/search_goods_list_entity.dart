import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';
import 'package:star/ktxxmodels/home_goods_list_entity.dart';


class SearchGoodsListEntity with JsonConvert<SearchGoodsListEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	SearchGoodsListData data;
}

class SearchGoodsListData with JsonConvert<SearchGoodsListData> {
	String total;
	int page;
	@JSONField(name: "list")
	List<HomeGoodsListGoodsList> goodsList;
}

class SearchGoodsListDataList with JsonConvert<SearchGoodsListDataList> {
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
