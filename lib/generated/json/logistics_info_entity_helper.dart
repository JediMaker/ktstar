import 'package:star/ktxxmodels/logistics_info_entity.dart';

logisticsInfoEntityFromJson(LogisticsInfoEntity data, Map<String, dynamic> json) {
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
			data.data = new LogisticsInfoData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> logisticsInfoEntityToJson(LogisticsInfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

logisticsInfoDataFromJson(LogisticsInfoData data, Map<String, dynamic> json) {
	if (json['express_list'] != null) {
		data.expressList = new List<LogisticsInfoDataExpressList>();
		(json['express_list'] as List).forEach((v) {
			data.expressList.add(new LogisticsInfoDataExpressList().fromJson(v));
		});
	}
	if (json['express_info'] != null) {
		data.expressInfo = new LogisticsInfoDataExpressInfo().fromJson(json['express_info']);
	}
	return data;
}

Map<String, dynamic> logisticsInfoDataToJson(LogisticsInfoData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.expressList != null) {
		data['express_list'] =  entity.expressList.map((v) => v.toJson()).toList();
	}
	if (entity.expressInfo != null) {
		data['express_info'] = entity.expressInfo.toJson();
	}
	return data;
}

logisticsInfoDataExpressListFromJson(LogisticsInfoDataExpressList data, Map<String, dynamic> json) {
	if (json['title'] != null) {
		data.title = json['title']?.toString();
	}
	if (json['type'] != null) {
		try {
			data.type = json['type']?.toInt();
		} catch (e) {
		}
	}
	if (json['time'] != null) {
		data.time = json['time']?.toString();
	}
	if (json['desc'] != null) {
		data.desc = json['desc']?.toString();
	}
	if (json['list'] != null) {
		data.xList = new List<LogisticsInfoDataExpressListList>();
		(json['list'] as List).forEach((v) {
			data.xList.add(new LogisticsInfoDataExpressListList().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> logisticsInfoDataExpressListToJson(LogisticsInfoDataExpressList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['title'] = entity.title;
	data['type'] = entity.type;
	data['time'] = entity.time;
	data['desc'] = entity.desc;
	if (entity.xList != null) {
		data['list'] =  entity.xList.map((v) => v.toJson()).toList();
	}
	return data;
}

logisticsInfoDataExpressListListFromJson(LogisticsInfoDataExpressListList data, Map<String, dynamic> json) {
	if (json['time'] != null) {
		data.time = json['time']?.toString();
	}
	if (json['subdesc'] != null) {
		data.subdesc = json['subdesc']?.toString();
	}
	return data;
}

Map<String, dynamic> logisticsInfoDataExpressListListToJson(LogisticsInfoDataExpressListList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['time'] = entity.time;
	data['subdesc'] = entity.subdesc;
	return data;
}

logisticsInfoDataExpressInfoFromJson(LogisticsInfoDataExpressInfo data, Map<String, dynamic> json) {
	if (json['number'] != null) {
		data.number = json['number']?.toString();
	}
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	if (json['tel'] != null) {
		data.tel = json['tel']?.toString();
	}
	return data;
}

Map<String, dynamic> logisticsInfoDataExpressInfoToJson(LogisticsInfoDataExpressInfo entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['number'] = entity.number;
	data['name'] = entity.name;
	data['tel'] = entity.tel;
	return data;
}