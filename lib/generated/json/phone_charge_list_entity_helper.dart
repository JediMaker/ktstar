import 'package:star/models/phone_charge_list_entity.dart';

phoneChargeListEntityFromJson(PhoneChargeListEntity data, Map<String, dynamic> json) {
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
		data.data = new PhoneChargeListData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> phoneChargeListEntityToJson(PhoneChargeListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

phoneChargeListDataFromJson(PhoneChargeListData data, Map<String, dynamic> json) {
	if (json['list'] != null) {
		data.xList = new List<PhoneChargeListDataList>();
		(json['list'] as List).forEach((v) {
			data.xList.add(new PhoneChargeListDataList().fromJson(v));
		});
	}
	if (json['page'] != null) {
		data.page = json['page']?.toInt();
	}
	if (json['page_size'] != null) {
		data.pageSize = json['page_size']?.toInt();
	}
	if (json['phone'] != null) {
		data.phone = json['phone']?.toString();
	}
	return data;
}

Map<String, dynamic> phoneChargeListDataToJson(PhoneChargeListData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.xList != null) {
		data['list'] =  entity.xList.map((v) => v.toJson()).toList();
	}
	data['page'] = entity.page;
	data['page_size'] = entity.pageSize;
	data['phone'] = entity.phone;
	return data;
}

phoneChargeListDataListFromJson(PhoneChargeListDataList data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['face_money'] != null) {
		data.faceMoney = json['face_money']?.toString();
	}
	if (json['pay_money'] != null) {
		data.payMoney = json['pay_money']?.toString();
	}
	if (json['title'] != null) {
		data.title = json['title']?.toString();
	}
	if (json['order_no'] != null) {
		data.orderNo = json['order_no']?.toString();
	}
	if (json['phone'] != null) {
		data.phone = json['phone']?.toString();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	if (json['cz_time'] != null) {
		data.czTime = json['cz_time']?.toString();
	}
	if (json['arrive_time'] != null) {
		data.arriveTime = json['arrive_time']?.toString();
	}
	if (json['use_money'] != null) {
		data.useMoney = json['use_money']?.toString();
	}
	if (json['type'] != null) {
		data.type = json['type']?.toInt();
	}
	return data;
}

Map<String, dynamic> phoneChargeListDataListToJson(PhoneChargeListDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['face_money'] = entity.faceMoney;
	data['pay_money'] = entity.payMoney;
	data['title'] = entity.title;
	data['order_no'] = entity.orderNo;
	data['phone'] = entity.phone;
	data['status'] = entity.status;
	data['cz_time'] = entity.czTime;
	data['arrive_time'] = entity.arriveTime;
	data['use_money'] = entity.useMoney;
	data['type'] = entity.type;
	return data;
}