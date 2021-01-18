import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluwx/fluwx.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/home_icon_list_entity.dart';
import 'package:star/models/pdd_goods_list_entity.dart';
import 'package:star/pages/goods/pdd/pdd_goods_detail.dart';
import 'package:star/pages/recharge/recharge_list.dart';
import 'package:star/pages/task/task_hall.dart';
import 'package:star/pages/widget/PriceText.dart';
import 'package:star/pages/widget/my_webview_plugin.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:star/utils/utils.dart';

import '../../../global_config.dart';

class FeaturedTabPage extends StatefulWidget {
  @override
  _FeaturedTabPageState createState() => _FeaturedTabPageState();
}

class _FeaturedTabPageState extends State<FeaturedTabPage>
    with AutomaticKeepAliveClientMixin {
  final dataKey = new GlobalKey();
  TabController _tabController;
  var resultData;
  var categroy = [
    '百货',
    '母婴',
    '食品',
    '女装',
  ];
  var slideshow;
  var products;
  var items;
  var productsLatestList;
  var _mFuture;
  bool isFirstLoading = true;

  int page = 1;
  EasyRefreshController _refreshController;

  Future _initData() async {
    /* List<ProductsBeanProduct> proListResult =
        await HttpManage.getLatestProductList(page);
    if (mounted) {
      setState(() {
        if (page == 1) {
          productsLatestList = proListResult;
        } else {
          if (proListResult == null) {
//              _refreshController.resetLoadState();
            _refreshController.finishLoad(noMore: true);
          } else {
            productsLatestList += proListResult;
          }
        }
      });
    }*/
    var result = await HttpManage.getHomeInfo();
    if (mounted) {
      setState(() {
        try {
          iconList = result.data.iconList;
        } catch (e) {}
      });
    }
  }

  Future _initHomeData() async {
    /* HomeResultBeanEntity result = await HttpManage.getHome();
    if (mounted) {
      setState(() {
        widget.slideshow = result.data.slideshow;
        widget.products = result.data.products;
        widget.items = result.data.items;
      });
    }*/
    var result2 = await HttpManage.getPddGoodsList(page, listId: listId);
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
      CommonUtils.showToast(result2.errMsg);
    }
  }

  @override
  void initState() {
    _refreshController = EasyRefreshController();
    _initData();
    _initHomeData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(FeaturedTabPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return buildView();
  }

  ///精选tab根布局
  Widget buildView() {
    return Container(
      width: double.maxFinite,
      height: double.infinity,
      child: EasyRefresh.custom(
        header: MaterialHeader(),
        footer: MaterialFooter(),
        controller: _refreshController,
        enableControlFinishRefresh: true,
        enableControlFinishLoad: true,
        onRefresh: () {
          /*_initHomeData();
          _initData();*/
        },
        onLoad: () {
          /*  page++;
          _initData();*/
        },
        topBouncing: false,
        bottomBouncing: false,
        slivers: <Widget>[
          buildBannerContainer(),
          buildItemsLayout(),
          buildBuyToday(),
          buildRowHot(),
          buildProductList(),
        ],
      ),
    );
  }

  ///拼多多专区首页轮播
  Widget buildSwiper() {
    return new Container(
      margin: const EdgeInsets.only(top: 8.0, bottom: 5.0, left: 16, right: 16),
      color: Colors.transparent,
      height: ScreenUtil().setHeight(468),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return new ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://alipic.lanhuapp.com/xd1e01d251-cd6d-4b84-8f5c-f622146922bc",
                    fit: BoxFit.cover,
                  ));
            },
            indicatorLayout: PageIndicatorLayout.COLOR,
            autoplay: true,
            itemCount: 1,
            pagination: SwiperPagination(
                builder: DotSwiperPaginationBuilder(
                    //自定义指示器颜色
                    color: Colors.white,
                    size: 8.0,
                    activeColor: Color(0xffF32E43),
                    activeSize: 10.0)),
