import 'package:star/models/address_list_entity.dart';

addressListEntityFromJson(AddressListEntity data, Map<String, dynamic> json) {
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
		data.data = new List<AddressListData>();
		(json['data'] as List).forEach((v) {
			try {
				data.data.add(new AddressListData().fromJson(v));
			} catch (e) {
			}
		});
	}
	return data;
}

Map<String, dynamic> addressListEntityToJson(AddressListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	return data;
}

addressListDataFromJson(AddressListData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['consignee'] != null) {
		data.consignee = json['consignee']?.toString();
	}
	if (json['mobile'] != null) {
		data.mobile = json['mobile']?.toString();
	}
	if (json['address'] != null) {
		data.address = json['address']?.toString();
	}
	if (json['is_default'] != null) {
		data.isDefault = json['is_default']?.toString();
	}
	return data;
}

Map<String, dynamic> addressListDataToJson(AddressListData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['consignee'] = entity.consignee;
	data['mobile'] = entity.mobile;
	data['address'] = entity.address;
	data['is_default'] = entity.isDefault;
	return data;
}