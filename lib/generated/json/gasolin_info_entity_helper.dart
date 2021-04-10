import 'package:star/models/gasolin_info_entity.dart';

gasolinInfoEntityFromJson(GasolinInfoEntity data, Map<String, dynamic> json) {
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
    data.data = new GasolinInfoData().fromJson(json['data']);
  }
  return data;
}

Map<String, dynamic> gasolinInfoEntityToJson(GasolinInfoEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  return data;
}

gasolinInfoDataFromJson(GasolinInfoData data, Map<String, dynamic> json) {
  if (json['info'] != null) {
    data.info = new GasolinInfoDataInfo().fromJson(json['info']);
  }
  return data;
}

Map<String, dynamic> gasolinInfoDataToJson(GasolinInfoData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (entity.info != null) {
    data['info'] = entity.info.toJson();
  }
  return data;
}

gasolinInfoDataInfoFromJson(
    GasolinInfoDataInfo data, Map<String, dynamic> json) {
  if (json['money'] != null) {
    data.money = json['money']?.toString();
  }
  if (json['face_money'] != null) {
    data.faceMoney = json['face_money']?.toString();
  }
  if (json['coin'] != null) {
    data.coin = json['coin']?.toString();
  }
  return data;
}

Map<String, dynamic> gasolinInfoDataInfoToJson(GasolinInfoDataInfo entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['money'] = entity.money;
  data['face_money'] = entity.faceMoney;
  data['coin'] = entity.coin;
  return data;
}
