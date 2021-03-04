import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/generated/json/ktxx_goods_spec_info_entity_helper.dart';
import 'package:star/ktxxhttp/ktxx_http_manage.dart';
import 'package:star/ktxxmodels/ktxx_goods_info_entity.dart';
import 'package:star/ktxxmodels/ktxx_goods_spec_info_entity.dart';
import 'package:star/ktxxmodels/ktxx_pdd_goods_info_entity.dart';
import 'package:star/ktxxpages/ktxxgoods/ktxx_ensure_order.dart';
import 'package:star/ktxxpages/ktxxlogin/ktxx_login.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_index.dart';
import 'package:star/ktxxpages/ktxxwidget/ktxx_price_text.dart';
import 'package:star/ktxxpages/ktxxwidget/ktxx_goods_select_choice.dart';
import 'package:star/ktxxpages/ktxxwidget/ktxx_my_fractionpaginationbuilder.dart';
import 'package:star/ktxxpages/ktxxwidget/ktxx_my_webview_plugin.dart';
import 'package:star/ktxxutils/ktxx_common_utils.dart';
import 'package:star/ktxxutils/ktxx_navigator_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../ktxx_global_config.dart';

//  return Column(
//  mainAxisSize: MainAxisSize.min,
//  children: <Widget>[
//  Stack(
//  overflow: Overflow.visible,
//  children: <Widget>[
//  GestureDetector(
//  onTap: () {
//  if (catg.name == listProfileCategories[0].name)
//  Navigator.pushNamed(context, '/furniture');
//  },
//  child: Container(
//  padding: EdgeInsets.all(10.0),
//  decoration: BoxDecoration(
//  shape: BoxShape.circle,
//  color: profile_info_categories_background,
//  ),
//  child: Icon(
//  catg.icon,
//  // size: 20.0,
//  ),
//  ),
//  ),
//  catg.number > 0
//  ? Positioned(
//  right: -5.0,
//  child: Container(
//  padding: EdgeInsets.all(5.0),
//  decoration: BoxDecoration(
//  color: profile_info_background,
//  shape: BoxShape.circle,
//  ),
//  child: Text(
//  catg.number.toString(),
//  style: TextStyle(
//  color: Colors.white,
//  fontSize: 10.0,
//  ),
//  ),
//  ),
//  )
//      : SizedBox(),
//  ],
//  ),
//  SizedBox(
//  height: 10.0,
//  ),
//  Text(
//  catg.name,
//  style: TextStyle(
//  fontSize: 13.0,
//  ),
//  )
//  ],
//  );
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedPddGoodsDetailPage extends StatefulWidget {
  var productId;
  var gId;
  var goodsSign;
  var searchId;
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;
  KeTaoFeaturedPddGoodsDetailPage(
      {this.productId, this.gId, this.searchId, this.goodsSign});

  @override
  _KeTaoFeaturedPddGoodsDetailPageState createState() =>
      _KeTaoFeaturedPddGoodsDetailPageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _KeTaoFeaturedPddGoodsDetailPageState
    extends State<KeTaoFeaturedPddGoodsDetailPage>
    with TickerProviderStateMixin {
  AnimationController _controller;
  var _txtRedColor = const Color(0xffF93736);
  var _bgRedColor = const Color(0xffF32e43);
  KeTaoFeaturedPddGoodsInfoData pddDetailData;
  KeTaoFeaturedGoodsInfoEntity detailData;
  var _salePrice = '';
  var _discountPrice = '';
  var _originalPrice = '';
  var _queueCount = '0';
  var _btPrice = '';
  var _saleTip = '';
  var _showNum = '';
  var _couponsAmount = '';
  var _shopName = ''; //店铺名称
  var _logisticsScore = ''; //物流评分
  var _descriptiveScore = ''; //描述评分
  var _serviceScore = ''; //服务评分
  var _mobileUri = '';
  var _pddUri = ''; //直接拉起拼多多的url
  var _mobileH5Uri = '';
  var _validPeriod = '';

  var _desList = [
    '正品保障',
    '破损包退',
    '急速退款',
    '退货运费险',
  ];
  var _loginStatus = '2';

  //var _couponsAmount = '';

  Future _initData() async {
    try {
      EasyLoading.show();
    } catch (e) {}
    KeTaoFeaturedPddGoodsInfoEntity pddResultData =
        await KeTaoFeaturedHttpManage.getPddGoodsInfo(
            gId: widget.gId,
            goodsSign: widget.goodsSign,
            searchId: widget.searchId);
    try {
      EasyLoading.dismiss();
    } catch (e) {}
    if (pddResultData.status) {
      if (mounted) {
        setState(() {
          try {
            pddDetailData = pddResultData.data;
            _salePrice = pddDetailData.gGroupPrice.toString();
            _originalPrice = pddDetailData.gNormalPrice.toString();
//            _queueCount = resultData.data.queueCount;
            _btPrice = pddDetailData.gBonus;
            _detailImgs = pddDetailData.gSlideshow;
            if (!KeTaoFeaturedCommonUtils.isEmpty(_detailImgs)) {
              _swiperImgs = _detailImgs.length > 5
                  ? _detailImgs.sublist(0, 5)
                  : _detailImgs;
            }
            _mobileUri = pddDetailData.mobileUri;
            _mobileH5Uri = pddDetailData.url;
            _pddUri = pddDetailData.schemaUrl;
            _saleTip = pddDetailData.salesTip;
            _descriptiveScore = pddDetailData.descTxt;
            _serviceScore = pddDetailData.servTxt;
            _logisticsScore = pddDetailData.lgstTxt;
            _shopName = pddDetailData.mallName;
            _loginStatus = pddDetailData.loginStatus;
            try {
              _couponsAmount = pddDetailData.coupons.couponDiscount.toString();
            } catch (e) {}
            if (KeTaoFeaturedCommonUtils.isEmpty(_couponsAmount)) {
              _discountPrice = _salePrice;
            } else {
              _discountPrice =
                  (double.parse(_salePrice) - double.parse(_couponsAmount))
                      .toStringAsFixed(2);
            }
            _validPeriod =
                "${pddDetailData.coupons.couponStartTime}-${pddDetailData.coupons.couponEndTime}";

            //_showNum = resultData.data.minPower;
          } catch (e) {
            print(e);
            /* try {
                EasyLoading.dismiss();
              } catch (e) {}*/
          }
        });
      }
    } else {
      Fluttertoast.showToast(
          msg: pddResultData.errMsg,
          textColor: Colors.white,
          backgroundColor: Colors.grey);
    }
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _initData();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var _detailImgs = List<String>();
  var _swiperImgs = List<String>();

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return FlutterEasyLoading(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                bottom: ScreenUtil().setHeight(245),
              ),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil().setHeight(30),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: ScreenUtil.screenWidth,
                            child: Swiper(
                              key: UniqueKey(),
                              itemHeight: ScreenUtil.screenWidth,
                              itemCount:
                                  _swiperImgs == null ? 0 : _swiperImgs.length,
/*
                              itemCount: detailData == null ||
                                      detailData.data == null ||
                                      detailData.data.images == null
                                  ? 1
                                  : detailData.data.images.length,
*/
                              itemBuilder: (BuildContext context, int index) {
                                return _swiperImgs != null
                                    ? new CachedNetworkImage(
                                        imageUrl: _swiperImgs[index] == null
                                            ? ""
                                            : _swiperImgs[index],
                                        fit: BoxFit.fill,
                                      )
                                    : Image.asset("static/images/c_error.jpg");
                              },
                              autoplay: true,
                              controller: SwiperController(),
                              pagination: new SwiperPagination(
                                alignment: Alignment.bottomRight,
                                builder:
                                    KeTaoFeaturedMyFractionPaginationBuilder(
                                  activeColor: Colors.white,
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(28),
                                  activeFontSize: ScreenUtil().setSp(28),
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            height: 1,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(
                                    ScreenUtil().setWidth(30)))),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(
                                          bottom: ScreenUtil().setHeight(8)),
                                      child: Text(
                                        '券后价 ',
                                        style: TextStyle(
                                          color: _txtRedColor,
                                          fontSize: ScreenUtil().setSp(42),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    KeTaoFeaturedPriceText(
                                      text: '$_discountPrice',
                                      textColor: _txtRedColor,
                                      fontSize: ScreenUtil().setSp(42),
                                      fontBigSize: ScreenUtil().setSp(56),
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Visibility(
                                      visible: _originalPrice != _salePrice,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            bottom: ScreenUtil().setHeight(8)),
                                        child: Text(
                                          "￥$_originalPrice",
//                                      "${_getPrice(false) == null ? "" : _getPrice(false)}",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: ScreenUtil().setSp(36),
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Visibility(
                                        visible:
                                            !KeTaoFeaturedCommonUtils.isEmpty(
                                                _btPrice),
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: ScreenUtil().setHeight(30),
                                              bottom:
                                                  ScreenUtil().setHeight(8)),
                                          child: Text(
                                            "分红金：￥$_btPrice",
//                                      "${_getPrice(false) == null ? "" : _getPrice(false)}",
                                            style: TextStyle(
                                              color: _txtRedColor,
                                              fontSize: ScreenUtil().setSp(36),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          !KeTaoFeaturedCommonUtils.isEmpty(
                                              _saleTip),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              bottom:
                                                  ScreenUtil().setHeight(8)),
                                          child: Text(
                                            "销量：$_saleTip",
//                                      "${_getPrice(false) == null ? "" : _getPrice(false)}",
                                            style: TextStyle(
                                              color: Color(0xff999999),
                                              fontSize: ScreenUtil().setSp(36),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    spacing: 0,
                                    children: <Widget>[
                                      Text.rich(
                                        //"",
                                        TextSpan(children: [
                                          WidgetSpan(
                                              child: Container(
                                            width: ScreenUtil().setWidth(75),
                                            height: ScreenUtil().setWidth(42),
                                            child: Center(
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                    ScreenUtil().setWidth(10),
                                                  ),
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "https://alipic.lanhuapp.com/xd84ca449e-5f8a-4427-bc99-96f0af169b33",
//                                                      "https://img.pddpic.com/favicon.ico",
                                                  width:
                                                      ScreenUtil().setWidth(75),
                                                  height:
                                                      ScreenUtil().setWidth(42),
                                                ),
                                              ),
                                            ),
                                          )),
                                          TextSpan(
                                              text:
                                                  " ${pddDetailData == null || pddDetailData.gTitle == null ? "" : pddDetailData.gTitle}")
                                        ]),
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(42),
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.start,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(57),
                                ),
                                Visibility(
                                  visible: KeTaoFeaturedCommonUtils.isEmpty(
                                          _couponsAmount)
                                      ? false
                                      : true,
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          if (KeTaoFeaturedCommonUtils.isEmpty(
                                              _mobileUri)) {
                                            return;
                                          }
                                          if (_loginStatus == "0") {
                                            KeTaoFeaturedCommonUtils.showToast(
                                                "尚未登陆，请登录！");
                                            KeTaoFeaturedNavigatorUtils
                                                .navigatorRouter(context,
                                                    KeTaoFeaturedLoginPage());
                                            return;
                                          }
                                          if (_loginStatus == "1") {
                                            await launchPdd();
                                          }
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "https://alipic.lanhuapp.com/xd19448a68-5e62-4de5-9df9-fc6e45522e8d",
                                                width:
                                                    ScreenUtil().setWidth(1045),
                                                height:
                                                    ScreenUtil().setWidth(189),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            Container(
                                              width: double.maxFinite,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 0),
                                              padding: EdgeInsets.symmetric(
                                                vertical: 18,
                                              ),
                                              decoration: BoxDecoration(
//                                                image: DecorationImage(image: Image.network("https://alipic.lanhuapp.com/xdef91e85b-f090-41c2-b34c-35e198ba740e").image),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                    ScreenUtil().setWidth(30),
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Flexible(
                                                    flex: 3,
                                                    fit: FlexFit.tight,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomLeft,
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 6),
                                                            child: Text(
                                                              "￥",
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            42),
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 10),
                                                          child: Text(
                                                            "$_couponsAmount",
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            86),
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  "优惠券",
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              42),
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Visibility(
                                                                  visible: !KeTaoFeaturedCommonUtils
                                                                      .isEmpty(
                                                                          _validPeriod),
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        color: Color(
                                                                            0xffFF4344),
                                                                        borderRadius:
                                                                            BorderRadius.circular(ScreenUtil().setWidth(20))),
                                                                    width: ScreenUtil()
                                                                        .setWidth(
                                                                            102),
                                                                    height: ScreenUtil()
                                                                        .setWidth(
                                                                            35),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                8),
                                                                    child: Text(
                                                                      "有效期",
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            ScreenUtil().setSp(24),
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Visibility(
                                                              visible:
                                                                  !KeTaoFeaturedCommonUtils
                                                                      .isEmpty(
                                                                          _validPeriod),
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 4),
                                                                child: Text(
//                                                                '$_showNum天后过期_validPeriod',
                                                                  '$_validPeriod',
                                                                  maxLines: 1,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            28),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: Container(
                                                      child: Center(
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Color(
                                                                      0xffFF4344),
                                                                  gradient:
                                                                      LinearGradient(
                                                                          colors: [
                                                                        Color(
                                                                            0xffFF6E6D),
                                                                        Color(
                                                                            0xffFF4344),
                                                                      ]),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          ScreenUtil()
                                                                              .setWidth(44))),
                                                          width: ScreenUtil()
                                                              .setWidth(213),
                                                          height: ScreenUtil()
                                                              .setWidth(87),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "立即领取",
                                                            style: TextStyle(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          36),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.white,
                      width: double.maxFinite,
                      margin: EdgeInsets.only(
                        bottom: ScreenUtil().setWidth(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 16, right: 10),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        ScreenUtil().setWidth(30),
                                      ),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "https://www.pinduoduo.com/homeFavicon.ico",
                                      width: ScreenUtil().setWidth(138),
                                      height: ScreenUtil().setWidth(138),
                                      fit: BoxFit.fill,
                                    )),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        bottom: ScreenUtil().setWidth(32),
                                      ),
                                      child: Text(
                                        "$_shopName",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(48),
                                          color: Color(0xff222222),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                          fit: FlexFit.tight,
                                          flex: 1,
                                          child: Container(
                                            margin: EdgeInsets.only(top: 4),
                                            child: Text(
                                              '宝贝描述：$_descriptiveScore',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(24),
                                                color: Color(0xff999999),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.tight,
                                          flex: 1,
                                          child: Container(
                                            margin: EdgeInsets.only(top: 4),
                                            child: Text(
                                              '卖家服务：$_serviceScore',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(24),
                                                color: Color(0xff999999),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.tight,
                                          flex: 1,
                                          child: Container(
                                            margin: EdgeInsets.only(top: 4),
                                            child: Text(
                                              '物流评价：$_logisticsScore',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(24),
                                                color: Color(0xff999999),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            color: Color(0xfff6f6f6),
                            margin: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setWidth(30),
                            ),
                            height: ScreenUtil().setWidth(3),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(60),
                            ),
                            child: Row(
                              children: List.generate(
                                _desList.length,
                                (index) => Expanded(
                                    child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl:
                                          'https://alipic.lanhuapp.com/xd14aa2fbd-3d5f-46b8-b7ea-fa9e23c97e41',
                                      width: ScreenUtil().setWidth(30),
                                      height: ScreenUtil().setWidth(30),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(20),
                                      ),
                                      child: Text(
                                        "${_desList[index]}",
                                        style: TextStyle(
                                          color: Color(0xff999999),
                                          fontSize: ScreenUtil().setSp(24),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (content, index) {
                        return Column(
                          children: [
                            Visibility(
                              ///不展示商品详情
                              ///
                              visible: index == 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                color: Colors.white,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                              width: ScreenUtil().setWidth(9),
                                              height: ScreenUtil().setWidth(9),
                                              child: CircleAvatar(
                                                  backgroundColor:
                                                      Color(0xFFFF8800))),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: ScreenUtil().setWidth(12),
                                            height: ScreenUtil().setWidth(12),
                                            child: CircleAvatar(
                                                backgroundColor:
                                                    Color(0xFFFF7270)),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: ScreenUtil().setWidth(16),
                                            height: ScreenUtil().setWidth(16),
                                            child: CircleAvatar(
                                                backgroundColor:
                                                    Color(0xFFFBEE3A)),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("商品详情"),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: ScreenUtil().setWidth(16),
                                            height: ScreenUtil().setWidth(16),
                                            child: CircleAvatar(
                                                backgroundColor:
                                                    Color(0xFFFBEE3A)),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: ScreenUtil().setWidth(12),
                                            height: ScreenUtil().setWidth(12),
                                            child: CircleAvatar(
                                                backgroundColor:
                                                    Color(0xFFFF7270)),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: ScreenUtil().setWidth(9),
                                            height: ScreenUtil().setWidth(9),
                                            child: CircleAvatar(
                                                backgroundColor:
                                                    Color(0xFFFF8800)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              child: CachedNetworkImage(
                                imageUrl: _detailImgs[index],
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        );
                      },
                      childCount: _detailImgs == null ? 0 : _detailImgs.length,
                    ),
                  )
                ],
              ),
            ),
            SafeArea(
              child: Container(
                height: 50,
                alignment: Alignment.topLeft,
                child: ClipOval(
                  child: IconButton(
                    icon: CachedNetworkImage(
                      imageUrl:
                          "https://alipic.lanhuapp.com/xd45f343be-7273-4f2b-956d-80a7d39dde4a",
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: ScreenUtil().setHeight(245),
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin:
                            EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                        child: IconButton(
                            icon: CachedNetworkImage(
                              imageUrl:
                                  "https://alipic.lanhuapp.com/xd213bb1c5-b03e-4bcd-8573-9837e479d518",
                              width: ScreenUtil().setWidth(80),
                              height: ScreenUtil().setHeight(80),
                            ),
                            color: Colors.grey,
                            onPressed: () {
                              KeTaoFeaturedNavigatorUtils
                                  .navigatorRouterAndRemoveUntil(this.context,
                                      KeTaoFeaturedTaskIndexPage());
                            }),
                      ),
                      Expanded(
                        child: Container(
                          height: ScreenUtil().setHeight(155),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                          child: GestureDetector(
                            onTap: () async {
                              if (KeTaoFeaturedCommonUtils.isEmpty(
                                  _mobileUri)) {
                                return;
                              }
                              if (_loginStatus == "0") {
                                KeTaoFeaturedCommonUtils.showToast("尚未登陆，请登录！");
                                KeTaoFeaturedNavigatorUtils.navigatorRouter(
                                    context, KeTaoFeaturedLoginPage());
                                return;
                              }
                              if (_loginStatus == "1") {
                                await launchPdd();
                              }
                            },
                            child: Container(
                              height: ScreenUtil().setHeight(155),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 26),
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                " 立即购买 ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(42)),
                              ),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Color(0xFFF93736),
                                    Color(0xFFF93664)
                                  ]),
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///拼多多授权弹窗
  showPddAuthorizationDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              "温馨提示",
              style: TextStyle(
                fontSize: ScreenUtil().setSp(42),
              ),
            ),
            content: Text("该功能需要获取拼多多授权,确认授权吗？"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  "取消",
                  style: TextStyle(
                    color: Color(0xff222222),
                    fontSize: ScreenUtil().setSp(42),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  "去授权",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(42),
                  ),
                ),
                onPressed: () async {
                  ///请求拼多多授权
                  ///getPddAuthorization
                  ///
                  ///
                  Navigator.pop(context);
                  var result =
                      await KeTaoFeaturedHttpManage.getPddAuthorization();
                  if (result.status) {
                    ///跳转拼多多app授权的url
                    var pddUrl = '';

                    ///跳转拼多多h5页面授权的url
                    var url = '';
                    pddUrl = result.data['schema_url'];
                    url = result.data['url'];
                    if (await canLaunch(pddUrl)) {
                      await launch(pddUrl);
                    } else {
                      if (KeTaoFeaturedCommonUtils.isEmpty(url)) {
                        return;
                      }
                      KeTaoFeaturedNavigatorUtils.navigatorRouter(
                          this.context,
                          KeTaoFeaturedWebViewPluginPage(
                            initialUrl: "$url",
                            showActions: true,
                            title: "拼多多",
                            appBarBackgroundColor: Colors.white,
                          ));
                    }

                    ///
                  } else {
                    KeTaoFeaturedCommonUtils.showToast(result.errMsg);
                  }
                },
              ),
            ],
          );
        });
  }

  ///根据链接跳转拼多多
  Future launchPdd() async {
    if (await canLaunch("pinduoduo://")) {
      try {
        await launch(_pddUri, forceSafariVC: false);
      } catch (e) {}
    } else {
      KeTaoFeaturedNavigatorUtils.navigatorRouter(
          this.context,
          KeTaoFeaturedWebViewPluginPage(
            initialUrl: _mobileH5Uri,
            showActions: true,
            title: "拼多多",
            appBarBackgroundColor: Colors.transparent,
          ));
    }
  }
}

//商品规格弹窗
class DetailWindow extends StatefulWidget {
//  GoodsDetailBeanEntity detailData; todo
  KeTaoFeaturedGoodsInfoEntity detailData;
  int type;

  DetailWindow({@required this.detailData, @required this.type});

  @override
  _DetailWindowState createState() => _DetailWindowState();
}

class _DetailWindowState extends State<DetailWindow>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  var minStockNum = 999999999;
  var _txtRedColor = const Color(0xffF93736);
  var _bgRedColor = const Color(0xffF32e43);

  ///选中的商品规格id
  var specId;
  KeTaoFeaturedGoodsSpecInfoSpecInfo _specInfo;
  var _defaultImgUrl = '';
  var _goodsName = '';
  var _goodsPrice = '';

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    //_initSelectedMap();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

//商品价格

  var selectedMap = HashMap();

  //减少按钮
  Widget _reduceBtn(context) {
    return InkWell(
      onTap: () {
        if (_count > 1) {
          setState(() {
            _count--;
          });
        }
      },
      child: Container(
        width: ScreenUtil().setWidth(115),
        //是正方形的所以宽和高都是45
        height: ScreenUtil().setWidth(115),
        alignment: Alignment.center,
        //上下左右都居中
        decoration: BoxDecoration(
            color: _count > 1 ? Colors.white : Colors.black12,
            //按钮颜色大于1是白色，小于1是灰色
            border: Border(
                //外层已经有边框了所以这里只设置右边的边框
                right: BorderSide(width: 1.0, color: Colors.black12))),
        child: Text('-'), //数量小于1 什么都不显示
      ),
    );
  }

  //加号
  Widget _addBtn(context) {
    return InkWell(
      onTap: () {
        if (_count < minStockNum) {
          setState(() {
            _count++;
          });
        }
      },
      child: Container(
        width: ScreenUtil().setWidth(115),
        //是正方形的所以宽和高都是45
        height: ScreenUtil().setWidth(115),
        alignment: Alignment.center,
        //上下左右都居中
        decoration: BoxDecoration(
            color: _count < minStockNum ? Colors.white : Colors.black12,
            //按钮颜色大于1是白色，小于1是灰色
            border: Border(
                //外层已经有边框了所以这里只设置右边的边框
                left: BorderSide(width: 1.0, color: Colors.black12))),
        child: Text('+'),
      ),
    );
  }

  int _count = 1;

  //中间数量显示区域
  Widget _countArea() {
    return Container(
      width: ScreenUtil().setWidth(135),
      //爬两个数字的这里显示不下就宽一点70
      height: ScreenUtil().setWidth(115),
      //高度和加减号保持一样的高度
      alignment: Alignment.center,
      //上下左右居中
      color: Colors.white,
      // 设置为白色
      child: Text(
        '$_count',
        style: TextStyle(
            fontSize: ScreenUtil().setSp(54), color: const Color(0xff666666)),
      ), //先默认设置为1 因为后续是动态的获取数字
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              buildTopBox(),
              Container(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 22,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          buildSpecList(),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: ScreenUtil().setHeight(340),
              child: Stack(
                children: <Widget>[
                  Container(
                    //https://img.pddpic.com/favicon.ico
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "数量",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(42),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(""),
                        ),
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Colors.black12) //设置所有的边框宽度为1 颜色为浅灰
                                ),
                            child: Row(
                              children: <Widget>[
                                _reduceBtn(context),
                                _countArea(),
                                _addBtn(context)
                              ],
                            ))
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Opacity(
                      opacity: canSubmit ? 1 : 0.4,
                      child: GestureDetector(
                        onTap: () async {
                          if (canSubmit) {
                            createBuyOrder();
                            if (!mounted) return;
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                          height: ScreenUtil().setHeight(155),
                          color: minStockNum > 0 ? _bgRedColor : Colors.grey,
                          alignment: Alignment.center,
                          child: Text(
                            "${canSubmit ? '确定' : '缺货'}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(48),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          /*  SafeArea(
            child: Container(
              width: double.maxFinite,
              constraints: BoxConstraints(
                maxHeight:
                    MediaQuery.of(context).size.height / 1.5, //设置最大高度（必要）
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
                ),
              ),
//        height:  MediaQueryData.fromWindow(ui.window).size.height * 9.0 / 16.0,
              child: Stack(
                children: <Widget>[
                  Column(
                    children: [],
                  ),
                  Positioned.fill(
                    bottom: ScreenUtil().setHeight(0),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: ScreenUtil().setHeight(340),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "数量",
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(42),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(""),
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: Colors
                                                  .black12) //设置所有的边框宽度为1 颜色为浅灰
                                          ),
                                      child: Row(
                                        children: <Widget>[
                                          _reduceBtn(context),
                                          _countArea(),
                                          _addBtn(context)
                                        ],
                                      ))
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                onTap: () async {
                                  createBuyOrder(context);
                                  Navigator.maybePop(context);
                                },
                                child: Container(
                                  height: ScreenUtil().setHeight(155),
                                  color: minStockNum > 0
                                      ? _bgRedColor
                                      : Colors.grey,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "确定",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(48),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 8),
                            child: Icon(Icons.close, size: 22)),
                      )),
                ],
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  Widget buildSpecList() {
    List<KeTaoFeaturedGoodsSpecInfoSpecInfoSpecItem> _specItem =
        List<KeTaoFeaturedGoodsSpecInfoSpecInfoSpecItem>();
    var _specPrice;
    try {
      _specItem = widget.detailData.data.specInfo.specItem;
      _specPrice = widget.detailData.data.specInfo.specPrice;
    } catch (e) {}
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          KeTaoFeaturedGoodsSpecInfoSpecInfoSpecItem opItem = _specItem[index];
          return Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: ScreenUtil().setWidth(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Visibility(
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: ScreenUtil().setWidth(20),
                    ),
                    child: Text(
                      "${opItem.name}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(42),
                      ),
                    ),
                  ),
                  visible: opItem.xList != null && opItem.xList.length > 0,
                ),
                Wrap(
                  spacing: ScreenUtil().setWidth(26),
                  runSpacing: ScreenUtil().setWidth(8),
                  alignment: WrapAlignment.start,
                  children: opItem.xList.asMap().keys.map((valueIndex) {
                    return KeTaoFeaturedGoodsSelectChoiceChip(
                      /*label:
                        Text('${option.productOptionValue[valueIndex].name}'),
                    selected: selectedMap[option.productOptionId] ==
                        option.productOptionValue[valueIndex]
                            .productOptionValueId,
                    labelStyle: TextStyle(
                        backgroundColor: Colors.transparent,
                        color: Colors.black),
                    //修改边框样式
                    selectBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.blue, width: 0.5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.black, width: 1),
                    ),
                    backgroundColor: Colors.transparent,*/
                      text: '${opItem.xList[valueIndex]}',
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      textSelectColor: Color(0xffF93736),
                      fontSize: ScreenUtil().setSp(42),
                      selected: selectedMap[index] == valueIndex,
                      onSelected: (v) {
                        setState(() {
                          selectedMap.addEntries([MapEntry(index, valueIndex)]);
//                          checkSelectedData(_specPrice);
                        });
                      },
                    );
                  }).toList(),
                )
              ],
            ),
          );
        },
        itemCount: _specItem.length);
  }

  bool canSubmit = true;

  void checkSelectedData(
      _specPrice, List<KeTaoFeaturedGoodsSpecInfoSpecInfoSpecItem> _specItem) {
    for (var index = 0; index < _specItem.length; index++) {
      if (!selectedMap.containsKey(index)) {
        for (var j = 0; j < _specItem[index].xList.length; j++) {
          selectedMap.addEntries([MapEntry(index, j)]);
          break;
        }
      }
    }
    var _indexTxt = 'ids';
    selectedMap.forEach((key, value) {
      _indexTxt += '_' + value.toString();
    });
    if (_specPrice.toString().contains(_indexTxt)) {
      try {
        canSubmit = true;
        KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds specInfo =
            KeTaoFeaturedGoodsSpecInfoSpecInfoSpecPriceIds();
        goodsSpecInfoSpecInfoSpecPriceIdsFromJson(
            specInfo, _specPrice[_indexTxt]);
        _defaultImgUrl = specInfo.specImg;
        _goodsPrice = specInfo.specPrice;
        specId = specInfo.specId;
        print(
            'specImg=$_defaultImgUrl&&specPrice=$_goodsPrice&&specId=$specId');

        /* if (mounted) {
        setState(() {});
      }*/
      } catch (e) {
        print("specIdspecIdspecIdspecId$e");
      }
    } else {
      canSubmit = false;
      print("specIdspecIdspecIdspecId=====null");
    }
  }

  Future createBuyOrder() async {
    var goodsId = '';
    var goodsNum;
    var orderId = '';
    try {
      goodsId = widget.detailData.data.id;
      goodsNum = _count;
    } catch (e) {}
    /* try {
                EasyLoading.dismiss();
              } catch (e) {}*/
    EasyLoading.show();
    var result = await KeTaoFeaturedHttpManage.createOrder(goodsId, goodsNum,
        specId: specId);
    EasyLoading.dismiss();
    if (result.status) {
      try {
        orderId = result.data['order_id'].toString();
      } catch (e) {}
      var context =
          KeTaoFeaturedGlobalConfig.navigatorKey.currentState.overlay.context;
      KeTaoFeaturedNavigatorUtils.navigatorRouter(
          context,
          KeTaoFeaturedEnsureOrderPage(
            orderId: "$orderId",
          ));
    } else {
      KeTaoFeaturedCommonUtils.showToast("${result.errMsg}");
    }
  }

  Widget buildTopBox() {
    try {
      _defaultImgUrl = widget.detailData.data.bannerImgs[0];
      _goodsName = widget.detailData.data.goodsName;
      _goodsPrice = widget.detailData.data.salePrice;
      _specInfo = widget.detailData.data.specInfo;
    } catch (e) {}
    List<KeTaoFeaturedGoodsSpecInfoSpecInfoSpecItem> _specItem =
        List<KeTaoFeaturedGoodsSpecInfoSpecInfoSpecItem>();
    var _specPrice;
    try {
      _specItem = widget.detailData.data.specInfo.specItem;
      _specPrice = widget.detailData.data.specInfo.specPrice;
      checkSelectedData(_specPrice, _specItem);
    } catch (e) {}
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        width: ScreenUtil().setHeight(1),
        color: Color(0xffdedede),
      ))),
      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: "$_defaultImgUrl",
/*
                widget.detailData == null || widget.detailData.data == null
                    ? ""
                    : widget.detailData.data.thumb,
*/
            width: ScreenUtil().setWidth(180),
            height: ScreenUtil().setWidth(180),
            fit: BoxFit.fill,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                KeTaoFeaturedPriceText(
                  text: '$_goodsPrice',
                  textColor: _txtRedColor,
                  fontSize: ScreenUtil().setSp(32),
                  fontBigSize: ScreenUtil().setSp(42),
                ),
                /* Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: "￥",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(42),
                      ),
                    ),
                    TextSpan(
                      text: "$goodsPrice",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(42),
                      ),
                    ),
                  ]),
                  style: TextStyle(
                    color: _txtRedColor,
                    fontSize: ScreenUtil().setSp(56),
                    fontWeight: FontWeight.bold,
                  ),
                ),*/
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(16)),
                  child: Text(
                    "$_goodsName",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(42),
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
}
