import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class GoodsSpecInfoEntity with JsonConvert<GoodsSpecInfoEntity> {
	@JSONField(name: "spec_info")
	GoodsSpecInfoSpecInfo specInfo;
}

class GoodsSpecInfoSpecInfo with JsonConvert<GoodsSpecInfoSpecInfo> {
	@JSONField(name: "spec_item")
	List<GoodsSpecInfoSpecInfoSpecItem> specItem;
	@JSONField(name: "spec_price")
	GoodsSpecInfoSpecInfoSpecPrice specPrice;
}

class GoodsSpecInfoSpecInfoSpecItem with JsonConvert<GoodsSpecInfoSpecInfoSpecItem> {
	String name;
	@JSONField(name: "list")
	List<String> xList;
}

class GoodsSpecInfoSpecInfoSpecPrice with JsonConvert<GoodsSpecInfoSpecInfoSpecPrice> {
	@JSONField(name: "ids_0_0")
	GoodsSpecInfoSpecInfoSpecPriceIds00 ids00;
	@JSONField(name: "ids_0_1")
	GoodsSpecInfoSpecInfoSpecPriceIds01 ids01;
	@JSONField(name: "ids_1_0")
	GoodsSpecInfoSpecInfoSpecPriceIds10 ids10;
	@JSONField(name: "ids_1_1")
	GoodsSpecInfoSpecInfoSpecPriceIds11 ids11;
}

class GoodsSpecInfoSpecInfoSpecPriceIds00 with JsonConvert<GoodsSpecInfoSpecInfoSpecPriceIds00> {
	@JSONField(name: "spec_id")
	String specId;
	@JSONField(name: "spec_img")
	String specImg;
	@JSONField(name: "spec_price")
	String specPrice;
}

class GoodsSpecInfoSpecInfoSpecPriceIds01 with JsonConvert<GoodsSpecInfoSpecInfoSpecPriceIds01> {
	@JSONField(name: "spec_id")
	String specId;
	@JSONField(name: "spec_img")
	String specImg;
	@JSONField(name: "spec_price")
	String specPrice;
}

class GoodsSpecInfoSpecInfoSpecPriceIds10 with JsonConvert<GoodsSpecInfoSpecInfoSpecPriceIds10> {
	@JSONField(name: "spec_id")
	String specId;
	@JSONField(name: "spec_img")
	String specImg;
	@JSONField(name: "spec_price")
	String specPrice;
}

class GoodsSpecInfoSpecInfoSpecPriceIds11 with JsonConvert<GoodsSpecInfoSpecInfoSpecPriceIds11> {
	@JSONField(name: "spec_id")
	String specId;
	@JSONField(name: "spec_img")
	String specImg;
	@JSONField(name: "spec_price")
	String specPrice;
}
