import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class GasolinInfoEntity with JsonConvert<GasolinInfoEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  GasolinInfoData data;
}

class GasolinInfoData with JsonConvert<GasolinInfoData> {
  GasolinInfoDataInfo info;
}

class GasolinInfoDataInfo with JsonConvert<GasolinInfoDataInfo> {
  String money;
  @JSONField(name: "face_money")
  String faceMoney;
  String coin;
}
