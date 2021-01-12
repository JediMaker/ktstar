import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:ui' as ui show window;

import 'package:star/bus/my_event_bus.dart';
import 'package:star/generated/json/goods_spec_info_entity_helper.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/goods_info_entity.dart';
import 'package:star/models/pdd_goods_info_entity.dart';
import 'package:star/pages/goods/ensure_order.dart';
import 'package:star/pages/goods/free_queue.dart';
import 'package:star/pages/task/task_index.dart';
import 'package:star/pages/widget/PriceText.dart';
import 'package:star/pages/widget/goods_select_choice.dart';
import 'package:star/pages/widget/my_webview_plugin.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';
import 'package:star/models/goods_spec_info_entity.dart';
import 'package:star/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global_config.dart';

class HomeGoodsDetailPage extends StatefulWidget {
  var productId;
  var gId;
  var goodsSign;
  var searchId;

  HomeGoodsDetailPage(
      {this.productId, this.gId, this.searchId, this.goodsSign});

  @override
  _HomeGoodsDetailPageState createState() => _HomeGoodsDetailPageState();
}

class _HomeGoodsDetailPageState extends State<HomeGoodsDetailPage>
    with TickerProviderStateMixin {
  AnimationController _controller;
  var _txtRedColor = const Color(0xffF93736);
  var _bgRedColor = const Color(0xffF32e43);
  PddGoodsInfoData pddDetailData;
  GoodsInfoEntity detailData;
  var _salePrice = '';
  var _originalPrice = '';
  var _queueCount = '0';
  var _btPrice = '';
  var _saleTip = '';
  var _showNum = '';
  var _couponsAmount = '';
  var _mobileUri = '';
  var _mobileH5Uri = '';

  //var _couponsAmount = '';

  Future _initData() async {
    try {
      EasyLoading.show();
    } catch (e) {}
    PddGoodsInfoEntity pddResultData = await HttpManage.getPddGoodsInfo(
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
//            _btPrice = resultData.data.btPrice;
            _detailImgs = pddDetailData.gSlideshow;
            _mobileUri = pddDetailData.mobileUri;
            _mobileH5Uri = pddDetailData.url;
            _saleTip = pddDetailData.salesTip;
            _couponsAmount = pddDetailData.coupons.couponDiscount.toString();
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
                        bottom: ScreenUtil().setHeight(60),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: ScreenUtil().setHeight(1231),
                            child: Swiper(
                              key: UniqueKey(),
                              itemHeight: ScreenUtil().setHeight(1231),
                              itemCount:
                                  _detailImgs == null ? 0 : _detailImgs.length,
/*
                              itemCount: detailData == null ||
                                      detailData.data == null ||
                                      detailData.data.images == null
                                  ? 1
                                  : detailData.data.images.length,
*/
                              itemBuilder: (BuildContext context, int index) {
                                return _detailImgs != null
                                    ? new CachedNetworkImage(
                                        imageUrl: _detailImgs[index] == null
                                            ? ""
                                            : _detailImgs[index],
                                        fit: BoxFit.fill,
                                      )
                                    : Image.asset("static/images/c_error.jpg");
                              },
                              autoplay: true,
                              controller: SwiperController(),
                              pagination: new SwiperPagination(
                                  alignment: Alignment.bottomRight,
                                  builder: FractionPaginationBuilder(
                                    activeColor: Colors.black,
                                    color: Colors.black,
                                    fontSize: ScreenUtil().setSp(20),
                                    activeFontSize: ScreenUtil().setSp(20),
                                  )),
                            ),
                          ),
                          Divider(
                            height: 1,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            padding: EdgeInsets.symmetric(
                                vertical: 18, horizontal: 16),
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
                                        '拼团价 ',
                                        style: TextStyle(
                                          color: _txtRedColor,
                                          fontSize: ScreenUtil().setSp(42),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    PriceText(
                                      text: '$_salePrice',
                                      textColor: _txtRedColor,
                                      fontSize: ScreenUtil().setSp(42),
                                      fontBigSize: ScreenUtil().setSp(56),
                                    ),
                                    SizedBox(
                                      width: 16,
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
                                      child: SizedBox(
                                        width: 16,
                                      ),
                                    ),
                                    Visibility(
                                      visible: !CommonUtils.isEmpty(_btPrice),
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            bottom: ScreenUtil().setHeight(8)),
                                        child: Text(
                                          "收益：￥$_btPrice",
//                                      "${_getPrice(false) == null ? "" : _getPrice(false)}",
                                          style: TextStyle(
                                            color: _txtRedColor,
                                            fontSize: ScreenUtil().setSp(36),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: !CommonUtils.isEmpty(_saleTip),
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
                                    spacing: 10,
                                    children: <Widget>[
                                      Text.rich(
                                        //"",
                                        TextSpan(children: [
                                          WidgetSpan(
                                              child: CachedNetworkImage(
                                            width: ScreenUtil().setWidth(48),
                                            height: ScreenUtil().setWidth(48),
                                            imageUrl:
                                                "https://img.pddpic.com/favicon.ico",
                                          )),
                                          TextSpan(
                                              text:
                                                  " ${pddDetailData == null || pddDetailData.gTitle == null ? "" : pddDetailData.gTitle}")
                                        ]),
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(42),
                                        ),
                                        textAlign: TextAlign.start,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: CommonUtils.isEmpty(_couponsAmount)
                                ? false
                                : true,
                            child: GestureDetector(
                              onTap: () async {
                                if (CommonUtils.isEmpty(_mobileUri)) {
                                  return;
                                }
                                await launchPdd();
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 0),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "https://alipic.lanhuapp.com/xdef91e85b-f090-41c2-b34c-35e198ba740e",
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 0),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 18, horizontal: 16),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                ScreenUtil().setWidth(30)))),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              right: ScreenUtil().setWidth(150),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "$_couponsAmount元优惠券",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(56),
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                /*Container(
                                                  margin:
                                                      EdgeInsets.only(top: 4),
                                                  child: Text(
                                                    '$_showNum天后过期',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: ScreenUtil()
                                                          .setSp(36),
                                                    ),
                                                  ),
                                                ),*/
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: true,
                                          child: Container(
                                            width: ScreenUtil().setWidth(210),
                                            child: Text(
                                              "立即\n领取",
                                              style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(48),
                                                color: Colors.white,
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
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(57),
                          ),
                          Visibility(
                            ///不展示商品详情
                            ///
                            visible: true,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
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
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (content, index) {
                        return CachedNetworkImage(
                          imageUrl: _detailImgs[index],
                          fit: BoxFit.fill,
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
                          "https://alipic.lanhuapp.com/xded955fd8-b440-4233-863c-337b04b3e66b",
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
                              NavigatorUtils.navigatorRouterAndRemoveUntil(
                                  this.context, TaskIndexPage());
                            }),
                      ),
                      Expanded(
                        child: Container(
                          height: ScreenUtil().setHeight(155),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                          child: GestureDetector(
                            onTap: () async {
                              if (CommonUtils.isEmpty(_mobileUri)) {
                                return;
                              }
                              await launchPdd();
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

  ///根据链接跳转拼多多
  Future launchPdd() async {
    /* if (await canLaunch("pinduoduo://")) {
      try {
        await launch(_mobileUri, forceSafariVC: false);
      } catch (e) {}
    } else {

    }*/
    NavigatorUtils.navigatorRouter(
        this.context,
        WebViewPluginPage(
          initialUrl: _mobileH5Uri,
          showActions: true,
          title: "拼多多",
          appBarBackgroundColor: Colors.transparent,
        ));
  }
}

//商品规格弹窗
class DetailWindow extends StatefulWidget {
//  GoodsDetailBeanEntity detailData; todo
  GoodsInfoEntity detailData;
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
  GoodsSpecInfoSpecInfo _specInfo;
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
    List<GoodsSpecInfoSpecInfoSpecItem> _specItem =
        List<GoodsSpecInfoSpecInfoSpecItem>();
    var _specPrice;
    try {
      _specItem = widget.detailData.data.specInfo.specItem;
      _specPrice = widget.detailData.data.specInfo.specPrice;
    } catch (e) {}
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          GoodsSpecInfoSpecInfoSpecItem opItem = _specItem[index];
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
                    return GoodsSelectChoiceChip(
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
      _specPrice, List<GoodsSpecInfoSpecInfoSpecItem> _specItem) {
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
        GoodsSpecInfoSpecInfoSpecPriceIds specInfo =
            GoodsSpecInfoSpecInfoSpecPriceIds();
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
    var result =
        await HttpManage.createOrder(goodsId, goodsNum, specId: specId);
    EasyLoading.dismiss();
    if (result.status) {
      try {
        orderId = result.data['order_id'].toString();
      } catch (e) {}
      var context = GlobalConfig.navigatorKey.currentState.overlay.context;
      NavigatorUtils.navigatorRouter(
          context,
          EnsureOrderPage(
            orderId: "$orderId",
          ));
    } else {
      CommonUtils.showToast("${result.errMsg}");
    }
  }

  Widget buildTopBox() {
    try {
      _defaultImgUrl = widget.detailData.data.bannerImgs[0];
      _goodsName = widget.detailData.data.goodsName;
      _goodsPrice = widget.detailData.data.salePrice;
      _specInfo = widget.detailData.data.specInfo;
    } catch (e) {}
    List<GoodsSpecInfoSpecInfoSpecItem> _specItem =
        List<GoodsSpecInfoSpecInfoSpecItem>();
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
                PriceText(
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
