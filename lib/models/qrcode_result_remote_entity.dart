import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class QrcodeResultRemoteEntity with JsonConvert<QrcodeResultRemoteEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  QrcodeResultRemoteData data;
}

class QrcodeResultRemoteData with JsonConvert<QrcodeResultRemoteData> {
  @JSONField(name: "store_id")
  String storeId;
  String code;
  String name;
}
