import 'package:star/models/goods_queue_entity.dart';

goodsQueueEntityFromJson(GoodsQueueEntity data, Map<String, dynamic> json) {
	if (json['status'] != null) {
		data.status = json['status'];
	}
	if (json['err_code'] != null) {
		data.errCode = json['err_code']?.toInt();
	}
	if (json['err_msg'] != null) {
		data.errMsg = json['err_msg'];
	}
	if (json['data'] != null) {
		try {
			data.data = new GoodsQueueData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> goodsQueueEntityToJson(GoodsQueueEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

goodsQueueDataFromJson(GoodsQueueData data, Map<String, dynamic> json) {
	if (json['list'] != null) {
		data.xList = new List<GoodsQueueDataList>();
		(json['list'] as List).forEach((v) {
			data.xList.add(new GoodsQueueDataList().fromJson(v));
		});
	}
	if (json['user_info'] != null) {
		data.userInfo = new GoodsQueueDataUserInfo().fromJson(json['user_info']);
	}
	return data;
}

Map<String, dynamic> goodsQueueDataToJson(GoodsQueueData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.xList != null) {
		data['list'] =  entity.xList.map((v) => v.toJson()).toList();
	}
	if (entity.userInfo != null) {
		data['user_info'] = entity.userInfo.toJson();
	}
	return data;
}

goodsQueueDataListFromJson(GoodsQueueDataList data, Map<String, dynamic> json) {
	if (json['username'] != null) {
		data.username = json['username']?.toString();
	}
	if (json['avatar'] != null) {
		data.avatar = json['avatar']?.toString();
	}
	if (json['create_time'] != null) {
		data.createTime = json['create_time']?.toString();
	}
	if (json['rank'] != null) {
		data.rank = json['rank']?.toInt();
	}
	if (json['is_my'] != null) {
		data.isMy = json['is_my'];
	}
	return data;
}

Map<String, dynamic> goodsQueueDataListToJson(GoodsQueueDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['username'] = entity.username;
	data['avatar'] = entity.avatar;
	data['create_time'] = entity.createTime;
	data['rank'] = entity.rank;
	data['is_my'] = entity.isMy;
	return data;
}

goodsQueueDataUserInfoFromJson(GoodsQueueDataUserInfo data, Map<String, dynamic> json) {
	if (json['username'] != null) {
		data.username = json['username']?.toString();
	}
	if (json['avatar'] != null) {
		data.avatar = json['avatar']?.toString();
	}
	if (json['goods_rank'] != null) {
		data.goodsRank = json['goods_rank']?.toInt();
	}
	if (json['my_status'] != null) {
		data.myStatus = json['my_status'];
	}
	return data;
}

Map<String, dynamic> goodsQueueDataUserInfoToJson(GoodsQueueDataUserInfo entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['username'] = entity.username;
	data['avatar'] = entity.avatar;
	data['goods_rank'] = entity.goodsRank;
	data['my_status'] = entity.myStatus;
	return data;
}