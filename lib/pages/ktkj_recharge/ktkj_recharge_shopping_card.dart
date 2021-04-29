import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alipay/flutter_alipay.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:star/global_config.dart';
import 'package:star/http/ktkj_http_manage.dart';
import 'package:star/models/wechat_payinfo_entity.dart';
import 'package:star/pages/ktkj_recharge/ktkj_recharge_result.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_octoimage.dart';
import 'package:star/utils/ktkj_common_utils.dart';
import 'package:star/utils/ktkj_navigator_utils.dart';

void main() {
  runApp(KTKJRechargeShoppingCardPage());
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJRechargeShoppingCardPage extends StatefulWidget {
  KTKJRechargeShoppingCardPage({Key key}) : super(key: key);
  final String title = "充值购物卡";

  @override
  _RechargeListPageState createState() => _RechargeListPageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _RechargeListPageState extends State<KTKJRechargeShoppingCardPage> {
  TextEditingController _moneyController = new TextEditingController();
  List<String> _moneyList = List<String>();
  List<String> _rules = List<String>();
  Color _mainColor = Color(0xffF96567);
  int _selectIndex = 0;
  int _payWay = 1;
  FocusNode _phoneFocusNode = FocusNode();
  var _payNo;
  String _selectedRechargeMoney;
  var _shoppingCardBalance = "0.00";
  var _scale = ScreenUtil.screenWidth / 750;
  _initWeChatResponseHandler() {
    KTKJGlobalConfig.payType = 6;
    fluwx.weChatResponseEventHandler.listen((res) async {
      if (res is fluwx.WeChatPaymentResponse) {
//        print("_result = " + "pay :${res.isSuccessful}");
        if (res.isSuccessful && KTKJGlobalConfig.payType == 6) {
//          Fluttertoast.showToast(
//              msg: "支付成功！",
//              textColor: Colors.white,
//              backgroundColor: Colors.grey);
          var result = await HttpManage.checkPayResult(_payNo);
          if (result.status) {
            var payStatus = result.data["pay_status"].toString();
            switch (payStatus) {
              case "1": //未成功
                KTKJCommonUtils.showToast("支付失败！");
                break;
              case "2": //已成功
                /* Fluttertoast.showToast(
                    msg: "支付成功！",
                    textColor: Colors.white,
                    backgroundColor: Colors.grey);*/
                KTKJNavigatorUtils.navigatorRouterAndRemoveUntil(
                    context, KTKJRechargeResultPage());
                break;
            }
          } else {
            KTKJCommonUtils.showToast(result.errMsg);
          }
        }
      }
    });
  }

  @override
  void initState() {
    _initData();
    _initWeChatResponseHandler();
    super.initState();
  }

  void _initData() async {
    var result = await HttpManage.shoppingCardGetInfo();
    if (result.status) {
      if (mounted) {
        setState(() {
          _shoppingCardBalance = result.data.nowMoney;
          var tempMoney = "0.00";
          if (KTKJCommonUtils.isNotEmpty(_shoppingCardBalance)) {
            tempMoney = double.parse(_shoppingCardBalance).toStringAsFixed(2);
          }
          _shoppingCardBalance = tempMoney;
          _moneyList = result.data.money;
          if (KTKJCommonUtils.isNotEmpty(_moneyList)) {
            _moneyController.text = _moneyList[0];
            _selectedRechargeMoney = _moneyController.text;
          }
          _rules = result.data.rules;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.title,
              style: TextStyle(
                  color: Colors.white, fontSize: ScreenUtil().setSp(54)),
            ),
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                width: ScreenUtil().setWidth(63),
                height: ScreenUtil().setHeight(63),
                child: Center(
                  child: Image.asset(
                    "static/images/icon_ios_back_white.png",
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
            backgroundColor: _mainColor,
          ),
          body: Container(
            color: _mainColor,
            height: double.infinity,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(30),
              ),
              child: Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          child: KTKJMyOctoImage(
                            image:
                                "https://alipic.lanhuapp.com/ps513bb67d3a0cb68c-caa0-47e1-ac70-c438c06ead20",
                            width: ScreenUtil().setWidth(726 * _scale),
                            height: ScreenUtil().setWidth(325 * _scale),
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          width: ScreenUtil().setWidth(274 * _scale),
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(76 * _scale),
                            left: ScreenUtil().setWidth(374 * _scale),
                          ),
                          child: Text(
                            "充值购物卡\n\t\t福利立即享",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(42 * _scale),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              ScreenUtil().setWidth(30 * _scale),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setWidth(42 * _scale),
                            horizontal: ScreenUtil().setWidth(30 * _scale),
                          ),
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(270 * _scale),
                          ),
                          child: Column(
                            children: <Widget>[
                              buildShoppingCardBalanceContainer(),
                              Container(
                                margin: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(46 * _scale),
                                ),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "充值金额",
                                  style: TextStyle(
                                    color: Color(0xff222222),
                                    fontSize: ScreenUtil().setSp(30 * _scale),
                                  ),
                                ),
                              ),
                              buildRechargeLayout(),
                              buildMoneyInputContainer(),
                              Visibility(
                                visible: true,
                                child: GestureDetector(
                                  onTap: () async {
                                    if (KTKJCommonUtils.isEmpty(
                                        _selectedRechargeMoney)) {
                                      KTKJCommonUtils.showToast("请输入充值金额！");
                                      /* KTKJCommonUtils.showSimplePromptDialog(
                                          context, "温馨提示", "请输入正确的手机号");*/
                                      return;
                                    }
                                    if (!KTKJCommonUtils.isEmpty(
                                        _selectedRechargeMoney)) {
                                      _showSelectPayWayBottomSheet(context);
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width:
                                            ScreenUtil().setWidth(440 * _scale),
                                        height:
                                            ScreenUtil().setWidth(113 * _scale),
                                        margin: EdgeInsets.only(
                                          bottom: ScreenUtil()
                                              .setWidth(20 * _scale),
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            KTKJMyOctoImage(
                                              image:
                                                  "https://alipic.lanhuapp.com/psf7f4a6396b2f7f18-457d-4fa5-8870-f2aaadb21aa8",
                                              fit: BoxFit.fill,
                                            ),
                                            Text(
                                              "立即充值",
                                              style: TextStyle(
                                                color: Color(0xff722E18),
                                                fontSize: ScreenUtil()
                                                    .setSp(50 * _scale),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: false,
                                child: GestureDetector(
                                  child: Container(
                                    //diamond
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(46 * _scale)),
                                      gradient: LinearGradient(colors: [
                                        Color(0xFF489FFF),
                                        Color(0xFF489FFF),
                                      ]),
                                    ),
                                    child: Text(
                                      "iOS暂未开放",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(42)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: ScreenUtil().setWidth(385 * _scale),
                      margin: EdgeInsets.only(
                        top: ScreenUtil().setWidth(55 * _scale),
                        bottom: ScreenUtil().setWidth(56 * _scale),
                      ),
                      child: Container(
                        height: ScreenUtil().setWidth(385 * _scale),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            KTKJMyOctoImage(
                              image:
                                  "https://alipic.lanhuapp.com/psd8a318a6b450a23d-8ff3-4b33-92ae-c81d3abeac8c",
                              fit: BoxFit.fill,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: ScreenUtil().setWidth(40 * _scale),
                              ),
                              child: Text(
                                "购物卡使用说明",
                                style: TextStyle(
                                  color: Color(0xffFF4026),
                                  fontSize: ScreenUtil().setSp(36 * _scale),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: ScreenUtil().setWidth(160 * _scale),
                              ),
                              padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(40 * _scale),
                                right: ScreenUtil().setWidth(40 * _scale),
                              ),
                              height: ScreenUtil().setWidth(200 * _scale),
                              width: double.infinity,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                      List.generate(_rules.length, (index) {
                                    return buildRulesItem(index);
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ) // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }

  Widget buildItemLayout({index = 0}) {
    var money = '';
    try {
      money = _moneyList[index];
    } catch (e) {}
    return Container(
      width: ScreenUtil().setWidth(183 * _scale),
      height: ScreenUtil().setWidth(77 * _scale),
      child: GestureDetector(
        onTap: () {
          _selectIndex = index;
          _moneyController.text = _moneyList[index];
          _selectedRechargeMoney = _moneyController.text;
          if (mounted) {
            setState(() {});
          }
        },
        child: Container(
          width: ScreenUtil().setWidth(183 * _scale),
          height: ScreenUtil().setWidth(77 * _scale),
          decoration: BoxDecoration(
            color: _selectIndex == index ? _mainColor : Colors.white,
            borderRadius: BorderRadius.circular(
              ScreenUtil().setWidth(11 * _scale),
            ),
            border: Border.all(
              width: ScreenUtil().setWidth(2),
              color:
                  _selectIndex == index ? Color(0xffE76062) : Color(0xffFC4044),
            ),
            boxShadow: _selectIndex == index
                ? <BoxShadow>[
                    BoxShadow(
                      color: Color(0xffFC4044).withOpacity(0.6),
                      offset: Offset(
                        ScreenUtil().setWidth(0),
                        ScreenUtil().setWidth(10),
                      ),
                      blurRadius: ScreenUtil().setWidth(10),
                      spreadRadius: ScreenUtil().setWidth(0),
                    )
                  ]
                : <BoxShadow>[],
          ),
          child: Center(
            child: Text(
              "￥$money元",
              style: TextStyle(
                color: _selectIndex == index ? Colors.white : Color(0xff222222),
                fontSize: ScreenUtil().setSp(24 * _scale),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildShoppingCardBalanceContainer() {
    return Container(
      width: ScreenUtil().setWidth(635 * _scale),
      height: ScreenUtil().setWidth(159 * _scale),
      child: Stack(
        children: [
          KTKJMyOctoImage(
            image:
                "https://alipic.lanhuapp.com/ps0b39ec6439f56b17-ab74-43fa-9c04-4278478fdd58",
            fit: BoxFit.fill,
          ),
          Container(
            width: ScreenUtil().setWidth(635 * _scale),
            height: ScreenUtil().setWidth(159 * _scale),
            child: Row(
              children: [
                Container(
                  child: Text(
                    "购物卡余额",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(32 * _scale)),
                  ),
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(50 * _scale),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(40 * _scale),
                  ),
                  child: Text(
                    "￥",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(30 * _scale)),
                  ),
                ),
                Text(
                  "$_shoppingCardBalance",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(52 * _scale),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildRechargeLayout() {
    return Container(
      width: double.maxFinite,
//                  height: ScreenUtil().setHeight(582),
      padding:
          EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(30 * _scale)),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30 * _scale)),
      ),
      child: Wrap(
        spacing: ScreenUtil().setWidth(40 * _scale),
        runSpacing: ScreenUtil().setWidth(30 * _scale),
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: List.generate(_moneyList.length, (index) {
          return buildItemLayout(index: index);
        }),
      ),
    );
  }

  Widget buildMoneyInputContainer() {
    return Column(
      children: [
        /*Container(
          height: ScreenUtil().setWidth(134),
          width: double.maxFinite,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        _showCoin = true;
                      });
                    }
                  },
                  child: Container(
                    height: ScreenUtil().setWidth(134),
                    width: double.maxFinite,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _showCoin ? Colors.white : Color(0xfff9f9f9),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          ScreenUtil().setWidth(30),
                        ),
                        topRight: Radius.circular(
                          ScreenUtil().setWidth(30),
                        ),
                      ),
                    ),
                    child: Text(
                      "分红金奖励",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(38),
                        color:
                            _showCoin ? Color(0xff5984E9) : Color(0xff9F9F9F),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        _showCoin = false;
                      });
                    }
                  },
                  child: Container(
                    height: ScreenUtil().setWidth(134),
                    width: double.maxFinite,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: !_showCoin ? Colors.white : Color(0xfff9f9f9),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          ScreenUtil().setWidth(30),
                        ),
                        topRight: Radius.circular(
                          ScreenUtil().setWidth(30),
                        ),
                      ),
                    ),
                    child: Text(
                      "话费95折",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(38),
                        color:
                            !_showCoin ? Color(0xff5984E9) : Color(0xff9F9F9F),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),*/
        Container(
          height: ScreenUtil().setWidth(100 * _scale),
          margin: EdgeInsets.only(
            top: ScreenUtil().setWidth(22 * _scale),
            bottom: ScreenUtil().setWidth(52 * _scale),
          ),
          width: double.maxFinite,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              ScreenUtil().setWidth(15 * _scale),
            ),
            border: Border.all(
              width: ScreenUtil().setWidth(1),
              color: Color(0xffcccccc),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Color(0xff333333).withOpacity(0.13),
                offset: Offset(
                  ScreenUtil().setWidth(5),
                  ScreenUtil().setWidth(0),
                ),
                blurRadius: ScreenUtil().setWidth(13),
                spreadRadius: ScreenUtil().setWidth(0),
              )
            ],
          ),
          child: Row(
            children: <Widget>[
              Container(
                child: Text(
                  "￥",
                  style: TextStyle(
                    color: Color(0xff222222),
                    fontSize: ScreenUtil().setSp(44 * _scale),
                  ),
                ),
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(20 * _scale),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _moneyController,
                  keyboardType: TextInputType.number,
                  focusNode: _phoneFocusNode,
                  onChanged: (value) {
                    _selectedRechargeMoney = value;
                  },
                  inputFormatters: [
//                            WhitelistingTextInputFormatter(RegExp("[a-z,A-Z,0-9]")),      //限制只允许输入字母和数字
                    WhitelistingTextInputFormatter.digitsOnly,
                    //限制只允许输入数字
                    LengthLimitingTextInputFormatter(11),
                    //限制输入长度不超过11位
                  ],
                  decoration: InputDecoration(
                    /*  labelText: widget.address.iphone == null
                                  ? ''
                                  : widget.address.iphone,*/
                    border: InputBorder.none,
                    hintText: '\t请输入充值金额，最低10元起',
                    hintStyle: TextStyle(
                        color: Color(0xff999999),
                        fontSize: ScreenUtil().setSp(24 * _scale)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
                        "购物卡充值",
                        style:
                            TextStyle(color: Color(0xFF222222), fontSize: 16),
                      ),
                      trailing: Text.rich(TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: "¥",
                            style: TextStyle(
                                color: KTKJGlobalConfig.taskHeadColor,
                                fontSize: 12)),
                        TextSpan(
                            text: " $_selectedRechargeMoney",
                            style: TextStyle(
                                color: KTKJGlobalConfig.taskHeadColor,
                                fontSize: 18)),
                        /*   TextSpan(
                            text: ".00",
                            style: TextStyle(
                                color: KTKJGlobalConfig.taskHeadColor,
                                fontSize: 12)),*/
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
                        _payWay == 1
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
                          _payWay == 2
                              ? "static/images/payway_checked.png"
                              : "static/images/payway_unchecked.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_payWay == 1) {
                          try {
                            EasyLoading.show();
                          } catch (e) {}
                          var result =
                              await HttpManage.shoppingCardGetWeChatPayInfo(
                                  payMoney: _selectedRechargeMoney);
                          try {
                            EasyLoading.dismiss();
                          } catch (e) {}
                          if (result.status) {
                            _payNo = result.data.payNo;
                            callWxPay(result.data);
                          } else {
                            KTKJCommonUtils.showToast(result.errMsg);
                          }
                        } else if (_payWay == 2) {
                          try {
                            EasyLoading.show();
                          } catch (e) {}
                          var result =
                              await HttpManage.shoppingCardGetAliPayInfo(
                                  payMoney: _selectedRechargeMoney);
                          try {
                            EasyLoading.dismiss();
                          } catch (e) {}
                          if (result.status) {
                            _payInfo = result.data.payInfo;
                            _payNo = result.data.payNo;
                            callAlipay();
                          } else {
                            KTKJCommonUtils.showToast(result.errMsg);
                          }
                        } else {
                          KTKJCommonUtils.showToast("请选择支付方式！");
                          return;
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
                            _mainColor,
                            _mainColor,
//                            Color(0xFF489FFF),
//                            Color(0xFF489FFF),
                          ]),
                        ),
                        child: Text(
                          "支付",
                          style: TextStyle(color: Colors.white, fontSize: 16),
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
    print("话费充值支付宝支付结果：" + _payResult.toString());
    if (_payResult.resultStatus == "9000") {}
    /* Fluttertoast.showToast(
          msg: _payResult == null ? "" : _payResult.toString(),
          textColor: Colors.black);*/
  }

  _changeSelectedPayWay(int i) {
    _payWay = i;
  }

  Widget buildRulesItem(int index) {
    var ruleText = '';
    try {
      /*if (index > 2) {
        ruleText = _rules[index - 3];
      } else {
        ruleText = _rules[index];
      }*/
      ruleText = _rules[index];
    } catch (e) {}
    return Container(
      margin: EdgeInsets.only(
        top: ScreenUtil().setWidth(18 * _scale),
      ),
      child: Text(
        "$ruleText",
        style: TextStyle(
          fontSize: ScreenUtil().setSp(28 * _scale),
          color: Color(0xff491F00),
        ),
      ),
    );
  }
}
