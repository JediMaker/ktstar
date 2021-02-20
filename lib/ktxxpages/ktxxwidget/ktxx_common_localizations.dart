import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
///语言(主要解决cupertino控件不能显示中文的问题)
class KeTaoFeaturedCommonLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const KeTaoFeaturedCommonLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      <String>['zh', 'CN'].contains(locale.languageCode);

  @override
  SynchronousFuture<_DefaultCupertinoLocalizations> load(Locale locale) {
    return SynchronousFuture<_DefaultCupertinoLocalizations>(
        _DefaultCupertinoLocalizations(locale.languageCode));
  }
//    Container(
//height: 6.0,
//width: 6.0,
//decoration: BoxDecoration(
//color: furnitureCateDisableColor,
//shape: BoxShape.circle,
//),
//),
//SizedBox(
//width: 5.0,
//),
//Container(
//height: 5.0,
//width: 20.0,
//decoration: BoxDecoration(
//color: Colors.blue[700],
//borderRadius: BorderRadius.circular(10.0)),
//),
  @override
  bool shouldReload(KeTaoFeaturedCommonLocalizationsDelegate old) => false;
}

class _DefaultCupertinoLocalizations extends CupertinoLocalizations {
  _DefaultCupertinoLocalizations(this._languageCode)
      : assert(_languageCode != null);
  final String _languageCode;

  static const List<String> _shortWeekdays = <String>[
    '周一',
    '周二',
    '周三',
    '周四',
    '周五',
    '周六',
    '周日',
  ];
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;
  static const List<String> _shortMonths = <String>[
    '一月',
    '二月',
    '三月',
    '四月',
    '五月',
    '六月',
    '七月',
    '八月',
    '九月',
    '十月',
    '十一月',
    '十二月',
  ];

  static const List<String> _months = <String>[
    '一月',
    '二月',
    '三月',
    '四月',
    '五月',
    '六月',
    '七月',
    '八月',
    '九月',
    '十月',
    '十一月',
    '十二月',
  ];

  @override
  String get alertDialogLabel => '提醒';

  @override
  String get anteMeridiemAbbreviation => "上午";

  @override
  String get postMeridiemAbbreviation => "下午";

  @override
  String get copyButtonLabel => "复制";

  @override
  String get cutButtonLabel => "剪切";

  @override
  String get pasteButtonLabel => "粘贴";

  @override
  String get selectAllButtonLabel => "全选";

  @override
  DatePickerDateOrder get datePickerDateOrder => DatePickerDateOrder.ymd;

  @override
  DatePickerDateTimeOrder get datePickerDateTimeOrder =>
      DatePickerDateTimeOrder.date_time_dayPeriod;

  @override
  String datePickerDayOfMonth(int dayIndex) => dayIndex.toString();

  @override
  String datePickerHour(int hour) => hour.toString();

  @override
  String datePickerHourSemanticsLabel(int hour) => hour.toString();

  @override
  String datePickerMediumDate(DateTime date) {
    return '${_shortWeekdays[date.weekday - DateTime.monday]} '
        '${_shortMonths[date.month - DateTime.january]} '
        '${date.day.toString().padRight(2)}';
  }

  @override
  String datePickerMinute(int minute) => minute.toString().padLeft(2, '0');

  @override
  String datePickerMinuteSemanticsLabel(int minute) {
    if (minute == 1) return '1 分钟';
    return minute.toString() + ' 分钟';
  }

  @override
  String datePickerMonth(int monthIndex) => _months[monthIndex - 1];

  @override
  String datePickerYear(int yearIndex) => yearIndex.toString();

  @override
  String timerPickerHour(int hour) => hour.toString();

  @override
  String timerPickerHourLabel(int hour) => '时';

  @override
  String timerPickerMinute(int minute) => minute.toString();

  @override
  String timerPickerMinuteLabel(int minute) => '分';

  @override
  String timerPickerSecond(int second) => second.toString();

  @override
  String timerPickerSecondLabel(int second) => '秒';

  @override
  // TODO: implement todayLabel
  String get todayLabel => '今天';

  @override
  // TODO: implement modalBarrierDismissLabel
  String get modalBarrierDismissLabel => '取消';

  @override
  String tabSemanticsLabel({int tabIndex, int tabCount}) {
    // TODO: implement tabSemanticsLabel
    assert(tabIndex >= 1);
    assert(tabCount >= 1);
    return 'Tab $tabIndex of $tabCount';
  }
}
