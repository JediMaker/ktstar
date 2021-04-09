import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:star/generated/json/home_goods_list_entity_helper.dart';
import 'package:star/http/ktkj_http_manage.dart';
import 'package:star/models/home_goods_list_entity.dart';
import 'package:star/pages/ktkj_goods/ktkj_goods_detail.dart';
import 'package:star/pages/ktkj_widget/ktkj_PriceText.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_octoimage.dart';
import 'package:star/pages/ktkj_widget/ktkj_no_data.dart';
import 'package:star/utils/ktkj_common_utils.dart';
import 'package:star/utils/ktkj_navigator_utils.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJHotGoodsListPage extends StatefulWidget {
  KTKJHotGoodsListPage({Key key}) : super(key: key);
  final String title = "今日爆款";

  @override
  _NewcomersGoodsListPageState createState() => _NewcomersGoodsListPageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _NewcomersGoodsListPageState extends State<KTKJHotGoodsListPage>
    with AutomaticKeepAliveClientMixin {
  int page = 1;
  EasyRefreshController _refreshController;
  bool isFirstLoading = true;
  List<HomeGoodsListGoodsList> goodsList = List<HomeGoodsListGoodsList>();

  _initData() async {
    var result = await HttpManage.getGoodsList(
      type: "hot",
      page: page,
      pageSize: 20,
      firstId: '',
      sortType: sortType,
    );
    if (result.status) {
      HomeGoodsListEntity entity = HomeGoodsListEntity();
      homeGoodsListEntityFromJson(entity, result.data);
      if (mounted) {
        setState(() {
          if (page == 1) {
            goodsList = entity.goodsList;
            _refreshController.finishLoad(noMore: false);
          } else {
            if (result == null ||
                result.data == null ||
                entity.goodsList == null ||
                entity.goodsList.length == 0) {
              //              _refreshController.resetLoadState();
              _refreshController.finishLoad(noMore: true);
            } else {
              goodsList += entity.goodsList;
            }
          }
          isFirstLoading = false;
        });
      }
    } else {
      KTKJCommonUtils.showToast(result.errMsg);
    }
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

  var bgTitleColor = Color(0xffFC8B2F);
  var bgContentColor = Color(0xffFD6211);

  ///排序类型
  var sortType = SortType.Comprehensive;
  var arrowUp =
      "https://alipic.lanhuapp.com/xd8ce5f00b-6bed-42f9-bea3-8f1e6d896a69";
  var arrowUpSel =
      "https://alipic.lanhuapp.com/xdab146d18-f13e-45a6-9b03-b0aeec075534";
  var arrowDown =
      "https://alipic.lanhuapp.com/xdc43a0d49-80b2-4a02-b8b6-cccc876958f7";
  var arrowDownSel =
      "https://alipic.lanhuapp.com/xdae9d0a7b-b0b4-4422-857e-97846f0baf56";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text(
          widget.title,
          style:
              TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(54)),
        ),
        leading: Visibility(
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
        brightness: Brightness.dark,
        gradient: LinearGradient(colors: [
          bgTitleColor,
          bgTitleColor,
        ]),
        elevation: 0,
      ),
      body:
          buildEasyRefresh(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  EasyRefresh buildEasyRefresh() {
    return EasyRefresh.custom(
      topBouncing: false,
      bottomBouncing: false,
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
      enableControlFinishLoad: true,
      enableControlFinishRefresh: true,
      controller: _refreshController,
      onRefresh: () {
        page = 1;
        _initData();
        _refreshController.finishLoad(noMore: false);
      },
      onLoad: () {
        if (!isFirstLoading) {
          page++;
          _initData();
        }
      },
      emptyWidget:
          goodsList == null || goodsList.length == 0 ? KTKJNoDataPage() : null,
      slivers: <Widget>[buildCenter()],
    );
  }

  var textSelColor = Color(0xffC02B25);
  var textNomalColor = Color(0xff222222);

  Widget buildCenter() {
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          color: bgContentColor,
          child: Column(
            children: [
              Stack(
                children: [
                  KTKJMyOctoImage(
                    image:
                        "https://alipic.lanhuapp.com/xde2aee21e-6f3c-4e02-9f6c-fb430f9a1bab",
                    fit: BoxFit.fill,
                    width: ScreenUtil().setWidth(1127),
                    height: ScreenUtil().setWidth(587),
//                                color: Color(0xffce0100),
                  ),
                  Container(
                    width: double.maxFinite,
                    height: ScreenUtil().setWidth(134),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          ScreenUtil().setWidth(30),
                        ),
                      ),
                    ),
                    margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(30),
                      right: ScreenUtil().setWidth(30),
                      top: ScreenUtil().setWidth(540),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              sortType = SortType.Comprehensive;
                              if (mounted) {
                                setState(() {
                                  page = 1;
                                  _initData();
                                });
                              }
                            },
                            child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "综合",
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(42),
                                    color: sortType == SortType.Comprehensive
                                        ? textSelColor
                                        : textNomalColor,
                                  ),
                                )),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (sortType == SortType.CoinAscending) {
                                sortType = SortType.CoinDescending;
                              } else if (sortType == SortType.CoinDescending) {
                                sortType = SortType.CoinAscending;
                              } else {
                                sortType = SortType.CoinAscending;
                              }
                              if (mounted) {
                                setState(() {
                                  page = 1;
                                  _initData();
                                });
                              }
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "分红金",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(42),
                                        color: sortType ==
                                                    SortType.CoinAscending ||
                                                sortType ==
                                                    SortType.CoinDescending
                                            ? textSelColor
                                            : textNomalColor,
                                      ),
                                    )),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(16),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: KTKJMyOctoImage(
                                          image:
                                              sortType == SortType.CoinAscending
                                                  ? arrowUpSel
                                                  : arrowUp,
                                          width: ScreenUtil().setWidth(17),
                                          height: ScreenUtil().setWidth(11),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                          top: ScreenUtil().setWidth(4),
                                        ),
                                        child: KTKJMyOctoImage(
                                          image: sortType ==
                                                  SortType.CoinDescending
                                              ? arrowDownSel
                                              : arrowDown,
                                          width: ScreenUtil().setWidth(17),
                                          height: ScreenUtil().setWidth(11),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (sortType == SortType.PriceAscending) {
                                sortType = SortType.PriceDescending;
                              } else if (sortType == SortType.PriceDescending) {
                                sortType = SortType.PriceAscending;
                              } else {
                                sortType = SortType.PriceAscending;
                              }
                              if (mounted) {
                                setState(() {
                                  page = 1;
                                  _initData();
                                });
                              }
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "价格",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(42),
                                        color: sortType ==
                                                    SortType.PriceAscending ||
                                                sortType ==
                                                    SortType.PriceDescending
                                            ? textSelColor
                                            : textNomalColor,
                                      ),
                                    )),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(16),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: KTKJMyOctoImage(
                                          image: sortType ==
                                                  SortType.PriceAscending
                                              ? arrowUpSel
                                              : arrowUp,
                                          width: ScreenUtil().setWidth(17),
                                          height: ScreenUtil().setWidth(11),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                          top: ScreenUtil().setWidth(4),
                                        ),
                                        child: KTKJMyOctoImage(
                                          image: sortType ==
                                                  SortType.PriceDescending
                                              ? arrowDownSel
                                              : arrowDown,
                                          width: ScreenUtil().setWidth(17),
                                          height: ScreenUtil().setWidth(11),
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
//          height: double.infinity,
                  ),
                ],
              ),
              Container(
                width: double.maxFinite,
                color: bgContentColor,
                constraints: BoxConstraints(
                  minHeight: ScreenUtil().setWidth(1527),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(30),
                  vertical: ScreenUtil().setWidth(30),
                ),
//          height: double.infinity,
                child: Column(
                  children: [
                    new StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
                      itemCount: goodsList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        HomeGoodsListGoodsList item;
                        try {
                          item = goodsList[index];
                        } catch (e) {}
                        return productItem(item: item);
                      },
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                      mainAxisSpacing: ScreenUtil().setWidth(30),
                      crossAxisSpacing: ScreenUtil().setWidth(30),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  var _priceColor = const Color(0xffe31735);

  Widget productItem({HomeGoodsListGoodsList item}) {
    String id = '';
    String goodsName = '';
    String goodsImg = '';
    String originalPrice = '';
    String salePrice = '';
    double topMargin = 0;
    String profit = '分红金￥0';
    String extraCoin;
    try {
      id = item.id;
      goodsName = item.goodsName;
      goodsImg = item.goodsImg;
      originalPrice = item.originalPrice;
      salePrice = item.salePrice;
      profit = '预估分红金￥${(item.btPrice)}';

      ///todo 获取分红体验金的值
      extraCoin = "￥${(item.btPrice)}";
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
            KTKJGoodsDetailPage(
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
//                          SizedBox(
//                            height: 10,
//                          ),
                Visibility(
                  visible: !KTKJCommonUtils.isEmpty(item.btPrice),
                  child: Container(
                    height: ScreenUtil().setWidth(60),
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                    ),
                    color: _priceColor,
                    child: Row(
                      children: [
                        Expanded(
                          child: Visibility(
                            child: Container(
                              child: Text(
                                "$profit",
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
                Container(
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20),
                    right: ScreenUtil().setWidth(20),
                    top: ScreenUtil().setHeight(16),
                  ),
                  child: Text(
                    "$goodsName",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(38),
                      color: Color(0xff222222),
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
                          margin: EdgeInsets.only(
                              bottom: ScreenUtil().setHeight(0)),
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
                      /* Icon(
                          Icons.more_horiz,
                          size: 15,
                          color: Color(0xFF979896),
                        ),*/
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

enum SortType {
  ///综合
  Comprehensive,

  ///价格升序
  PriceAscending,

  ///价格降序
  PriceDescending,

  ///分红金升序
  CoinAscending,

  ///分红金降序
  CoinDescending

  ///
}
