import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class PhoneChargeListEntity with JsonConvert<PhoneChargeListEntity> {
  bool status;
  @JSONField(name: "err_code")
  int errCode;
  @JSONField(name: "err_msg")
  dynamic errMsg;
  PhoneChargeListData data;
}

class PhoneChargeListData
    with JsonConvert<PhoneChargeListData> {
  @JSONField(name: "list")
  List<PhoneChargeListDataList> xList;
  int page;
  @JSONField(name: "page_size")
  int pageSize;
  String phone;
}

class PhoneChargeListDataList
    with JsonConvert<PhoneChargeListDataList> {
  String id;
  @JSONField(name: "face_money")
  String faceMoney;
  @JSONField(name: "pay_money")
  String payMoney;
  String title;
  @JSONField(name: "order_no")
  String orderNo;
  String phone;
  String status;
  @JSONField(name: "cz_time")
  String czTime;
  @JSONField(name: "arrive_time")
  String arriveTime;
  @JSONField(name: "use_money")
  String useMoney;
  int type;
}
