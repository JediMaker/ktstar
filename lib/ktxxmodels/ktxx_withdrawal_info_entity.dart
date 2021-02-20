import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class KeTaoFeaturedWithdrawalInfoEntity with JsonConvert<KeTaoFeaturedWithdrawalInfoEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	KeTaoFeaturedWithdrawalInfoData data;
}

class KeTaoFeaturedWithdrawalInfoData with JsonConvert<KeTaoFeaturedWithdrawalInfoData> {
	KeTaoFeaturedWithdrawalInfoDataUser user;
	KeTaoFeaturedWithdrawalInfoDataUseModel useModel;
}

class KeTaoFeaturedWithdrawalInfoDataUser with JsonConvert<KeTaoFeaturedWithdrawalInfoDataUser> {
	@JSONField(name: "zfb_account")
	String zfbAccount;
	@JSONField(name: "zfb_name")
	String zfbName;
	String price;
}

class KeTaoFeaturedWithdrawalInfoDataUseModel with JsonConvert<KeTaoFeaturedWithdrawalInfoDataUseModel> {
	String price;
	@JSONField(name: "apply_price")
	String applyPrice;
	@JSONField(name: "service_fee")
	String serviceFee;
}
