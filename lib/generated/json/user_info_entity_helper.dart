import 'package:star/models/user_holder_profit_entity.dart';
import 'package:star/models/user_info_entity.dart';

userInfoEntityFromJson(UserInfoEntity data, Map<String, dynamic> json) {
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
      data.data = new UserInfoData().fromJson(json['data']);
    } catch (e) {}
  }
  return data;
}

Map<String, dynamic> userInfoEntityToJson(UserInfoEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  return data;
}

userInfoDataFromJson(UserInfoData data, Map<String, dynamic> json) {
  if (json['username'] != null) {
    data.username = json['username']?.toString();
  }
  if (json['avatar'] != null) {
    data.avatar = json['avatar']?.toString();
  }
  if (json['tel'] != null) {
    data.tel = json['tel']?.toString();
  }
  if (json['type'] != null) {
    data.type = json['type']?.toString();
  }
  if (json['gender'] != null) {
    data.gender = json['gender']?.toString();
  }
  if (json['code'] != null) {
    data.code = json['code']?.toString();
  }
  if (json['is_withdrawal'] != null) {
    data.isWithdrawal = json['is_withdrawal']?.toString();
  }
  if (json['wx_no'] != null) {
    data.wxNo = json['wx_no']?.toString();
  }
  if (json['zfb_name'] != null) {
    data.zfbName = json['zfb_name']?.toString();
  }
  if (json['zfb_account'] != null) {
    data.zfbAccount = json['zfb_account']?.toString();
  }
  if (json['reg_date'] != null) {
    data.regDate = json['reg_date']?.toString();
  }
  if (json['bind_third'] != null) {
    data.bindThird = json['bind_third']?.toInt();
  }
  if (json['now_price'] != null) {
    data.nowPrice = json['now_price']?.toString();
  }
  if (json['tx_price'] != null) {
    data.txPrice = json['tx_price']?.toString();
  }
  if (json['total_price'] != null) {
    data.totalPrice = json['total_price']?.toString();
  }
  if (json['pwd_status'] != null) {
    data.pwdStatus = json['pwd_status']?.toString();
  }
  if (json['pay_pwd_status'] != null) {
    data.payPwdStatus = json['pay_pwd_status']?.toString();
  }
  if (json['is_partner'] != null) {
    data.isPartner = json['is_partner']?.toString();
  }
  if (json['partner_time'] != null) {
    data.partnerTime = json['partner_time']?.toString();
  }
  if (json['partner_expire_time'] != null) {
    data.partnerExpireTime = json['partner_expire_time']?.toString();
  }
  if (json['store_status'] != null) {
    data.storeStatus = json['store_status']?.toString();
  }
  if (json['store_reject_msg'] != null) {
    data.storeRejectMsg = json['store_reject_msg']?.toString();
  }
  if (json['store_id'] != null) {
    data.storeId = json['store_id']?.toString();
  }
  if (json['is_protecting'] != null) {
    data.isProtecting = json['is_protecting'] ?? false;
  }
  if (json['protect_days'] != null) {
    data.protectDays = json['protect_days']?.toString();
  }
  if (json['partner_bonus'] != null) {
    data.partnerBonus =
        new UserHolderProfitPartnerBonus().fromJson(json['partner_bonus']);
  }
  return data;
}

Map<String, dynamic> userInfoDataToJson(UserInfoData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['username'] = entity.username;
  data['avatar'] = entity.avatar;
  data['tel'] = entity.tel;
  data['type'] = entity.type;
  data['gender'] = entity.gender;
  data['code'] = entity.code;
  data['is_withdrawal'] = entity.isWithdrawal;
  data['wx_no'] = entity.wxNo;
  data['zfb_name'] = entity.zfbName;
  data['zfb_account'] = entity.zfbAccount;
  data['reg_date'] = entity.regDate;
  data['bind_third'] = entity.bindThird;
  data['now_price'] = entity.nowPrice;
  data['tx_price'] = entity.txPrice;
  data['total_price'] = entity.totalPrice;
  data['pwd_status'] = entity.pwdStatus;
  data['pay_pwd_status'] = entity.payPwdStatus;
  data['is_partner'] = entity.isPartner;
  data['partner_time'] = entity.partnerTime;
  data['partner_expire_time'] = entity.partnerExpireTime;
  data['store_status'] = entity.storeStatus;
  data['store_reject_msg'] = entity.storeRejectMsg;
  data['store_id'] = entity.storeId;
  data['is_protecting'] = entity.isProtecting;
  data['protect_days'] = entity.protectDays;
  if (entity.partnerBonus != null) {
    data['partner_bonus'] = entity.partnerBonus.toJson();
  }
  return data;
}
