import 'package:star/models/fans_total_entity.dart';

fansTotalEntityFromJson(FansTotalEntity data, Map<String, dynamic> json) {
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
			data.data = new FansTotalData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> fansTotalEntityToJson(FansTotalEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

fansTotalDataFromJson(FansTotalData data, Map<String, dynamic> json) {
	if (json['agent_info'] != null) {
		data.agentInfo = new FansTotalDataAgentInfo().fromJson(json['agent_info']);
	}
	if (json['count_info'] != null) {
		data.countInfo = new FansTotalDataCountInfo().fromJson(json['count_info']);
	}
	return data;
}

Map<String, dynamic> fansTotalDataToJson(FansTotalData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.agentInfo != null) {
		data['agent_info'] = entity.agentInfo.toJson();
	}
	if (entity.countInfo != null) {
		data['count_info'] = entity.countInfo.toJson();
	}
	return data;
}

fansTotalDataAgentInfoFromJson(FansTotalDataAgentInfo data, Map<String, dynamic> json) {
	if (json['avatar'] != null) {
		data.avatar = json['avatar']?.toString();
	}
	if (json['username'] != null) {
		data.username = json['username']?.toString();
	}
	if (json['tel'] != null) {
		data.tel = json['tel']?.toString();
	}
	if (json['wx_no'] != null) {
		data.wxNo = json['wx_no']?.toString();
	}
	return data;
}

Map<String, dynamic> fansTotalDataAgentInfoToJson(FansTotalDataAgentInfo entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['avatar'] = entity.avatar;
	data['username'] = entity.username;
	data['tel'] = entity.tel;
	data['wx_no'] = entity.wxNo;
	return data;
}

fansTotalDataCountInfoFromJson(FansTotalDataCountInfo data, Map<String, dynamic> json) {
	if (json['total'] != null) {
		data.total = json['total']?.toInt();
	}
	if (json['vip'] != null) {
		data.vip = json['vip']?.toInt();
	}
	if (json['experience'] != null) {
		data.experience = json['experience']?.toInt();
	}
	if (json['ordinary'] != null) {
		data.ordinary = json['ordinary']?.toInt();
	}
	if (json['diamond'] != null) {
		data.diamond = json['diamond']?.toInt();
	}
	return data;
}

Map<String, dynamic> fansTotalDataCountInfoToJson(FansTotalDataCountInfo entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['total'] = entity.total;
	data['vip'] = entity.vip;
	data['experience'] = entity.experience;
	data['ordinary'] = entity.ordinary;
	data['diamond'] = entity.diamond;
	return data;
}