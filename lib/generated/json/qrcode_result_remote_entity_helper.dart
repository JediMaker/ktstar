import 'package:star/models/qrcode_result_remote_entity.dart';

qrcodeResultRemoteEntityFromJson(
    QrcodeResultRemoteEntity data, Map<String, dynamic> json) {
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
    try {
      data.data = new QrcodeResultRemoteData().fromJson(json['data']);
    } catch (e) {
    }
  }
  return data;
}

Map<String, dynamic> qrcodeResultRemoteEntityToJson(
    QrcodeResultRemoteEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  return data;
}

qrcodeResultRemoteDataFromJson(
    QrcodeResultRemoteData data, Map<String, dynamic> json) {
  if (json['store_id'] != null) {
    data.storeId = json['store_id']?.toString();
  }
  if (json['code'] != null) {
    data.code = json['code']?.toString();
  }
  if (json['name'] != null) {
    data.name = json['name']?.toString();
  }
  return data;
}

Map<String, dynamic> qrcodeResultRemoteDataToJson(
    QrcodeResultRemoteData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['store_id'] = entity.storeId;
  data['code'] = entity.code;
  data['name'] = entity.name;
  return data;
}
