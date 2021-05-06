import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';

class NoticeEntity with JsonConvert<NoticeEntity> {
  @JSONField(name: "notice_msg")
  NoticeNoticeMsg noticeMsg;
}

class NoticeNoticeMsg with JsonConvert<NoticeNoticeMsg> {
  bool status;
  String title;
  String content;
}
