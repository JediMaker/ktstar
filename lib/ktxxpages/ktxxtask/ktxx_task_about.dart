import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:star/ktxxhttp/ktxx_api.dart';
import 'package:star/ktxxpages/ktxxwidget/ktxx_my_webview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../ktxx_global_config.dart';
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedAboutPage extends StatefulWidget {
  @override
  _KeTaoFeaturedAboutPageState createState() => _KeTaoFeaturedAboutPageState();
}
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _KeTaoFeaturedAboutPageState extends State<KeTaoFeaturedAboutPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;
  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }
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
        Ink(
          decoration: BoxDecoration(color: Colors.white),
          child: InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return KeTaoFeaturedWebViewPage(
                    initialUrl: KeTaoFeaturedAPi.AGREEMENT_SERVICES_URL, title: "用户协议");
              }));
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
                          "可淘星选用户服务协议",
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
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(
            height: ScreenUtil().setHeight(1),
            color: Color(0xFFefefef),
          ),
        ),
        Ink(
          decoration: BoxDecoration(color: Colors.white),
          child: InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return KeTaoFeaturedWebViewPage(
                  initialUrl: KeTaoFeaturedAPi.AGREEMENT_PRIVACY_URL,
                  title: "隐私政策",
                );
              }));
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
                          "可淘星选隐私保护协议",
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
        Visibility(
          visible: KeTaoFeaturedGlobalConfig.isHuaweiUnderReview,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(
                  height: ScreenUtil().setHeight(1),
                  color: Color(0xFFefefef),
                ),
              ),
              Ink(
                decoration: BoxDecoration(color: Colors.white),
                child: InkWell(
                  onTap: () {
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "客服电话",
                                style:
                                    TextStyle(fontSize: ScreenUtil().setSp(42)),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "4006002868",
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(42),
                                color: Color(0xff999999),
                              ),
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
            ],
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
            "关于我们",
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
