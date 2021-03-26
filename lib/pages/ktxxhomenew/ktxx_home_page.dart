import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:star/http/api.dart';
import 'package:star/models/user_info_entity.dart';
import 'package:star/pages/ktxxhomenew/ktxx_home_new_index.dart';
import 'package:star/pages/task/task_index.dart';
import 'package:star/pages/task/task_list.dart';
import 'package:star/pages/widget/my_webview.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/utils/navigator_utils.dart';
import '../../global_config.dart';
import 'package:star/pages/task/task_mine.dart';
import 'package:star/pages/shareholders/micro_mine.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJHomePagePage extends StatefulWidget {
  KTKJHomePagePage({Key key}) : super(key: key);
  final String title = "";

//  return Column(
//  mainAxisSize: MainAxisSize.min,
//  children: <Widget>[
//  Stack(
//  overflow: Overflow.visible,
//  children: <Widget>[
//  GestureDetector(
//  onTap: () {
//  if (catg.name == listProfileCategories[0].name)
//  Navigator.pushNamed(context, '/furniture');
//  },
//  child: Container(
//  padding: EdgeInsets.all(10.0),
//  decoration: BoxDecoration(
//  shape: BoxShape.circle,
//  color: profile_info_categories_background,
//  ),
//  child: Icon(
//  catg.icon,
//  // size: 20.0,
//  ),
//  ),
//  ),
//  catg.number > 0
//  ? Positioned(
//  right: -5.0,
//  child: Container(
//  padding: EdgeInsets.all(5.0),
//  decoration: BoxDecoration(
//  color: profile_info_background,
//  shape: BoxShape.circle,
//  ),
//  child: Text(
//  catg.number.toString(),
//  style: TextStyle(
//  color: Colors.white,
//  fontSize: 10.0,
//  ),
//  ),
//  ),
//  )
//      : SizedBox(),
//  ],
//  ),
//  SizedBox(
//  height: 10.0,
//  ),
//  Text(
//  catg.name,
//  style: TextStyle(
//  fontSize: 13.0,
//  ),
//  )
//  ],
//  );

  @override
  _HomePagePageState createState() => _HomePagePageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _HomePagePageState extends State<KTKJHomePagePage> {
  UserInfoData userInfoData;
  Widget rootView;
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;

  ///  微股东等级
  ///
  ///  1 见习股东
  ///
  ///  2 不是微股东
  ///
  ///  3 vip股东
  ///
  ///  4 高级股东
  String _shareholderType = '';

  _initVersionData() async {
    /*var versionInfo = await HttpManage.getVersionInfo();
    if (versionInfo.status) {
      switch (versionInfo.data.wxLogin) {
        case "1": //不显示
          KTKJGlobalConfig.displayThirdLoginInformation = false;

          if (mounted) {
            setState(() {});
          }
          break;

        case "2": //显示
          KTKJGlobalConfig.displayThirdLoginInformation = true;
          if (mounted) {
            setState(() {});
          }
          break;
      }

    }*/
    if (Platform.isAndroid) {
      if (mounted) {
        setState(() {
          rootView = KTKJTaskListPage();
//            rootView = KTKJHomeIndexPage();
        });
      }
    }
    if (Platform.isIOS) {
//        setState(() {
//          print("KTKJGlobalConfig.iosCheck=${KTKJGlobalConfig.iosCheck}");
//          print("versionInfo.data.whCheck=${versionInfo.data.whCheck}");
//
//        });
      if (mounted) {
        setState(() {
          if (KTKJGlobalConfig.iosCheck) {
            rootView = KTKJHomeIndexPage();
          } else {
            rootView = KTKJTaskListPage();
//            w1 = KTKJHomeIndexPage();
          }
//            rootView = KTKJHomeIndexPage();
        });
      }
    }
  }

  ///展示隐私弹窗
  ///
  showPrivacyDialog(context) {
    return KTKJNavigatorUtils.showGSYDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: AlertDialog(
              title: Center(child: new Text('服务协议和隐私政策')), //
              content: Container(
                padding: EdgeInsets.all(0),
                height: 180,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      new Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text:
                                    "请你务必审慎阅读、充分理解\“服务协议\”和\“隐私政策\”各条款，包括但不限于：为了向你提供购物、内容分享等服务，我们需要收集你的设备信息、操作日志等个人信息。你可以在“设置”中查看、变更、删除个人信息并管理你的授权。你可阅读"),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  KTKJNavigatorUtils.navigatorRouter(
                                      context,
                                      KTKJWebViewPage(
                                        initialUrl: APi.AGREEMENT_SERVICES_URL,
                                        showActions: false,
                                        title: "服务协议",
                                      ));
                                },
                                child: Text(
                                  "《服务协议》",
                                  style: TextStyle(
                                      color: KTKJGlobalConfig.taskHeadColor,
                                      fontSize: ScreenUtil().setSp(42)),
                                ),
                              ),
                            ),
                            //text: "《服务协议》",style: TextStyle(color: Colors.blueAccent)
                            TextSpan(text: "和"),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  KTKJNavigatorUtils.navigatorRouter(
                                      context,
                                      KTKJWebViewPage(
                                        initialUrl: APi.AGREEMENT_PRIVACY_URL,
                                        showActions: false,
                                        title: "隐私政策",
                                      ));
                                },
                                child: Text(
                                  "《隐私政策》",
                                  style: TextStyle(
                                      color: KTKJGlobalConfig.taskHeadColor,
                                      fontSize: ScreenUtil().setSp(42)),
                                ),
                              ),
                            ),
                            TextSpan(text: "了解详细信息。如你同意，请点击“同意”开始接受我们的服务。"),
                          ],
                        ),
                        style: TextStyle(fontSize: ScreenUtil().setSp(42)),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    },
                    child: new Text(
                      '暂不使用',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(42),
                          color: Colors.black54),
                    )),
                Container(
                  height: 30,
                  alignment: Alignment.center,
                  child: new FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        KTKJGlobalConfig.prefs.setBool("isAgreePrivacy", true);
                      },
                      child: new Text(
                        '同意',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: ScreenUtil().setSp(42),
                        ),
                      )),
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    userInfoData = KTKJGlobalConfig.getUserInfo();
//    _initData();
    _initVersionData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var title = '我的';
    /*  WidgetsBinding.instance.addPostFrameCallback((_) {
      print(
          "KTKJGlobalConfig.iosCheck=${KTKJGlobalConfig.iosCheck}");
      if (mounted) {
        setState(() {
          if (KTKJGlobalConfig.iosCheck) {
            rootView = KTKJHomeIndexPage();
          } else {
            rootView = KTKJTaskListPage();
//            w1 = KTKJHomeIndexPage();
          }
        });
      }
    });*/
    return Container(
      child: rootView,
      constraints: BoxConstraints(minHeight: 20, minWidth: 200),
    );
  }
}
