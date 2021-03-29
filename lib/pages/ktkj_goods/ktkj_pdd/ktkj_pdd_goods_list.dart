import 'dart:convert';

import 'package:star/global_config.dart';
import 'package:star/pages/ktkj_goods/ktkj_pdd/ktkj_pdd_goods_detail.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_octoimage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:star/bus/ktkj_my_event_bus.dart';
import 'package:star/generated/json/home_goods_list_entity_helper.dart';
import 'package:star/http/ktkj_http_manage.dart';
import 'package:star/models/home_goods_list_entity.dart';
import 'package:star/models/pdd_goods_list_entity.dart';
import 'package:star/pages/ktkj_login/ktkj_login.dart';
import 'package:star/pages/ktkj_widget/ktkj_PriceText.dart';
import 'package:star/pages/ktkj_widget/ktkj_dashed_rect.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_webview_plugin.dart';
import 'package:star/pages/ktkj_widget/ktkj_no_data.dart';
import 'package:star/utils/ktkj_common_utils.dart';
import 'package:star/utils/ktkj_navigator_utils.dart';
import 'package:url_launcher/url_launcher.dart';


// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJPddGoodsListPage extends StatefulWidget {
  KTKJPddGoodsListPage(
      {Key key,
      this.title = "补贴商品",
      this.categoryId = '',
      this.type = '',
      this.tabIndex,
      this.showAppBar = false})
      : super(key: key);
  String title = "精选商品";
  String categoryId;
  String type;
  bool showAppBar;
  int tabIndex = -1;

  @override
  _PddGoodsListPageState createState() => _PddGoodsListPageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _PddGoodsListPageState extends State<KTKJPddGoodsListPage>
    with AutomaticKeepAliveClientMixin {
  int page = 1;
  bool isFirstLoading = true;
  List<PddGoodsListDataList> pddGoodsList = List<PddGoodsListDataList>();
  var listId;
  EasyRefreshController _refreshController;

  _initData() async {
    /* var result = await HttpManage.getGoodsList(cId: widget.categoryId);
    if (result.status) {
      HomeGoodsListEntity entity = HomeGoodsListEntity();
      homeGoodsListEntityFromJson(entity, result.data);
      if (mounted) {
        setState(() {
          if (page == 1) {
            goodsList = entity.goodsList;
          } else {
            if (result == null ||
                result.data == null ||
                entity.goodsList == null ||
                entity.goodsList.length == 0) {
              //              _refreshController.resetLoadState();
            } else {
              goodsList += entity.goodsList;
            }
          }
          isFirstLoading = false;
        });
      }
    } else {
      KTKJCommonUtils.showToast(result.errMsg);
    }*/
    if (!KTKJGlobalConfig.isLogin()) {
      KTKJCommonUtils.showToast("未获取到登录信息，，请登录！");
      Future.delayed(Duration(seconds: 1), () {
        KTKJNavigatorUtils.navigatorRouter(context, KTKJLoginPage());
      });
      return;
    }
    var authResult = await HttpManage.getPddAuth();
    if (authResult.errCode.toString() == "50001" ||
        authResult.errCode.toString() == "60001") {
      showPddAuthorizationDialog();
      return;
    }
    if (isFirstLoading) {
      /* try {
        EasyLoading.show();
      } catch (e) {}*/
    }
    try {
      var result2 = await HttpManage.getPddGoodsList(page,
          listId: listId, categoryId: widget.categoryId, type: widget.type);
      print("getPddGoodsList");
      /* try {
        EasyLoading.dismiss();
      } catch (e) {}*/
      if (result2.status) {
        if (mounted) {
          setState(() {
            listId = result2.data.listId;
            if (page == 1) {
              //下拉刷新
              pddGoodsList = result2.data.xList;
            } else {
              //加载更多
              if (result2 == null ||
                  result2.data == null ||
                  result2.data.xList == null ||
                  result2.data.xList.length == 0) {
                //              _refreshController.resetLoadState();
              } else {
                pddGoodsList += result2.data.xList;
              }
            }
            isFirstLoading = false;
          });
        }
      } else {
        KTKJCommonUtils.showToast(result2.errMsg);
      }
    } catch (e) {}
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
                  Navigator.pop(this.context);
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
                  var result = await HttpManage.getPddAuthorization();
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
                      if (KTKJCommonUtils.isEmpty(url)) {
                        return;
                      }
                      KTKJNavigatorUtils.navigatorRouter(
                          this.context,
                          KTKJWebViewPluginPage(
                            initialUrl: "$url",
                            showActions: true,
                            title: "拼多多",
                            appBarBackgroundColor: Colors.white,
                          ));
                    }

                    ///
                  } else {
                    KTKJCommonUtils.showToast(result.errMsg);
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController();
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  ///根布局
  Widget buildView() {
    return Container(
      width: double.maxFinite,
      height: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16),
      child: EasyRefresh.custom(
        header: MaterialHeader(),
        footer: CustomFooter(
//          triggerDistance: ScreenUtil().setWidth(180),
            completeDuration: Duration(seconds: 1),
            footerBuilder: (context,
                loadState,
                pulledExtent,
                loadTriggerPullDistance,
                loadIndicatorExtent,
                axisDirection,
                float,
                completeDuration,
                enableInfiniteLoad,
                success,
                noMore) {
              return Stack(
                children: <Widget>[
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Visibility(
                      visible: noMore,
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(30),
                            bottom: ScreenUtil().setWidth(30),
                          ),
                          child: Text(
                            "~我是有底线的~",
                            style: TextStyle(
                              color: Color(0xff666666),
                              fontSize: ScreenUtil().setSp(32),
                            ),
                          ),
                        ),
                      ),
                    ),
//                  child: Container(
//                    width: 30.0,
//                    height: 30.0,
//                    /* child: SpinKitCircle(
//                            color: KTKJGlobalConfig.colorPrimary,
//                            size: 30.0,
//                          ),*/
//                  ),
                  ),
                ],
              );
            }),
        controller: _refreshController,
