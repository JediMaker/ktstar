import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_alipay/flutter_alipay.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io' as H;
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:star/global_config.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/wechat_payinfo_entity.dart';
import 'package:star/models/vip_price_entity.dart';
import 'package:star/pages/task/pay_result.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';

class TaskOpenDiamondPage extends StatefulWidget {
  TaskOpenDiamondPage({Key key}) : super(key: key);
  final String title = "钻石会员权益";

  @override
  _TaskOpenDiamondPageState createState() => _TaskOpenDiamondPageState();
}

class _TaskOpenDiamondPageState extends State<TaskOpenDiamondPage> {
  String _url = "https://wxpay.wxutil.com/pub_v2/app/app_pay.php";

  String _result = "无";
  int _payway = 0;
  var _payNo;
  String oldPrice = "";
  String nowPrice = "";
  bool showOldPrice = false;

  _initData() async {
    var result = await HttpManage.getVipPrice();
    if (result.status) {
      if (mounted) {
        setState(() {
//          oldPrice = result.data.yPrice.toString();
//          nowPrice = result.data.nowPrice.toString();
//          showOldPrice = !(result.data.nowPrice == result.data.yPrice);
        });
      }
    }
  }

  _initWeChatResponseHandler() {
    GlobalConfig.payType = 0;
    fluwx.weChatResponseEventHandler.listen((res) async {
      if (res is fluwx.WeChatPaymentResponse) {
//        print("_result = " + "pay :${res.isSuccessful}");
        if (res.isSuccessful && GlobalConfig.payType == 0) {
          _checkPayStatus();
        }
      }
    });
  }

  _checkPayStatus() async {
    var result = await HttpManage.checkPayResult(_payNo);
    if (result.status) {
      var payStatus = result.data["pay_status"].toString();
      switch (payStatus) {
        case "1": //未成功
          CommonUtils.showToast("支付失败");
          break;
        case "2": //已成功
          /* Fluttertoast.showToast(
              msg: "开通成功,去领任务吧",
              textColor: Colors.white,
              backgroundColor: Colors.grey);*/
          NavigatorUtils.navigatorRouterAndRemoveUntil(
              context,
              PayResultPage(
                payNo: _payNo,
              ));
          break;
      }
    } else {
      CommonUtils.showToast(result.errMsg);
    }
  }

