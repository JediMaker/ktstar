import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alipay/flutter_alipay.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:star/http/ktkj_api.dart';
import 'package:star/http/ktkj_http_manage.dart';
import 'package:star/models/recharge_entity.dart';
import 'package:star/models/vip_price_info_entity.dart';
import 'package:star/models/wechat_payinfo_entity.dart';
import 'package:star/pages/ktkj_task/ktkj_pay_result.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_webview.dart';
import 'package:star/pages/ktkj_widget/ktkj_select_choice.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:star/utils/ktkj_common_utils.dart';
import 'package:star/utils/ktkj_navigator_utils.dart';
import 'package:star/utils/ktkj_utils.dart';
import '../../global_config.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJTaskOpenVipPage extends StatefulWidget {
  KTKJTaskOpenVipPage({Key key, this.taskType = 1}) : super(key: key);
  final String title = "会员中心";
  int taskType;

  @override
  _TaskOpenVipPageState createState() => _TaskOpenVipPageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _TaskOpenVipPageState extends State<KTKJTaskOpenVipPage> {
  var _vipIncome = '10';
  var _vipPrice = '199';
  var _diamondVipIncome = '20';
  var _diamondVipPrice = '799';
  bool _isDiamondVip = false;
  Color _textTopColor = Color(0xff0A7FFF);
  Color _textBottomColor = Color(0xff666666);
  Color _layoutSelectedColor = Colors.white;
  int _selectIndex = -1;
  String _selectPrice = "";
  int _currentIndex = 0;
  int _payway = 0;
  var _payNo;

  VipPriceInfoVip _vipInfo;
  VipPriceInfoDiamond _diamondInfo;

  _initWeChatResponseHandler() {
    KTKJGlobalConfig.payType = 0;
    fluwx.weChatResponseEventHandler.listen((res) async {
      if (res is fluwx.WeChatPaymentResponse) {
//        print("_result = " + "pay :${res.isSuccessful}");
        if (res.isSuccessful && KTKJGlobalConfig.payType == 0) {
          _checkPayStatus();
        }
      }
    });
  }

  _initData() async {
    var result = await HttpManage.getVipPrice();
    if (result.status) {
      if (mounted) {
        setState(() {
          _vipInfo = result.data.vip;
          _diamondInfo = result.data.diamond;
          if (_vipInfo.moneyList.length > 0 &&
              !KTKJCommonUtils.isEmpty(_vipInfo.moneyList[0]) &&
              _vipInfo.moneyList[0].flag &&
              !_isDiamondVip) {
            _selectIndex = 0;
          }
          if (_diamondInfo.moneyList.length > 0 &&
              !KTKJCommonUtils.isEmpty(_diamondInfo.moneyList[0]) &&
              _diamondInfo.moneyList[0].flag &&
              _isDiamondVip) {
            _selectIndex = 0;
          }
        });
      }
    }
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
              ));
          break;
      }
    } else {
      KTKJCommonUtils.showToast(result.errMsg);
    }
  }

  @override
  void initState() {
    _initWeChatResponseHandler();
    if (mounted) {
      setState(() {
        if (widget.taskType != 1) {
          _currentIndex = 1;
          _isDiamondVip = true;
          _selectIndex = -1;
        }
      });
    }
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
        appBar: GradientAppBar(
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
          gradient: LinearGradient(colors: [
            Color(0xff111214),
            Color(0xff303036),
          ]),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        ClipPath(
                          // 只裁切底部的方法
                          clipper: BottomClipper(),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color(0xff111214),
                                Color(0xff303036),
                              ]),
                            ),
                            height: ScreenUtil().setHeight(550),
                          ),
                        ),
                        Container(
                          height: ScreenUtil().setHeight(573),
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setHeight(138),
                            left: ScreenUtil().setWidth(38),
                            right: ScreenUtil().setWidth(38),
                          ),
                          child: Swiper(
                            itemCount: 2,
                            autoplay: false,
                            loop: false,
                            viewportFraction: 0.86,
                            scale: 0.96,
                            index: _currentIndex,
                            onIndexChanged: (index) {
                              if (mounted) {
                                setState(() {
                                  _currentIndex = index;
                                  _selectIndex = -1;
                                  if (_currentIndex == 0) {
                                    //VIP会员
                                    _isDiamondVip = false;
                                    if (_vipInfo.moneyList.length > 0 &&
                                        !KTKJCommonUtils.isEmpty(
                                            _vipInfo.moneyList[0]) &&
                                        _vipInfo.moneyList[0].flag) {
                                      _selectIndex = 0;
                                    }
                                  } else {
                                    ///钻石会员
                                    _isDiamondVip = true;
                                    if (_diamondInfo.moneyList.length > 0 &&
                                        !KTKJCommonUtils.isEmpty(
                                            _diamondInfo.moneyList[0]) &&
                                        _diamondInfo.moneyList[0].flag) {
                                      _selectIndex = 0;
                                    }
                                  }
                                });
                              }
                            },
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return buildVipCard();
                              } else {
                                return buildDiamondVipCard();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    benefitsRow(),
                  ],
                ),
              ),
              buildSetMealLayout(),
              Visibility(
                child: GestureDetector(
                  onTap: () async {
                    if (_selectIndex == -1) {
                      KTKJCommonUtils.showToast("请选择会员卡类型");
                      return;
                    }
                    //标语
                    _showSelectPayWayBottomSheet(context);
                  },
                  child: Container(
                    //diamond
                    height: ScreenUtil().setHeight(140),
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(97),
                      left: 16,
                      right: 16,
                      bottom: ScreenUtil().setHeight(32),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(46)),
                      gradient: LinearGradient(colors: [
                        Color(0xFF222328),
                        Color(0xFF222222),
                      ]),
                    ),
                    child: Text(
                      "立即开通",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(42)),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    bottom: ScreenUtil().setHeight(70),
                    left: ScreenUtil().setWidth(32),
                    right: ScreenUtil().setWidth(32)),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    Text(
                      "开通VIP前阅读",
                      style: TextStyle(
                        color: Color(0xffAFAFAF),
                        fontSize: ScreenUtil().setSp(32),
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        "《会员服务协议》",
                        style: TextStyle(
                          color: Color(0xffAFAFAF),
                          fontSize: ScreenUtil().setSp(32),
                        ),
                      ),
                      onTap: () {
                        KTKJNavigatorUtils.navigatorRouter(
                            context,
                            KTKJWebViewPage(
                              initialUrl: APi.AGREEMENT_SERVICES_URL,
                              showActions: false,
                              title: "服务协议",
                            ));
                      },
                    ),
                    Text(
                      "及",
                      style: TextStyle(
                        color: Color(0xffAFAFAF),
                        fontSize: ScreenUtil().setSp(32),
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        "《隐私条款》",
                        style: TextStyle(
                          color: Color(0xffAFAFAF),
                          fontSize: ScreenUtil().setSp(32),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return KTKJWebViewPage(
                            initialUrl: APi.AGREEMENT_PRIVACY_URL,
                            title: "隐私政策",
                          );
                        }));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  ///vip价格展示布局
  Widget buildVipCard() {
    var name = '';
    var profit_day = '';
    var desc = '';
    var year_money = '';
    var b_year_money = '';
    try {
      name = _vipInfo.name;
      profit_day = _vipInfo.profitDay;
      desc = _vipInfo.desc;
      year_money = _vipInfo.yearMoney;
      b_year_money = _vipInfo.bYearMoney;
    } catch (e) {}
    return Container(
      width: double.maxFinite,
      height: ScreenUtil().setHeight(473),
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: Image.asset(
                "static/images/task_mine_card_bg_vip1.png",
                fit: BoxFit.fill,
              ).image)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(50),
                vertical: ScreenUtil().setHeight(56)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  "$name",
                  style: TextStyle(
                      color: Color(
                        0xff222222,
                      ),
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(54)),
                ),
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(5)),
                  child: Image.asset(
                    "static/images/icon_o_vip.png",
                    width: ScreenUtil().setWidth(61),
                    height: ScreenUtil().setWidth(61),
                    fit: BoxFit.fill,
                  ),
                ),
                /*Text(
                  "(收益$profit_day元起/天)",
                  style: TextStyle(
                      color: Color(
                        0xff222222,
                      ),
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(36)),
                ),*/
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(50),
              vertical: ScreenUtil().setHeight(30),
            ),
            child: Wrap(
              children: <Widget>[
                Container(
                  child: Text(
                    "$desc，收益$profit_day元起/天",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Color(
                          0xff222222,
                        ),
                        fontSize: ScreenUtil().setSp(42)),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(50),
                  vertical: ScreenUtil().setHeight(33)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        color: Color(0xff222222),
                      ),
                      children: <InlineSpan>[
                        TextSpan(
                          text: "￥",
                        ),
                        TextSpan(
                          text: "$year_money",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(76),
                              color: Color(0xff222222),
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "/年",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(42),
                            color: Color(0xff222222),
                          ),
                        ),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Visibility(
                    visible: false,
                    child: Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(16)),
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: Color(0xff222222),
                          ),
                          children: <InlineSpan>[
                            TextSpan(
                              text: "（原价",
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(42),
                                color: Color(0xff222222),
                              ),
                            ),
                            TextSpan(
                              text: "$b_year_money",
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(42),
                                color: Color(0xff222222),
                              ),
                            ),
                            TextSpan(
                              text: "/年）",
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(42),
                                color: Color(0xff222222),
                              ),
                            ),
                          ],
                        ),
                        style:
                            TextStyle(decoration: TextDecoration.lineThrough),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  ///钻石vip价格展示布局
  Widget buildDiamondVipCard() {
    var name = '';
    var profit_day = '';
    var desc = '';
    var year_money = '';
    var b_year_money = '';
    try {
      name = _diamondInfo.name;
      profit_day = _diamondInfo.profitDay;
      desc = _diamondInfo.desc;
      year_money = _diamondInfo.yearMoney;
      b_year_money = _diamondInfo.bYearMoney;
    } catch (e) {}
    return Container(
      height: ScreenUtil().setHeight(473),
      decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFF222328),
          ),
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(32))),
          gradient: LinearGradient(colors: [
            Color(0xFF222328),
            Color(0xFF222222),
          ]),
          image: DecorationImage(
              fit: BoxFit.fill,
              image: Image.asset(
                "static/images/bg_diamond_card.png",
              ).image)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(50),
                vertical: ScreenUtil().setHeight(56)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "$name",
                  style: TextStyle(
                      color: Color(
                        0xffE3C19F,
                      ),
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(54)),
                ),
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(5)),
                  child: Image.asset(
                    "static/images/icon_o_diamond.png",
                    width: ScreenUtil().setWidth(60),
                    height: ScreenUtil().setWidth(60),
                    fit: BoxFit.fill,
                  ),
                ),
                /*Text(
                  "(收益$profit_day元起/天)",
                  style: TextStyle(
                      color: Color(
                        0xffE3C19F,
                      ),
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(36)),
                ),*/
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(50),
              vertical: ScreenUtil().setHeight(30),
            ),
            child: Wrap(
              children: <Widget>[
                Container(
                  child: Text(
                    "$desc，收益$profit_day元起/天",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Color(
                          0xffffffff,
                        ),
                        fontSize: ScreenUtil().setSp(42)),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(50),
                vertical: ScreenUtil().setHeight(33)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text.rich(TextSpan(
                  style: TextStyle(
                    color: Color(0xffE3C19F),
                  ),
                  children: <InlineSpan>[
                    TextSpan(
                      text: "￥",
                    ),
                    TextSpan(
                      text: "$year_money",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(76),
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "/年",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(42),
                      ),
                    ),
                  ],
                )),
                Visibility(
                  visible: false,
                  child: Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(16)),
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(
                          color: Color(0xffE3C19F),
                        ),
                        children: <InlineSpan>[
                          TextSpan(
                            text: "（原价",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(42),
                            ),
                          ),
                          TextSpan(
                            text: "$b_year_money",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(42),
                            ),
                          ),
                          TextSpan(
                            text: "/年）",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(42),
                            ),
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(decoration: TextDecoration.lineThrough),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  ///会员权益
  Widget benefitsRow() {
    var vipRewards = '20';
    var diamondVipRewards = '79.9';
    List<VipPriceInfoVipIconDesc> iconDesc = List<VipPriceInfoVipIconDesc>();
    List<VipPriceInfoDiamondIconDesc> iconDesc1 =
        List<VipPriceInfoDiamondIconDesc>();
    try {
      if (_isDiamondVip) {
        iconDesc1 = _diamondInfo.iconDesc;
      } else {
        iconDesc = _vipInfo.iconDesc;
      }
    } catch (e) {}
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 130,
          alignment: Alignment.center,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
                _isDiamondVip ? iconDesc1.length : iconDesc.length, (index) {
              var itemVip;
              var itemDiamond;
              if (_isDiamondVip) {
                itemDiamond = iconDesc1[index];
              } else {
                itemVip = iconDesc[index];
              }
              return benefitItem(
                  index: index, itemVip: itemVip, itemDiamond: itemDiamond);
            }),

            /*<Widget>[
              benefitItem(vipRewards, diamondVipRewards),
              new Container(
                width: MediaQuery.of(context).size.width / 3,
                child: new Container(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        margin: const EdgeInsets.only(bottom: 6.0),
                        child: new CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.transparent,
                          child: new Image.asset(
                            "static/images/${_isDiamondVip ? "icon_diamond2.png" : "icon_vip2.png"}",
                            width: ScreenUtil().setWidth(181),
                            height: ScreenUtil().setWidth(181),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      new Container(
                        child: new Text("${!_isDiamondVip ? "直推钻石会员" : "间推好友"}",
                            style: new TextStyle(
                                fontSize: ScreenUtil().setSp(36),
                                fontWeight: FontWeight.bold)),
                      ),
                      new Container(
                        margin: EdgeInsets.only(top: 4),
                        child: new Text(
                          "${!_isDiamondVip ? "一次性奖励$vipRewards元" : "一次性奖励$diamondVipRewards元"}",
                          style: new TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                              color: _textBottomColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              new Container(
                width: MediaQuery.of(context).size.width / 3,
                child: new Container(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        margin: const EdgeInsets.only(bottom: 6.0),
                        child: new CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.transparent,
                          child: new Image.asset(
                            "static/images/${_isDiamondVip ? "icon_diamond3.png" : "icon_vip3.png"}",
                            width: ScreenUtil().setWidth(181),
                            height: ScreenUtil().setWidth(181),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      new Container(
                        child: new Text("${!_isDiamondVip ? "基本收益" : "被动收益"}",
                            style: new TextStyle(
                                fontSize: ScreenUtil().setSp(36),
                                fontWeight: FontWeight.bold)),
                      ),
                      new Container(
                        margin: EdgeInsets.only(top: 4),
                        child: new Text(
                          "${!_isDiamondVip ? "每天10元起" : "好友任务收益的5%"}",
                          style: new TextStyle(
                              fontSize: ScreenUtil().setSp(32),
                              color: _textBottomColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],*/
          ),
        ),
      ),
    );
  }

  Container benefitItem(
      {VipPriceInfoVipIconDesc itemVip,
      VipPriceInfoDiamondIconDesc itemDiamond,
      int index}) {
    return new Container(
      width: MediaQuery.of(context).size.width / 3,
      child: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(bottom: 6.0),
              child: new CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.transparent,
                child: new Image.asset(
                  "static/images/${_isDiamondVip ? "icon_diamond${(index + 1)}.png" : "icon_vip${(index + 1)}.png"}",
                  width: ScreenUtil().setWidth(181),
                  height: ScreenUtil().setWidth(181),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            new Container(
              child: new Text(
                "${!_isDiamondVip ? "${itemVip.desc}" : "${itemDiamond.desc}"}",
                style: new TextStyle(
                    fontSize: ScreenUtil().setSp(36),
                    fontWeight: FontWeight.bold),
              ),
            ),
            new Container(
              margin: EdgeInsets.only(top: 4),
              child: new Text(
                "${!_isDiamondVip ? "${itemVip.subdesc}" : "${itemDiamond.subdesc}"}",
                style: new TextStyle(
                    fontSize: ScreenUtil().setSp(30), color: _textBottomColor),
              ),
            ),
            new Container(
              margin: EdgeInsets.only(top: 4),
              child: new Text(
                "${!_isDiamondVip ? "${itemVip.ssubdesc}" : "${itemDiamond.ssubdesc}"}",
                style: new TextStyle(
                    fontSize: ScreenUtil().setSp(30), color: _textBottomColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildSetMealLayout() {
    //setMeal
    List<VipPriceInfoDiamondMoneyList> moneyList1 =
        List<VipPriceInfoDiamondMoneyList>();
    List<VipPriceInfoVipMoneyList> moneyList = List<VipPriceInfoVipMoneyList>();
    try {
      if (_isDiamondVip) {
        moneyList1 = _diamondInfo.moneyList;
        _selectPrice = moneyList1[_selectIndex].price;
      } else {
        moneyList = _vipInfo.moneyList;
        _selectPrice = moneyList[_selectIndex].price;
      }
    } catch (e) {}
    return Container(
      width: double.maxFinite,
//                  height: ScreenUtil().setHeight(582),
      margin: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(48),
          horizontal: ScreenUtil().setWidth(48)),
      child: Wrap(
        spacing: ScreenUtil().setWidth(20),
        runSpacing: ScreenUtil().setWidth(20),
        children: List.generate(
            _isDiamondVip ? moneyList1.length : moneyList.length, (index) {
          var itemVip;
          var itemDiamond;
          if (_isDiamondVip) {
            itemDiamond = moneyList1[index];
          } else {
            itemVip = moneyList[index];
          }
          return buildVipSelectLayout(
              index: index, itemVip: itemVip, itemDiamond: itemDiamond);
        }),

        /*moneyList != null
            ? moneyList.asMap().keys.map((valueIndex) {
                return buildVipSelectLayout(index: valueIndex);
              }).toList()
            : <Widget>[
//                buildVipSelectLayout(0),
//                buildVipSelectLayout(1),
//                buildVipSelectLayout(2),
//                buildVipSelectLayout(3),
              ],*/
      ),
    );
  }

  Widget buildVipSelectLayout(
      {VipPriceInfoVipMoneyList itemVip,
      VipPriceInfoDiamondMoneyList itemDiamond,
      int index}) {
    String title = '';
    String yearPrice = '';
    String monthPrice = '';
    String renewalPrice = ''; //续费价格
    String des = ''; //续费价格
    String originalPrice = ''; //原价
    bool flag = false; //续费价格
    try {
      if (_isDiamondVip) {
        title = itemDiamond.desc;
        yearPrice = itemDiamond.price;
        renewalPrice = itemDiamond.nextPrice;
        monthPrice = itemDiamond.moneyPrice;
        flag = itemDiamond.flag;
        originalPrice = itemDiamond.originalPrice;
      } else {
        title = itemVip.desc;
        yearPrice = itemVip.price;
        renewalPrice = itemVip.nextPrice;
        monthPrice = itemVip.moneyPrice;
        flag = itemVip.flag;
        originalPrice = itemVip.originalPrice;
      }
      des = '$title续费$renewalPrice元';
    } catch (e) {}
    return KTKJSelectChoiceChip(
      width: ScreenUtil().setWidth(325),
      height: ScreenUtil().setHeight(393),
      child: Container(
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                "${title}",
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(47),
                  color: Color(0xff666666),
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "￥",
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(47),
                      color: Color(0xffBD8B4C),
                    ),
                  ),
                  Text(
                    "$yearPrice",
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(61),
                      color: Color(0xffBD8B4C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: ScreenUtil().setHeight(15),
              ),
              child: Text(
                //
                "原价￥$originalPrice",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  fontSize: ScreenUtil().setSp(32),
                  color: Color(0xff999999),
                ),
              ),
            ),
            Visibility(
              visible: true,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Color(0xffE5BD7B),
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(10)))),
                height: ScreenUtil().setHeight(65),
                width: ScreenUtil().setWidth(266),
                child: Text(
                  "${flag ? "${flag ? monthPrice : "--"}" : "暂未开通"}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(32), color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      borderRadius: BorderRadius.all(Radius.circular(5)),
      selected: _selectIndex == index,
      selectBorder: Border.all(color: Color(0xffE8C392)),
      border: Border.all(color: Color(0xffDEDEDE)),
      selectGradient: LinearGradient(colors: [
        Color(0xffFFF9EE),
        Color(0xffFFFBF3),
      ]),
      gradient: LinearGradient(colors: [
        Colors.white,
        Colors.white,
      ]),
      boxSelectColor: Color(0xffFFF9EE),
      boxColor: Colors.white,
      onSelected: (v) {
        setState(() {
          if (!flag) {
            KTKJCommonUtils.showToast("暂未开通，敬请期待");
            return;
          }
          _selectIndex = index;
          _selectPrice = yearPrice;
        });
      },
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
                                color: KTKJGlobalConfig.taskHeadColor,
                                fontSize: 12)),
                        TextSpan(
                            text: " $_selectPrice",
                            style: TextStyle(
                                color: KTKJGlobalConfig.taskHeadColor,
                                fontSize: 18)),
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
                        var term;
                        if (_isDiamondVip) {
                          term = _diamondInfo.moneyList[_selectIndex].type;
                        } else {
                          term = _vipInfo.moneyList[_selectIndex].type;
                        }
                        if (_payway == 1) {
                          var result = await HttpManage.getWechatPayInfo(
                              pay_type: _isDiamondVip ? "3" : "1", term: term);
                          if (result.status) {
                            _payNo = result.data.payNo;
                            callWxPay(result.data);
                          } else {
                            KTKJCommonUtils.showToast(result.errMsg);
                          }
                        } else if (_payway == 2) {
                          var result = await HttpManage.getAliPayInfo(
                              pay_type: _isDiamondVip ? "3" : "1", term: term);
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
