import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class HomePddCategoryEntity with JsonConvert<HomePddCategoryEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  HomePddCategoryData data;
}

class HomePddCategoryData with JsonConvert<HomePddCategoryData> {
  List<HomePddCategoryDataCat> cats;
}

class HomePddCategoryDataCat with JsonConvert<HomePddCategoryDataCat> {
  @JSONField(name: "cat_id")
  int catId;
  @JSONField(name: "cat_name")
  String catName;
  String subtitle;
  String type;
}
