import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class GoodsQueueEntity with JsonConvert<GoodsQueueEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	GoodsQueueData data;
}

class GoodsQueueData with JsonConvert<GoodsQueueData> {
	@JSONField(name: "list")
	List<GoodsQueueDataList> xList;
	@JSONField(name: "user_info")
	GoodsQueueDataUserInfo userInfo;
}

class GoodsQueueDataList with JsonConvert<GoodsQueueDataList> {
	String username;
	String avatar;
	@JSONField(name: "create_time")
	String createTime;
	int rank;
	@JSONField(name: "is_my")
	bool isMy;
}

class GoodsQueueDataUserInfo with JsonConvert<GoodsQueueDataUserInfo> {
	String username;
	String avatar;
	@JSONField(name: "goods_rank")
	int goodsRank;
	@JSONField(name: "my_status")
	bool myStatus;
}
