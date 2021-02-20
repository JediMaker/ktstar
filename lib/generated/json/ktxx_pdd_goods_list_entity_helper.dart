import 'package:star/ktxxmodels/ktxx_pdd_goods_list_entity.dart';

pddGoodsListEntityFromJson(KeTaoFeaturedPddGoodsListEntity data, Map<String, dynamic> json) {
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
			data.data = new KeTaoFeaturedPddGoodsListData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> pddGoodsListEntityToJson(KeTaoFeaturedPddGoodsListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

pddGoodsListDataFromJson(KeTaoFeaturedPddGoodsListData data, Map<String, dynamic> json) {
	if (json['list'] != null) {
		data.xList = new List<KeTaoFeaturedPddGoodsListDataList>();
		(json['list'] as List).forEach((v) {
			data.xList.add(new KeTaoFeaturedPddGoodsListDataList().fromJson(v));
		});
	}
	if (json['list_id'] != null) {
		data.listId = json['list_id']?.toString();
	}
	if (json['page'] != null) {
		data.page = json['page']?.toInt();
	}
	return data;
}

Map<String, dynamic> pddGoodsListDataToJson(KeTaoFeaturedPddGoodsListData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.xList != null) {
		data['list'] =  entity.xList.map((v) => v.toJson()).toList();
	}
	data['list_id'] = entity.listId;
	data['page'] = entity.page;
	return data;
}

pddGoodsListDataListFromJson(KeTaoFeaturedPddGoodsListDataList data, Map<String, dynamic> json) {
	if (json['g_id'] != null) {
		data.gId = json['g_id']?.toInt();
	}
	if (json['g_title'] != null) {
		data.gTitle = json['g_title']?.toString();
	}
	if (json['g_pic'] != null) {
		data.gPic = json['g_pic']?.toString();
	}
	if (json['g_thumbnail'] != null) {
		data.gThumbnail = json['g_thumbnail']?.toString();
	}
	if (json['g_group_price'] != null) {
		data.gGroupPrice = json['g_group_price']?.toString();
	}
	if (json['g_normal_price'] != null) {
		data.gNormalPrice = json['g_normal_price']?.toString();
	}
	if (json['goods_sign'] != null) {
		data.goodsSign = json['goods_sign']?.toString();
	}
	if (json['search_id'] != null) {
		data.searchId = json['search_id']?.toString();
	}
	if (json['sales_tip'] != null) {
		data.salesTip = json['sales_tip']?.toString();
	}
	if (json['mall_name'] != null) {
		data.mallName = json['mall_name']?.toString();
	}
	if (json['g_bonus'] != null) {
		data.gBonus = json['g_bonus']?.toString();
	}
	if (json['coupons'] != null) {
		try {
			data.coupons = new KeTaoFeaturedPddGoodsListDataListCoupons().fromJson(json['coupons']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> pddGoodsListDataListToJson(KeTaoFeaturedPddGoodsListDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['g_id'] = entity.gId;
	data['g_title'] = entity.gTitle;
	data['g_pic'] = entity.gPic;
	data['g_thumbnail'] = entity.gThumbnail;
	data['g_group_price'] = entity.gGroupPrice;
	data['g_normal_price'] = entity.gNormalPrice;
	data['goods_sign'] = entity.goodsSign;
	data['search_id'] = entity.searchId;
	data['sales_tip'] = entity.salesTip;
	data['mall_name'] = entity.mallName;
	data['g_bonus'] = entity.gBonus;
	if (entity.coupons != null) {
		data['coupons'] = entity.coupons.toJson();
	}
	return data;
}

pddGoodsListDataListCouponsFromJson(KeTaoFeaturedPddGoodsListDataListCoupons data, Map<String, dynamic> json) {
	if (json['coupon_discount'] != null) {
		data.couponDiscount = json['coupon_discount']?.toString();
	}
	if (json['coupon_remain_quantity'] != null) {
		data.couponRemainQuantity = json['coupon_remain_quantity']?.toString();
	}
	if (json['coupon_total_quantity'] != null) {
		data.couponTotalQuantity = json['coupon_total_quantity']?.toString();
	}
	return data;
}

Map<String, dynamic> pddGoodsListDataListCouponsToJson(KeTaoFeaturedPddGoodsListDataListCoupons entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['coupon_discount'] = entity.couponDiscount;
	data['coupon_remain_quantity'] = entity.couponRemainQuantity;
	data['coupon_total_quantity'] = entity.couponTotalQuantity;
	return data;
}