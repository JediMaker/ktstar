import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class WithdrawalUserInfoEntity with JsonConvert<WithdrawalUserInfoEntity> {
	bool status;
	@JSONField(name: "err_code")
	int errCode;
	@JSONField(name: "err_msg")
	dynamic errMsg;
	WithdrawalUserInfoData data;
}

class WithdrawalUserInfoData with JsonConvert<WithdrawalUserInfoData> {
	WithdrawalUserInfoDataUser user;
	@JSONField(name: "start_flag")
	bool startFlag;
	@JSONField(name: "last_date")
	String lastDate;
}

class WithdrawalUserInfoDataUser with JsonConvert<WithdrawalUserInfoDataUser> {
	@JSONField(name: "zfb_account")
	String zfbAccount;
	@JSONField(name: "zfb_name")
	String zfbName;
	String price;
}
