import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/pay_coupon_entity.dart';
import 'package:star/pages/recharge/recharge_list.dart';
import 'package:star/pages/task/task_index.dart';
import 'package:star/utils/navigator_utils.dart';

import '../../global_config.dart';

class PayResultPage extends StatefulWidget {
  String payNo;

  PayResultPage({Key key, this.payNo = ""}) : super(key: key);
  final String title = "购买成功";

  @override
  _PayResultPageState createState() => _PayResultPageState();
}

class _PayResultPageState extends State<PayResultPage> {
  //
  String _money = '';
  String _condition = '';
  String _startTime = '';
  String _endTime = '';

  _initData() async {
    var result = await HttpManage.getRechargeCoupon(widget.payNo);
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(
                color: Color(0xFF222222), fontSize: ScreenUtil().setSp(54)),
          ),
          brightness: Brightness.dark,
          centerTitle: true,
          backgroundColor: GlobalConfig.taskNomalHeadColor,
          elevation: 0,
        ),
        body: WillPopScope(
            onWillPop: () async {
              if (_lastQuitTime == null ||
                  DateTime.now().difference(_lastQuitTime).inSeconds > 1) {
                /*Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('再按一次 Back 按钮退出')));*/
                Fluttertoast.showToast(
                    msg: "再按一次返回键退出应用",
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    gravity: ToastGravity.BOTTOM);
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
      ),
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
                            NavigatorUtils.navigatorRouterAndRemoveUntil(
                                context, TaskIndexPage());
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
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            NavigatorUtils.navigatorRouter(
                                context, RechargeListPage());
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
                                  border: Border.all(color: Color(0xffF93736)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(34))),
                              child: Text(
                                "去充值",
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
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
            Container(
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
                                NavigatorUtils.navigatorRouter(
                                    context, RechargeListPage());
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
          ],
        ),
      ),
    );
  }
}
