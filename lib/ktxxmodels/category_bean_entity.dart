import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class CategoryBeanEntity with JsonConvert<CategoryBeanEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  String errMsg;
  List<CategoryBeanData> data;
}

class CategoryBeanData with JsonConvert<CategoryBeanData> {
  @JSONField(name: "category_id")
  String categoryId;
  String id;
  @JSONField(name: "img_id")
  String imgId;
  String level;
  String pid;
  @JSONField(name: "create_time")
  String createTime;
  String status;
  @JSONField(name: "sort_no")
  String sortNo;
  @JSONField(name: "img_url")
  String imgUrl;
	String name;
	List<CategoryBeanData> children;
  @JSONField(name: "language_id")
  String languageId;
  String description;
  @JSONField(name: "meta_title")
  String metaTitle;
  @JSONField(name: "meta_description")
  String metaDescription;
  @JSONField(name: "meta_keyword")
  String metaKeyword;
  @JSONField(name: "store_id")
  String storeId;
}
