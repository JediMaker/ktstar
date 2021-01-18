import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alipay/flutter_alipay.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/recharge_entity.dart';
import 'package:star/models/wechat_payinfo_entity.dart';
import 'package:star/pages/recharge/recharge_result.dart';
import 'package:star/pages/widget/select_choice.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';
import '../../global_config.dart';

void main() {
  runApp(RechargeListPage());
}

class RechargeListPage extends StatefulWidget {
  RechargeListPage({Key key}) : super(key: key);
  final String title = "话费充值";

  @override
  _RechargeListPageState createState() => _RechargeListPageState();
}

class _RechargeListPageState extends State<RechargeListPage> {
  TextEditingController _phoneController = new TextEditingController();
  List<RechargeDataRechageList> _dataList;
  Color _textTopColor = Color(0xff0A7FFF);
  Color _textBottomColor = Color(0xff999999);
  Color _textSelectedColor = Colors.white;
  int _selectIndex = -1;
  int _payWay = 0;
  FocusNode _phoneFocusNode = FocusNode();
  var _payNo;
  RechargeDataRechageList _selectedRechargeData;
  RechargeDatacouponList _couponData;

  _initWeChatResponseHandler() {
    GlobalConfig.payType = 1;
    fluwx.weChatResponseEventHandler.listen((res) async {
      if (res is fluwx.WeChatPaymentResponse) {
//        print("_result = " + "pay :${res.isSuccessful}");
        if (res.isSuccessful && GlobalConfig.payType == 1) {
//          Fluttertoast.showToast(
//              msg: "支付成功！",
//              textColor: Colors.white,
//              backgroundColor: Colors.grey);
          var result = await HttpManage.checkPayResult(_payNo);
          if (result.status) {
            var payStatus = result.data["pay_status"].toString();
            switch (payStatus) {
              case "1": //未成功
                CommonUtils.showToast("支付失败！");
                break;
              case "2": //已成功
                /* Fluttertoast.showToast(
                    msg: "支付成功！",
                    textColor: Colors.white,
                    backgroundColor: Colors.grey);*/
                NavigatorUtils.navigatorRouterAndRemoveUntil(
                    context, RechargeResultPage());
                break;
            }
          } else {
            CommonUtils.showToast(result.errMsg);
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
    var result = await HttpManage.getRechargeList();
    if (result.status) {
      if (mounted) {
        setState(() {
          _dataList = result.data.rechageList;
          try {
            _couponData = result.data.couponList[0];
          } catch (e) {}
        });
      }
    }
    /*dataList = List<RechargeData>();
    dataList.add(RechargeData());
    dataList.add(RechargeData());
    dataList.add(RechargeData());
    dataList.add(RechargeData());
    dataList.add(RechargeData());
    dataList.add(RechargeData());*/
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 1125, height: 2436, allowFontScaling: false);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(
                color: Colors.white, fontSize: ScreenUtil().setSp(54)),
          ),
          centerTitle: true,
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
          backgroundColor: Color(0xFF489FFF),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(48),
              vertical: ScreenUtil().setHeight(30)),
          child: Center(
            child: Column(
              children: <Widget>[
                buildphoneInputContainer(),
                SizedBox(
                  height: ScreenUtil().setHeight(30),
                ),
                buildRechargeLayout(),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(37),
                      bottom: ScreenUtil().setHeight(182)),
                  child: Visibility(
                    visible: _couponData != null &&
                        _couponData.money != null &&
                        _couponData.condition != null,
                    child: _couponData != null &&
                            _couponData.money != null &&
                            _couponData.condition != null
                        ? Text(
                            "* 您有一张${_couponData.money}元优惠券可用(满${_couponData.condition}元)",
                            style: TextStyle(
                                color: Color(0xff999999),
                                fontSize: ScreenUtil().setSp(32)),
                          )
                        : Text(""),
                  ),
                ),
                Visibility(
                  visible: !Platform.isIOS,
                  child: GestureDetector(
                    onTap: () async {
                      if (!CommonUtils.isPhoneLegal(_phoneController.text)) {
                        CommonUtils.showSimplePromptDialog(
                            context, "温馨提示", "请输入正确的手机号");
                        return;
                      }
                      try {
                        _selectedRechargeData = _dataList[_selectIndex];
                      } catch (e) {
                        print(e);
                      }
                      if (!CommonUtils.isEmpty(_selectedRechargeData)) {
                        _showSelectPayWayBottomSheet(context);
                      }
                    },
                    child: Container(
                      //diamond
                      height: ScreenUtil().setHeight(140),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(46)),
                        gradient: LinearGradient(colors: [
                          Color(0xFF489FFF),
                          Color(0xFF489FFF),
                        ]),
                      ),
                      child: Text(
                        "支付",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(42)),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: Platform.isIOS,
                  child: GestureDetector(
                    child: Container(
                      //diamond
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(46)),
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
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Container buildRechargeLayout() {
    return Container(
      width: double.maxFinite,
//                  height: ScreenUtil().setHeight(582),
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(65)),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
      ),
      child: Wrap(
        spacing: ScreenUtil().setWidth(20),
        runSpacing: ScreenUtil().setWidth(20),
        children: _dataList != null
            ? _dataList.asMap().keys.map((valueIndex) {
                RechargeDataRechageList dataItem = _dataList[valueIndex];

                try {
                  if (_selectIndex == -1 &&
                      double.parse(dataItem.couponMoney) > 0) {
                    setState(() {
                      _selectIndex = valueIndex;
                    });
                  }
                } catch (e) {}
                return SelectChoiceChip(
                  width: ScreenUtil().setWidth(310),
                  height: ScreenUtil().setHeight(216),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "${dataItem.faceMoney}",
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(56),
                                color: _selectIndex == valueIndex
                                    ? _textSelectedColor
                                    : _textTopColor),
                          ),
                          Text(
                            "元",
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(42),
                                color: _selectIndex == valueIndex
                                    ? _textSelectedColor
                                    : _textTopColor),
                          ),
                        ],
                      ),
                      Text(
                        //
                        "售价${dataItem.useMoney}元",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(32),
                            color: _selectIndex == valueIndex
                                ? _textSelectedColor
                                : _textBottomColor),
                      ),
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  textSelectColor: _textSelectedColor,
                  selected: _selectIndex == valueIndex,
                  onSelected: (v) {
                    _phoneFocusNode.unfocus();
                    setState(() {
                      _selectIndex = valueIndex;
                    });
                  },
                );
              }).toList()
            : <Widget>[],
      ),
    );
  }

  Widget buildphoneInputContainer() {
    return Container(
      height: ScreenUtil().setHeight(162),
      width: double.maxFinite,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.number,
              focusNode: _phoneFocusNode,
              onChanged: (value) {},
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
                hintText: '请输入手机号',
                hintStyle: TextStyle(
                    color: Color(0xffb9b9b9), fontSize: ScreenUtil().setSp(42)),
              ),
            ),
          ),
          Image.asset(
            "static/images/icon_contact.png",
            width: ScreenUtil().setWidth(137),
            height: ScreenUtil().setHeight(83.5),
          ),
        ],
      ),
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
                        "话费支付",
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
                            text: " ${_selectedRechargeData.payMoney}",
                            style: TextStyle(
                                color: GlobalConfig.taskHeadColor,
                                fontSize: 18)),
                        /*   TextSpan(
                            text: ".00",
                            style: TextStyle(
                                color: GlobalConfig.taskHeadColor,
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
                          var result =
                              await HttpManage.getRechargeWeChatPayInfo(
                                  _phoneController.text,
                                  _selectedRechargeData.id);
                          if (result.status) {
                            _payNo = result.data.payNo;
                            callWxPay(result.data);
                          } else {
                            CommonUtils.showToast(result.errMsg);
                          }
                        } else if (_payWay == 2) {
                          var result = await HttpManage.getRechargeAliPayInfo(
                              _phoneController.text, _selectedRechargeData.id);
                          if (result.status) {
                            _payInfo = result.data.payInfo;
                            _payNo = result.data.payNo;
                            callAlipay();
                          } else {
                            CommonUtils.showToast(result.errMsg);
                          }
                        } else {
                          CommonUtils.showToast("请选择支付方式！");
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
                            Color(0xFF489FFF),
                            Color(0xFF489FFF),
                          ]),
                        ),
                        child: Text(
                          "支付",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(52)),
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
}
