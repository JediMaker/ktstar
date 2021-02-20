import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedPhoneChargeListEntity with JsonConvert<KeTaoFeaturedPhoneChargeListEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	KeTaoFeaturedPhoneChargeListData data;
}

class KeTaoFeaturedPhoneChargeListData with JsonConvert<KeTaoFeaturedPhoneChargeListData> {
	@JSONField(name: "list")
	List<KeTaoFeaturedPhoneChargeListDataList> xList;
	int page;
	@JSONField(name: "page_size")
	int pageSize;
	String phone;
}

class KeTaoFeaturedPhoneChargeListDataList with JsonConvert<KeTaoFeaturedPhoneChargeListDataList> {
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
