import 'package:flutter/material.dart';
import 'package:flutter_alipay/flutter_alipay.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:star/global_config.dart';
import 'package:star/http/ktkj_http_manage.dart';
import 'package:star/models/wechat_payinfo_entity.dart';
import 'package:star/pages/ktkj_task/ktkj_pay_result.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_octoimage.dart';
import 'package:star/utils/ktkj_common_utils.dart';
import 'package:star/utils/ktkj_navigator_utils.dart';

///油卡充值
class KTKJOilRechargePage extends StatefulWidget {
  KTKJOilRechargePage({Key key}) : super(key: key);
  final String title = "油卡充值";

  @override
  _KTKJOilRechargePageState createState() => _KTKJOilRechargePageState();
}

class _KTKJOilRechargePageState extends State<KTKJOilRechargePage> {
  final Color _requestDescBgColor = Color(0xffFFF0D1);

//  final Color _requestDescTxtColor = Color(0xffD95E00);
  final Color _requestDescTxtColor = Color(0xffDC6000);
  final Color _nickColor = Color(0xff576A94);
  final Color _bgGreyColor = Color(0xffF5F5F5);
  var _requestDesc = '由于渠道官方原因该商品为溢价商品，请慎重充值！';
  var _oilPrice = '';
  var _textGray = Color(0xff999999);
  var _payPrice = '';
  var _coin = '';
  var _oilCardNumController;
  var _phoneController;
  var _nameController;
  var _oilCardNum;
  var _phone;
  var _name;

  int _payway = 1;
  var _payNo;

  Future<void> _initData() async {
    var result = await HttpManage.gasolineGetInfo();
    if (result.status) {
      if (mounted) {
        setState(() {
          _oilPrice = result.data.info.faceMoney;
          _payPrice = result.data.info.money;
          _coin = result.data.info.coin;
        });
      }
    }
  }

