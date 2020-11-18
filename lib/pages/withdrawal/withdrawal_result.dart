import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/pages/task/task_index.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';

import '../../global_config.dart';

class WithdrawalResultPage extends StatefulWidget {
  WithdrawalResultPage({Key key}) : super(key: key);
  final String title = "";

  @override
  _WithdrawalResultPageState createState() => _WithdrawalResultPageState();
}

class _WithdrawalResultPageState extends State<WithdrawalResultPage> {
  var _withdrawalPrice = '';

  var _withdrawalFee = '';

  var _realReceivePrice = '';

  var _withdrawalAccount = '';

  var _accountBalance = '';

  _initData() async {
    var result = await HttpManage.getWithdrawalInfo();
    if (result.status) {
      if (mounted) {
        setState(() {
          try {
            _withdrawalPrice = result.data.useModel.applyPrice;
            _withdrawalFee = result.data.useModel.serviceFee;
            _realReceivePrice = result.data.useModel.price;
            _withdrawalAccount = result.data.user.zfbAccount;
            _accountBalance = result.data.user.price;
          } catch (e) {
            print(e);
          }
        });
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "提现",
          style: TextStyle(
              color: Color(0xFF222222), fontSize: ScreenUtil().setSp(54)),
        ),
        leading: IconButton(
          icon: Image.asset(
            "static/images/icon_ios_back.png",
            width: ScreenUtil().setWidth(36),
            height: ScreenUtil().setHeight(63),
            fit: BoxFit.fill,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        brightness: Brightness.light,
        centerTitle: true,
        backgroundColor: GlobalConfig.taskNomalHeadColor,
        elevation: 0,
      ),
      body: buildHomeWidget(
          context), // This trailing comma makes auto-formatting nicer for build methods.
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
            Visibility(
                child: Container(
                    width: double.infinity,
                    color: Color(0xffFFDDDC),
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(28), horizontal: 16),
                    child: Text(
                      "审核通过后，将提现至您当前绑定的支付宝账号，请注意查收~",
                      style: TextStyle(
                        color: Color(0xffF93736),
                        fontSize: ScreenUtil().setSp(36),
                      ),
                    ))),
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
                    "等待审核",
                    style: TextStyle(
//                color:  Color(0xFF222222) ,
                        fontSize: ScreenUtil().setSp(42)),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(67),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                  children: [
                                    WidgetSpan(
                                        child: Container(
                                      child: Text(
                                        "提现账户：",
                                        style: TextStyle(
                                          color: Color(0xFF222222),
                                          fontSize: ScreenUtil().setSp(42),
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                                TextSpan(
                                  text: '$_withdrawalAccount',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(42),
                                  ),
                                ),
                              ]),
                              style: TextStyle(
                                color: Color(0xFF222222),
                                fontSize: ScreenUtil().setSp(42),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                  text: '提现金额：',
                                  style: TextStyle(
                                    color: Color(0xFF222222),
                                    fontSize: ScreenUtil().setSp(42),
                                  ),
                                ),
                                TextSpan(
                                  text: '￥$_withdrawalPrice',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(42),
                                  ),
                                ),
                              ]),
                              style: TextStyle(
                                color: Color(0xFFF93736),
                                fontSize: ScreenUtil().setSp(42),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                  text: '服  务  费：',
                                  style: TextStyle(
                                    color: Color(0xFF222222),
                                    fontSize: ScreenUtil().setSp(42),
                                  ),
                                ),
                                TextSpan(
                                  text: '￥$_withdrawalFee',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(42),
                                  ),
                                ),
                              ]),
                              style: TextStyle(
                                color: Color(0xFFF93736),
                                fontSize: ScreenUtil().setSp(42),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                  text: '到账金额：',
                                  style: TextStyle(
                                    color: Color(0xFF222222),
                                    fontSize: ScreenUtil().setSp(42),
                                  ),
                                ),
                                TextSpan(
                                  text: '￥$_realReceivePrice',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(42),
                                  ),
                                ),
                              ]),
                              style: TextStyle(
                                color: Color(0xFFF93736),
                                fontSize: ScreenUtil().setSp(42),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                  text: '当前余额：',
                                  style: TextStyle(
                                    color: Color(0xFF222222),
                                    fontSize: ScreenUtil().setSp(42),
                                  ),
                                ),
                                TextSpan(
                                  text: '￥$_accountBalance',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(42),
                                  ),
                                ),
                              ]),
                              style: TextStyle(
                                color: Color(0xFFF93736),
                                fontSize: ScreenUtil().setSp(42),
                              ),
                            ),
                          ),
                        ],
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
