import 'package:star/models/wechat_payinfo_entity.dart';

wechatPayinfoEntityFromJson(WechatPayinfoEntity data, Map<String, dynamic> json) {
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
			data.data = new WechatPayinfoData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> wechatPayinfoEntityToJson(WechatPayinfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

wechatPayinfoDataFromJson(WechatPayinfoData data, Map<String, dynamic> json) {
	if (json['pay_no'] != null) {
		data.payNo = json['pay_no']?.toString();
	}
	if (json['pay_info'] != null) {
		data.payInfo = new WechatPayinfoDataPayInfo().fromJson(json['pay_info']);
	}
	if (json['finish'] != null) {
		data.finish = json['finish'];
	}
	return data;
}

Map<String, dynamic> wechatPayinfoDataToJson(WechatPayinfoData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['pay_no'] = entity.payNo;
	if (entity.payInfo != null) {
		data['pay_info'] = entity.payInfo.toJson();
	}
	data['finish'] = entity.finish;
	return data;
}

wechatPayinfoDataPayInfoFromJson(WechatPayinfoDataPayInfo data, Map<String, dynamic> json) {
	if (json['appid'] != null) {
		data.appid = json['appid']?.toString();
	}
	if (json['noncestr'] != null) {
		data.noncestr = json['noncestr']?.toString();
	}
	if (json['package'] != null) {
		data.package = json['package']?.toString();
	}
	if (json['partnerid'] != null) {
		data.partnerid = json['partnerid']?.toString();
	}
	if (json['prepayid'] != null) {
		data.prepayid = json['prepayid']?.toString();
	}
	if (json['timestamp'] != null) {
		try {
			data.timestamp = json['timestamp']?.toInt();
		} catch (e) {
		}
	}
	if (json['sign'] != null) {
		data.sign = json['sign']?.toString();
	}
	return data;
}

Map<String, dynamic> wechatPayinfoDataPayInfoToJson(WechatPayinfoDataPayInfo entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['appid'] = entity.appid;
	data['noncestr'] = entity.noncestr;
	data['package'] = entity.package;
	data['partnerid'] = entity.partnerid;
	data['prepayid'] = entity.prepayid;
	data['timestamp'] = entity.timestamp;
	data['sign'] = entity.sign;
	return data;
}