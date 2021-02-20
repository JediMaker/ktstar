import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:star/ktxxbus/kt_my_event_bus.dart';
import 'package:star/generated/json/ktxx_home_goods_list_entity_helper.dart';
import 'package:star/ktxxhttp/ktxx_http_manage.dart';
import 'package:star/ktxxmodels/ktxx_home_goods_list_entity.dart';
import 'package:star/ktxxmodels/ktxx_home_pdd_category_entity.dart';
import 'package:star/ktxxmodels/ktxx_pdd_goods_list_entity.dart';
import 'package:star/ktxxpages/ktxxgoods/ktxxpdd/ktxx_pdd_goods_detail.dart';
import 'package:star/ktxxpages/ktxxwidget/ktxx_price_text.dart';
import 'package:star/ktxxpages/ktxxwidget/ktxx_dashed_rect.dart';
import 'package:star/ktxxpages/ktxxwidget/ktxx_my_webview_plugin.dart';
import 'package:star/ktxxpages/ktxxwidget/ktxx_no_data.dart';
import 'package:star/ktxxutils/ktxx_common_utils.dart';
import 'package:star/ktxxutils/ktxx_navigator_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../ktxx_global_config.dart';
import 'ktxx_goods_detail.dart';
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
class KeTaoFeaturedHomePddGoodsListPage extends StatefulWidget {
  KeTaoFeaturedHomePddGoodsListPage({Key key, this.title = "补贴商品", this.categoryId = ''})
      : super(key: key);
  String title = "补贴商品";
  String categoryId;
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;
  @override
  _KeTaoFeaturedHomePddGoodsListPageState createState() => _KeTaoFeaturedHomePddGoodsListPageState();
}
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _KeTaoFeaturedHomePddGoodsListPageState extends State<KeTaoFeaturedHomePddGoodsListPage>
    with AutomaticKeepAliveClientMixin {
  int page = 1;
  int count = 1;
  bool isFirstLoading = true;
  List<KeTaoFeaturedHomeGoodsListGoodsList> goodsList = List<KeTaoFeaturedHomeGoodsListGoodsList>();
  List<KeTaoFeaturedPddGoodsListDataList> pddGoodsList = List<KeTaoFeaturedPddGoodsListDataList>();
  var listId;
  var categoryId;
  var type;
  bool _isfirst = true;

  _initData() async {
    /*var result = await HttpManage.getGoodsList(cId: widget.categoryId);
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
      CommonUtils.showToast(result.errMsg);
    }*/

    var result2 = await KeTaoFeaturedHttpManage.getPddGoodsList(page,
        listId: listId, type: type, categoryId: categoryId);
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
      if (result2.errCode.toString() == "50001" ||
          result2.errCode.toString() == "60001") {
        showPddAuthorizationDialog();
        return;
      }
      KeTaoFeaturedCommonUtils.showToast(result2.errMsg);
    }
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
                  var result = await KeTaoFeaturedHttpManage.getPddAuthorization();
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

  @override
  void initState() {
    super.initState();
    categoryId = widget.categoryId;
    _initData();
    bus.on("refreshHomeData", (arg) {
      page = 1;
      listId = '';
      _initData();
    });
    bus.on("loadMoreHomeData", (arg) {
      page++;
      _initData();
    });
    bus.on("changePddListViewData", (arg) {
      page = 1;
      listId = '';
      categoryId = arg.catId.toString();
      type = arg.type;
      _initData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///    组件创建完成的回调通知方法
    ///解决首次数据加载失败问题
    ///
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!KeTaoFeaturedCommonUtils.isEmpty(pddGoodsList)) {
      } else {
        print("$context WidgetsBinding_initData");
        if (count < 5) {
          count++;
          _initData();
        }
      }
    });
    return buildCenter2();
  }

  Widget buildCenter() {
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(horizontal: 16),
//          height: double.infinity,
          child: new StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            itemCount: goodsList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              KeTaoFeaturedHomeGoodsListGoodsList item;
              try {
                item = goodsList[index];
              } catch (e) {}
              return productItem(item: item);
            },
            staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
            mainAxisSpacing: ScreenUtil().setWidth(20),
            crossAxisSpacing: ScreenUtil().setWidth(20),
          ),
        ),
      ),
    );
  }

  Widget buildCenter2() {
    return Center(
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
//          height: double.infinity,
        child: new StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          itemCount: pddGoodsList.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            KeTaoFeaturedPddGoodsListDataList item;
            try {
              item = pddGoodsList[index];
            } catch (e) {}
            return productItem2(item: item);
          },
          staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
          mainAxisSpacing: ScreenUtil().setWidth(20),
          crossAxisSpacing: ScreenUtil().setWidth(20),
        ),
      ),
    );
  }

  var _priceColor = const Color(0xffCE0100);

  Widget productItem({KeTaoFeaturedHomeGoodsListGoodsList item}) {
    String id = '';
    String goodsName = '';
    String goodsImg = '';
    String originalPrice = '';
    String salePrice = '';
    double topMargin = 0;
    String profit = '分红金￥0';
    try {
      id = item.id;
      goodsName = item.goodsName;
      goodsImg = item.goodsImg;
      originalPrice = item.originalPrice;
      salePrice = item.salePrice;
      profit = '分红金￥${(item.btPrice)}';
      /*  if (goodsName.length < 8) {
        topMargin = ScreenUtil().setHeight(70);
      } else {
        topMargin = ScreenUtil().setHeight(10);
      }*/
    } catch (e) {}

    return GestureDetector(
      onTap: () {
//        launchWeChatMiniProgram(username: "gh_8ae370170974");
        KeTaoFeaturedNavigatorUtils.navigatorRouter(
            context,
            KeTaoFeaturedPddGoodsDetailPage(
              productId: id,
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
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
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
                Container(
                  color: Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(ScreenUtil().setWidth(10)),
                      topLeft: Radius.circular(ScreenUtil().setWidth(10)),
                    ),
                    child: CachedNetworkImage(
                      fadeInDuration: Duration(milliseconds: 0),
                      fadeOutDuration: Duration(milliseconds: 0),
                      height: ScreenUtil().setWidth(523),
                      width: ScreenUtil().setWidth(523),
                      fit: BoxFit.fill,
                      imageUrl: "$goodsImg",
                    ),
                  ),
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
                      WidgetSpan(
                          child: CachedNetworkImage(
                        imageUrl: "https://img.pddpic.com/favicon.ico",
                        width: ScreenUtil().setWidth(48),
                        height: ScreenUtil().setWidth(48),
                      )),
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
                Container(
                  margin: EdgeInsets.only(top: topMargin),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 5,
                      ),
                      KeTaoFeaturedPriceText(
                        text: '$salePrice',
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
                      Container(
                        padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(8),
                          right: ScreenUtil().setWidth(8),
                          top: ScreenUtil().setWidth(8),
                          bottom: ScreenUtil().setWidth(8),
                        ),
                        constraints: BoxConstraints(
                          maxWidth: ScreenUtil().setWidth(160),
                        ),
                        decoration: BoxDecoration(
                          color: _priceColor,
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setWidth(10)),
                        ),
                        child: Text(
                          "券${(double.parse(originalPrice) / 10).toString()}元",
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

  Widget productItem2({KeTaoFeaturedPddGoodsListDataList item}) {
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
      if (KeTaoFeaturedCommonUtils.isEmpty(couponAmount)) {
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
        KeTaoFeaturedNavigatorUtils.navigatorRouter(
            context,
            KeTaoFeaturedPddGoodsDetailPage(
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
                      color: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(ScreenUtil().setWidth(30)),
                          topLeft: Radius.circular(ScreenUtil().setWidth(30)),
                        ),
                        child: CachedNetworkImage(
                          fadeInDuration: Duration(milliseconds: 0),
                          fadeOutDuration: Duration(milliseconds: 0),
                          height: ScreenUtil().setWidth(523),
                          width: ScreenUtil().setWidth(523),
                          fit: BoxFit.fill,
                          imageUrl: "$goodsImg",
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !KeTaoFeaturedCommonUtils.isEmpty(_gBonus),
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
                            child: CachedNetworkImage(
                              imageUrl:
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
                          visible: !KeTaoFeaturedCommonUtils.isEmpty(_shopName),
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
                        color: Color(0xffF93736),
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
                      KeTaoFeaturedPriceText(
                        text: '$_discountPrice',
                        textColor: _priceColor,
                        fontSize: ScreenUtil().setSp(32),
                        fontBigSize: ScreenUtil().setSp(48),
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
                                  fontSize: ScreenUtil().setSp(24),
                                  color: Color(0xFF979896)),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        //微股东权益 equity
                        visible: !KeTaoFeaturedCommonUtils.isEmpty(couponAmount),
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
                                child: KeTaoFeaturedDashedRect(
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