//        control: new SwiperControl(color: GlobalConfig.colorPrimary),
          ),
        ),
      ),
    );
  }

  ///轮播模块
  Widget buildBannerContainer() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((content, index) {
        return Container(
          child: Column(
            children: <Widget>[
              Stack(children: <Widget>[
                ClipPath(
                  // 只裁切底部的方法
                  clipper: BottomClipper(),
                  child: Container(
                    color: Color(0xffF32E43),
                    height: ScreenUtil().setHeight(500),
                  ),
                ),
                buildSwiper(),
              ]),
            ],
          ),
        );
      }, childCount: 1),
    );
  }

  List<HomeIconListIconList> iconList = List<HomeIconListIconList>();

  ///icon 操作列表
  Widget buildItemsLayout() {
    Color _itemsTextColor = Color(0xff222222);
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(
          top: 16,
          bottom: 16,
        ),
        margin: EdgeInsets.only(
          left: 16,
          right: 16,
          top: ScreenUtil().setHeight(0),
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
//            color: Colors.white,
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setWidth(28))),
            border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                color: Colors.white,
                width: 0.5)),
        child: new Wrap(
//        mainAxisAlignment: MainAxisAlignment.center,
//        crossAxisAlignment: CrossAxisAlignment.center,
          runSpacing: 16,
          children: iconList.asMap().keys.map((index) {
            HomeIconListIconList item;
            try {
              item = iconList[index];
            } catch (e) {}
            return iconItem(_itemsTextColor, item: item);
          }).toList(),
        ),
      ),
    );
  }

  Widget iconItem(Color _itemsTextColor, {HomeIconListIconList item}) {
    String icon = '';
    String name = '';
    String type = '';
    String appId = '';
    String path = '';
    String subtitle = '';
    bool needShow = true;
    try {
      icon = item.icon;
      name = item.name;
      type = item.type;
      appId = item.appId;
      path = item.path;
      subtitle = item.subtitle;
//      print("iconsubtitle=${icon + name + type + appId + path + subtitle}");
    } catch (e) {}
    if ((name.contains('游戏') ||
            name.contains('赚钱') ||
            name.contains('会员') ||
            name.contains('加油')) &&
        GlobalConfig.isHuaweiUnderReview) {
      needShow = false;
    }
    return new InkWell(
        onTap: () async {
          if (name.contains('赚钱')) {
            if (!GlobalConfig.isHuaweiUnderReview) {
              NavigatorUtils.navigatorRouter(context, TaskHallPage());
            } else {
              needShow = false;
              CommonUtils.showToast("敬请期待");
            }
            return;
          }
          if (type == 'anchor') {
            //滚动到指定位置
//            _tabController.animateTo(2);
            List<String> items = path.split("_");
            String indexString = items[items.length - 1];
//            print("indexString=$indexString");
            try {
              int index = int.parse(indexString);
              _tabController.animateTo(index);
              Scrollable.ensureVisible(dataKey.currentContext);
            } catch (e) {
              print(e);
            }
            return;
          }
          if (type == 'webapp') {
            launchWeChatMiniProgram(username: appId, path: path);
            return;
          }
          if (type == 'app') {
            switch (path) {
              case "recharge":
                NavigatorUtils.navigatorRouter(context, RechargeListPage());
                break;
            }
            return;
          }
          if (type == 'toast') {
            needShow = false;
            CommonUtils.showToast("敬请期待");
            needShow = false;
            return;
          }
          if (type == 'link') {
            /*PaletteGenerator generator =
                await PaletteGenerator.fromImageProvider(
                    Image.network("$icon").image);
            NavigatorUtils.navigatorRouter(
                context,
                WebViewPage(
                  initialUrl: path,
                  showActions: true,
                  appBarBackgroundColor: generator.dominantColor.color,
                ));*/
            if (path.contains("czb365")) {
              /* PaletteGenerator generator =
                  await PaletteGenerator.fromImageProvider(
                      Image.network("$icon").image);*/
              //platformType=渠道编码&platformCode=用户手92657653
              /*path =
                  "https://st.czb365.com/v3_prod/"; */ //?platformType=98653913&authCode=040af220c0f
              NavigatorUtils.navigatorRouter(
                  context,
                  WebViewPluginPage(
                    initialUrl: path,
                    showActions: true,
                    title: "优惠加油",
                    appBarBackgroundColor: Colors.white,
                  ));
              return;
              /* NavigatorUtils.navigatorRouter(context, MyTestApp());
              return;*/
            }
            if (name.contains('游戏') && GlobalConfig.isHuaweiUnderReview) {
              needShow = false;
              CommonUtils.showToast("敬请期待");
              return;
            }

            Utils.launchUrl(path);
            return;
          }
        },
        child: Visibility(
          visible: needShow,
          child: Container(
            width: (ScreenUtil.screenWidth - 40) / 4,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: new CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Colors.transparent,
                    child: CachedNetworkImage(
                      imageUrl: "$icon",
                      width: ScreenUtil().setWidth(136),
                      height: ScreenUtil().setWidth(136),
                    ),
                  ),
                ),
                new Container(
                  child: new Text(
                    "$name",
                    style: new TextStyle(
                      fontSize: ScreenUtil().setSp(42),
                      color: _itemsTextColor,
                    ),
                  ),
                ),
                Visibility(
                  visible: false,
                  child: new Container(
                    margin: const EdgeInsets.only(top: 4.0),
                    child: new Text(
                      "$subtitle",
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                        fontSize: ScreenUtil().setSp(32),
                        fontWeight: FontWeight.w500,
                        color: Color(0xff999999),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  ///精选热销商品模块
  Widget buildRowHot() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((content, index) {
        return Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          margin: EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl:
                    "https://alipic.lanhuapp.com/xdf34d1da7-bae5-4ff5-9ea0-77890e1113e3",
                width: ScreenUtil().setWidth(522),
                height: ScreenUtil().setWidth(52),
                fit: BoxFit.cover,
              ),
              Expanded(
                child: Text(''),
              ),
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "更多>>",
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        );
      }, childCount: 1),
    );
  }

  ///今日必买模块
  Widget buildBuyToday() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl:
                  "https://alipic.lanhuapp.com/xd626c699a-d52b-4c3b-b0b1-8f489f74a4cb",
              fit: BoxFit.cover,
              width: ScreenUtil().setWidth(544),
              height: ScreenUtil().setWidth(102),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 16, top: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  ScreenUtil().setWidth(20),
                ),
              ),
              child: CachedNetworkImage(
                imageUrl:
                    "https://alipic.lanhuapp.com/xde2865247-cea7-4904-a447-271f6c33d9e6",
                fit: BoxFit.fitWidth,
                width: ScreenUtil().setWidth(1029),
                height: ScreenUtil().setWidth(414),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          ScreenUtil().setWidth(20),
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://alipic.lanhuapp.com/xd49882190-ee93-41ec-8bbb-beed7e7bb5d2",
                        fit: BoxFit.fitWidth,
                        width: ScreenUtil().setWidth(492),
                        height: ScreenUtil().setWidth(600),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          ScreenUtil().setWidth(20),
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://alipic.lanhuapp.com/xd3c98d579-dce5-4138-be36-bf50895aa4d4",
                        fit: BoxFit.fitWidth,
                        width: ScreenUtil().setWidth(492),
                        height: ScreenUtil().setWidth(600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ), //
    );
  }

  List<PddGoodsListDataList> pddGoodsList = List<PddGoodsListDataList>();
  var listId;

  ///热销商品
  Widget buildProductList() {
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(horizontal: 16),
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
            mainAxisSpacing: ScreenUtil().setWidth(20),
            crossAxisSpacing: ScreenUtil().setWidth(20),
          ),
        ),
      ),
    );
  }

  var _priceColor = const Color(0xffe31735);

  Widget productItem2({PddGoodsListDataList item}) {
    String id = '';
    String goodsName = '';
    String goodsImg = '';
    String originalPrice = '';
    String salePrice = '';
    double topMargin = 0;
    String profit = '预估补贴￥0';
    String couponAmount = ''; //优惠券金额
    String goodsSign = ''; //
    String searchId = ''; //
    try {
      id = item.gId.toString();
      goodsName = item.gTitle;
      goodsImg = item.gThumbnail;
      originalPrice = item.gNormalPrice.toString();
      salePrice = item.gGroupPrice.toString();
      goodsSign = item.goodsSign.toString();
      searchId = item.searchId.toString();
      couponAmount = item.coupons.couponDiscount.toString();
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
        NavigatorUtils.navigatorRouter(
            context,
            PddGoodsDetailPage(
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
                      height: ScreenUtil().setWidth(480),
                      width: ScreenUtil().setWidth(480),
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
                          child: Container(
                        width: ScreenUtil().setWidth(48),
                        height: ScreenUtil().setWidth(52),
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                ScreenUtil().setWidth(10),
                              ),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: "https://img.pddpic.com/favicon.ico",
                              width: ScreenUtil().setWidth(42),
                              height: ScreenUtil().setWidth(42),
                            ),
                          ),
                        ),
                      )),
                      TextSpan(text: " "),
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
                        visible: !CommonUtils.isEmpty(couponAmount),
                        child: Container(
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
                            color: Color(0xfff93736),
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(10)),
                          ),
                          child: Text(
                            "券${couponAmount.toString()}元",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(32),
                            ),
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