//        enableControlFinishRefresh: true,
//        enableControlFinishLoad: true,
        onRefresh: () {
//          if (!isFirstLoading) {
          page = 1;
          _initData();
          print("onRefresh");
//          }
        },
        onLoad: () {
//          if (!isFirstLoading) {
          page++;
          _initData();
//          }
        },
        topBouncing: false,
        bottomBouncing: false,
        emptyWidget: pddGoodsList == null || pddGoodsList.length == 0
            ? KTKJNoDataPage()
            : null,
        slivers: <Widget>[
          buildCenter2(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ///    组件创建完成的回调通知方法
    ///解决首次数据加载失败问题
    ///
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /*if (!KTKJCommonUtils.isEmpty(goodsList)) {
      } else {
        _initData();
      }*/
    });
    return FlutterEasyLoading(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Visibility(
            visible: widget.showAppBar,
            child: AppBar(
              title: Text(
                "${widget.title}",
                style: TextStyle(
                    color: Color(0xFF222222), fontSize: ScreenUtil().setSp(54)),
              ),
              brightness: Brightness.light,
              leading: IconButton(
                icon: Container(
                  width: ScreenUtil().setWidth(63),
                  height: ScreenUtil().setHeight(63),
                  child: Center(
                    child: Image.asset(
                      "static/images/icon_ios_back.png",
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
              backgroundColor: KTKJGlobalConfig.taskNomalHeadColor,
              elevation: 0,
            ),
          ),
        ),
        body:
            buildView(), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Widget buildCenter2() {
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          width: double.maxFinite,
          margin:
              EdgeInsets.symmetric(horizontal: KTKJGlobalConfig.LAYOUT_MARGIN),
//          height: double.infinity,
          child: new StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            itemCount: pddGoodsList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              PddGoodsListDataList item;
              try {
                item = pddGoodsList[index];
              } catch (e) {}
              return productItem2(item: item);
            },
            staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
            mainAxisSpacing: ScreenUtil().setWidth(30),
            crossAxisSpacing: ScreenUtil().setWidth(30),
          ),
        ),
      ),
    );
  }

  var _priceColor = const Color(0xffF93736);

  Widget productItem2({PddGoodsListDataList item}) {
    String id = '';
    String goodsName = '';
    String goodsImg = '';
    String originalPrice = '';
    String salePrice = '';
    double topMargin = 0;
    String profit = '分红金￥0';
    String couponAmount = ''; //优惠券金额
    String goodsSign = ''; //
    String searchId = ''; //
    var _discountPrice = '';
    var _saleTip = '';
    var _shopName = '';
    var _gBonus = '';
    try {
      id = item.gId.toString();
      goodsName = item.gTitle;
      goodsImg = item.gThumbnail;
      originalPrice = item.gNormalPrice.toString();
      salePrice = item.gGroupPrice.toString();
      goodsSign = item.goodsSign.toString();
      searchId = item.searchId.toString();
      _saleTip = item.salesTip.toString();
      _shopName = item.mallName.toString();
      _gBonus = item.gBonus.toString();

      try {
        couponAmount = item.coupons.couponDiscount.toString();
      } catch (e) {}
      if (KTKJCommonUtils.isEmpty(couponAmount)) {
        _discountPrice = salePrice;
      } else {
        _discountPrice = (double.parse(salePrice) - double.parse(couponAmount))
            .toStringAsFixed(2);
      }
//      profit = '预估补贴￥${(item.btPrice)}';
      /*  if (goodsName.length < 8) {
        topMargin = ScreenUtil().setHeight(70);
      } else {
        topMargin = ScreenUtil().setHeight(10);
      }*/
    } catch (e) {}

    return GestureDetector(
      onTap: () {
//        launchWeChatMiniProgram(username: "gh_8ae370170974");
        KTKJNavigatorUtils.navigatorRouter(
            context,
            KTKJPddGoodsDetailPage(
              gId: id,
              goodsSign: goodsSign,
              searchId: searchId,
            ));
      },
      child: Container(
//            color: Colors.blue ,商学院
          width: ScreenUtil().setWidth(523),
//          margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
          /*constraints: BoxConstraints(
            minHeight: ScreenUtil().setHeight(560),
          ),*/
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
          ),
          child: Padding(
//                  padding: const EdgeInsets.only(left: 4,right: 4,top: 4,bottom: 4),
            padding: const EdgeInsets.all(0),
//            child: InkWell(
//              splashColor: Colors.yellow,

//        onDoubleTap: () => showSnackBar(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
//                        fit: StackFit.expand,
              children: <Widget>[
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(30)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(ScreenUtil().setWidth(30)),
                          topLeft: Radius.circular(ScreenUtil().setWidth(30)),
                        ),
                        child: KTKJMyOctoImage(
                          fadeInDuration: Duration(milliseconds: 0),
                          fadeOutDuration: Duration(milliseconds: 0),
                          height: ScreenUtil().setWidth(523),
                          width: ScreenUtil().setWidth(523),
                          fit: BoxFit.fill,
                          image: "$goodsImg",
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !KTKJCommonUtils.isEmpty(_gBonus),
                      child: Container(
                        height: ScreenUtil().setWidth(60),
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                        ),
                        margin: EdgeInsets.only(
                          top: ScreenUtil().setSp(463),
                        ),
                        color: _priceColor,
                        child: Row(
                          children: [
                            Expanded(
                              child: Visibility(
                                child: Container(
                                  child: Text(
                                    "预估分红金：¥$_gBonus",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(28),
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

//                          SizedBox(
//                            height: 10,
//                          ),

                Container(
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20),
                    right: ScreenUtil().setWidth(20),
                    top: ScreenUtil().setHeight(16),
                  ),
                  child: Text.rich(
                    //"$goodsName",
                    TextSpan(children: [
                      /*WidgetSpan(
                          child: Container(
                        width: ScreenUtil().setWidth(75),
                        height: ScreenUtil().setWidth(52),
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                ScreenUtil().setWidth(10),
                              ),
                            ),
                            child: KTKJMyOctoImage(
                              image:
                                  "https://alipic.lanhuapp.com/xd84ca449e-5f8a-4427-bc99-96f0af169b33",
                              width: ScreenUtil().setWidth(75),
                              height: ScreenUtil().setWidth(42),
                            ),
                          ),
                        ),
                      )),*/
                      TextSpan(text: "$goodsName")
                    ]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(38),
                      color: Color(0xff222222),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Visibility(
                          visible: !KTKJCommonUtils.isEmpty(_shopName),
                          child: Container(
                            child: Text(
                              "$_shopName",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                                color: Color(0xff999999),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "销量$_saleTip",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                          color: Color(0xff999999),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: false,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(8),
                      right: ScreenUtil().setWidth(8),
                      top: ScreenUtil().setWidth(8),
                      bottom: ScreenUtil().setWidth(8),
                    ),
                    margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                      top: ScreenUtil().setWidth(8),
                      bottom: ScreenUtil().setWidth(8),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xffFFDDDC),
                      borderRadius: BorderRadius.circular(
                        ScreenUtil().setWidth(10),
                      ),
                    ),
                    child: Text(
                      "$profit",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                        color: _priceColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: topMargin),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 5,
                      ),
                      PriceText(
                        text: '$_discountPrice',
                        textColor: _priceColor,
                        fontSize: ScreenUtil().setSp(32),
                        fontBigSize: ScreenUtil().setSp(42),
//                          '27.5',
                        /*style: TextStyle(
                          fontSize: ScreenUtil().setSp(42),
                          color: _priceColor,
                          fontWeight: FontWeight.bold,
                        ),*/
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(20),
                      ),
                      Expanded(
                        child: Container(
                          child: Visibility(
                            visible: salePrice != originalPrice,
                            child: Text(
                              "￥$originalPrice",
                              overflow: TextOverflow.ellipsis,
//                            '${0}人评价',
//                            '23234人评价',
//                          product
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: ScreenUtil().setSp(32),
                                  color: Color(0xFF979896)),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !KTKJCommonUtils.isEmpty(couponAmount),
                        child: Container(
                          height: ScreenUtil().setHeight(52),
                          padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(8),
                            right: ScreenUtil().setWidth(8),
                          ),
                          margin: EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: _priceColor,
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(10)),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "券",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(32),
                                ),
                              ),
                              Container(
                                height: ScreenUtil().setHeight(42),
                                margin: EdgeInsets.symmetric(horizontal: 2),
                                child: KTKJDashedRect(
                                    color: Colors.white,
                                    strokeWidth: 1,
                                    gap: 1.0),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 2),
                                child: Text(
                                  "${couponAmount.toString()}元",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
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
                ),
                SizedBox(
                  height: 8,
                )
//                          descStack(product),
//                          ratingStack(product.rating),
//                          Container( child: imageStack(product.image),),
              ],
            ),
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
