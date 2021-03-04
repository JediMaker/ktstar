import 'package:star/ktxxmodels/ktxx_shareholder_income_list_entity.dart';
import 'package:star/ktxxmodels/ktxx_income_list_entity.dart';

shareholderIncomeListEntityFromJson(
    ShareholderIncomeListEntity data, Map<String, dynamic> json) {
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
    data.data = new List<IncomeListDataList>();
    (json['data'] as List).forEach((v) {
      data.data.add(new IncomeListDataList().fromJson(v));
    });
  }
  return data;
}

Map<String, dynamic> shareholderIncomeListEntityToJson(
    ShareholderIncomeListEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['err_code'] = entity.errCode;
  data['err_msg'] = entity.errMsg;
  if (entity.data != null) {
    data['data'] = entity.data.map((v) => v.toJson()).toList();
  }
  return data;
}
