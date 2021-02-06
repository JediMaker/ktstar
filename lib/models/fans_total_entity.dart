import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class FansTotalEntity with JsonConvert<FansTotalEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	FansTotalData data;
}

class FansTotalData with JsonConvert<FansTotalData> {
	@JSONField(name: "agent_info")
	FansTotalDataAgentInfo agentInfo;
	@JSONField(name: "count_info")
	FansTotalDataCountInfo countInfo;
}

class FansTotalDataAgentInfo with JsonConvert<FansTotalDataAgentInfo> {
	String avatar;
	String username;
	String tel;
	@JSONField(name: "wx_no")
	String wxNo;
}

class FansTotalDataCountInfo with JsonConvert<FansTotalDataCountInfo> {
	int total;
	int vip;
	int experience;
	int noviciate;
	int ordinary;
	int diamond;
}
