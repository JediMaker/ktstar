import 'package:star/ktxxmodels/ktxx_home_pdd_category_entity.dart';

homePddCategoryEntityFromJson(
    HomePddCategoryEntity data, Map<String, dynamic> json) {
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
    data.data = new HomePddCategoryData().fromJson(json['data']);
  }
  return data;
}

Map<String, dynamic> homePddCategoryEntityToJson(HomePddCategoryEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  return data;
}

homePddCategoryDataFromJson(
    HomePddCategoryData data, Map<String, dynamic> json) {
  if (json['cats'] != null) {
    data.cats = new List<HomePddCategoryDataCat>();
    (json['cats'] as List).forEach((v) {
      data.cats.add(new HomePddCategoryDataCat().fromJson(v));
    });
  }
  return data;
}

Map<String, dynamic> homePddCategoryDataToJson(HomePddCategoryData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (entity.cats != null) {
    data['cats'] = entity.cats.map((v) => v.toJson()).toList();
  }
  return data;
}

homePddCategoryDataCatFromJson(
    HomePddCategoryDataCat data, Map<String, dynamic> json) {
  if (json['cat_id'] != null) {
    data.catId = json['cat_id']?.toInt();
  }
  if (json['cat_name'] != null) {
    data.catName = json['cat_name']?.toString();
  }
  if (json['subtitle'] != null) {
    data.subtitle = json['subtitle']?.toString();
  }
  if (json['type'] != null) {
    data.type = json['type']?.toString();
  }
  return data;
}

Map<String, dynamic> homePddCategoryDataCatToJson(
    HomePddCategoryDataCat entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['cat_id'] = entity.catId;
  data['cat_name'] = entity.catName;
  data['subtitle'] = entity.subtitle;
  data['type'] = entity.type;
  return data;
}
