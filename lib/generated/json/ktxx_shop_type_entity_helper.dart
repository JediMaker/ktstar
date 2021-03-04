import 'package:star/ktxxmodels/ktxx_shop_type_entity.dart';

shopTypeEntityFromJson(
    ShopTypeEntity data, Map<String, dynamic> json) {
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
    data.data = new ShopTypeData().fromJson(json['data']);
  }
  return data;
}

Map<String, dynamic> shopTypeEntityToJson(ShopTypeEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  return data;
}

shopTypeDataFromJson(ShopTypeData data, Map<String, dynamic> json) {
  if (json['list'] != null) {
    data.xList = new List<ShopTypeDataList>();
    (json['list'] as List).forEach((v) {
      data.xList.add(new ShopTypeDataList().fromJson(v));
    });
  }
  return data;
}

Map<String, dynamic> shopTypeDataToJson(ShopTypeData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (entity.xList != null) {
    data['list'] = entity.xList.map((v) => v.toJson()).toList();
  }
  return data;
}

shopTypeDataListFromJson(ShopTypeDataList data, Map<String, dynamic> json) {
  if (json['id'] != null) {
    data.id = json['id']?.toString();
  }
  if (json['name'] != null) {
    data.name = json['name']?.toString();
  }
  if (json['profit'] != null) {
    data.profit = json['profit']?.toString();
  }
  return data;
}

Map<String, dynamic> shopTypeDataListToJson(ShopTypeDataList entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = entity.id;
  data['name'] = entity.name;
  data['profit'] = entity.profit;
  return data;
}
