import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedLogisticsInfoEntity with JsonConvert<KeTaoFeaturedLogisticsInfoEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	KeTaoFeaturedLogisticsInfoData data;
}

class KeTaoFeaturedLogisticsInfoData with JsonConvert<KeTaoFeaturedLogisticsInfoData> {
	@JSONField(name: "express_list")
	List<KeTaoFeaturedLogisticsInfoDataExpressList> expressList;
	@JSONField(name: "express_info")
	KeTaoFeaturedLogisticsInfoDataExpressInfo expressInfo;
}

class KeTaoFeaturedLogisticsInfoDataExpressList with JsonConvert<KeTaoFeaturedLogisticsInfoDataExpressList> {
	String title;
	int type;
	String time;
	String desc;
	@JSONField(name: "list")
	List<KeTaoFeaturedLogisticsInfoDataExpressListList> xList;
}

class KeTaoFeaturedLogisticsInfoDataExpressListList with JsonConvert<KeTaoFeaturedLogisticsInfoDataExpressListList> {
	String time;
	String subdesc;
}

class KeTaoFeaturedLogisticsInfoDataExpressInfo with JsonConvert<KeTaoFeaturedLogisticsInfoDataExpressInfo> {
	String number;
	String name;
	String tel;
}
