import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:star/ktxxhttp/ktxx_api.dart';
import 'package:star/ktxxhttp/ktxx_http_manage.dart';
import 'package:star/ktxxpages/ktxxwidget/ktxx_my_webview.dart';
import 'package:star/ktxxpages/ktxxwithdrawal/ktxx_forget_pay_password.dart';
import 'package:star/ktxxpages/ktxxwithdrawal/ktxx_pay_password_setting.dart';
import 'package:star/ktxxutils/ktxx_navigator_utils.dart';

import '../../ktxx_global_config.dart';
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedSafeSettingsPage extends StatefulWidget {
  KeTaoFeaturedSafeSettingsPage({this.hasPayPassword = false, this.phoneNum});
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
  _KeTaoFeaturedSafeSettingsPageState createState() => _KeTaoFeaturedSafeSettingsPageState();
  bool hasPayPassword;
  String phoneNum;
}
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _KeTaoFeaturedSafeSettingsPageState extends State<KeTaoFeaturedSafeSettingsPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  var _payPwdStatus = '1';

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _initUserData();
    super.initState();
  }
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;
  _initUserData() async {
    try {
      if (widget.hasPayPassword) {
        return;
      }
    } catch (e) {}
    var result = await KeTaoFeaturedHttpManage.getUserInfo();
    if (result.status) {
      if (mounted) {
        setState(() {
          _payPwdStatus = result.data.payPwdStatus;
          widget.hasPayPassword = _payPwdStatus == '2';
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildInfoCard() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: ScreenUtil().setHeight(40),
        ),
        Visibility(
          visible: !widget.hasPayPassword,
          child: Ink(
            decoration: BoxDecoration(color: Colors.white),
            child: InkWell(
              onTap: () async {
                await KeTaoFeaturedNavigatorUtils.navigatorRouter(
                    context,
                    KeTaoFeaturedPayPasswordSettingPage(
                      pageType: 0,
                    ));
                _initUserData();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "设置支付密码",
                            style: TextStyle(fontSize: ScreenUtil().setSp(42)),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 4,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: ScreenUtil().setWidth(32),
                          color: Color(0xff999999),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: !widget.hasPayPassword,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: ScreenUtil().setHeight(1),
              color: Color(0xFFefefef),
            ),
          ),
        ),
        Visibility(
          visible: widget.hasPayPassword,
          child: Ink(
            decoration: BoxDecoration(color: Colors.white),
            child: InkWell(
              onTap: () async {
                await KeTaoFeaturedNavigatorUtils.navigatorRouter(
                    context,
                    KeTaoFeaturedPayPasswordSettingPage(
                      pageType: 2,
                    ));
                _initUserData();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "修改支付密码",
                            style: TextStyle(fontSize: ScreenUtil().setSp(42)),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 4,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: ScreenUtil().setWidth(32),
                          color: Color(0xff999999),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.hasPayPassword,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: ScreenUtil().setHeight(1),
              color: Color(0xFFefefef),
            ),
          ),
        ),
        Ink(
          decoration: BoxDecoration(color: Colors.white),
          child: InkWell(
            onTap: () async {
              await KeTaoFeaturedNavigatorUtils.navigatorRouter(
                  context,
                  KeTaoFeaturedForgetPayPasswordPage(
                    phoneNum: widget.phoneNum,
                  ));
              _initUserData();
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "忘记支付密码",
                          style: TextStyle(fontSize: ScreenUtil().setSp(42)),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: ScreenUtil().setWidth(32),
                        color: Color(0xff999999),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

//
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "安全设置",
            style: TextStyle(
                color: Color(0xFF222222), fontSize: ScreenUtil().setSp(54)),
          ),
          leading: IconButton(
            icon: Container(
              width: ScreenUtil().setWidth(63),
              height: ScreenUtil().setHeight(63),
              child: Center(
                child: Image.asset(
                  "static/images/icon_ios_back.png",
                  width: ScreenUtil().setWidth(36),
                  height: ScreenUtil().setHeight(63),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          brightness: Brightness.light,
          centerTitle: true,
          backgroundColor: KeTaoFeaturedGlobalConfig.taskNomalHeadColor,
          elevation: 0,
        ),
        body: _buildInfoCard());
  }
}
