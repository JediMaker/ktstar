import 'package:star/ktxxmodels/goods_queue_entity.dart';

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
	if (json['goods_info'] != null) {
		data.goodsInfo = new GoodsQueueDataGoodsInfo().fromJson(json['goods_info']);
	}
	if (json['signPackage'] != null) {
		data.signPackage = new GoodsQueueDataSignPackage().fromJson(json['signPackage']);
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
	if (entity.goodsInfo != null) {
		data['goods_info'] = entity.goodsInfo.toJson();
	}
	if (entity.signPackage != null) {
		data['signPackage'] = entity.signPackage.toJson();
	}
	return data;
}

goodsQueueDataSignPackageFromJson(GoodsQueueDataSignPackage data, Map<String, dynamic> json) {
	if (json['url'] != null) {
		data.url = json['url']?.toString();
	}
	return data;
}

Map<String, dynamic> goodsQueueDataSignPackageToJson(GoodsQueueDataSignPackage entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['url'] = entity.url;
	return data;
}

goodsQueueDataGoodsInfoFromJson(GoodsQueueDataGoodsInfo data, Map<String, dynamic> json) {
	if (json['g_name'] != null) {
		data.gName = json['g_name']?.toString();
	}
	if (json['g_desc'] != null) {
		data.gDesc = json['g_desc']?.toString();
	}
	if (json['g_img'] != null) {
		data.gImg = json['g_img']?.toString();
	}
	return data;
}

Map<String, dynamic> goodsQueueDataGoodsInfoToJson(GoodsQueueDataGoodsInfo entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['g_name'] = entity.gName;
	data['g_desc'] = entity.gDesc;
	data['g_img'] = entity.gImg;
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
	if (json['power_num'] != null) {
		data.powerNum = json['power_num']?.toString();
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
	data['power_num'] = entity.powerNum;
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
	if (json['power_num'] != null) {
		data.powerNum = json['power_num']?.toString();
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
	data['power_num'] = entity.powerNum;
	data['goods_rank'] = entity.goodsRank;
	data['my_status'] = entity.myStatus;
	return data;
}