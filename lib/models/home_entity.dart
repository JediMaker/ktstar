import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';
import 'package:star/models/home_goods_list_entity.dart';
import 'package:star/models/home_icon_list_entity.dart';
import 'package:star/models/notice_entity.dart';

class HomeEntity with JsonConvert<HomeEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  HomeData data;
}

class HomeData with JsonConvert<HomeData> {
  List<HomeIconListIconList> banner;
  @JSONField(name: "task_list")
  List<HomeDataTaskList> taskList;
  String links;
  @JSONField(name: "goods_list")
  List<HomeGoodsListGoodsList> goodsList;
  @JSONField(name: "icon_list")
  List<HomeIconListIconList> iconList;
  @JSONField(name: "ad_list")
  List<HomeIconListIconList> adList;
  @JSONField(name: "user_level")
  String userLevel;
  @JSONField(name: "notice_msg")
  NoticeNoticeMsg noticeMsg;
  @JSONField(name: "is_login")
  bool isLogin;
}

class HomeDataBanner with JsonConvert<HomeDataBanner> {
  String id;
  @JSONField(name: "img_path")
  String imgPath;
  dynamic uri;
}

class HomeDataTaskList with JsonConvert<HomeDataTaskList> {
  @JSONField(name: "data")
  List<HomeDataTaskListList> xList;
  @JSONField(name: "task_total")
  String taskTotal;
  @JSONField(name: "use_task_total")
  String useTaskTotal;
  String name;
}

class HomeDataTaskListList with JsonConvert<HomeDataTaskListList> {
  String id;
  @JSONField(name: "share_price")
  String sharePrice;
  String title;
  @JSONField(name: "task_status")
  int taskStatus;
  String icons;
  @JSONField(name: "status_desc")
  String statusDesc;
  String type;
  String subtitle;
  String num;
  String category;
  String ratio;
  @JSONField(name: "diamonds_ratio")
  String diamondsRatio;
  @JSONField(name: "is_higher")
  String isHigher;
  @JSONField(name: "is_new")
  String isNew;
  @JSONField(name: "last_simple_id")
  String lastSimpleId;
}