  @override
  void initState() {
    _initData();
    _initWeChatResponseHandler();
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
            widget.title,
            style: TextStyle(
                color: Colors.white, fontSize: ScreenUtil().setSp(54)),
          ),
          leading: IconButton(
            icon: Image.asset(
              "static/images/icon_ios_back_white.png",
              width: ScreenUtil().setWidth(36),
              height: ScreenUtil().setHeight(63),
              fit: BoxFit.fill,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xFF222222),
        ),
        body: Container(
          color: Color(0xFF222222),
          width: double.maxFinite,
          height: double.maxFinite,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  Visibility(
                    visible: false,
                    child: Container(
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        width: double.maxFinite,
                        child: Image.asset(
                          "static/images/task_diamond_top_img.png",
                          fit: BoxFit.fill,
                          height: 200,
                        )),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 20, bottom: 40),
                      width: double.maxFinite,
                      child: Image.asset(
                        "static/images/task_diamond_top_img_bg.png",
                        fit: BoxFit.fitWidth,
                        width: ScreenUtil().setWidth(1125),
                      )),
                  Visibility(
                    visible: false,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Container(
                          width: 21,
                          height: 21,
                          transform: Matrix4.rotationZ(0.8),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Color(0xFFBC9B87)),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 15),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 216,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              shape: BoxShape.rectangle,
                              color: Color(0xFFBC9B87)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ListTile(
                                leading: Image.asset(
                                  "static/images/task_diamon_icon_1.png",
                                  width: 63,
                                  height: 63,
                                ),
                                title: Text(
                                  "任务数量",
                                  style: TextStyle(
                                      color: Color(0xFF222222),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "钻石会员可领取所有任务",
                                  style: TextStyle(
                                      color: Color(0xFF222222), fontSize: 14),
                                ),
                              ),
                              ListTile(
                                leading: Image.asset(
                                  "static/images/task_diamon_icon_2.png",
                                  width: 63,
                                  height: 63,
                                ),
                                title: Text(
                                  "奖励金额",
                                  style: TextStyle(
                                      color: Color(0xFF222222),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Wrap(
                                  children: <Widget>[
                                    Text(
                                      "VIP会员每条任务1元，钻石会员每条2元。",
                                      style: TextStyle(
                                          color: Color(0xFF222222),
                                          fontSize: 14),
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
                  Visibility(
                    visible: !H.Platform.isIOS,
                    child: GestureDetector(
                      onTap: () async {
                        //标语
                        _showSelectPayWayBottomSheet(context);
                      },
                      child: Container(
                        //diamond
                        height: ScreenUtil().setHeight(140),
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.symmetric(vertical: 65, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(46)),
                          gradient: LinearGradient(colors: [
                            Color(0xFFA75441),
                            Color(0xFF773A2C),
                          ]),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "$nowPrice元/年\t",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(42)),
                            ),
                            Visibility(
                              visible: showOldPrice,
                              child: Text(
                                "$oldPrice元/年",
                                style: TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: ScreenUtil().setSp(32)),
                              ),
                            ),
                            Text(
                              showOldPrice ? "\t限时开通" : "\t立即开通",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(42)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: H.Platform.isIOS,
                    child: GestureDetector(
                      onTap: () async {},
                      child: Container(
                        //diamond
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.symmetric(vertical: 65, horizontal: 16),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(46)),
                          gradient: LinearGradient(colors: [
                            Color(0xFFA75441),
                            Color(0xFF773A2C),
                          ]),
                        ),
                        child: Wrap(
                          children: <Widget>[
                            Text(
                              "由于相关规范，iOS功能暂不可用，请到公众号内或安卓端使用",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(42)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  _showSelectPayWayBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        builder: (context) {
          return StatefulBuilder(
            builder: (context, state) {
              return Container(
                height: 300,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "钻石会员开通",
                        style:
                            TextStyle(color: Color(0xFF222222), fontSize: 18),
                      ),
                      trailing: Text.rich(TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: "¥",
                            style: TextStyle(
                                color: GlobalConfig.taskHeadColor,
                                fontSize: 12)),
                        TextSpan(
                            text: " 199",
                            style: TextStyle(
                                color: GlobalConfig.taskHeadColor,
                                fontSize: 18)),
                        TextSpan(
                            text: ".00",
                            style: TextStyle(
                                color: GlobalConfig.taskHeadColor,
                                fontSize: 12)),
                      ])),
                    ),
                    ListTile(
                      onTap: () {
                        state(() {
                          _changeSelectedPayWay(1);
                        });
                      },
                      leading: Image.asset(
                        "static/images/payway_wx.png",
                        width: 30,
                        height: 30,
                      ),
                      title: Text(
                        "微信",
                        style:
                            TextStyle(color: Color(0xFF222222), fontSize: 16),
                      ),
                      trailing: Image.asset(
                        _payway == 1
                            ? "static/images/payway_checked.png"
                            : "static/images/payway_unchecked.png",
                        width: 20,
                        height: 20,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        state(() {
                          _changeSelectedPayWay(2);
                        });
                      },
                      leading: Image.asset(
                        "static/images/payway_zfb.png",
                        width: 30,
                        height: 30,
                      ),
                      title: Text(
                        "支付宝",
                        style:
                            TextStyle(color: Color(0xFF222222), fontSize: 16),
                      ),
                      trailing: Container(
                        child: Image.asset(
                          _payway == 2
                              ? "static/images/payway_checked.png"
                              : "static/images/payway_unchecked.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_payway == 1) {
                          var result = await HttpManage.getWechatPayInfo();
                          if (result.status) {
                            _payNo = result.data.payNo;
                            callWxPay(result.data);
                          } else {
                            CommonUtils.showToast(result.errMsg);
                          }
                        } else if (_payway == 2) {
                          var result = await HttpManage.getAliPayInfo();
                          if (result.status) {
                            _payInfo = result.data.payInfo;
                            _payNo = result.data.payNo;
                            callAlipay();
                          } else {
                            CommonUtils.showToast(result.errMsg);
                          }
                        } else {
                          CommonUtils.showToast("请选择支付方式");
                        }
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 46,
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(46)),
                          gradient: LinearGradient(colors: [
                            Color(0xFF73D9C4),
                            Color(0xFF50C8AD),
                          ]),
                        ),
                        child: Text(
                          "支付",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  Future callWxPay(WechatPayinfoData wechatPayinfoData) async {
    /*  var h = H.HttpClient();
    h.badCertificateCallback = (cert, String host, int port) {
      return true;
    };
    var request = await h.getUrl(Uri.parse(_url));
    var response = await request.close();
    var data = await Utf8Decoder().bind(response).join();
    Map<String, dynamic> result = json.decode(data);
    print(result['appid']);
    print(result["timestamp"]);*/
    /* fluwx
        .payWithWeChat(
      appId: result['appid'].toString(),
      partnerId: result['partnerid'].toString(),
      prepayId: result['prepayid'].toString(),
      packageValue: result['package'].toString(),
      nonceStr: result['noncestr'].toString(),
      timeStamp: result['timestamp'],
      sign: result['sign'].toString(),
    )
        .then((data) {
      print("---》$data");
    });*/
    fluwx
        .payWithWeChat(
      appId: wechatPayinfoData.payInfo.appid.toString(),
      partnerId: wechatPayinfoData.payInfo.partnerid.toString(),
      prepayId: wechatPayinfoData.payInfo.prepayid.toString(),
      packageValue: wechatPayinfoData.payInfo.package.toString(),
      nonceStr: wechatPayinfoData.payInfo.noncestr.toString(),
      timeStamp: wechatPayinfoData.payInfo.timestamp,
      sign: wechatPayinfoData.payInfo.sign.toString(),
    )
        .then((data) {
      print("wechatpayinfo---》$data");
    });
  }

  String _payInfo = "";

//      "alipay_sdk=alipay-sdk-php-easyalipay-20190926&app_id=2016101400682987&biz_content=%7B%22subject%22%3A+%22%E8%90%8C%E8%B1%A1%E7%94%9F%E6%B4%BB%E5%95%86%E5%93%81%E4%BA%A4%E6%98%93%22%2C%22out_trade_no%22%3A+%22408%22%2C%22timeout_express%22%3A+%2230m%22%2C%22total_amount%22%3A+%2245%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%7D&charset=UTF-8&format=json&method=alipay.trade.app.pay&notify_url=http%3A%2F%2Fmxss.0371.ml%3A88%2Findex.php%3Froute%3Dapp%2Fnotify%2Falipay&sign_type=RSA2&timestamp=2020-09-14+14%3A07%3A43&version=1.0&sign=NuVxhh1U1Bbx%2BaTsNp6cUYMqbId7OLokBe1yGexcoV2biaRbB4dypVUqzAkFVzlGwHbHfrvoAkADsBp%2BZfKu6lxlMKYp7OgBP6cwruA%2FYLAgtLvT0MDgMFzwz%2F%2B9njZY44u4YRsALI6jIL1seDZLSn5FXrAUDq5arwEA16P%2BcaTTS5ymx16fUqx1bTN6y%2BMGuAU7X53ZI37D3nujMEibaH549amYQWrWYxuRb6g%2Fbv%2FedLKjeP7MBozWylFNsBrqStjf1OCoPW2hj8OCYpyNE7eUqkSA3RcB0dNI7pwjhIhf3sRzJaDBAtOainSGCcR1hfv3cVhIX%2FamTSEd4%2Brtvg%3D%3D";
  AlipayResult _payResult;

  callAlipay() async {
    dynamic payResult;
    try {
      print("The pay info is : " + _payInfo);
      payResult = await FlutterAlipay.pay(_payInfo);
    } on Exception catch (e) {
      payResult = null;
    }

    _payResult = payResult;
    print("用户升级支付宝支付结果：" + _payResult.toString());
    if (_payResult.resultStatus == "9000") {
      _checkPayStatus();
    }
  }

  _changeSelectedPayWay(int i) {
    _payway = i;
  }
}
