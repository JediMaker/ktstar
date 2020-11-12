import 'package:star/models/address_info_entity.dart';

addressInfoEntityFromJson(AddressInfoEntity data, Map<String, dynamic> json) {
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
			data.data = new AddressInfoData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> addressInfoEntityToJson(AddressInfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

addressInfoDataFromJson(AddressInfoData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['consignee'] != null) {
		data.consignee = json['consignee']?.toString();
	}
	if (json['mobile'] != null) {
		data.mobile = json['mobile']?.toString();
	}
	if (json['province_id'] != null) {
		data.provinceId = json['province_id']?.toString();
	}
	if (json['province'] != null) {
		data.province = json['province']?.toString();
	}
	if (json['city_id'] != null) {
		data.cityId = json['city_id']?.toString();
	}
	if (json['city'] != null) {
		data.city = json['city']?.toString();
	}
	if (json['county_id'] != null) {
		data.countyId = json['county_id']?.toString();
	}
	if (json['county'] != null) {
		data.county = json['county']?.toString();
	}
	if (json['address'] != null) {
		data.address = json['address']?.toString();
	}
	if (json['is_default'] != null) {
		data.isDefault = json['is_default']?.toString();
	}
	return data;
}

Map<String, dynamic> addressInfoDataToJson(AddressInfoData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['consignee'] = entity.consignee;
	data['mobile'] = entity.mobile;
	data['province_id'] = entity.provinceId;
	data['province'] = entity.province;
	data['city_id'] = entity.cityId;
	data['city'] = entity.city;
	data['county_id'] = entity.countyId;
	data['county'] = entity.county;
	data['address'] = entity.address;
	data['is_default'] = entity.isDefault;
	return data;
}