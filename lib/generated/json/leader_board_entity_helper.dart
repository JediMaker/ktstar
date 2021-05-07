import 'package:star/models/leader_board_entity.dart';

leaderBoardEntityFromJson(LeaderBoardEntity data, Map<String, dynamic> json) {
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
    data.data = new LeaderBoardData().fromJson(json['data']);
  }
  return data;
}

Map<String, dynamic> leaderBoardEntityToJson(LeaderBoardEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  return data;
}

leaderBoardDataFromJson(LeaderBoardData data, Map<String, dynamic> json) {
  if (json['lists'] != null) {
    data.lists = new List<LeaderBoardDataList>();
    (json['lists'] as List).forEach((v) {
      data.lists.add(new LeaderBoardDataList().fromJson(v));
    });
  }
  if (json['my_rank'] != null) {
    data.myRank = new LeaderBoardDataMyRank().fromJson(json['my_rank']);
  }
  if (json['rules_h5'] != null) {
    data.rulesH5 = json['rules_h5']?.toString();
  }
  return data;
}

Map<String, dynamic> leaderBoardDataToJson(LeaderBoardData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (entity.lists != null) {
    data['lists'] = entity.lists.map((v) => v.toJson()).toList();
  }
  if (entity.myRank != null) {
    data['my_rank'] = entity.myRank.toJson();
  }
  data['rules_h5'] = entity.rulesH5;
  return data;
}

leaderBoardDataListFromJson(
    LeaderBoardDataList data, Map<String, dynamic> json) {
  if (json['username'] != null) {
    data.username = json['username']?.toString();
  }
  if (json['avatar'] != null) {
    data.avatar = json['avatar']?.toString();
  }
  if (json['count'] != null) {
    data.count = json['count']?.toString();
  }
  if (json['ranking'] != null) {
    data.ranking = json['ranking']?.toString();
  }
  if (json['cz_time'] != null) {
    data.czTime = json['cz_time']?.toString();
  }
  if (json['reward'] != null) {
    data.reward = json['reward']?.toString();
  }
  return data;
}

Map<String, dynamic> leaderBoardDataListToJson(LeaderBoardDataList entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['username'] = entity.username;
  data['avatar'] = entity.avatar;
  data['count'] = entity.count;
  data['ranking'] = entity.ranking;
  data['cz_time'] = entity.czTime;
  data['reward'] = entity.reward;
  return data;
}

leaderBoardDataMyRankFromJson(
    LeaderBoardDataMyRank data, Map<String, dynamic> json) {
  if (json['ranking'] != null) {
    data.ranking = json['ranking']?.toString();
  }
  if (json['username'] != null) {
    data.username = json['username']?.toString();
  }
  if (json['avatar'] != null) {
    data.avatar = json['avatar']?.toString();
  }
  if (json['count'] != null) {
    data.count = json['count']?.toString();
  }
  if (json['reward'] != null) {
    data.reward = json['reward']?.toString();
  }
  return data;
}

Map<String, dynamic> leaderBoardDataMyRankToJson(LeaderBoardDataMyRank entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['ranking'] = entity.ranking;
  data['username'] = entity.username;
  data['avatar'] = entity.avatar;
  data['count'] = entity.count;
  data['reward'] = entity.reward;
  return data;
}
