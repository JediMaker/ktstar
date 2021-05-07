import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class LeaderBoardEntity with JsonConvert<LeaderBoardEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  LeaderBoardData data;
}

class LeaderBoardData with JsonConvert<LeaderBoardData> {
  List<LeaderBoardDataList> lists;
  @JSONField(name: "my_rank")
  LeaderBoardDataMyRank myRank;
  @JSONField(name: "rules_h5")
  String rulesH5;
}

class LeaderBoardDataList with JsonConvert<LeaderBoardDataList> {
  String username;
  String avatar;
  String count;
  String ranking;
  @JSONField(name: "cz_time")
  String czTime;
  String reward;
}

class LeaderBoardDataMyRank with JsonConvert<LeaderBoardDataMyRank> {
  String ranking;
  String username;
  String avatar;
  String count;
  String reward;
}
