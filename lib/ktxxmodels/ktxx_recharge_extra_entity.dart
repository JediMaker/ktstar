import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedRechargeExtraEntity
    with JsonConvert<KeTaoFeaturedRechargeExtraEntity> {
  @JSONField(name: "s_rechage_list")
  List<KeTaoFeaturedRechargeExtraSRechageList> sRechageList;
  KeTaoFeaturedRechargeExtraRatio ratio;
}

class KeTaoFeaturedRechargeExtraSRechageList
    with JsonConvert<KeTaoFeaturedRechargeExtraSRechageList> {
  String id;
  @JSONField(name: "face_money")
  String faceMoney;
  @JSONField(name: "use_money")
  String useMoney;
  bool flag;
  @JSONField(name: "pay_money")
  String payMoney;
  String coin;
  @JSONField(name: "coin_desc")
  String coinDesc;
}

class KeTaoFeaturedRechargeExtraRatio
    with JsonConvert<KeTaoFeaturedRechargeExtraRatio> {
  String fast;
  String slow;
}
