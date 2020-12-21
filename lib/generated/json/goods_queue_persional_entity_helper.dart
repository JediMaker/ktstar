import 'package:star/models/goods_queue_persional_entity.dart';

goodsQueuePersionalEntityFromJson(GoodsQueuePersionalEntity data, Map<String, dynamic> json) {
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
		data.data = new List<GoodsQueuePersionalData>();
		(json['data'] as List).forEach((v) {
			try {
				data.data.add(new GoodsQueuePersionalData().fromJson(v));
			} catch (e) {
			}
		});
	}
	return data;
}

Map<String, dynamic> goodsQueuePersionalEntityToJson(GoodsQueuePersionalEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	return data;
}

goodsQueuePersionalDataFromJson(GoodsQueuePersionalData data, Map<String, dynamic> json) {
	if (json['goods_id'] != null) {
		data.goodsId = json['goods_id']?.toString();
	}
	if (json['goods_img'] != null) {
		data.goodsImg = json['goods_img']?.toString();
	}
	if (json['goods_name'] != null) {
		data.goodsName = json['goods_name']?.toString();
	}
	if (json['create_time'] != null) {
		data.createTime = json['create_time']?.toString();
	}
	if (json['sale_price'] != null) {
		data.goodsPrice = json['sale_price']?.toString();
	}
	if (json['power_num'] != null) {
		data.powerNum = json['power_num']?.toString();
	}
	if (json['rank'] != null) {
		data.rank = json['rank']?.toInt();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	return data;
}

Map<String, dynamic> goodsQueuePersionalDataToJson(GoodsQueuePersionalData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['goods_id'] = entity.goodsId;
	data['goods_img'] = entity.goodsImg;
	data['goods_name'] = entity.goodsName;
	data['create_time'] = entity.createTime;
	data['sale_price'] = entity.goodsPrice;
	data['power_num'] = entity.powerNum;
	data['rank'] = entity.rank;
	data['status'] = entity.status;
	return data;
}