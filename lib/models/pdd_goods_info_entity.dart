import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class PddGoodsInfoEntity with JsonConvert<PddGoodsInfoEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	PddGoodsInfoData data;
}

class PddGoodsInfoData with JsonConvert<PddGoodsInfoData> {
	@JSONField(name: "g_id")
	int gId;
	@JSONField(name: "g_title")
	String gTitle;
	@JSONField(name: "g_desc")
	String gDesc;
	@JSONField(name: "g_slideshow")
	List<String> gSlideshow;
	@JSONField(name: "g_group_price")
	String gGroupPrice;
	@JSONField(name: "g_normal_price")
	String gNormalPrice;
	@JSONField(name: "sales_tip")
	String salesTip;
	@JSONField(name: "goods_sign")
	String goodsSign;
	@JSONField(name: "we_app_path")
	String weAppPath;
	@JSONField(name: "we_app_id")
	String weAppId;
	@JSONField(name: "mobile_uri")
	String mobileUri;
	String url;
	PddGoodsInfoDataCoupons coupons;
}

class PddGoodsInfoDataCoupons with JsonConvert<PddGoodsInfoDataCoupons> {
	@JSONField(name: "coupon_discount")
	String couponDiscount;
	@JSONField(name: "coupon_remain_quantity")
	String couponRemainQuantity;
	@JSONField(name: "coupon_total_quantity")
	String couponTotalQuantity;
}
