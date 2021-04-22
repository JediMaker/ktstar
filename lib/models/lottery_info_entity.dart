import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class LotteryInfoEntity with JsonConvert<LotteryInfoEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  LotteryInfoData data;
}

class LotteryInfoData with JsonConvert<LotteryInfoData> {
  @JSONField(name: "prize_id")
  int prizeId;
  @JSONField(name: "prize_name")
  String prizeName;
  @JSONField(name: "lottery_msg")
  String lotteryMsg;
  @JSONField(name: "play_times")
  String playTimes;
  @JSONField(name: "need_power_num")
  String needPowerNum;
  @JSONField(name: "user_power_num")
  String userPowerNum;
  @JSONField(name: "user_card_num")
  LotteryInfoDataUserCardNum userCardNum;
  @JSONField(name: "card_config")
  LotteryInfoDataCardConfig cardConfig;
  @JSONField(name: "prize_list")
  List<LotteryInfoDataPrizeList> prizeList;
}

class LotteryInfoDataUserCardNum with JsonConvert<LotteryInfoDataUserCardNum> {
  @JSONField(name: "card_total")
  String cardTotal;
  @JSONField(name: "magic_num")
  String magicNum;
  @JSONField(name: "attack_num")
  String attackNum;
  @JSONField(name: "protect_num")
  String protectNum;
}

class LotteryInfoDataCardConfig with JsonConvert<LotteryInfoDataCardConfig> {
  @JSONField(name: "protect_num")
  String protectNum;
}

class LotteryInfoDataPrizeList with JsonConvert<LotteryInfoDataPrizeList> {
  String id;
  String num;
  String type;
  String prize;
}
