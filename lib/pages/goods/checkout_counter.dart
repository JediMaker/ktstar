import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alipay/flutter_alipay.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:star/http/http_manage.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:star/models/wechat_payinfo_entity.dart';
import 'package:star/pages/task/pay_result.dart';
import 'package:star/pages/widget/PriceText.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';

import '../../global_config.dart';

class CheckOutCounterPage extends StatefulWidget {
  List<String> cartIdList;
  String addressId;
  String orderId;
  String orderMoney;

  CheckOutCounterPage(
      {this.cartIdList, this.addressId, this.orderId, this.orderMoney});

  @override
  _CheckOutCounterPageState createState() => _CheckOutCounterPageState();
}

class _CheckOutCounterPageState extends State<CheckOutCounterPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

//  OrderCheckoutConfirmEntity entity;
//  OrderCheckoutxEntity entity2;

  int _payway = 0;
  var _payNo;

  _initWeChatResponseHandler() {
    GlobalConfig.payType = 2;
    fluwx.weChatResponseEventHandler.listen((res) async {
      if (res is fluwx.WeChatPaymentResponse) {
//        print("_result = " + "pay :${res.isSuccessful}");
        if (res.isSuccessful && GlobalConfig.payType == 2) {
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
          NavigatorUtils.navigatorRouterAndRemoveUntil(
              context,
              PayResultPage(
                payNo: _payNo,
                type: 1,
                title: '支付成功',
              ));
          break;
      }
    } else {
      CommonUtils.showToast(result.errMsg);
    }
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
    print("用户商品支付宝支付结果：" + _payResult.toString());
    if (_payResult.resultStatus == "9000") {
      _checkPayStatus();
    }
  }

  _changeSelectedPayWay(int i) {
    _payway = i;
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _initWeChatResponseHandler();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Text(
            '结算台',
            style: TextStyle(
                color: Color(0xFF222222), fontSize: ScreenUtil().setSp(54)),
          ),
          brightness: Brightness.light,
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
          centerTitle: true,
          backgroundColor: GlobalConfig.taskNomalHeadColor,
          elevation: 0,
        ),
        body: KeyboardDismissOnTap(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 16),
                  height: 50,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '订单总额：',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(48),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      PriceText(
                        text: widget.orderMoney == null
                            ? ""
                            : "${widget.orderMoney}",
                        fontSize: ScreenUtil().setSp(42),
                        fontBigSize: ScreenUtil().setSp(56),
                        textColor: Colors.red,
                        /* style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(56),
                        ),*/
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          '请选择支付方式：',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(48),
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.black12,
                      ),
                      ListTile(
                        onTap: () async {
                          var result = await HttpManage.getGoodsPayAliPayInfo(
                              orderId: widget.orderId);
                          if (result.status) {
                            _payInfo = result.data.payInfo;
                            _payNo = result.data.payNo;
                            callAlipay();
                          } else {
                            CommonUtils.showToast(result.errMsg);
                          }
                        },
                        leading: CachedNetworkImage(
                          imageUrl:
                              'https://alipic.lanhuapp.com/xdb61f0e63-777a-485a-97c7-ecdd8e261ff2',
                          width: ScreenUtil().setWidth(78),
                          height: ScreenUtil().setWidth(78),
                          fit: BoxFit.fill,
                        ),
                        title: Text(
                          '支付宝',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(48),
                          ),
                        ),
                        trailing: Icon(
                          CupertinoIcons.forward,
                          size: 16,
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.black12,
                      ),
                      ListTile(
                        onTap: () async {
                          var result =
                              await HttpManage.getGoodsPayWeChatPayInfo(
                                  orderId: widget.orderId);
                          if (result.status) {
                            _payNo = result.data.payNo;
                            callWxPay(result.data);
                          } else {
                            CommonUtils.showToast(result.errMsg);
                          }
                        },
                        leading: CachedNetworkImage(
                          imageUrl:
                              'https://alipic.lanhuapp.com/xdb0f27927-d450-4cc2-a0df-4147410870e7',
                          width: ScreenUtil().setWidth(78),
                          height: ScreenUtil().setWidth(78),
                          fit: BoxFit.fill,
                        ),
                        title: Text(
                          '微信',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(48),
                          ),
                        ),
                        trailing: Icon(
                          CupertinoIcons.forward,
                          size: 16,
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.black12,
                      ),
                      ListTile(
                        onTap: () async {
                          CommonUtils.showPayPasswordDialog(
                            context,
                          );
                        },
                        leading: CachedNetworkImage(
                          imageUrl:
                              'https://alipic.lanhuapp.com/xdd5f9c369-8c30-4f93-bcf0-151a16b97220',
                          width: ScreenUtil().setWidth(78),
                          height: ScreenUtil().setWidth(78),
                          fit: BoxFit.fill,
                        ),
                        title: Text(
                          '余额支付',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(48),
                          ),
                        ),
                        trailing: Icon(
                          CupertinoIcons.forward,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
