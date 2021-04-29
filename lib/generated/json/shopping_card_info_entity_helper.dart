import 'package:star/models/shopping_card_info_entity.dart';

shoppingCardInfoEntityFromJson(
    ShoppingCardInfoEntity data, Map<String, dynamic> json) {
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
    data.data = new ShoppingCardInfoData().fromJson(json['data']);
  }
  return data;
}

Map<String, dynamic> shoppingCardInfoEntityToJson(
    ShoppingCardInfoEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  return data;
}

shoppingCardInfoDataFromJson(
    ShoppingCardInfoData data, Map<String, dynamic> json) {
  if (json['money'] != null) {
    data.money =
        json['money']?.map((v) => v?.toString())?.toList()?.cast<String>();
  }
  if (json['rules'] != null) {
    data.rules =
        json['rules']?.map((v) => v?.toString())?.toList()?.cast<String>();
  }
  if (json['now_money'] != null) {
    data.nowMoney = json['now_money']?.toString();
  }
  return data;
}

Map<String, dynamic> shoppingCardInfoDataToJson(ShoppingCardInfoData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['money'] = entity.money;
  data['rules'] = entity.rules;
  data['now_money'] = entity.nowMoney;
  return data;
}
