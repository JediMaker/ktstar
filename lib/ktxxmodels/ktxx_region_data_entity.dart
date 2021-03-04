import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class RegionDataEntity with JsonConvert<RegionDataEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	List<RegionDataData> data;
}

class RegionDataData with JsonConvert<RegionDataData> {
	int id;
	String value;
	List<RegionDataData> children;
}

class RegionDataDatachild with JsonConvert<RegionDataDatachild> {
	int id;
	String value;
	List<RegionDataDatachildchild> children;
}

class RegionDataDatachildchild with JsonConvert<RegionDataDatachildchild> {
	int id;
	String value;
}
