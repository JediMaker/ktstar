import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';
import 'package:star/ktxxmodels/ktxx_vip_price_info_entity.dart';

class KeTaoFeaturedVipPriceEntity with JsonConvert<KeTaoFeaturedVipPriceEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	KeTaoFeaturedVipPriceInfoEntity data;
}

class KeTaoFeaturedVipPriceData with JsonConvert<KeTaoFeaturedVipPriceData> {
	@JSONField(name: "now_price")
	int nowPrice;
	@JSONField(name: "y_price")
	int yPrice;
}
