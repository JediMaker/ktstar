import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';
import 'package:star/ktxxmodels/ktxx_vip_price_info_entity.dart';

class VipPriceEntity with JsonConvert<VipPriceEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	VipPriceInfoEntity data;
}

class VipPriceData with JsonConvert<VipPriceData> {
	@JSONField(name: "now_price")
	int nowPrice;
	@JSONField(name: "y_price")
	int yPrice;
}
