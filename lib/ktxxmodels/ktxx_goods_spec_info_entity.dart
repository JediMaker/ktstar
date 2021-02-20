import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedGoodsSpecInfoEntity with JsonConvert<KeTaoFeaturedGoodsSpecInfoEntity> {
	@JSONField(name: "spec_info")
	KeTaoFeaturedGoodsSpecInfoSpecInfo specInfo;
}

class KeTaoFeaturedGoodsSpecInfoSpecInfo with JsonConvert<KeTaoFeaturedGoodsSpecInfoSpecInfo> {
	@JSONField(name: "spec_item")
	List<KeTaoFeaturedGoodsSpecInfoSpecInfoSpecItem> specItem;
	@JSONField(name: "spec_price")
	dynamic specPrice;
}

class KeTaoFeaturedGoodsSpecInfoSpecInfoSpecItem with JsonConvert<KeTaoFeaturedGoodsSpecInfoSpecInfoSpecItem> {
	String name;
	@JSONField(name: "list")
	List<String> xList;
}

class KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPrice with JsonConvert<KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPrice> {
	@JSONField(name: "ids_0_0")
	KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds ids00;
	@JSONField(name: "ids_0_1")
	KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds01 ids01;
	@JSONField(name: "ids_1_0")
	KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds10 ids10;
	@JSONField(name: "ids_1_1")
	KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds11 ids11;
}

class KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds with JsonConvert<KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds> {
	@JSONField(name: "spec_id")
	String specId;
	@JSONField(name: "spec_img")
	String specImg;
	@JSONField(name: "spec_price")
	String specPrice;
}

class KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds01 with JsonConvert<KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds01> {
	@JSONField(name: "spec_id")
	String specId;
	@JSONField(name: "spec_img")
	String specImg;
	@JSONField(name: "spec_price")
	String specPrice;
}

class KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds10 with JsonConvert<KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds10> {
	@JSONField(name: "spec_id")
	String specId;
	@JSONField(name: "spec_img")
	String specImg;
	@JSONField(name: "spec_price")
	String specPrice;
}

class KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds11 with JsonConvert<KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds11> {
	@JSONField(name: "spec_id")
	String specId;
	@JSONField(name: "spec_img")
	String specImg;
	@JSONField(name: "spec_price")
	String specPrice;
}
