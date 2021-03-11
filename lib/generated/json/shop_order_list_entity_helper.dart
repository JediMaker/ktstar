import 'package:star/models/shop_order_list_entity.dart';

shopOrderListEntityFromJson(
    ShopOrderListEntity data, Map<String, dynamic> json) {
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
    data.data = new ShopOrderListData().fromJson(json['data']);
  }
  return data;
}

Map<String, dynamic> shopOrderListEntityToJson(ShopOrderListEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  return data;
}

shopOrderListDataFromJson(ShopOrderListData data, Map<String, dynamic> json) {
  if (json['list'] != null) {
    data.xList = new List<ShopOrderListDataList>();
    (json['list'] as List).forEach((v) {
      data.xList.add(new ShopOrderListDataList().fromJson(v));
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

Map<String, dynamic> shopOrderListDataToJson(ShopOrderListData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (entity.xList != null) {
    data['list'] = entity.xList.map((v) => v.toJson()).toList();
  }
  data['page'] = entity.page;
  data['page_size'] = entity.pageSize;
  return data;
}

shopOrderListDataListFromJson(
    ShopOrderListDataList data, Map<String, dynamic> json) {
  if (json['orderno'] != null) {
    data.orderno = json['orderno']?.toString();
  }
  if (json['pay_price'] != null) {
    data.payPrice = json['pay_price']?.toString();
  }
  if (json['pay_time'] != null) {
    data.payTime = json['pay_time']?.toString();
  }
  if (json['username'] != null) {
    data.username = json['username']?.toString();
  }
  return data;
}

Map<String, dynamic> shopOrderListDataListToJson(ShopOrderListDataList entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['orderno'] = entity.orderno;
  data['pay_price'] = entity.payPrice;
  data['pay_time'] = entity.payTime;
  data['username'] = entity.username;
  return data;
}
