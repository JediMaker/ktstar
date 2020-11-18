import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class WithdrawalInfoEntity with JsonConvert<WithdrawalInfoEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	WithdrawalInfoData data;
}

class WithdrawalInfoData with JsonConvert<WithdrawalInfoData> {
	WithdrawalInfoDataUser user;
	WithdrawalInfoDataUseModel useModel;
}

class WithdrawalInfoDataUser with JsonConvert<WithdrawalInfoDataUser> {
	@JSONField(name: "zfb_account")
	String zfbAccount;
	@JSONField(name: "zfb_name")
	String zfbName;
	String price;
}

class WithdrawalInfoDataUseModel with JsonConvert<WithdrawalInfoDataUseModel> {
	String price;
	@JSONField(name: "apply_price")
	String applyPrice;
	@JSONField(name: "service_fee")
	String serviceFee;
}
