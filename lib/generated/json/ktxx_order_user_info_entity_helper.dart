import 'package:star/ktxxmodels/ktxx_order_user_info_entity.dart';

orderUserInfoEntityFromJson(
    OrderUserInfoEntity data, Map<String, dynamic> json) {
  if (json['user_info'] != null) {
    data.userInfo = new OrderUserInfoUserInfo().fromJson(json['user_info']);
  }
  return data;
}

Map<String, dynamic> orderUserInfoEntityToJson(OrderUserInfoEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (entity.userInfo != null) {
    data['user_info'] = entity.userInfo.toJson();
  }
  return data;
}

orderUserInfoUserInfoFromJson(
    OrderUserInfoUserInfo data, Map<String, dynamic> json) {
  if (json['price'] != null) {
    data.price = json['price']?.toString();
  }
  if (json['pay_pwd_flag'] != null) {
    data.payPwdFlag = json['pay_pwd_flag'];
  }
  return data;
}

Map<String, dynamic> orderUserInfoUserInfoToJson(OrderUserInfoUserInfo entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['price'] = entity.price;
  data['pay_pwd_flag'] = entity.payPwdFlag;
  return data;
}
