import 'package:star/models/message_list_entity.dart';

messageListEntityFromJson(MessageListEntity data, Map<String, dynamic> json) {
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
		data.data = new MessageListData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> messageListEntityToJson(MessageListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

messageListDataFromJson(MessageListData data, Map<String, dynamic> json) {
	if (json['list'] != null) {
		data.xList = new List<MessageListDataList>();
		(json['list'] as List).forEach((v) {
			data.xList.add(new MessageListDataList().fromJson(v));
		});
	}
	if (json['page'] != null) {
		data.page = json['page']?.toInt();
	}
	if (json['page_size'] != null) {
		data.pageSize = json['page_size']?.toInt();
	}
	return data;
}

Map<String, dynamic> messageListDataToJson(MessageListData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.xList != null) {
		data['list'] =  entity.xList.map((v) => v.toJson()).toList();
	}
	data['page'] = entity.page;
	data['page_size'] = entity.pageSize;
	return data;
}

messageListDataListFromJson(MessageListDataList data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['title'] != null) {
		data.title = json['title']?.toString();
	}
	if (json['desc'] != null) {
		data.desc = json['desc']?.toString();
	}
	if (json['notice_time'] != null) {
		data.noticeTime = json['notice_time']?.toString();
	}
	if (json['type'] != null) {
		data.type = json['type']?.toString();
	}
	if (json['read_status'] != null) {
		data.readStatus = json['read_status']?.toString();
	}
	return data;
}

Map<String, dynamic> messageListDataListToJson(MessageListDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['title'] = entity.title;
	data['desc'] = entity.desc;
	data['notice_time'] = entity.noticeTime;
	data['type'] = entity.type;
	data['read_status'] = entity.readStatus;
	return data;
}