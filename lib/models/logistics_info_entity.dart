import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class LogisticsInfoEntity with JsonConvert<LogisticsInfoEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	LogisticsInfoData data;
}

class LogisticsInfoData with JsonConvert<LogisticsInfoData> {
	@JSONField(name: "express_list")
	List<LogisticsInfoDataExpressList> expressList;
	@JSONField(name: "express_info")
	LogisticsInfoDataExpressInfo expressInfo;
}

class LogisticsInfoDataExpressList with JsonConvert<LogisticsInfoDataExpressList> {
	String title;
	int type;
	String time;
	String desc;
	@JSONField(name: "list")
	List<LogisticsInfoDataExpressListList> xList;
}

class LogisticsInfoDataExpressListList with JsonConvert<LogisticsInfoDataExpressListList> {
	String time;
	String subdesc;
}

class LogisticsInfoDataExpressInfo with JsonConvert<LogisticsInfoDataExpressInfo> {
	String number;
	String name;
	String tel;
}
