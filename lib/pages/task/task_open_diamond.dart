import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io' as H;
import 'package:fluwx/fluwx.dart' as fluwx;

class TaskOpenDiamondPage extends StatefulWidget {
  TaskOpenDiamondPage({Key key}) : super(key: key);
  final String title = "钻石会员权益";

  @override
  _TaskOpenDiamondPageState createState() => _TaskOpenDiamondPageState();
}

class _TaskOpenDiamondPageState extends State<TaskOpenDiamondPage> {
  String _url = "https://wxpay.wxutil.com/pub_v2/app/app_pay.php";

  String _result = "无";
  @override
  void initState() {
    fluwx.weChatResponseEventHandler.listen((res) {
      if (res is fluwx.WeChatPaymentResponse) {
        setState(() {
          _result = "pay :${res.isSuccessful}";
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose   star
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.white),
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
                  Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      width: double.maxFinite,
                      child: Image.asset(
                        "static/images/task_diamond_top_img.png",
                        fit: BoxFit.fill,
                        height: 200,
                      )),
                  Stack(
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
                  GestureDetector(
                    onTap: () async {
                      //todo 调用接口去开通钻石会员 ，调用微信支付
                      var h = H.HttpClient();
                      h.badCertificateCallback = (cert, String host, int port) {
                        return true;
                      };
                      var request = await h.getUrl(Uri.parse(_url));
                      var response = await request.close();
                      var data = await Utf8Decoder().bind(response).join();
                      Map<String, dynamic> result = json.decode(data);
                      print(result['appid']);
                      print(result["timestamp"]);
                      fluwx.payWithWeChat(
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
                      });
                    },
                    child: Container(
                      height: 46,
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(
                          vertical: 65, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(46)),
                        gradient: LinearGradient(colors: [
                          Color(0xFFA75441),
                          Color(0xFF773A2C),
                        ]),
                      ),
                      child: Text(
                        "199元/年 立即开通",
                        style: TextStyle(color: Colors.white),
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
}
