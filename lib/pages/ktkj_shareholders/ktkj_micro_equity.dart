import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alipay/flutter_alipay.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:star/http/ktkj_http_manage.dart';
import 'package:star/models/micro_shareholder_item_entity.dart';
import 'package:star/models/user_info_entity.dart';
import 'package:star/models/vip_price_info_entity.dart';
import 'package:star/models/wechat_payinfo_entity.dart';
import 'package:star/pages/ktkj_task/ktkj_pay_result.dart';
import 'package:star/pages/ktkj_task/ktkj_task_index.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_octoimage.dart';
import 'package:star/utils/ktkj_common_utils.dart';
import 'package:star/utils/ktkj_navigator_utils.dart';
import 'package:star/utils/ktkj_utils.dart';

import '../../global_config.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
///微股东权益
class KTKJMicroShareHolderEquityPage extends StatefulWidget {
  KTKJMicroShareHolderEquityPage(
      {Key key, this.shareholderType = 1, this.showBackBtnIcon = true})
      : super(key: key);
  final String title = "微股东权益";

  ///是否显示 appbar
  bool showBackBtnIcon;

  ///股东类型
  ///-1非股东 0 见习股东 ; 1 vip 股东 ，高级股东
  int shareholderType;

  @override
  _MicroShareHolderEquityPageState createState() =>
      _MicroShareHolderEquityPageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _MicroShareHolderEquityPageState
    extends State<KTKJMicroShareHolderEquityPage>
    with AutomaticKeepAliveClientMixin {
  Color _textTopColor = Color(0xff0A7FFF);
  Color _textBottomColor = Color(0xff666666);
  Color _layoutSelectedColor = Colors.white;
  int _selectIndex = -1;
  String _selectPrice = "";
  int _currentIndex = 0;
  int _payway = 1;
  var _payNo;

  ///  微股东等级
  ///
  ///  1 见习股东
  ///
  ///  2 不是微股东
  ///
  ///  3 股东
  ///
  ///  4 高级股东
  String _shareholderType = '';
  VipPriceInfoVip _vipInfo;
  VipPriceInfoDiamond _diamondInfo;

  ///微股东类型名称
  var _shareholderTypeName = '';

  ///微股东权益类型描述
  var _shareholderProfitDesc = '';

  ///微股东年收益
  var _shareholderYearProfit = '';

  ///分红比例
  var _dividendRatio = "";

  ///万份分红金昨日收益
  var _yesterdayProfit = '0';

  ///万份分红金7日收益
  var _sevenDayProfit = '0';

  ///万份分红金30日收益
  var _monthProfit = '0';
  UserInfoData userInfoData;

  ///是否展示开通股东卡片
  var showCard = true;

  _initWeChatResponseHandler() {
    KTKJGlobalConfig.payType = 3;
    fluwx.weChatResponseEventHandler.listen((res) async {
      if (res is fluwx.WeChatPaymentResponse) {
//        print("_result = " + "pay :${res.isSuccessful}");
        if (res.isSuccessful && KTKJGlobalConfig.payType == 3) {
          _checkPayStatus();
        }
      }
    });
  }

  MicroShareholderItemEntity grade1;
  MicroShareholderItemEntity grade2;
  MicroShareholderItemEntity grade3;
  List<MicroShareholderItemEntity> _dataList =
      List<MicroShareholderItemEntity>();

  _initData() async {
    userInfoData = KTKJGlobalConfig.getUserInfo();
    if (KTKJCommonUtils.isEmpty(userInfoData)) {
      var result = await HttpManage.getUserInfo();
      if (result.status) {
        setState(() {
          _shareholderType = result.data.isPartner;
          _currentIndex = _shareholderType == '1'
              ? 1
              : _shareholderType == '3' || _shareholderType == '4'
                  ? 2
                  : 0;
        });
      } else {
        if (KTKJCommonUtils.isEmpty(userInfoData.isPartner)) {
          var result = await HttpManage.getUserInfo();
          if (result.status) {
            setState(() {
              _shareholderType = result.data.isPartner;
              _currentIndex = _shareholderType == '1'
                  ? 1
                  : _shareholderType == '3' || _shareholderType == '4'
                      ? 2
                      : 0;
            });
          } else {}
        }
      }
    } else {
      if (!KTKJCommonUtils.isEmpty(userInfoData.isPartner)) {
        setState(() {
          _shareholderType = userInfoData.isPartner;
          _currentIndex = _shareholderType == '1'
              ? 1
              : _shareholderType == '3' || _shareholderType == '4'
                  ? 2
                  : 0;
        });
      }
    }
    print("_shareholderType=$_shareholderType");
    var result = await HttpManage.getMicroShareHolderInfo();
    if (result.status) {
      if (mounted) {
        setState(() {
          _dataList.add(result.data.grade1);
          _dataList.add(result.data.grade2);
          _dataList.add(result.data.grade3);
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
          await HttpManage.getUserInfo();
          KTKJNavigatorUtils.navigatorRouterAndRemoveUntil(
              context,
              KTKJPayResultPage(
                payNo: _payNo,
                type: 2,
                title: '支付成功',
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
        if (widget.shareholderType != 1) {
          _currentIndex = 1;
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
    if (Platform.isIOS && KTKJGlobalConfig.iosCheck) {
      showCard = false;
    }
    return Scaffold(
        appBar: GradientAppBar(
          title: Text(
            widget.title,
            style: TextStyle(
                color: Colors.white, fontSize: ScreenUtil().setSp(54)),
          ),
          leading: Visibility(
            visible: widget.showBackBtnIcon,
            child: IconButton(
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
          ),
          centerTitle: true,
          elevation: 0,
          brightness: Brightness.dark,
          gradient: LinearGradient(colors: [
            Color(0xff25272E),
            Color(0xff25272E),
          ]),
        ),
        body: Container(
          color: Color(0xff25272E),
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                buildBenefitCenter(),
                Visibility(
                  visible: showCard,
                  child: Container(
                    color: Color(0xff25272E),
                    child: Column(
                      children: <Widget>[
                        buildSwiperCard(),
//                      benefitsRow(),
                      ],
                    ),
                  ),
                ),
                buildProfitShow(),
                buildShareholdersEquityDescriptionDisplay(),
                SizedBox(
                  height: 88,
                ),
              ],
            ),
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  var btnTxt = "";

  ///轮播卡片
  Widget buildSwiperCard() {
    bool _showBtnIcon = true;
    double _opacity = 1;
    try {
      var item = _dataList[_currentIndex];
      _dividendRatio = '${item.interests.dailyMoneyRate}%';
      novitiatePrice = _dataList[0].payPrice;
      vipPrice = _dataList[1].payPrice;
      advancedPrice = _dataList[2].payPrice;
    } catch (e) {}
    switch (_currentIndex) {
      case 0:
        btnTxt = _shareholderType != "1" ? '消费$novitiatePrice元/立即开通' : '已开通';
        _showBtnIcon = _shareholderType != "1";
        _opacity = _shareholderType != "1" ? 1 : 0.6;
        break;
      case 1:
        btnTxt =
            _shareholderType != "3" ? '年费$vipPrice/立即开通' : '年费$vipPrice元/立即续费';
        break;
      case 2:
        btnTxt = _shareholderType != "4"
            ? '年费$advancedPrice元/立即开通'
            : '年费$advancedPrice元/立即续费';
        break;
    }
    //限时优惠图标
    var xsIcon =
        'https://alipic.lanhuapp.com/xd130d769b-1304-4f90-a3af-55000ac90eb7';

    ///小喇叭图标
    var lbIcon =
        'https://alipic.lanhuapp.com/xd92657a69-39df-48d4-bb44-ef8edacccde3';
    if (Platform.isIOS && KTKJGlobalConfig.prefs.getBool("isIosUnderReview")) {
      btnTxt = 'ios暂未开通';
    }

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(
            top: ScreenUtil().setWidth(53),
          ),
          child: Stack(
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(1065),
                height: ScreenUtil().setWidth(338),
                margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(274),
                  left: ScreenUtil().setWidth(30),
                  right: ScreenUtil().setWidth(30),
                ),
                decoration: BoxDecoration(
                  color: Color(0xff313235),
                  border: Border.all(
                    color: Color(0xffFFDC9C),
                    width: ScreenUtil().setWidth(2),
                  ),
                  borderRadius: BorderRadius.circular(
                    ScreenUtil().setWidth(30),
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: ScreenUtil().setWidth(314),
                  width: ScreenUtil().setWidth(1001),
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setHeight(10),
                    left: ScreenUtil().setWidth(38),
                    right: ScreenUtil().setWidth(38),
                  ),
                  child: Swiper(
                    itemCount: 3,
                    autoplay: false,
                    loop: false,

//                              viewportFraction: 0.86,
//                              scale: 0.96,
                    index: _currentIndex,
                    /*control: SwiperControl(
                      color: Color(0xE82C2D30),
                    ),*/
                    /*  pagination: new SwiperPagination(
                        margin: new EdgeInsets.all(5.0)
                    ),*/
                    key: UniqueKey(),
                    onIndexChanged: (index) {
                      if (mounted) {
                        setState(() {
                          if (_currentIndex != index) {
                            _currentIndex = index;
                          }
                        });
                      }
                    },
                    itemBuilder: (context, index) {
                      return buildShareHolderCard(index);
                    },
                  ),
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(1065),
                height: ScreenUtil().setWidth(316),
                margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(316),
                  left: ScreenUtil().setWidth(30),
                  right: ScreenUtil().setWidth(30),
                ),
                decoration: BoxDecoration(
//                color: Colors.green,
//                  color: Color(0xff313235),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                      ScreenUtil().setWidth(30),
                    ),
                    bottomRight: Radius.circular(
                      ScreenUtil().setWidth(30),
                    ),
                  ),
                  /*    image: DecorationImage(
                      image: Image.network(
                    "https://alipic.lanhuapp.com/xd52654c11-0f1f-43da-8f0d-43e6ffeddc89",
                    fit: BoxFit.fill,
                    width: ScreenUtil().setWidth(30000),
                    height: ScreenUtil().setWidth(397),
                  ).image),*/
                ),
                child: Column(
                  children: [
                    Flexible(
                        child: GestureDetector(
                      child: Stack(
                        children: [
                          /* KTKJMyOctoImage(
                            image:
                                'https://alipic.lanhuapp.com/xd52654c11-0f1f-43da-8f0d-43e6ffeddc89',
                            width: ScreenUtil().setWidth(1255),
                            height: ScreenUtil().setWidth(397),
                            fit: BoxFit.fill,
                          ),*/
                          Container(
                            margin:
                                EdgeInsets.only(top: ScreenUtil().setWidth(1)),
                            decoration: BoxDecoration(
//                color: Colors.green,
                              color: Color(0xff313235),
                              /*    image: DecorationImage(
                      image: Image.network(
                    "https://alipic.lanhuapp.com/xd52654c11-0f1f-43da-8f0d-43e6ffeddc89",
                    fit: BoxFit.fill,
                    width: ScreenUtil().setWidth(30000),
                    height: ScreenUtil().setWidth(397),
                  ).image),*/
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () async {
                                  if (_shareholderType == "2" &&
                                      _currentIndex == 0) {
                                    var result = await HttpManage
                                        .applyToBecomeAMicroShareholder();
                                    if (result.status) {
                                      KTKJCommonUtils.showToast("微股东申请开通成功！");
                                    } else {
                                      showOpenMicroShareholderDialog();
                                    }
                                    return;
                                  } else {
                                    if (_opacity == 1) {
                                      _showSelectPayWayBottomSheet();
                                    }
                                  }
                                },
                                child: Stack(
                                  children: [
                                    Opacity(
                                      opacity: _opacity,
                                      child: Container(
                                        width: ScreenUtil().setWidth(982),
                                        height: ScreenUtil().setWidth(120),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            Color(0xffF3D6AA),
                                            Color(0xffEDC182),
                                          ]),
                                          borderRadius: BorderRadius.circular(
                                            ScreenUtil().setWidth(60),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "$btnTxt",
                                            style: TextStyle(
                                              color: Color(0xff313235),
                                              fontSize: ScreenUtil().setSp(33),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: _showBtnIcon,
                                      child: Container(
                                        width: ScreenUtil().setWidth(982),
                                        height: ScreenUtil().setWidth(120),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: Image.network(
                                                "$xsIcon",
                                                fit: BoxFit.fill,
                                              ).image),
                                          borderRadius: BorderRadius.circular(
                                            ScreenUtil().setWidth(50),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
//                            visible: false,
                            child: Positioned(
//                              left: ScreenUtil().setWidth(30),
//                              right: ScreenUtil().setWidth(30),

                              child: ClipPath(
                                clipper: TopPartClipper(),
                                child: Container(
                                  width: ScreenUtil().setWidth(1065),
                                  height: ScreenUtil().setWidth(20),
                                  decoration: BoxDecoration(
//                                    color: Color(0xffF5D8A9),
                                    gradient: LinearGradient(colors: [
                                      Color(0xffF5D8A9),
                                      Color(0xffEEC48C),
                                    ]),
                                    border: Border(
                                      top: BorderSide.none,
                                      bottom: BorderSide.none,
                                      left: BorderSide.none,
                                      right: BorderSide.none,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(30),
                                    right: ScreenUtil().setWidth(30),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                    Visibility(
                      visible: false,
                      child: Container(
                        width: ScreenUtil().setWidth(1065),
                        height: ScreenUtil().setWidth(88),
                        padding: EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                          color: Color(0xff2C2D30),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(
                              ScreenUtil().setWidth(30),
                            ),
                            bottomRight: Radius.circular(
                              ScreenUtil().setWidth(30),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            KTKJMyOctoImage(
                              image: "$lbIcon",
                              width: ScreenUtil().setWidth(33),
                              height: ScreenUtil().setWidth(33),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 4),
                              child: Text(
                                "开通可享受每日股东分红，分红比例为股东正常分红比例的$_dividendRatio",
                                style: TextStyle(
                                    color: Color(0xff8F8274),
                                    fontSize: ScreenUtil().setSp(32)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future showOpenMicroShareholderDialog({desc}) async {
    //
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '消费金额未达标,充值$novitiatePrice元红包可立即升级为见习股东，是否充值？',
                  style: TextStyle(
                    //                color:  Color(0xFF222222) ,
                    fontSize: ScreenUtil().setSp(42),
                  ),
                )),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  '去购物',
                  style: TextStyle(
                    color: Color(0xff222222),
                    fontSize: ScreenUtil().setSp(42),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  KTKJNavigatorUtils.navigatorRouterAndRemoveUntil(
                      context, KTKJTaskIndexPage());
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  '充红包',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(42),
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  _showSelectPayWayBottomSheet();
                },
              ),
            ],
          );
        });
  }

  var nameList = [
    '见习股东',
    '股东',
    '高级股东',
  ];

  ///微股东预估年收益
  Widget buildBenefitCenter() {
    switch (_currentIndex) {
      case 0:
        _shareholderTypeName = '见习';
        break;
      case 1:
        _shareholderTypeName = '';
        break;
      case 2:
        _shareholderTypeName = '高级';
        break;
    }
    _shareholderYearProfit = '';
    try {
      var item = _dataList[_currentIndex];
      _shareholderYearProfit = '${item.annualIncome}';
    } catch (e) {}

    return Container(
      height: ScreenUtil().setWidth(64),
      margin: EdgeInsets.only(
        top: ScreenUtil().setWidth(30),
      ),
      decoration: BoxDecoration(
//        color: Color(0xff313235),
        border: Border.all(
          color: Color(0xffA09988),
          width: ScreenUtil().setWidth(1),
        ),
        borderRadius: BorderRadius.circular(
          ScreenUtil().setWidth(20),
        ),
      ),
      child: Wrap(
        children: List.generate(nameList.length, (index) {
          var name = nameList[index];
          return GestureDetector(
            onTap: () {
              if (mounted) {
                setState(() {
                  if (_currentIndex != index) {
                    _currentIndex = index;
                  }
                });
              }
            },
            child: Container(
              height: ScreenUtil().setWidth(64),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(31),
                vertical: ScreenUtil().setWidth(6),
              ),
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? Color(0xffCAAC74)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(
                  ScreenUtil().setWidth(20),
                ),
              ),
              child: Text(
                "$name",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(34),
                  color: _currentIndex == index
                      ? Color(0xff25272E)
                      : Color(0xffA09988), //#A09988
                ),
              ),
            ),
          );
        }) /*[
          Center(
            child: Text.rich(
              TextSpan(children: [
                TextSpan(text: "开通$_shareholderTypeName股东，人均年收入"),
                TextSpan(
                  text: "¥$_shareholderYearProfit",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(48),
                    color: Color(0xffF3CA83),
                  ),
                ),
                TextSpan(text: "起"),
              ]),
              style: TextStyle(
                fontSize: ScreenUtil().setSp(34),
                color: Color(0xffA09988),
              ),
            ),
          ),
        ]*/
        ,
      ),
    );
  }

  var shareholdersEquityDescriptionList;

  ///股东权益描述展示
  Widget buildShareholdersEquityDescriptionDisplay() {
    var listSize = _currentIndex == 0 ? 1 : 2;
    return Column(
      children: List.generate(
          KTKJCommonUtils.isEmpty(shareholdersEquityDescriptionList)
              ? listSize
              : shareholdersEquityDescriptionList.lenth,
          (index) => buildShareholdersEquityDescriptionDisplayItem(
              item: shareholdersEquityDescriptionList, index: index)),
    );
  }

  ///权益描述选项卡片布局
  Container buildShareholdersEquityDescriptionDisplayItem({item, index}) {
    var profitTitle = '';
    var profitDesc = '';
    var desChildrenList;
    var childrenListSize = _currentIndex == 2 && index == 1 ? 4 : 2;
    if (_currentIndex == 0) {
      childrenListSize = 1;
    }

    if (!KTKJCommonUtils.isEmpty(item)) {
      try {
        profitTitle = item.title;
        profitDesc = item.desc;
        desChildrenList = item.xList;
      } catch (e) {
        print(e);
      }
    }
    try {
      profitTitle = index == 0
          ? '$_shareholderTypeName股东分红权益'
          : '$_shareholderTypeName股东推荐权益';
      profitDesc = index == 0
          ? '${_dataList[_currentIndex].interests.bonusDescription}'
          : '${_dataList[_currentIndex].interests.recommendDescription}';
    } catch (e) {}
    return Container(
      margin: EdgeInsets.only(
        top: ScreenUtil().setHeight(30),
        left: ScreenUtil().setWidth(30),
        right: ScreenUtil().setWidth(30),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color(0xffFFEFDA),
          Color(0xffFFF3DA),
        ]),
        borderRadius: BorderRadius.circular(
          ScreenUtil().setWidth(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: ScreenUtil().setWidth(1065),
            padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(47),
              bottom: ScreenUtil().setWidth(47),
              left: ScreenUtil().setWidth(38),
              right: ScreenUtil().setWidth(32),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: ScreenUtil().setWidth(119),
                      height: ScreenUtil().setWidth(51),
                      margin: EdgeInsets.only(
                        right: ScreenUtil().setWidth(21),
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: Image.network(
                            "https://alipic.lanhuapp.com/xd7687a0aa-be3e-4a0c-b641-05e90da76066",
                            fit: BoxFit.fill,
                          ).image,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "权益${index + 1}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(30),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        "$profitTitle",
                        style: TextStyle(
                          color: Color(0xff313235),
                          fontSize: ScreenUtil().setSp(46),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setWidth(10),
                  ),
                  child: Text(
                    "$profitDesc",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: Color(0xffAD8E6E),
                      fontSize: ScreenUtil().setSp(32),
                    ),
                  ),
                ),
                Column(
                  children: List.generate(
                      KTKJCommonUtils.isEmpty(desChildrenList)
                          ? childrenListSize
                          : desChildrenList.lenth,
                      (itemIndex) => buildBenefitDescriptionItem(

                          ///
                          item: desChildrenList,
                          groupIndex: index,
                          index: itemIndex)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///单项权益描述布局
  Container buildBenefitDescriptionItem({item, groupIndex, int index}) {
    var profitTitle = '';
    var profitDesc = '';
    var iconUrl = index % 2 == 0
        ? "https://alipic.lanhuapp.com/xdde8fa682-7e93-4790-8f11-6654c2724828"
        : 'https://alipic.lanhuapp.com/xd1f5df4e2-52ec-43ac-91a1-9e96dd2960de';
    var iconDesc = '';
    if (!KTKJCommonUtils.isEmpty(item)) {
      try {
        profitTitle = item.title;
        profitDesc = item.desc;
      } catch (e) {
        print(e);
      }
    }
    try {
      switch (groupIndex) {
        case 0:
          switch (index) {
            case 0:
              profitTitle = '每日股东分红';
              profitDesc = "分红比例为个人应得分红的$_dividendRatio";
              iconDesc = '$_dividendRatio';
              break;
            case 1:
              var bonusCoin = '${_dataList[_currentIndex].interests.bonusCoin}';
              profitTitle = '$bonusCoin个分红金';
              profitDesc = _currentIndex == 0
                  ? '消费满$novitiatePrice元，平台赠送至少$bonusCoin个分红金用于分红'
                  : _currentIndex == 1
                      ? "缴纳年费$vipPrice元，平台赠送$bonusCoin个分红金用于分红"
                      : "缴纳年费$advancedPrice元，平台赠送$bonusCoin个分红金用于分红";
              if (!showCard) {
                profitDesc = _currentIndex == 0
                    ? '消费满$novitiatePrice元，平台赠送至少$bonusCoin个分红金用于分红'
                    : _currentIndex == 1
                        ? "平台赠送$bonusCoin个分红金用于分红"
                        : "平台赠送$bonusCoin个分红金用于分红";
              }
              iconDesc = '$bonusCoin';
              break;
          }
          break;
        case 1:
          switch (index) {
            case 0:
              var directBonus =
                  '${_dataList[_currentIndex].interests.directBonus}';
              profitTitle = '直推分红奖励'; //
              profitDesc = "下级股东分红金额的$directBonus%(实际分红金额的$directBonus%)";
              iconDesc = '$directBonus%';
              break;
            case 1:
              var indirectBonus =
                  '${_dataList[_currentIndex].interests.indirectBonus}';
              var directUpgrade =
                  '${_dataList[_currentIndex].interests.directUpgrade}';
              profitTitle = _currentIndex == 1 ? '推荐好友升级奖励' : '间推分红奖励';
              profitDesc = _currentIndex == 1
                  ? '推荐好友升级股东或者高级股东，奖励均为20元'
                  : "下下级股东分红金额的5%(实际分红金额的5%)";
              iconDesc =
                  _currentIndex == 1 ? '￥$directUpgrade' : '$indirectBonus%';
              break;
            case 2:
              var directUpgrade =
                  '${_dataList[_currentIndex].interests.directUpgrade}';
              profitTitle = '直推好友升级奖励';
              profitDesc = "推荐好友升级股东或者高级股东，奖励充值金额的$directUpgrade%";
              iconDesc = '$directUpgrade%';
              break;
            case 3:
              var indirectUpgrade =
                  '${_dataList[_currentIndex].interests.indirectUpgrade}';
              profitTitle = '间推好友升级奖励';
              profitDesc = "下下级升级股东或者高级股东，奖励充值金额的$indirectUpgrade%";
              iconDesc = '$indirectUpgrade%';
              break;
          }
          break;
      }
    } catch (e) {
      print(e);
    }
    return Container(
      padding: EdgeInsets.only(
        top: ScreenUtil().setWidth(47),
        bottom: ScreenUtil().setWidth(47),
        left: ScreenUtil().setWidth(38),
        right: ScreenUtil().setWidth(32),
      ),
      margin: EdgeInsets.only(
        top: ScreenUtil().setWidth(32),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color(0xffFFFFFF),
          Color(0xffFFFFFF),
        ]),
        borderRadius: BorderRadius.circular(
          ScreenUtil().setWidth(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: ScreenUtil().setWidth(128),
            height: ScreenUtil().setWidth(128),
            margin: EdgeInsets.only(
              right: ScreenUtil().setWidth(21),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.network(
                  "$iconUrl",
                  fit: BoxFit.fill,
                ).image,
              ),
            ),
            child: Center(
              child: Container(
                child: Padding(
                  padding: EdgeInsets.only(top: index % 2 == 0 ? 0 : 10),
                  child: Text(
                    "$iconDesc",
                    style: TextStyle(
                      color: Color(0xff25272E),
                      fontSize: ScreenUtil().setSp(32),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      "$profitTitle",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xff313235),
                        fontSize: ScreenUtil().setSp(42),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setWidth(22),
                    ),
                    child: Text(
                      "$profitDesc",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xff313235),
                        fontSize: ScreenUtil().setSp(32),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///分红金收益数据展示
  Widget buildProfitShow() {
    try {
      var item = _dataList[_currentIndex];
      _yesterdayProfit = '${item.estimate.yesterday}';
      _sevenDayProfit = '${item.estimate.week}';
      _monthProfit = '${item.estimate.month}';
    } catch (e) {}
    return Container(
      margin: EdgeInsets.only(
        top: ScreenUtil().setHeight(30),
        left: ScreenUtil().setWidth(30),
        right: ScreenUtil().setWidth(30),
      ),
      decoration: BoxDecoration(
        color: Color(0xff313235),
        borderRadius: BorderRadius.circular(
          ScreenUtil().setWidth(30),
        ),
      ),
      child: Stack(
        children: [
          KTKJMyOctoImage(
            image:
                "https://alipic.lanhuapp.com/xd94361c9c-aef0-4d62-a616-844f4bda2189",
            width: ScreenUtil().setWidth(1065),
            height: ScreenUtil().setWidth(331),
            fit: BoxFit.fill,
          ),
          KTKJMyOctoImage(
            image:
                "https://alipic.lanhuapp.com/xd8690d7d2-d313-45f5-b70c-ec09f259915a",
            width: ScreenUtil().setWidth(1065),
            height: ScreenUtil().setWidth(331),
            fit: BoxFit.fill,
          ),
          KTKJMyOctoImage(
            image:
                "https://alipic.lanhuapp.com/xd42e3eaf9-41e0-4057-ad08-713b3ae1a0e8",
            width: ScreenUtil().setWidth(1065),
            height: ScreenUtil().setWidth(331),
            fit: BoxFit.fill,
          ),
          Container(
            width: ScreenUtil().setWidth(1065),
            height: ScreenUtil().setWidth(331),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setWidth(40),
                    left: ScreenUtil().setWidth(30),
                    right: ScreenUtil().setWidth(30),
                  ),
                  child: Text(
                    "以下为每100000个分红金所得数据",
                    style: TextStyle(
                      color: Color(0xff949494),
                      fontSize: ScreenUtil().setSp(33),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setWidth(60),
                      left: ScreenUtil().setWidth(80),
                      right: ScreenUtil().setWidth(80),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "昨日",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(38),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(10),
                                ),
                                child: Text.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                      text: "¥",
                                      style: TextStyle(
                                        color: Color(0xffF2DDB0),
                                        fontSize: ScreenUtil().setSp(33),
                                      ),
                                    ),
                                    TextSpan(
                                      text: "$_yesterdayProfit",
                                    ),
                                  ]),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color(0xffF2DDB0),
                                    fontSize: ScreenUtil().setSp(48),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "7日内",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(38),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(10),
                                ),
                                child: Text.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                      text: "¥",
                                      style: TextStyle(
                                        color: Color(0xffF2DDB0),
                                        fontSize: ScreenUtil().setSp(33),
                                      ),
                                    ),
                                    TextSpan(
                                      text: "$_sevenDayProfit",
                                    ),
                                  ]),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color(0xffF2DDB0),
                                    fontSize: ScreenUtil().setSp(48),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "30日内",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(38),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(10),
                                ),
                                child: Text.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                      text: "¥",
                                      style: TextStyle(
                                        color: Color(0xffF2DDB0),
                                        fontSize: ScreenUtil().setSp(33),
                                      ),
                                    ),
                                    TextSpan(
                                      text: "$_monthProfit",
                                    ),
                                  ]),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color(0xffF2DDB0),
                                    fontSize: ScreenUtil().setSp(48),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  var novitiatePrice = "";
  var vipPrice = "";
  var advancedPrice = "";

  ///股东信息展示布局
  Widget buildShareHolderCard(index) {
    var name = '';
    var headUrl = '';
    var profit_day = '';
    var desc = '';
    var expireDate = '';
    var year_money = '';
    var b_year_money = '';
    var iconLinkUrl;
    try {
      name = userInfoData.username;
      headUrl = userInfoData.avatar;
      expireDate = userInfoData.partnerExpireTime;
    } catch (e) {}

    ///股东身份信息描述
    var idDesc = '您还未开通见习股东';

    ///高级
    var advancedIconLinkUrl =
        'https://alipic.lanhuapp.com/xdfaf65cbc-a64a-436a-8e08-62cdd5d7c0fe';

    ///初级
    var primaryIconLinkUrl =
        'https://alipic.lanhuapp.com/xd773ad065-1911-4bf5-aa89-fb3572829d73';

    ///vip
    var vipIconLinkUrl =
        'https://alipic.lanhuapp.com/xd195c52f3-7d0c-4b72-8169-3eeec3937bc4';
    switch (_currentIndex) {
      case 0:
        desc = '消费满$novitiatePrice元即可升级为见习股东';
        idDesc = _shareholderType != "1" ? '您还未开通见习股东' : '见习股东已开通';
        iconLinkUrl = primaryIconLinkUrl;
        _selectPrice = "$novitiatePrice";

        break;
      case 1:
        desc = '缴纳年费$vipPrice元即可开通为股东';
        idDesc = _shareholderType != "3" ? '您还未开通股东' : '股东将于$expireDate到期';
        iconLinkUrl = vipIconLinkUrl;
        _selectPrice = "$vipPrice";
        break;
      case 2:
        desc = '缴纳年费$advancedPrice元即可开通为高级股东';
        idDesc = _shareholderType != "4" ? '您还未开通高级股东' : '高级股东将于$expireDate到期';
        iconLinkUrl = advancedIconLinkUrl;
        _selectPrice = "$advancedPrice";
        break;
    }

    return Container(
      width: double.maxFinite,
      height: ScreenUtil().setWidth(314),
      decoration: BoxDecoration(
        /*image: DecorationImage(
            fit: BoxFit.fill,
            image: Image.asset(
              "static/images/task_mine_card_bg_vip1.png",
              fit: BoxFit.fill,
            ).image),*/
        gradient: LinearGradient(colors: [
          Color(0xffF5D8A9),
          Color(0xffEEC48C),
        ]),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            ScreenUtil().setWidth(30),
          ),
          topRight: Radius.circular(
            ScreenUtil().setWidth(30),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(30),
              right: ScreenUtil().setWidth(30),
              top: ScreenUtil().setWidth(19),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClipOval(
                  child: KTKJMyOctoImage(
                    image: "$headUrl",
                    width: ScreenUtil().setWidth(168),
                    height: ScreenUtil().setWidth(168),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "$name",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Color(
                                  0xff512A08,
                                ),
                                fontWeight: FontWeight.w600,
                                fontSize: ScreenUtil().setSp(42)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 6,
                          ),
                          child: Text(
                            "$idDesc",
                            style: TextStyle(
                                color: Color(
                                  0xffA58053,
                                ),
                                fontSize: ScreenUtil().setSp(30)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: KTKJMyOctoImage(
                    image: "$iconLinkUrl",
                    width: ScreenUtil().setWidth(281),
                    height: ScreenUtil().setWidth(149),
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
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(50),
                vertical: ScreenUtil().setHeight(20),
              ),
              child: Container(
                child: Text(
                  "$desc",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Color(
                        0xff512A08,
                      ),
                      fontWeight: FontWeight.w600,
                      fontSize: ScreenUtil().setSp(42)),
                ),
              ),
            ),
          ),
          Visibility(
            visible: false,
            child: Container(
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
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(16)),
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
            ),
          )
        ],
      ),
    );
  }

  _showSelectPayWayBottomSheet() {
    if (Platform.isIOS && KTKJGlobalConfig.prefs.getBool("isIosUnderReview")) {
      KTKJCommonUtils.showIosPayDialog();
      return;
    }
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
                        "微股东开通/续费",
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
                            text: " $_selectPrice",
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
                          var result = await HttpManage
                              .getMicroShareholdersWechatPayInfo(
                            pay_type: _currentIndex + 1,
                          );
                          if (result.status) {
                            _payNo = result.data.payNo;
                            callWxPay(result.data);
                          } else {
                            KTKJCommonUtils.showToast(result.errMsg);
                          }
                        } else if (_payway == 2) {
                          var result =
                              await HttpManage.getMicroShareholdersAliPayInfo(
                                  pay_type: _currentIndex + 1);
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

  @override
  bool get wantKeepAlive => true;
}
