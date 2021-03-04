import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';
import 'package:star/ktxxmodels/ktxx_recharge_extra_entity.dart';

class RechargeEntity with JsonConvert<RechargeEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  RechargeData data;
}

class RechargeData with JsonConvert<RechargeData> {
  @JSONField(name: "rechage_list")
  List<RechargeDataRechageList> rechageList;
  @JSONField(name: "coupon_list")
  List<RechargeDatacouponList> couponList;
  @JSONField(name: "s_rechage_list")
  List<RechargeDataRechageList> sRechageList;
  RechargeExtraRatio ratio;
}

class RechargeDataRechageList with JsonConvert<RechargeDataRechageList> {
  int id;
  @JSONField(name: "face_money")
  String faceMoney;
  @JSONField(name: "use_money")
  String useMoney;
  @JSONField(name: "coupon_money")
  String couponMoney;
  @JSONField(name: "pay_money")
  String payMoney;
  bool flag;
  String coin;
  @JSONField(name: "coin_desc")
  String coinDesc;
}

class RechargeDatacouponList with JsonConvert<RechargeDatacouponList> {
  String money;
  String condition;
}
