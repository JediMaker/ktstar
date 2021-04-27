import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';
import 'package:star/models/user_holder_profit_entity.dart';

class UserInfoEntity with JsonConvert<UserInfoEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  UserInfoData data;
}

class UserInfoData with JsonConvert<UserInfoData> {
  String username;
  String avatar;
  String tel;
  String type;
  String gender;
  String code;
  @JSONField(name: "is_withdrawal")
  String isWithdrawal;
  @JSONField(name: "wx_no")
  String wxNo;
  @JSONField(name: "zfb_name")
  String zfbName;
  @JSONField(name: "zfb_account")
  String zfbAccount;
  @JSONField(name: "reg_date")
  String regDate;
  @JSONField(name: "bind_third")
  int bindThird;
  @JSONField(name: "now_price")
  String nowPrice;
  @JSONField(name: "tx_price")
  String txPrice;
  @JSONField(name: "total_price")
  String totalPrice;
  @JSONField(name: "pwd_status")
  String pwdStatus;
  @JSONField(name: "pay_pwd_status")
  String payPwdStatus;
  @JSONField(name: "is_partner")
  String isPartner;
  @JSONField(name: "partner_time")
  String partnerTime;
  @JSONField(name: "partner_expire_time")
  String partnerExpireTime;
  @JSONField(name: "store_status")
  String storeStatus;
  @JSONField(name: "store_reject_msg")
  String storeRejectMsg;
  @JSONField(name: "store_id")
  String storeId;
  @JSONField(name: "is_protecting")
  bool isProtecting;
  @JSONField(name: "protect_days")
  String protectDays;
  @JSONField(name: "partner_bonus")
  UserHolderProfitPartnerBonus partnerBonus;
}
