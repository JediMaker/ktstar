import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alipay/flutter_alipay.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:star/bus/my_event_bus.dart';
import 'package:star/global_config.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/wechat_payinfo_entity.dart';
import 'package:star/pages/task/pay_result.dart';
import 'package:star/pages/widget/my_octoimage.dart';
import 'package:star/pages/withdrawal/pay_password_setting.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';

class ShopPaymentPage extends StatefulWidget {
  var orderId;

  ShopPaymentPage({
    Key key,
    this.shopId,
    this.latitude,
    this.longitude,
    this.isOwnShop,
    this.balance,
    this.shopName,
    this.shopCode,
    this.hasPayPassword,
  }) : super(key: key);
  final String title = "商家收款";

  ///商家收款
  var shopId;
  var latitude = '';
  var longitude = '';
  var isOwnShop = false;
  var balance = '';
  var shopName = '';
  var shopCode = '';
  var hasPayPassword = true;

  @override
  _ShopPaymentPageState createState() => _ShopPaymentPageState();
}

class _ShopPaymentPageState extends State<ShopPaymentPage> {
  var _latitude;
  var _longitude;
  TextEditingController _payAmountController = new TextEditingController();
  FocusNode _payAmountFocusNode = FocusNode();
  String _payAmount;

  int _payway = 0;
  var _payNo;
  var _payPrice = '';
  var _balance = '';
  var _shopName = '';
  var _shopCode = '';
  bool _hasPayPassword = true;
  bool _canUseBalance = true;
  int _payWay = 3;

  Future _initData({bool onlyChangeAddress = false}) async {
    var entityResult = await HttpManage.getShopPayInfo(storeId: widget.shopId);
    if (entityResult.status) {
      if (mounted) {
        setState(() {
//        _payPrice = entityResult.data.payPrice;
//        _oUserInfo = entityResult.data.userInfo;
          _balance = entityResult.data.user.price;
          _hasPayPassword = entityResult.data.user.payPwdFlag;
          _shopName = entityResult.data.store.storeName;
          _shopCode = entityResult.data.store.storeCode;
        });
      }
    }
    try {
      EasyLoading.dismiss();
    } catch (e) {}
  }

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

