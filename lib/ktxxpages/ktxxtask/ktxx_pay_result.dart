import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/ktxxhttp/ktxx_http_manage.dart';
import 'package:star/ktxxmodels/ktxx_pay_coupon_entity.dart';
import 'package:star/ktxxpages/ktxxorder/ktxx_order_list.dart';
import 'package:star/ktxxpages/ktxxorder/ktxx_recharge_order_list.dart';
import 'package:star/ktxxpages/ktxxrecharge/ktxx_recharge_list.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_index.dart';
import 'package:star/ktxxutils/ktxx_common_utils.dart';
import 'package:star/ktxxutils/ktxx_navigator_utils.dart';

import '../../ktxx_global_config.dart';
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedPayResultPage extends StatefulWidget {
  String payNo;
  int type;

  KeTaoFeaturedPayResultPage({Key key, this.payNo = "", this.type = 0, this.title = "购买成功"})
      : super(key: key);
  String title;
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
  _KeTaoFeaturedPayResultPageState createState() => _KeTaoFeaturedPayResultPageState();
}
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _KeTaoFeaturedPayResultPageState extends State<KeTaoFeaturedPayResultPage> {
  //
  String _money = '';
  String _condition = '';
  String _startTime = '';
  String _endTime = '';
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;
  _initData() async {
    if (widget.type == 1) {
      return;
    }
    var result = await KeTaoFeaturedHttpManage.getRechargeCoupon(widget.payNo);
    if (result.status) {
      if (mounted) {
        setState(() {
          _money = result.data.money;
          _condition = result.data.condition;
          _startTime = result.data.startTime;
          _endTime = result.data.endTime;
        });
      }
    } else {}
  }

  @override
  void initState() {
    _initData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  DateTime _lastQuitTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
              color: Color(0xFF222222), fontSize: ScreenUtil().setSp(54)),
        ),
        brightness: Brightness.light,
        centerTitle: true,
        backgroundColor: KeTaoFeaturedGlobalConfig.taskNomalHeadColor,
        elevation: 0,
      ),
      body: WillPopScope(
          onWillPop: () async {
            if (_lastQuitTime == null ||
                DateTime.now().difference(_lastQuitTime).inSeconds > 1) {
              /*Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('再按一次 Back 按钮退出')));*/
              KeTaoFeaturedCommonUtils.showToast("再按一次返回键退出应用");
              _lastQuitTime = DateTime.now();
              return false;
            } else {
              // 退出app
              await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//              Navigator.of(context).pop(true);
              return true;
            }
          },
          child: buildHomeWidget(
              context)), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildHomeWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
            Container(
              color: Colors.white,
              alignment: Alignment.center,
              padding:
                  EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(140)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "static/images/pay_success.png",
                    width: ScreenUtil().setWidth(230),
                    height: ScreenUtil().setWidth(230),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(67),
                  ),
                  Text(
                    "购买成功",
                    style: TextStyle(
//                color:  Color(0xFF222222) ,
                        fontSize: ScreenUtil().setSp(42)),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(67),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            KeTaoFeaturedNavigatorUtils.navigatorRouterAndRemoveUntil(
                                context, KeTaoFeaturedTaskIndexPage());
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Container(
                              alignment: Alignment.center,
                              height: ScreenUtil().setHeight(116),
                              width: ScreenUtil().setWidth(308),
                              decoration: BoxDecoration(
                                  /*gradient: LinearGradient(colors: [
                                      Color(0xFFFBA951),
                                      Color(0xFFFFDCAC),
                                    ]),*/
                                  border: Border.all(color: Color(0xffF93736)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(34))),
                              child: Text(
                                "返回首页",
                                style: TextStyle(
                                  color: Color(0xFFF93736),
                                  fontSize: ScreenUtil().setSp(42),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: widget.type != 2,
                        child: Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (widget.type == 0) {
                                KeTaoFeaturedNavigatorUtils.navigatorRouter(
                                    context, KeTaoFeaturedRechargeListPage());
                              } else {
                                KeTaoFeaturedNavigatorUtils.navigatorRouter(
                                    context, KeTaoFeaturedOrderListPage());
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Container(
                                alignment: Alignment.center,
                                height: ScreenUtil().setHeight(116),
                                width: ScreenUtil().setWidth(308),
                                decoration: BoxDecoration(
                                    /*gradient: LinearGradient(colors: [
                                        Color(0xFFFBA951),
                                        Color(0xFFFFDCAC),
                                      ]),*/
                                    color: Color(0xffF93736),
                                    border:
                                        Border.all(color: Color(0xffF93736)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(34))),
                                child: Text(
                                  "${widget.type == 0 ? "去充值" : "查看订单"}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil().setSp(42),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
            Visibility(
              visible: widget.type == 0,
              child: Container(
                color: Colors.white,
                alignment: Alignment.center,
                padding:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(30)),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Image.asset(
                      "static/images/pay_bg.png",
                      width: ScreenUtil().setWidth(1028),
                      height: ScreenUtil().setWidth(504),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: ScreenUtil().setWidth(28),
                          top: ScreenUtil().setHeight(30)),
                      child: Image.asset(
                        "static/images/pay_fg.png",
                        width: ScreenUtil().setWidth(972),
                        height: ScreenUtil().setWidth(443),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: ScreenUtil().setHeight(160),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(100)),
                      width: ScreenUtil().setWidth(972),
                      height: ScreenUtil().setWidth(443),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "¥ $_money",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(72)),
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setHeight(24),
                                    ),
                                    Text(
                                      "充值话费满$_condition元$_money元",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(37)),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  KeTaoFeaturedNavigatorUtils.navigatorRouter(
                                      context, KeTaoFeaturedRechargeListPage());
                                },
                                child: Container(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: ScreenUtil().setHeight(84),
                                    width: ScreenUtil().setWidth(210),
                                    decoration: BoxDecoration(
                                        /*gradient: LinearGradient(colors: [
                                          Color(0xFFFBA951),
                                          Color(0xFFFFDCAC),
                                        ]),*/
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(34))),
                                    child: Text(
                                      "立即使用",
                                      style: TextStyle(
                                        color: Color(0xffFF5F4F),
                                        fontSize: ScreenUtil().setSp(36),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(60),
                          ),
                          Divider(
                            height: ScreenUtil().setHeight(1),
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(55),
                          ),
                          Text(
                            "有效期：$_startTime-$_endTime",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(37)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}