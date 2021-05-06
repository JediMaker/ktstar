import 'package:star/models/notice_entity.dart';

noticeEntityFromJson(NoticeEntity data, Map<String, dynamic> json) {
  if (json['notice_msg'] != null) {
    data.noticeMsg = new NoticeNoticeMsg().fromJson(json['notice_msg']);
  }
  return data;
}

Map<String, dynamic> noticeEntityToJson(NoticeEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (entity.noticeMsg != null) {
    data['notice_msg'] = entity.noticeMsg.toJson();
  }
  return data;
}

noticeNoticeMsgFromJson(NoticeNoticeMsg data, Map<String, dynamic> json) {
  if (json['status'] != null) {
    data.status = json['status'];
  }
  if (json['title'] != null) {
    data.title = json['title']?.toString();
  }
  if (json['content'] != null) {
    data.content = json['content']?.toString();
  }
  return data;
}

Map<String, dynamic> noticeNoticeMsgToJson(NoticeNoticeMsg entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['title'] = entity.title;
  data['content'] = entity.content;
  return data;
}
