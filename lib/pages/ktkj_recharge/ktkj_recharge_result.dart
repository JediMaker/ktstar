import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/global_config.dart';
import 'package:star/pages/ktkj_task/ktkj_task_index.dart';
import 'package:star/utils/ktkj_common_utils.dart';
import 'package:star/utils/ktkj_navigator_utils.dart';


// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJRechargeResultPage extends StatefulWidget {
  KTKJRechargeResultPage({Key key}) : super(key: key);
  final String title = "充值成功";

  @override
  _RechargeResultPageState createState() => _RechargeResultPageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _RechargeResultPageState extends State<KTKJRechargeResultPage> {
  @override
  void initState() {
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
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: KTKJGlobalConfig.taskNomalHeadColor,
        elevation: 0,
      ),
      body: WillPopScope(
          onWillPop: () async {
            if (_lastQuitTime == null ||
                DateTime.now().difference(_lastQuitTime).inSeconds > 1) {
              /*Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('再按一次 Back 按钮退出')));*/
              KTKJCommonUtils.showToast("再按一次返回键退出应用！");
              _lastQuitTime = DateTime.now();
              return false;
            } else {
              // 退出app
              await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//              Navigator.of(context).pop(true);
              return true;
            }
          },
          child: buildHomeWidget(context)),

      /// This trailing comma makes auto-formatting nicer for build methods.
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
                    "充值成功",
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
                            KTKJNavigatorUtils.navigatorRouterAndRemoveUntil(
                                context, KTKJTaskIndexPage());
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
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
          ],
        ),
      ),
    );
  }
}
