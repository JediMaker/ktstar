import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedGoodsQueueEntity with JsonConvert<KeTaoFeaturedGoodsQueueEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  KeTaoFeaturedGoodsQueueData data;
}

class KeTaoFeaturedGoodsQueueData with JsonConvert<KeTaoFeaturedGoodsQueueData> {
  @JSONField(name: "list")
  List<KeTaoFeaturedGoodsQueueDataList> xList;
  @JSONField(name: "user_info")
  KeTaoFeaturedGoodsQueueDataUserInfo userInfo;
  @JSONField(name: "goods_info")
  KeTaoFeaturedGoodsQueueDataGoodsInfo goodsInfo;
  @JSONField(name: "signPackage")
  KeTaoFeaturedGoodsQueueDataSignPackage signPackage;
}

class KeTaoFeaturedGoodsQueueDataSignPackage with JsonConvert<KeTaoFeaturedGoodsQueueDataSignPackage> {
  String url;
}

class KeTaoFeaturedGoodsQueueDataGoodsInfo with JsonConvert<KeTaoFeaturedGoodsQueueDataGoodsInfo> {
  @JSONField(name: "g_name")
  String gName;
  @JSONField(name: "g_desc")
  String gDesc;
  @JSONField(name: "g_img")
  String gImg;
}

class KeTaoFeaturedGoodsQueueDataList with JsonConvert<KeTaoFeaturedGoodsQueueDataList> {
  String username;
  String avatar;
  @JSONField(name: "create_time")
  String createTime;
  @JSONField(name: "power_num")
  String powerNum;
  int rank;
  @JSONField(name: "is_my")
  bool isMy;
}

class KeTaoFeaturedGoodsQueueDataUserInfo with JsonConvert<KeTaoFeaturedGoodsQueueDataUserInfo> {
  String username;
  String avatar;
  @JSONField(name: "power_num")
  String powerNum;
  @JSONField(name: "goods_rank")
  int goodsRank;
  @JSONField(name: "my_status")
  bool myStatus;
}
