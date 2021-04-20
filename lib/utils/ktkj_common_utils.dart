import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:star/global_config.dart';
import 'package:star/pages/ktkj_widget/ktkj_notice_dialog.dart';
import 'package:star/pages/ktkj_widget/ktkj_update_dialog.dart';
import 'package:star/utils/ktkj_navigator_utils.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJCommonUtils {
  static final double MILLIS_LIMIT = 1000.0;

  static final double SECONDS_LIMIT = 60 * MILLIS_LIMIT;

  static final double MINUTES_LIMIT = 60 * SECONDS_LIMIT;

  static final double HOURS_LIMIT = 24 * MINUTES_LIMIT;

  static final double DAYS_LIMIT = 30 * HOURS_LIMIT;

  static Color string2Color(String colorString) {
    int value = 0x00000000;

    if (isNotEmpty(colorString)) {
      if (colorString[0] == '#') {
        colorString = colorString.substring(1);
      }
      value = int.tryParse(colorString, radix: 16);
      if (value != null) {
        if (value < 0xFF000000) {
          value += 0xFF000000;
        }
      }
    }
    return Color(value);
  }

  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  /// Returns true  String or List or Map is empty.
  static bool isEmpty(Object object) {
    if (object == null) return true;
    if (object is String && object.isEmpty) {
      return true;
    } else if (object is Iterable && object.isEmpty) {
      return true;
    } else if (object is Map && object.isEmpty) {
      return true;
    }
    return false;
  }

  static showToast(msg) {
    if (msg == "token已过期" || '您的账号已在其他设备上登录' == msg) {
      return;
    }
    Fluttertoast.showToast(
        msg: "$msg",
        backgroundColor: Colors.black38,
//        backgroundColor: Color(0XFF222222c2),
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM);
  }

  /// Returns true String or List or Map is not empty.
  static bool isNotEmpty(Object object) {
    return !isEmpty(object);
  }

  static Future imageToBase64(File file) async {
    List<int> imageBytes = await file.readAsBytes();
    print('图片大小:' + imageBytes.length.toString());
    return base64Encode(imageBytes);
  }

  static Future imageToBase64AndCompress(File file) async {
    List<int> imageBytes1 = await file.readAsBytes();
    print('图片大小:' + imageBytes1.length.toString());
    List<int> imageBytes = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        quality: 20);
    print('压缩图片大小:' + imageBytes.length.toString());
    return base64Encode(imageBytes);
  }

  static Map url2query(String url) {
    var search = new RegExp('([^&=]+)=?([^&]*)');
    var result = new Map();

    // Get rid off the beginning ? in query strings.
    if (url.startsWith('?')) url = url.substring(1);

    // A custom decoder.
    decode(String s) => Uri.decodeComponent(s.replaceAll('+', ' '));

    // Go through all the matches and build the result map.
    for (Match match in search.allMatches(url)) {
      result[decode(match.group(1))] = decode(match.group(2));
    }

    return result;
  }

  static Color randomColor() {
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
        .withOpacity(1.0);
  }

  static String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  ///获取当前时间戳
  static String currentTimeMillis() {
    return new DateTime.now().millisecondsSinceEpoch.toString();
  }

  static String getDateStr(DateTime date) {
    if (date == null || date.toString() == null) {
      return "";
    } else if (date.toString().length < 10) {
      return date.toString();
    }
    return date.toString().substring(0, 10);
  }

  static String getNewsTimeStr(DateTime date) {
    int subTime =
        DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;

    if (subTime < MILLIS_LIMIT) {
      return "刚刚";
    } else if (subTime < SECONDS_LIMIT) {
      return (subTime / MILLIS_LIMIT).round().toString() + " 秒前";
    } else if (subTime < MINUTES_LIMIT) {
      return (subTime / SECONDS_LIMIT).round().toString() + " 分钟前";
    } else if (subTime < HOURS_LIMIT) {
      return (subTime / MINUTES_LIMIT).round().toString() + " 小时前";
    } else if (subTime < DAYS_LIMIT) {
      return (subTime / HOURS_LIMIT).round().toString() + " 天前";
    } else {
      return getDateStr(date);
    }
  }

  static String getTimeDuration(String comTime) {
    var nowTime = DateTime.now();
    var compareTime = DateTime.parse(comTime);
    if (nowTime.isAfter(compareTime)) {
      if (nowTime.year == compareTime.year) {
        if (nowTime.month == compareTime.month) {
          if (nowTime.day == compareTime.day) {
            if (nowTime.hour == compareTime.hour) {
              if (nowTime.minute == compareTime.minute) {
                return '片刻之间';
              }
              return (nowTime.minute - compareTime.minute).toString() + '分钟前';
            }
            return (nowTime.hour - compareTime.hour).toString() + '小时前';
          }
          return (nowTime.day - compareTime.day).toString() + '天前';
        }
        return (nowTime.month - compareTime.month).toString() + '月前';
      }
      return (nowTime.year - compareTime.year).toString() + '年前';
    }
    return 'time error';
  }

  ///大陆手机号码11位数，匹配格式：前三位固定格式+后8位任意数
  /// 此方法中前三位格式有：
  /// 13+任意数 * 15+除4的任意数 * 18+除1和4的任意数 * 17+除9的任意数 * 147
  static bool isPhoneLegal(String str) {
    if (isEmpty(str)) {
      return false;
    } else {
      return new RegExp(
              '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$')
          .hasMatch(str);
    }
  }

  static Future<Null> showIosPayDialog() {
    Future.delayed(Duration(seconds: 0)).then((onValue) {
      var context = KTKJGlobalConfig.navigatorKey.currentState.overlay.context;
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text('温馨提示'),
              content: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('iOS暂不支持购买')),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(
                    '确定',
//                    style: TextStyle(color: Color(0xff222222)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    });
  }

  ///版本更新(废弃)
  /*static Future<Null> showUpdateDialog(
      BuildContext context, String contentMsg) {
    return KTKJNavigatorUtils.showGSYDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('版本更新'),
            content: new Text(contentMsg),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text('取消')),
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text('确定')),
            ],
          );
        });
  }*/

  static Widget getNoDuplicateSubmissionWidget(
      {@required Widget childWidget, Function() fun}) {
    var lastPopTime;
    return Ink(
      child: InkWell(
          onTap: () async {
            // 防重复提交
            if (lastPopTime == null ||
                DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
              lastPopTime = DateTime.now();
              fun();
            } else {
              lastPopTime = DateTime.now();
              KTKJCommonUtils.showToast("请勿重复点击！");
            }
          },
          child: childWidget),
    );
  }

  static Future<Null> showPromptDialog(
      BuildContext context, String title, String contentMsg) {
    return KTKJNavigatorUtils.showGSYDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: AlertDialog(
              title: Center(child: new Text(title)),
              content: Container(
                  height: 20,
                  padding: EdgeInsets.all(0),
                  alignment: Alignment.center,
                  child: new Text(contentMsg)),
              actions: <Widget>[
//              new FlatButton(
//                  onPressed: () {
//                    Navigator.pop(context);
//                  },
//                  child: new Text('取消')),
                Container(
                  height: 30,
                  alignment: Alignment.center,
                  child: new FlatButton(
                      onPressed: () {
//                    launch(Address.updateUrl);
                        Navigator.pop(context);
                      },
                      child: new Text('确定')),
                ),
              ],
            ),
          );
        });
  }

  static Future<Null> showSimplePromptDialog(
      BuildContext context, String title, String contentMsg) {
    return KTKJNavigatorUtils.showGSYDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: SimpleDialog(
              title: Center(child: new Text(title)),
              children: <Widget>[
                Container(
                    height: 20,
                    padding: EdgeInsets.all(0),
                    alignment: Alignment.center,
                    child: new Text(contentMsg)),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: new FlatButton(
                      onPressed: () {
//                    launch(Address.updateUrl);
                        Navigator.pop(context);
                      },
                      child: new Text(
                        '确定',
                        style: TextStyle(color: KTKJGlobalConfig.colorPrimary),
                      )),
                ),
              ],
            ),
          );
        });
  }

  static Future<Null> showPayPasswordDialog(BuildContext context, orderId) {
    return KTKJNavigatorUtils.showGSYDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: SimpleDialog(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Center(
                            child: Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(61),
                          ),
                          child: new Text(
                            "请输入支付密码",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(48),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(vertical: 30),
                          child: PinCodeTextField(
                            length: 6,
                            obsecureText: true,
                            autoFocus: true,
                            animationType: AnimationType.fade,
                            mainAxisAlignment: MainAxisAlignment.center,
                            autoDismissKeyboard: true,
                            textInputType: TextInputType.number,
                            errorTextSpace: 0,
                            textStyle:
                                TextStyle(fontSize: ScreenUtil().setSp(42)),
                            validator: (v) {
                              if (v.length < 3) {
                                return "I'm from validator";
                              } else {
                                return null;
                              }
                            },

                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderWidth: ScreenUtil().setWidth(1),
                              borderRadius: BorderRadius.circular(0),
                              fieldHeight: ScreenUtil().setWidth(130),
                              fieldWidth: ScreenUtil().setWidth(130),
                              activeColor: Color(0xffeaeaea),
                              activeFillColor: Colors.white,
                              selectedColor: Color(0xffeaeaea),
                              selectedFillColor: Colors.white,
                              inactiveColor: Color(0xffeaeaea),
                              inactiveFillColor: Colors.white,
                              disabledColor: Colors.white,
                            ),
                            animationDuration: Duration(milliseconds: 300),
//                        backgroundColor: Colors.green.shade50,
                            enableActiveFill: true,
                            onCompleted: (v) {
                              print("Completed");
                            },
                            onChanged: (value) {
                              print(value);
                            },
                            beforeTextPaste: (text) {
                              print("Allowing to paste $text");
                              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                              //but you can show anything you want here, like your pop up saying wrong paste format or etc
                              return true;
                            },
                          ),
                        ),
                      ],
                    ),
                    Positioned.fill(
                      top: 0,
                      left: 0,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                            onTap: () {
//                    launch(Address.updateUrl);
                              Navigator.pop(context);
                            },
                            child: Container(
                                width: ScreenUtil().setWidth(120),
                                height: ScreenUtil().setWidth(120),
                                alignment: Alignment.topCenter,
                                child: FlatButton(
                                  child: new Icon(
                                    CupertinoIcons.clear_thick,
                                    color: Color(0xff999999),
                                    size: ScreenUtil().setSp(56),
                                  ),
                                ))),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  ///
  /// [permission] 需要授权的权限
  ///
  /// [fun] 授权成功后执行的方法
  ///
  /// 请求权限授权
  ///
  static Future<PermissionStatus> requestPermission(
      Permission permission, fun) async {
    final status = await permission.request();
    switch (status) {
      case PermissionStatus.denied:
        print("denied");
        KTKJCommonUtils.showToast("相关功能受限，请设置允许相关权限");
        break;
      case PermissionStatus.granted:
        fun;
        break;
      case PermissionStatus.restricted:
        break;
      case PermissionStatus.undetermined:
        break;
      case PermissionStatus.permanentlyDenied:
        KTKJCommonUtils.showToast("相关功能受限，请设置允许相关权限");
        openAppSettings();
        break;
    }
    return status;
  }

  ///展示公告弹窗
  static Future<bool> showNoticeDialog(
      {BuildContext context,
      String mNoticeContent,
      String noticeTitle,
      bool mIsForce}) async {
    return await showDialog(
        barrierDismissible: false, //屏蔽物理返回键（因为强更的时候点击返回键，弹窗会消失）
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              child: KTKJNoticeDialog(
                  noticeContent: mNoticeContent,
                  noticeTitle: noticeTitle,
                  isForce: mIsForce),
              onWillPop: _onWillPop);
        });
  }

  ///版本升级弹窗
  static Future<bool> showUpdateDialog(
      BuildContext context, String mUpdateContent, bool mIsForce) async {
    return await showDialog(
        barrierDismissible: false, //屏蔽物理返回键（因为强更的时候点击返回键，弹窗会消失）

        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              child: KTKJUpdateDialog(
                  upDateContent: mUpdateContent, isForce: mIsForce),
              onWillPop: _onWillPop);
        });
  }

  static Future<bool> _onWillPop() async {
    return false;
  }
}
