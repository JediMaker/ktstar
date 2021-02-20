import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedFansTotalEntity with JsonConvert<KeTaoFeaturedFansTotalEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	KeTaoFeaturedFansTotalData data;
}

class KeTaoFeaturedFansTotalData with JsonConvert<KeTaoFeaturedFansTotalData> {
	@JSONField(name: "agent_info")
	KeTaoFeaturedFansTotalDataAgentInfo agentInfo;
	@JSONField(name: "count_info")
	KeTaoFeaturedFansTotalDataCountInfo countInfo;
}

class KeTaoFeaturedFansTotalDataAgentInfo with JsonConvert<KeTaoFeaturedFansTotalDataAgentInfo> {
	String avatar;
	String username;
	String tel;
	@JSONField(name: "wx_no")
	String wxNo;
}

class KeTaoFeaturedFansTotalDataCountInfo with JsonConvert<KeTaoFeaturedFansTotalDataCountInfo> {
	int total;
	int vip;
	int experience;
	int noviciate;
	int ordinary;
	int diamond;
}
