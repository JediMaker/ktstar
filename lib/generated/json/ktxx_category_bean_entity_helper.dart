import 'package:star/ktxxmodels/ktxx_category_bean_entity.dart';

categoryBeanEntityFromJson(CategoryBeanEntity data, Map<String, dynamic> json) {
  if (json['status'] != null) {
    data.status = json['status'];
  }
  if (json['err_code'] != null) {
    data.errCode = json['err_code']?.toInt();
  }
  if (json['err_msg'] != null) {
    data.errMsg = json['err_msg']?.toString();
  }
  if (json['data'] != null) {
    data.data = new List<CategoryBeanData>();
    (json['data'] as List).forEach((v) {
      data.data.add(new CategoryBeanData().fromJson(v));
    });
  }
  return data;
}

Map<String, dynamic> categoryBeanEntityToJson(CategoryBeanEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.map((v) => v.toJson()).toList();
  }
  return data;
}

categoryBeanDataFromJson(
    CategoryBeanData data, Map<String, dynamic> json) {
  if (json['category_id'] != null) {
    data.categoryId = json['category_id']?.toString();
  }
  if (json['id'] != null) {
    data.id = json['id']?.toString();
  }
  if (json['img_id'] != null) {
    data.imgId = json['img_id']?.toString();
  }
  if (json['level'] != null) {
    data.level = json['level']?.toString();
  }
  if (json['pid'] != null) {
    data.pid = json['pid']?.toString();
  }
  if (json['create_time'] != null) {
    data.createTime = json['create_time']?.toString();
  }
  if (json['status'] != null) {
    data.status = json['status']?.toString();
  }
  if (json['sort_no'] != null) {
    data.sortNo = json['sort_no']?.toString();
  }
  if (json['img_url'] != null) {
    data.imgUrl = json['img_url']?.toString();
  }
  if (json['name'] != null) {
    data.name = json['name']?.toString();
  }
  if (json['children'] != null) {
    data.children = new List<CategoryBeanData>();
    (json['children'] as List).forEach((v) {
      data.children.add(new CategoryBeanData().fromJson(v));
    });
  }
  if (json['language_id'] != null) {
    data.languageId = json['language_id']?.toString();
  }
  if (json['description'] != null) {
    data.description = json['description']?.toString();
  }
  if (json['meta_title'] != null) {
    data.metaTitle = json['meta_title']?.toString();
  }
  if (json['meta_description'] != null) {
    data.metaDescription = json['meta_description']?.toString();
  }
  if (json['meta_keyword'] != null) {
    data.metaKeyword = json['meta_keyword']?.toString();
  }
  if (json['store_id'] != null) {
    data.storeId = json['store_id']?.toString();
  }
  return data;
}

Map<String, dynamic> categoryBeanDataToJson(
    CategoryBeanData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['category_id'] = entity.categoryId;
  data['id'] = entity.id;
  data['img_id'] = entity.imgId;
  data['level'] = entity.level;
  data['pid'] = entity.pid;
  data['create_time'] = entity.createTime;
  data['status'] = entity.status;
  data['sort_no'] = entity.sortNo;
  data['img_url'] = entity.imgUrl;
  data['name'] = entity.name;
  if (entity.children != null) {
    data['children'] = entity.children.map((v) => v.toJson()).toList();
  }
  data['language_id'] = entity.languageId;
  data['description'] = entity.description;
  data['meta_title'] = entity.metaTitle;
  data['meta_description'] = entity.metaDescription;
  data['meta_keyword'] = entity.metaKeyword;
  data['store_id'] = entity.storeId;
  return data;
}
