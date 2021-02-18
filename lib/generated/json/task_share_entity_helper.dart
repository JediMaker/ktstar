import 'package:star/ktxxmodels/task_share_entity.dart';

taskShareEntityFromJson(TaskShareEntity data, Map<String, dynamic> json) {
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
			data.data = new TaskShareData().fromJson(json['data']);
		} catch (e) {
		}
	}
	return data;
}

Map<String, dynamic> taskShareEntityToJson(TaskShareEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['err_code'] = entity.errCode;
	data['err_msg'] = entity.errMsg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

taskShareDataFromJson(TaskShareData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['file_id'] != null) {
		data.fileId = json['file_id']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['title'] != null) {
		data.title = json['title']?.toString();
	}
	if (json['text'] != null) {
		data.text = json['text']?.toString();
	}
	if (json['comment_desc'] != null) {
		data.commentDesc = json['comment_desc']?.toString();
	}
	if (json['require_desc'] != null) {
		data.requireDesc = json['require_desc']?.toString();
	}
	if (json['username'] != null) {
		data.username = json['username']?.toString();
	}
	if (json['avatar'] != null) {
		data.avatar = json['avatar']?.toString();
	}
	if (json['share_info'] != null) {
		data.shareInfo = new TaskShareDataShareInfo().fromJson(json['share_info']);
	}
	if (json['footer_img'] != null) {
		data.footerImg = new TaskShareDataFooterImg().fromJson(json['footer_img']);
	}
	return data;
}

Map<String, dynamic> taskShareDataToJson(TaskShareData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['file_id'] = entity.fileId;
	data['title'] = entity.title;
	data['text'] = entity.text;
	data['comment_desc'] = entity.commentDesc;
	data['require_desc'] = entity.requireDesc;
	data['username'] = entity.username;
	data['avatar'] = entity.avatar;
	if (entity.shareInfo != null) {
		data['share_info'] = entity.shareInfo.toJson();
	}
	if (entity.footerImg != null) {
		data['footer_img'] = entity.footerImg.toJson();
	}
	return data;
}

taskShareDataShareInfoFromJson(TaskShareDataShareInfo data, Map<String, dynamic> json) {
	if (json['title'] != null) {
		data.title = json['title']?.toString();
	}
	if (json['icon'] != null) {
		data.icon = json['icon']?.toString();
	}
	if (json['link'] != null) {
		data.link = json['link']?.toString();
	}
	if (json['desc'] != null) {
		data.desc = json['desc']?.toString();
	}
	return data;
}

Map<String, dynamic> taskShareDataShareInfoToJson(TaskShareDataShareInfo entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['title'] = entity.title;
	data['icon'] = entity.icon;
	data['link'] = entity.link;
	data['desc'] = entity.desc;
	return data;
}

taskShareDataFooterImgFromJson(TaskShareDataFooterImg data, Map<String, dynamic> json) {
	if (json['image'] != null) {
		data.image = json['image']?.toString();
	}
	if (json['link'] != null) {
		data.link = json['link']?.toString();
	}
	return data;
}

Map<String, dynamic> taskShareDataFooterImgToJson(TaskShareDataFooterImg entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['image'] = entity.image;
	data['link'] = entity.link;
	return data;
}