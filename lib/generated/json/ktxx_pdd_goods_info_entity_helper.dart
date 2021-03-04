import 'package:star/ktxxmodels/ktxx_pdd_goods_info_entity.dart';

pddGoodsInfoEntityFromJson(PddGoodsInfoEntity data, Map<String, dynamic> json) {
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
    data.data = new PddGoodsInfoData().fromJson(json['data']);
  }
  return data;
}

Map<String, dynamic> pddGoodsInfoEntityToJson(PddGoodsInfoEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  return data;
}

pddGoodsInfoDataFromJson(PddGoodsInfoData data, Map<String, dynamic> json) {
  if (json['g_id'] != null) {
    data.gId = json['g_id']?.toInt();
  }
  if (json['g_title'] != null) {
    data.gTitle = json['g_title']?.toString();
  }
  if (json['g_desc'] != null) {
    data.gDesc = json['g_desc']?.toString();
  }
  if (json['g_slideshow'] != null) {
    data.gSlideshow = json['g_slideshow']
        ?.map((v) => v?.toString())
        ?.toList()
        ?.cast<String>();
  }
  if (json['g_group_price'] != null) {
    data.gGroupPrice = json['g_group_price']?.toString();
  }
  if (json['g_normal_price'] != null) {
    data.gNormalPrice = json['g_normal_price']?.toString();
  }
  if (json['sales_tip'] != null) {
    data.salesTip = json['sales_tip']?.toString();
  }
  if (json['goods_sign'] != null) {
    data.goodsSign = json['goods_sign']?.toString();
  }
  if (json['we_app_path'] != null) {
    data.weAppPath = json['we_app_path']?.toString();
  }
  if (json['we_app_id'] != null) {
    data.weAppId = json['we_app_id']?.toString();
  }
  if (json['mobile_uri'] != null) {
    data.mobileUri = json['mobile_uri']?.toString();
  }
  if (json['schema_url'] != null) {
    data.schemaUrl = json['schema_url']?.toString();
  }
  if (json['desc_txt'] != null) {
    data.descTxt = json['desc_txt']?.toString();
  }
  if (json['serv_txt'] != null) {
    data.servTxt = json['serv_txt']?.toString();
  }
  if (json['lgst_txt'] != null) {
    data.lgstTxt = json['lgst_txt']?.toString();
  }
  if (json['mall_name'] != null) {
    data.mallName = json['mall_name']?.toString();
  }
  if (json['g_bonus'] != null) {
    data.gBonus = json['g_bonus']?.toString();
  }
  if (json['login_status'] != null) {
    data.loginStatus = json['login_status']?.toString();
  }
  if (json['url'] != null) {
    data.url = json['url']?.toString();
  }
  if (json['coupons'] != null) {
    try {
      data.coupons = new PddGoodsInfoDataCoupons().fromJson(json['coupons']);
    } catch (e) {}
  }
  return data;
}

Map<String, dynamic> pddGoodsInfoDataToJson(PddGoodsInfoData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['g_id'] = entity.gId;
  data['g_title'] = entity.gTitle;
  data['g_desc'] = entity.gDesc;
  data['g_slideshow'] = entity.gSlideshow;
  data['g_group_price'] = entity.gGroupPrice;
  data['g_normal_price'] = entity.gNormalPrice;
  data['sales_tip'] = entity.salesTip;
  data['goods_sign'] = entity.goodsSign;
  data['we_app_path'] = entity.weAppPath;
  data['we_app_id'] = entity.weAppId;
  data['mobile_uri'] = entity.mobileUri;
  data['schema_url'] = entity.schemaUrl;
  data['desc_txt'] = entity.descTxt;
  data['serv_txt'] = entity.servTxt;
  data['lgst_txt'] = entity.lgstTxt;
  data['mall_name'] = entity.mallName;
  data['g_bonus'] = entity.gBonus;
  data['login_status'] = entity.loginStatus;
  data['url'] = entity.url;
  if (entity.coupons != null) {
    data['coupons'] = entity.coupons.toJson();
  }
  return data;
}

pddGoodsInfoDataCouponsFromJson(
    PddGoodsInfoDataCoupons data, Map<String, dynamic> json) {
  if (json['coupon_discount'] != null) {
    data.couponDiscount = json['coupon_discount']?.toString();
  }
  if (json['coupon_remain_quantity'] != null) {
    data.couponRemainQuantity = json['coupon_remain_quantity']?.toString();
  }
  if (json['coupon_total_quantity'] != null) {
    data.couponTotalQuantity = json['coupon_total_quantity']?.toString();
  }
  if (json['coupon_start_time'] != null) {
    data.couponStartTime = json['coupon_start_time']?.toString();
  }
  if (json['coupon_end_time'] != null) {
    data.couponEndTime = json['coupon_end_time']?.toString();
  }
  return data;
}

Map<String, dynamic> pddGoodsInfoDataCouponsToJson(
    PddGoodsInfoDataCoupons entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['coupon_discount'] = entity.couponDiscount;
  data['coupon_remain_quantity'] = entity.couponRemainQuantity;
  data['coupon_total_quantity'] = entity.couponTotalQuantity;
  data['coupon_start_time'] = entity.couponStartTime;
  data['coupon_end_time'] = entity.couponEndTime;
  return data;
}