  _initWeChatResponseHandler() {
    KTKJGlobalConfig.payType = 5;
    fluwx.weChatResponseEventHandler.listen((res) async {
      if (res is fluwx.WeChatPaymentResponse) {
//        print("_result = " + "pay :${res.isSuccessful}");
        if (res.isSuccessful && KTKJGlobalConfig.payType == 5) {
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
          KTKJCommonUtils.showToast("支付失败");
          break;
        case "2": //已成功
          KTKJNavigatorUtils.navigatorRouterAndRemoveUntil(
              context,
              KTKJPayResultPage(
                payNo: _payNo,
                type: 1,
                title: '支付成功',
              ));
          break;
      }
    } else {
      KTKJCommonUtils.showToast(result.errMsg);
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
    super.initState();
    _initWeChatResponseHandler();
    _initData();
    _oilCardNumController = TextEditingController();
    _phoneController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _oilCardNumController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
      child: KeyboardDismissOnTap(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                widget.title,
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
              backgroundColor: KTKJGlobalConfig.taskNomalHeadColor,
              centerTitle: true,
//          backgroundColor: Color(0xfff5f5f5),
              elevation: 0,
            ),
            body: Stack(
              children: <Widget>[
                Container(
                  color: KTKJGlobalConfig.taskNomalHeadColor,
                  width: double.infinity,
                  height: double.infinity,
                  margin: EdgeInsets.only(bottom: 100),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        buildDescVisibility(),
                        buildMainContainer(),
                        buildSubmitButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ) // ThThis trailing comma makes auto-formatting nicer for build methods.
            ),
      ),
    );
  }

  Widget buildMainContainer() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(32), vertical: 16),
      child: Column(
        children: <Widget>[
          buildOilTypeContainer(),
          buildOilRechargeInfoContainer(),
          buildRechargeProfitDesc(),
        ],
      ),
    );
  }

  Container buildRechargeProfitDesc() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        vertical: ScreenUtil().setHeight(30),
      ),
      margin: EdgeInsets.only(
        top: ScreenUtil().setHeight(30),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            ScreenUtil().setWidth(30),
          ),
          topRight: Radius.circular(
            ScreenUtil().setWidth(30),
          ),
          bottomLeft: Radius.circular(
            ScreenUtil().setWidth(30),
          ),
          bottomRight: Radius.circular(
            ScreenUtil().setWidth(30),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  "* 油卡充值成功后可得",
                  style: TextStyle(
                    color: Color(0xff666666),
                    fontSize: ScreenUtil().setSp(32),
                  ),
                ),
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(69),
                ),
              ),
              Container(
                child: Text(
                  "$_coin分红金！",
                  style: TextStyle(
                    color: Color(0xffF32E43),
                    fontSize: ScreenUtil().setSp(32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container buildOilRechargeInfoContainer() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        vertical: ScreenUtil().setHeight(30),
      ),
      margin: EdgeInsets.only(
        top: ScreenUtil().setHeight(30),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            ScreenUtil().setWidth(30),
          ),
          topRight: Radius.circular(
            ScreenUtil().setWidth(30),
          ),
          bottomLeft: Radius.circular(
            ScreenUtil().setWidth(30),
          ),
          bottomRight: Radius.circular(
            ScreenUtil().setWidth(30),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: KTKJMyOctoImage(
                  image:
                      "https://alipic.lanhuapp.com/xdc806fd9a-cefa-40cc-a6e8-6baeeaaceebf",
                  width: ScreenUtil().setWidth(48),
                  height: ScreenUtil().setWidth(37),
                ),
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(69),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(39),
                  ),
                  child: TextField(
                    controller: _oilCardNumController,
                    onChanged: (value) {
                      _oilCardNum = value;
                    },
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(42),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '请输入加油卡号',
                      hintStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(42),
                        color: _textGray,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                "（暂仅支持中国石化）",
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(32),
                  color: Color(0xfff93736),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: KTKJMyOctoImage(
                  image:
                      "https://alipic.lanhuapp.com/xdecf74934-eebe-426f-a742-497544cdac60",
                  width: ScreenUtil().setWidth(32),
                  height: ScreenUtil().setWidth(48),
                ),
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(69),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(39),
                  ),
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _phone = value;
                    },
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(42),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '请输入手机号码',
                      hintStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(42),
                        color: _textGray,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                "（暂仅支持中国石化）",
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(32),
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: KTKJMyOctoImage(
                  image:
                      "https://alipic.lanhuapp.com/xdfafe95e9-2fcc-4fc7-a572-3c1d6d818f5a",
                  width: ScreenUtil().setWidth(41),
                  height: ScreenUtil().setWidth(44),
                ),
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(69),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(39),
                  ),
                  child: TextField(
                    controller: _nameController,
                    onChanged: (value) {
                      _name = value;
                    },
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(42),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '请输入姓名',
                      hintStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(42),
                        color: _textGray,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                "（暂仅支持中国石化）",
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(32),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container buildOilTypeContainer() {
    return Container(
      width: double.maxFinite,
      height: ScreenUtil().setWidth(192),
      decoration: BoxDecoration(
        color: Color(0xffF36A2E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            ScreenUtil().setWidth(30),
          ),
          topRight: Radius.circular(
            ScreenUtil().setWidth(30),
          ),
          bottomLeft: Radius.circular(
            ScreenUtil().setWidth(30),
          ),
          bottomRight: Radius.circular(
            ScreenUtil().setWidth(30),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: KTKJMyOctoImage(
              image:
                  "https://alipic.lanhuapp.com/xd0e0632d2-4861-4d95-8088-1c3629c7313a",
              width: ScreenUtil().setWidth(122),
              height: ScreenUtil().setWidth(122),
            ),
            margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(69),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(39),
              ),
              child: Text(
                "$_oilPrice元",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(74),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            child: KTKJMyOctoImage(
              image:
                  "https://alipic.lanhuapp.com/xd45b79d01-ef3e-436d-b165-f10a7d6bce45",
              width: ScreenUtil().setWidth(323),
              height: ScreenUtil().setWidth(112),
            ),
            margin: EdgeInsets.only(
              right: ScreenUtil().setWidth(36),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDescVisibility() {
    return Visibility(
        visible: !KTKJCommonUtils.isEmpty(_requestDesc),
        child: Container(
            width: double.infinity,
            color: _requestDescBgColor,
            padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setHeight(30),
                horizontal: ScreenUtil().setWidth(32)),
            child: Text(
              "$_requestDesc",
              style: TextStyle(
                color: _requestDescTxtColor,
                fontSize: ScreenUtil().setSp(32),
              ),
            )));
  }

  ///提交审核
  Widget buildSubmitButton() {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: double.maxFinite,
          child: GestureDetector(
            onTap: () async {
              if (KTKJCommonUtils.isEmpty(_phone) ||
                  KTKJCommonUtils.isEmpty(_oilCardNum) ||
                  KTKJCommonUtils.isEmpty(_name)) {
                KTKJCommonUtils.showToast("必填项内容未填写！");
                return;
              }
              if (!KTKJCommonUtils.isPhoneLegal(_phone)) {
                KTKJCommonUtils.showToast("请输入正确的手机号！");
                return;
              }
              _showSelectPayWayBottomSheet();
              /* 'title': await item.title,
        'addressDetail': distance +
        await item.provinceName +
        await item.cityName +
        await item.adName +
        await item.address,
        'position': await item.latLng,
        'distance': distance,
        'latitude': endlat.latitude,
        'longitude': endlat.longitude,
        'provinceName': await item.provinceName,
        'cityName': await item.cityName,
        'adName': await item.adName,
        'address': await item.address,*/

//              HttpManage.s
              /*String imgIds = allImgIds.join(",");
              if (widget.pageType == 0) {
                ///提交任务
                var result = await HttpManage.taskReSubmit(widget.comId, imgIds,
                    remark: _remark);
                if (result.status) {
                  KTKJCommonUtils.showToast("提交成功");
                  KTKJNavigatorUtils.navigatorRouterAndRemoveUntil(
                      context, KTKJTaskIndexPage());
                } else {
                  KTKJCommonUtils.showToast(result.errMsg);
                }
              } else {
                ///重新提交任务
                var result = await HttpManage.taskReSubmit(widget.comId, imgIds,
                    remark: _remark);
                if (result.status) {
                  KTKJCommonUtils.showToast("提交成功");
                  KTKJNavigatorUtils.navigatorRouterAndRemoveUntil(
                      context, KTKJTaskIndexPage());
                } else {
                  KTKJCommonUtils.showToast(result.errMsg);
                }

                ///
              }*/
            },
            child: Container(
              width: ScreenUtil().setWidth(673),
              height: ScreenUtil().setWidth(140),
              margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(60),
                vertical: ScreenUtil().setWidth(178),
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFFF36B2E), Color(0xFFF32E43)]),
                  borderRadius: BorderRadius.circular(70)),
              child: Text(
                '售价$_payPrice',
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(48)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _showSelectPayWayBottomSheet() {
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
                        "${widget.title}",
                        style: TextStyle(
                          color: Color(0xFF222222),
                          fontSize: ScreenUtil().setSp(48),
                        ),
                      ),
                      trailing: Text.rich(TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: "¥",
                            style: TextStyle(
                              color: KTKJGlobalConfig.taskHeadColor,
                              fontSize: ScreenUtil().setSp(42),
                            )),
                        TextSpan(
                            text: " $_payPrice",
                            style: TextStyle(
                              color: KTKJGlobalConfig.taskHeadColor,
                              fontSize: ScreenUtil().setSp(48),
                            )),
                        /*TextSpan(
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
                        style: TextStyle(
                          color: Color(0xFF222222),
                          fontSize: ScreenUtil().setSp(42),
                        ),
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
                        style: TextStyle(
                          color: Color(0xFF222222),
                          fontSize: ScreenUtil().setSp(42),
                        ),
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
                          try {
                            EasyLoading.show();
                          } catch (e) {}
                          var result =
                              await HttpManage.gasolinePayWeChatPayInfo(
                            cardNo: _oilCardNum,
                            phone: _phone,
                            name: _name,
                          );
                          try {
                            EasyLoading.dismiss();
                          } catch (e) {}
                          if (result.status) {
                            _payNo = result.data.payNo;
                            callWxPay(result.data);
                          } else {
                            KTKJCommonUtils.showToast(result.errMsg);
                          }
                        } else if (_payway == 2) {
                          try {
                            EasyLoading.show();
                          } catch (e) {}
                          var result = await HttpManage.gasolinePayAliPayInfo(
                            cardNo: _oilCardNum,
                            phone: _phone,
                            name: _name,
                          );
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
                          KTKJCommonUtils.showToast("请选择支付方式");
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
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(42),
                          ),
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
}
