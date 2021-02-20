import 'package:star/ktxxmodels/ktxx_order_list_entity.dart';

orderListEntityFromJson(KeTaoFeaturedOrderListEntity data, Map<String, dynamic> json) {
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
			data.data = new KeTaoFeaturedOrderListData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> orderListEntityToJson(KeTaoFeaturedOrderListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

orderListDataFromJson(KeTaoFeaturedOrderListData data, Map<String, dynamic> json) {
	if (json['list'] != null) {
		data.xList = new List<KeTaoFeaturedOrderListDataList>();
		(json['list'] as List).forEach((v) {
			data.xList.add(new KeTaoFeaturedOrderListDataList().fromJson(v));
		});
	}
	if (json['page'] != null) {
		data.page = json['page']?.toInt();
	}
	if (json['page_size'] != null) {
		data.pageSize = json['page_size']?.toInt();
	}
	return data;
}

Map<String, dynamic> orderListDataToJson(KeTaoFeaturedOrderListData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.xList != null) {
		data['list'] =  entity.xList.map((v) => v.toJson()).toList();
	}
	data['page'] = entity.page;
	data['page_size'] = entity.pageSize;
	return data;
}

orderListDataListFromJson(KeTaoFeaturedOrderListDataList data, Map<String, dynamic> json) {
	if (json['order_type'] != null) {
		data.orderType = json['order_type']?.toString();
	}
	if (json['order_id'] != null) {
		data.orderId = json['order_id']?.toString();
	}
	if (json['pay_price'] != null) {
		data.payPrice = json['pay_price']?.toString();
	}
	if (json['total_price'] != null) {
		data.totalPrice = json['total_price']?.toString();
	}
	if (json['orderno'] != null) {
		data.orderno = json['orderno']?.toString();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	if (json['create_time'] != null) {
		data.createTime = json['create_time']?.toString();
	}
	if (json['goods_list'] != null) {
		data.goodsList = new List<KeTaoFeaturedOrderListDataListGoodsList>();
		(json['goods_list'] as List).forEach((v) {
			data.goodsList.add(new KeTaoFeaturedOrderListDataListGoodsList().fromJson(v));
		});
	}
	if (json['face_money'] != null) {
		data.faceMoney = json['face_money']?.toString();
	}
	if (json['order_source'] != null) {
		data.orderSource = json['order_source']?.toString();
	}
	if (json['mobile'] != null) {
		data.mobile = json['mobile']?.toString();
	}
	if (json['phone'] != null) {
		data.phone = json['phone']?.toString();
	}
	if (json['coin'] != null) {
		data.coin = json['coin']?.toString();
	}
	return data;
}

Map<String, dynamic> orderListDataListToJson(KeTaoFeaturedOrderListDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['order_type'] = entity.orderType;
	data['order_id'] = entity.orderId;
	data['pay_price'] = entity.payPrice;
	data['total_price'] = entity.totalPrice;
	data['orderno'] = entity.orderno;
	data['status'] = entity.status;
	data['create_time'] = entity.createTime;
	if (entity.goodsList != null) {
		data['goods_list'] =  entity.goodsList.map((v) => v.toJson()).toList();
	}
	data['face_money'] = entity.faceMoney;
	data['order_source'] = entity.orderSource;
	data['mobile'] = entity.mobile;
	data['phone'] = entity.phone;
	data['coin'] = entity.coin;
	return data;
}

orderListDataListGoodsListFromJson(KeTaoFeaturedOrderListDataListGoodsList data, Map<String, dynamic> json) {
	if (json['goods_id'] != null) {
		data.goodsId = json['goods_id']?.toString();
	}
	if (json['goods_name'] != null) {
		try {
			data.goodsName = json['goods_name']?.toString();
		} catch (e) {
		}
	}
	if (json['goods_img'] != null) {
		data.goodsImg = json['goods_img']?.toString();
	}
	if (json['goods_num'] != null) {
		data.goodsNum = json['goods_num']?.toInt();
	}
	if (json['sale_price'] != null) {
		data.salePrice = json['sale_price']?.toString();
	}
	if (json['spec_item'] != null) {
		data.specItem = json['spec_item']?.toString();
	}
	if (json['goods_source'] != null) {
		data.goodsSource = json['goods_source']?.toString();
	}
	if (json['pdd_goods_id'] != null) {
		data.pddGoodsId = json['pdd_goods_id']?.toString();
	}
	if (json['goods_sign'] != null) {
		data.goodsSign = json['goods_sign']?.toString();
	}
	return data;
}

Map<String, dynamic> orderListDataListGoodsListToJson(KeTaoFeaturedOrderListDataListGoodsList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['goods_id'] = entity.goodsId;
	data['goods_name'] = entity.goodsName;
	data['goods_img'] = entity.goodsImg;
	data['goods_num'] = entity.goodsNum;
	data['sale_price'] = entity.salePrice;
	data['spec_item'] = entity.specItem;
	data['goods_source'] = entity.goodsSource;
	data['pdd_goods_id'] = entity.pddGoodsId;
	data['goods_sign'] = entity.goodsSign;
	return data;
}