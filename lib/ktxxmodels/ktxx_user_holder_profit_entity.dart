import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class UserHolderProfitEntity with JsonConvert<UserHolderProfitEntity> {
  @JSONField(name: "partner_bonus")
  UserHolderProfitPartnerBonus partnerBonus;
}

class UserHolderProfitPartnerBonus
    with JsonConvert<UserHolderProfitPartnerBonus> {
  @JSONField(name: "today_price")
  String todayPrice;
  @JSONField(name: "today_deserve")
  String todayDeserve;
  String yesterday;
  String week;
  String month;
  String total;
  String coin;
}