  showPayPasswordDialog(BuildContext context, orderId) {
    return NavigatorUtils.showGSYDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: SimpleDialog(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Center(
                            child: Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(30),
                          ),
                          child: Column(
                            children: [
                              new Text(
                                "请输入支付密码",
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(48),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setWidth(44),
                                ),
                                child: new Text(
                                  "$_shopName",
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(48),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  new Text(
                                    "￥",
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(68),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  new Text(
                                    "$_payAmount",
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(99),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(vertical: 30),
                          child: PinCodeTextField(
                            length: 6,
                            obsecureText: true,
                            autoFocus: true,
                            animationType: AnimationType.fade,
                            mainAxisAlignment: MainAxisAlignment.center,
                            autoDismissKeyboard: true,
                            textInputType: TextInputType.number,
                            errorTextSpace: 0,
                            textStyle:
                                TextStyle(fontSize: ScreenUtil().setSp(42)),
                            validator: (v) {
                              if (v.length < 3) {
                                return "I'm from validator";
                              } else {
                                return null;
                              }
                            },

                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderWidth: ScreenUtil().setWidth(1),
                              borderRadius: BorderRadius.circular(0),
                              fieldHeight: ScreenUtil().setWidth(120),
                              fieldWidth: ScreenUtil().setWidth(120),
                              activeColor: Colors.grey[400],
                              //Color(0xffeaeaea),
                              activeFillColor: Colors.white,
                              selectedColor: Colors.grey[400],
                              // Color(0xffeaeaea),
                              selectedFillColor: Colors.white,
                              inactiveColor: Colors.grey[400],
                              //Color(0xffeaeaea),
                              inactiveFillColor: Colors.white,
                              disabledColor: Colors.white,
                            ),
                            animationDuration: Duration(milliseconds: 300),
//                        backgroundColor: Colors.green.shade50,
                            enableActiveFill: true,
                            onCompleted: (v) async {
                              Navigator.pop(context);
                              try {
                                EasyLoading.show(status: "正在支付");
                                var result =
                                    await HttpManage.getShopPayBalanceInfo(
                                        payMoney: _payAmount,
                                        shopCode: _shopCode,
                                        payPassword: v);
                                EasyLoading.dismiss();
                                if (result.status) {
                                  _payInfo = result.data.payInfo;
                                  _payNo = result.data.payNo;
                                  /* if (result.data.finish) {
                                    NavigatorUtils
                                        .navigatorRouterAndRemoveUntil(
                                            this.context,
                                            PayResultPage(
                                              payNo: _payNo,
                                              type: 1,
                                              title: '支付成功',
                                            ));
                                    return;
                                  }*/
                                  _checkPayStatus();
                                } else {
                                  CommonUtils.showToast(result.errMsg);
                                }
                              } catch (e) {
                                EasyLoading.dismiss();
                              }
                            },
                            onChanged: (value) {
                              print(value);
                            },
                            beforeTextPaste: (text) {
                              print("Allowing to paste $text");
                              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                              //but you can show anything you want here, like your pop up saying wrong paste format or etc
                              return true;
                            },
                          ),
                        ),
                      ],
                    ),
                    Positioned.fill(
                      top: 0,
                      left: 0,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                            onTap: () {
//                    launch(Address.updateUrl);
                              Navigator.pop(context);
                            },
                            child: Container(
                                width: ScreenUtil().setWidth(120),
                                height: ScreenUtil().setWidth(120),
                                alignment: Alignment.topCenter,
                                child: FlatButton(
                                  child: new Icon(
                                    CupertinoIcons.clear_thick,
                                    color: Color(0xff999999),
                                    size: ScreenUtil().setSp(56),
                                  ),
                                ))),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget _buildDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('提示'),
      content: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          '您还未设置余额支付密码，是否去设置？',
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(
            '取消',
            style: TextStyle(
              color: Color(0xff222222),
              fontSize: ScreenUtil().setSp(42),
            ),
          ),
          onPressed: () async {
            Navigator.pop(context, false);
          },
        ),
        CupertinoDialogAction(
          child: Text(
            '去设置',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(42),
            ),
          ),
          onPressed: () async {
            Navigator.pop(context, false);
            NavigatorUtils.navigatorRouter(
                context,
                PayPasswordSettingPage(
                  pageType: 0,
                  refreshCheckOutCounterPage: true,
                ));
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _initWeChatResponseHandler();
    bus.on("refreshCheckOutCounterPage", (refresh) {
      if (refresh) {
        _initData();
      }
    });
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
    _payAmountFocusNode.dispose();
    _payAmountController.dispose();
  }

  var _shopTypeBgColor = Color(0xffFFF0EB);
  var _shopTypeTxtColor = Color(0xffFF8D56);
  var _shopDistanceBgColor = Color(0xffFDF6DF);
  var _shopDistanceTxtColor = Color(0xffEDA703);
  var _shopNameTxtColor = Color(0xff222222);
  var _shopLocationTxtColor = Color(0xff666666);
  var _shopLocationIconUrl =
      "https://alipic.lanhuapp.com/xd7535be55-da9e-45c7-a98d-dc5a3207f662";

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: FlutterEasyLoading(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                widget.title,
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(54)),
              ),
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
              centerTitle: true,
              brightness: Brightness.dark,
              backgroundColor: Color(0xff0F0F0F),
              elevation: 0,
            ),
            body: Container(
              color: Color(0xfff6f6f6),
              height: double.infinity,
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(30),
                vertical: ScreenUtil().setWidth(40),
              ),
              child: Column(
                children: [
                  Container(
                    height: ScreenUtil().setWidth(225),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(62),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xffFBFAFA),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          ScreenUtil().setWidth(10),
                        ),
                        topRight: Radius.circular(
                          ScreenUtil().setWidth(10),
                        ),
                      ),
                    ),
                    child: Text(
                      "商家名称:    $_shopName",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xff222222),
                        fontSize: ScreenUtil().setSp(48),
                      ),
                    ),
                  ),
                  Container(
                    height: ScreenUtil().setWidth(434),
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(62),
                      right: ScreenUtil().setWidth(62),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                          ScreenUtil().setWidth(10),
                        ),
                        bottomRight: Radius.circular(
                          ScreenUtil().setWidth(10),
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(72),
                            bottom: ScreenUtil().setWidth(40),
                          ),
                          child: Text(
                            "消费金额",
                            style: TextStyle(
                              color: Color(0xffafafaf),
                              fontSize: ScreenUtil().setSp(38),
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "￥",
                              style: TextStyle(
//                color:  Color(0xFF222222) ,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(87)),
                            ),
                            Expanded(
                              child: buildPayAmountContainer(),
                            ),
                            /*GestureDetector(
                              onTap: () {
                                _payAmountController.text = "";
                                _payAmount = "";
                              },
                              child: Image.asset(
                                "static/images/money_del.png",
                                width: ScreenUtil().setWidth(45),
                                height: ScreenUtil().setWidth(45),
                                fit: BoxFit.fill,
                              ),
                            ),*/
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setWidth(20),
                        ),
                        Divider(
                          height: ScreenUtil().setWidth(1),
                          color: Color(0xFFE6E5E5),
                        ),
                        SizedBox(
                          height: ScreenUtil().setWidth(55),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: ScreenUtil().setWidth(180),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(62),
                    ),
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setWidth(30),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xffFBFAFA),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          ScreenUtil().setWidth(10),
                        ),
                        topRight: Radius.circular(
                          ScreenUtil().setWidth(10),
                        ),
                      ),
                    ),
                    child: Text(
                      "请选择支付方式",
                      style: TextStyle(
                        color: Color(0xff222222),
                        fontSize: ScreenUtil().setSp(48),
                      ),
                    ),
                  ),
                  Container(
                    height: ScreenUtil().setWidth(506),
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(62),
                      right: ScreenUtil().setWidth(62),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                          ScreenUtil().setWidth(10),
                        ),
                        bottomRight: Radius.circular(
                          ScreenUtil().setWidth(10),
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          onTap: () async {
                            setState(() {
                              _payWay = 1;
                            });
                          },
                          selected: _payWay == 1,
                          leading: MyOctoImage(
                            image:
                                'https://alipic.lanhuapp.com/xdb61f0e63-777a-485a-97c7-ecdd8e261ff2',
                            width: ScreenUtil().setWidth(78),
                            height: ScreenUtil().setWidth(78),
                            fit: BoxFit.fill,
                          ),
                          title: Text(
                            '支付宝',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(48),
                              color: Color(0xff222222),
                            ),
                          ),
                          trailing: MyOctoImage(
                            image:
                                "${_payWay == 1 ? "https://alipic.lanhuapp.com/xdfa5fc964-b765-41b5-ada7-c89372b1d61d" : "https://alipic.lanhuapp.com/xd9cbbe519-1886-421d-a02e-27d8c33cfc90"}",
                            width: ScreenUtil().setWidth(60),
                            height: ScreenUtil().setWidth(60),
                            fit: BoxFit.fill,
                          ),
                        ),
                        ListTile(
                          onTap: () async {
                            setState(() {
                              _payWay = 2;
                            });
                          },
                          selected: _payWay == 2,
                          leading: MyOctoImage(
                            image:
                                'https://alipic.lanhuapp.com/xdb0f27927-d450-4cc2-a0df-4147410870e7',
                            width: ScreenUtil().setWidth(78),
                            height: ScreenUtil().setWidth(78),
                            fit: BoxFit.fill,
                          ),
                          title: Text(
                            '微信',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(48),
                              color: Color(0xff222222),
                            ),
                          ),
                          trailing: MyOctoImage(
                            image:
                                "${_payWay == 2 ? "https://alipic.lanhuapp.com/xdfa5fc964-b765-41b5-ada7-c89372b1d61d" : "https://alipic.lanhuapp.com/xd9cbbe519-1886-421d-a02e-27d8c33cfc90"}",
                            width: ScreenUtil().setWidth(60),
                            height: ScreenUtil().setWidth(60),
                            fit: BoxFit.fill,
                          ),
                        ),
                        Visibility(
                          //todo
                          visible: true,
                          child: Opacity(
                            opacity: _canUseBalance ? 1 : 0.6,
                            child: ListTile(
                              onTap: () async {
                                if (!_canUseBalance) {
                                  CommonUtils.showToast("账户余额不足！");
                                  return;
                                }
                                setState(() {
                                  _payWay = 3;
                                });
                              },
                              selected: _payWay == 3,
                              leading: MyOctoImage(
                                image:
                                    'https://alipic.lanhuapp.com/xdd5f9c369-8c30-4f93-bcf0-151a16b97220',
                                width: ScreenUtil().setWidth(78),
                                height: ScreenUtil().setWidth(78),
                                fit: BoxFit.fill,
                              ),
                              title: Text(
                                '余额支付', //(可用余额:￥$_balance)
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(48),
                                  color: Color(0xff222222),
                                ),
                              ),
                              trailing: MyOctoImage(
                                image:
                                    "${_payWay == 3 ? "https://alipic.lanhuapp.com/xdfa5fc964-b765-41b5-ada7-c89372b1d61d" : "https://alipic.lanhuapp.com/xd9cbbe519-1886-421d-a02e-27d8c33cfc90"}",
                                width: ScreenUtil().setWidth(60),
                                height: ScreenUtil().setWidth(60),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildBtnLayout(),
                ],
              ),
            ) // This trailing comma makes auto-formatting nicer for build methods.
            ),
      ),
    );
  }

  Widget buildPayAmountContainer() {
    return Container(
      height: ScreenUtil().setWidth(180),
      alignment: Alignment.center,
//      margin: EdgeInsets.only(left: 24, right: 24, top: 20),
      margin: EdgeInsets.symmetric(horizontal: 10),
      /*padding: EdgeInsets.only(
        top: ScreenUtil().setWidth(16),
      ),*/
      decoration: BoxDecoration(
//        color: Color(0xFFF5F5F5),
//        borderRadius: BorderRadius.circular(48),
          ),
      child: Container(
        margin: EdgeInsets.only(
          right: ScreenUtil().setWidth(66),
          top: ScreenUtil().setWidth(16),
        ),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Color(0xFF222222),
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil().setSp(99)),
          controller: _payAmountController,
          focusNode: _payAmountFocusNode,
          keyboardType: TextInputType.number,
          maxLengthEnforced: false,
          onChanged: (value) {
            setState(() {
              _payAmount = value.trim();
              if (CommonUtils.isEmpty(_payAmount)) {
                return;
              }
              try {
                if (mounted) {
                  setState(() {
                    if (double.parse(_balance) > double.parse(_payAmount)) {
                      _canUseBalance = true;
                    } else {
                      _canUseBalance = false;
                      _payWay = 1;
                    }
                  });
                }
              } catch (e) {}
            });
          },
          decoration: InputDecoration(
              /* labelText: widget.address.name == null
                                    ? ''
                                    : widget.address.name,*/
              border: InputBorder.none,
              hintText: '请输入消费金额',
              hintStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: ScreenUtil().setSp(42),
              )),
        ),
      ),
    );
  }

  invokeWxPay() async {
    try {
      EasyLoading.show();
      var result = await HttpManage.getShopPayWeChatPayInfo(
          payMoney: _payAmount, shopCode: _shopCode);
      EasyLoading.dismiss();
      if (result.status) {
        _payNo = result.data.payNo;
        /*if (result.data.finish) {
          NavigatorUtils.navigatorRouterAndRemoveUntil(
              context,
              PayResultPage(
                payNo: _payNo,
                type: 1,
                title: '支付成功',
              ));
          return;
        }*/
        callWxPay(result.data);
      } else {
        CommonUtils.showToast(result.errMsg);
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  invokeAlipay() async {
    try {
      EasyLoading.show();
      var result = await HttpManage.getShopPayAliPayInfo(
          payMoney: _payAmount, shopCode: _shopCode);
      EasyLoading.dismiss();
      if (result.status) {
        _payInfo = result.data.payInfo;
        _payNo = result.data.payNo;
        /*if (result.data.finish) {
          NavigatorUtils.navigatorRouterAndRemoveUntil(
              context,
              PayResultPage(
                payNo: _payNo,
                type: 1,
                title: '支付成功',
              ));
          return;
        }*/
        callAlipay();
      } else {
        CommonUtils.showToast(result.errMsg);
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  Widget buildBtnLayout() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        top: ScreenUtil().setHeight(257),
      ),
      child: Ink(
        child: InkWell(
            onTap: () async {
              if (CommonUtils.isEmpty(_payAmount)) {
                CommonUtils.showToast("请输入消费金额");
                return;
              }
              switch (_payWay) {
                case 1:
                  invokeAlipay();
                  break;
                case 2:
                  invokeWxPay();
                  break;
                case 3:
                  if (!_hasPayPassword) {
                    showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) => _buildDialog(context),
                      barrierDismissible: false,
                    );
                    return;
                  }
                  showPayPasswordDialog(context, widget.orderId);
                  break;
              }
            },
            child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 30),
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: ScreenUtil().setHeight(152),
                width: ScreenUtil().setWidth(810),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(100)),
                    color: Color(0xff3EB036)),
                child: Text(
                  "确认支付",
                  style: TextStyle(
                      color: Colors.white, fontSize: ScreenUtil().setSp(48)),
                ))),
      ),
    );
  }
}
