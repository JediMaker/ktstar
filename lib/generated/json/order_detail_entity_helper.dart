import 'package:star/models/order_detail_entity.dart';

orderDetailEntityFromJson(OrderDetailEntity data, Map<String, dynamic> json) {
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
			data.data = new OrderDetailData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> orderDetailEntityToJson(OrderDetailEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

orderDetailDataFromJson(OrderDetailData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toInt();
	}
	if (json['pay_price'] != null) {
		data.payPrice = json['pay_price']?.toString();
	}
	if (json['payment'] != null) {
		data.payment = json['payment']?.toString();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toInt();
	}
	if (json['orderno'] != null) {
		data.orderno = json['orderno']?.toString();
	}
	if (json['consignee'] != null) {
		data.consignee = json['consignee']?.toString();
	}
	if (json['mobile'] != null) {
		data.mobile = json['mobile']?.toString();
	}
	if (json['address'] != null) {
		data.address = json['address']?.toString();
	}
	if (json['goods_list'] != null) {
		data.goodsList = new List<OrderDetailDataGoodsList>();
		(json['goods_list'] as List).forEach((v) {
			data.goodsList.add(new OrderDetailDataGoodsList().fromJson(v));
		});
	}
	if (json['total_price'] != null) {
		data.totalPrice = json['total_price']?.toString();
	}
	if (json['create_time'] != null) {
		data.createTime = json['create_time']?.toString();
	}
	if (json['pay_time'] != null) {
		data.payTime = json['pay_time']?.toString();
	}
	if (json['send_time'] != null) {
		data.sendTime = json['send_time']?.toString();
	}
	if (json['confirm_time'] != null) {
		data.confirmTime = json['confirm_time']?.toString();
	}
	if (json['send_name'] != null) {
		data.sendName = json['send_name']?.toString();
	}
	if (json['send_number'] != null) {
		data.sendNumber = json['send_number']?.toString();
	}
	return data;
}

Map<String, dynamic> orderDetailDataToJson(OrderDetailData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['pay_price'] = entity.payPrice;
	data['payment'] = entity.payment;
	data['status'] = entity.status;
	data['orderno'] = entity.orderno;
	data['consignee'] = entity.consignee;
	data['mobile'] = entity.mobile;
	data['address'] = entity.address;
	if (entity.goodsList != null) {
		data['goods_list'] =  entity.goodsList.map((v) => v.toJson()).toList();
	}
	data['total_price'] = entity.totalPrice;
	data['create_time'] = entity.createTime;
	data['pay_time'] = entity.payTime;
	data['send_time'] = entity.sendTime;
	data['confirm_time'] = entity.confirmTime;
	data['send_name'] = entity.sendName;
	data['send_number'] = entity.sendNumber;
	return data;
}

orderDetailDataGoodsListFromJson(OrderDetailDataGoodsList data, Map<String, dynamic> json) {
	if (json['goods_id'] != null) {
		data.goodsId = json['goods_id']?.toString();
	}
	if (json['goods_name'] != null) {
		data.goodsName = json['goods_name']?.toString();
	}
	if (json['goods_img'] != null) {
		data.goodsImg = json['goods_img']?.toString();
	}
	if (json['goods_num'] != null) {
		data.goodsNum = json['goods_num']?.toString();
	}
	if (json['sale_price'] != null) {
		data.salePrice = json['sale_price']?.toString();
	}
	return data;
}

Map<String, dynamic> orderDetailDataGoodsListToJson(OrderDetailDataGoodsList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['goods_id'] = entity.goodsId;
	data['goods_name'] = entity.goodsName;
	data['goods_img'] = entity.goodsImg;
	data['goods_num'] = entity.goodsNum;
	data['sale_price'] = entity.salePrice;
	return data;
}