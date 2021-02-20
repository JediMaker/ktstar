import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';
import 'package:star/ktxxmodels/ktxx_home_goods_list_entity.dart';
import 'package:star/ktxxmodels/ktxx_home_icon_list_entity.dart';

class KeTaoFeaturedHomeEntity with JsonConvert<KeTaoFeaturedHomeEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  KeTaoFeaturedHomeData data;
}

class KeTaoFeaturedHomeData with JsonConvert<KeTaoFeaturedHomeData> {
  List<KeTaoFeaturedHomeIconListIconList> banner;
  @JSONField(name: "task_list")
  List<KeTaoFeaturedHomeDataTaskList> taskList;
  String links;
  @JSONField(name: "goods_list")
  List<KeTaoFeaturedHomeGoodsListGoodsList> goodsList;
  @JSONField(name: "icon_list")
  List<KeTaoFeaturedHomeIconListIconList> iconList;
  @JSONField(name: "ad_list")
  List<KeTaoFeaturedHomeIconListIconList> adList;
  @JSONField(name: "user_level")
  String userLevel;
}

class KeTaoFeaturedHomeDataBanner with JsonConvert<KeTaoFeaturedHomeDataBanner> {
  String id;
  @JSONField(name: "img_path")
  String imgPath;
  dynamic uri;
}

class KeTaoFeaturedHomeDataTaskList with JsonConvert<KeTaoFeaturedHomeDataTaskList> {
  @JSONField(name: "data")
  List<KeTaoFeaturedHomeDataTaskListList> xList;
  @JSONField(name: "task_total")
  String taskTotal;
  @JSONField(name: "use_task_total")
  String useTaskTotal;
  String name;
}

class KeTaoFeaturedHomeDataTaskListList with JsonConvert<KeTaoFeaturedHomeDataTaskListList> {
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
