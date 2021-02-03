import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluwx/fluwx.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/home_icon_list_entity.dart';
import 'package:star/models/pdd_goods_list_entity.dart';
import 'package:star/models/pdd_home_entity.dart';
import 'package:star/pages/goods/pdd/pdd_goods_detail.dart';
import 'package:star/pages/goods/pdd/pdd_goods_list.dart';
import 'package:star/pages/recharge/recharge_list.dart';
import 'package:star/pages/task/task_hall.dart';
import 'package:star/pages/widget/PriceText.dart';
import 'package:star/pages/widget/dashed_rect.dart';
import 'package:star/pages/widget/my_webview_plugin.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:star/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../global_config.dart';

class FeaturedTabPage extends StatefulWidget {
  PddHomeData pddHomeData;

  @override
  _FeaturedTabPageState createState() => _FeaturedTabPageState();

  FeaturedTabPage({Key key, this.pddHomeData}) : super(key: key);
}

class _FeaturedTabPageState extends State<FeaturedTabPage>
    with AutomaticKeepAliveClientMixin {
  bool isFirstLoading = true;
  List<HomeIconListIconList> _banner;
  List<HomeIconListIconList> _ads;
  HomeIconListIconList _buyTop;
  HomeIconListIconList _buyLeft;
  HomeIconListIconList _buyRight;
  int page = 1;
  EasyRefreshController _refreshController;

  Future _initPddGoodsListData() async {
    var result2 =
        await HttpManage.getPddGoodsList(page, listId: listId, categoryId: -1);
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
              _refreshController.finishLoad(noMore: true);
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
    super.initState();
    _initPddGoodsListData();
    _refreshController = EasyRefreshController();
    try {
      iconList = widget.pddHomeData.tools;
      _banner = widget.pddHomeData.banner;
      _ads = widget.pddHomeData.ads;

      if (!CommonUtils.isEmpty(_ads)) {
        _buyTop = _ads[0];
        if (_ads.length > 1) {
          _buyLeft = _ads[1];
        }
        if (_ads.length > 2) {
          _buyRight = _ads[2];
        }
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!CommonUtils.isEmpty(pddGoodsList)) {
      } else {
        print("_initPddGoodsListData");
        _initPddGoodsListData();
      }
    });
    return buildView();
  }

  ///精选tab根布局
  Widget buildView() {
    return Container(
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
          page++;
          _initPddGoodsListData();
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
    return Visibility(
      visible: !CommonUtils.isEmpty(_banner),
      child: new Container(
        margin:
            const EdgeInsets.only(top: 8.0, bottom: 5.0, left: 16, right: 16),
        color: Colors.transparent,
        height: ScreenUtil().setHeight(468),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  var item = _banner[index];
                  String icon = '';
                  String name = '';
                  String type = '';
                  String appId = '';
                  String path = '';
                  String imgPath = '';
                  String subtitle = '';
                  String params = '';
                  String catId = '';
                  String pddType = '';
                  try {
                    icon = item.icon;
                    name = item.name;
                    type = item.type;
                    appId = item.appId;
                    path =
                        !CommonUtils.isEmpty(item.path) ? item.path : item.uri;
                    subtitle = item.subtitle;
                    params = item.params;
                    imgPath = item.imgPath;
//      print("iconsubtitle=${icon + name + type + appId + path + subtitle}");
                    if (params.contains("&")) {}
                    List<String> pList = params.split("&");
                    for (var itemString in pList) {
                      List<String> itemList = itemString.split("=");
                      if (!CommonUtils.isEmpty(itemList)) {
                        switch (itemList[0]) {
                          case "cat_id":
                            catId = itemList[1];
                            break;
                          case "type":
                            pddType = itemList[1];
                            break;
                        }
                      }
                    }
                  } catch (e) {
                    print(e);
                  }
                  return GestureDetector(
                    onTap: () async {
                      ///跳转对应链接
                      ///
                      if (type == 'webapp') {
                        launchWeChatMiniProgram(username: appId, path: path);
                        return;
                      }
                      if (type == 'app') {
                        if (path == 'pdd_index') {
//                          NavigatorUtils.navigatorRouter(context, PddHomeIndexPage());
                          return;
                        }
                        if (path == 'pdd_goods') {
                          NavigatorUtils.navigatorRouter(
                              context,
                              PddGoodsListPage(
                                showAppBar: true,
                                type: pddType,
                                title: CommonUtils.isEmpty(name) ? "精选" : name,
                                categoryId: catId,
                              ));
                          return;
                        }
                        switch (path) {
                          case "recharge":
                            NavigatorUtils.navigatorRouter(
                                context, RechargeListPage());
                            break;
                        }
                        return;
                      }
                      if (type == 'toast') {
                        CommonUtils.showToast("敬请期待");
                        return;
                      }
                      if (type == 'link') {
                        if (path.toString().startsWith("pinduoduo")) {
                          if (await canLaunch(path)) {
                            await launch(path);
                          } else {
                            if (path.startsWith("pinduoduo://")) {
                              CommonUtils.showToast("亲，您还未安装拼多多客户端哦！");
                              NavigatorUtils.navigatorRouter(
                                  context,
                                  WebViewPluginPage(
                                    initialUrl: "$path",
                                    showActions: true,
                                    title: "拼多多",
                                    appBarBackgroundColor: Colors.white,
                                  ));
                            } else {}
                            return;
                          }
                        }
                        if (path.contains("yangkeduo")) {
                          var pddPath = path.replaceAll(
                              "https://mobile.yangkeduo.com/",
                              "pinduoduo://com.xunmeng.pinduoduo/");
                          if (await canLaunch(pddPath)) {
                            await launch(pddPath);
                            return;
                          } else {
                            NavigatorUtils.navigatorRouter(
                                context,
                                WebViewPluginPage(
                                  initialUrl: "$path",
                                  showActions: true,
                                  title: "拼多多",
                                  appBarBackgroundColor: Colors.white,
                                ));
                            return;
                          }
                        }
                        Utils.launchUrl(path);
                        return;
                      }

                      ///
                    },
                    child: new ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        child: CachedNetworkImage(
                          imageUrl: "${item.imgPath}",
                          placeholder: (context, url) => Center(
                            child: Loading(
                              indicator: BallSpinFadeLoaderIndicator(),
                              size: 50.0,
                              color: GlobalConfig.colorPrimary,
                            ),
                          ),
                          errorWidget: (context, url, d) {
                            return Center(child: Text("图片加载失败"));
                          },

/*
                          imageUrl:
                              "https://alipic.lanhuapp.com/xd1e01d251-cd6d-4b84-8f5c-f622146922bc",
*/
                          fit: BoxFit.cover,
                        )),
                  );
                },
                indicatorLayout: PageIndicatorLayout.COLOR,
                autoplay: true,
                itemCount: CommonUtils.isEmpty(_banner) ? 0 : _banner.length,
                pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                        //自定义指示器颜色
                        color: Colors.white,
                        size: 2.0,
                        activeColor: Color(0xffF32E43),
                        activeSize: 3.0)),
//        control: new SwiperControl(color: GlobalConfig.colorPrimary),
              ),
            ),
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
    String imgPath = '';
    String subtitle = '';
    String params = '';
    String catId = '';
    String pddType = '';
    bool needShow = true;
    try {
      icon = item.icon;
      name = item.name;
      type = item.type;
      appId = item.appId;
      path = !CommonUtils.isEmpty(item.path) ? item.path : item.uri;
      subtitle = item.subtitle;
      params = item.params;
      imgPath = item.imgPath;
//      print("iconsubtitle=${icon + name + type + appId + path + subtitle}");
      if (params.contains("&")) {}
      List<String> pList = params.split("&");
      for (var itemString in pList) {
        List<String> itemList = itemString.split("=");
        if (!CommonUtils.isEmpty(itemList)) {
          switch (itemList[0]) {
            case "cat_id":
              catId = itemList[1];
              break;
            case "type":
              pddType = itemList[1];
              break;
          }
        }
      }
    } catch (e) {
      print(e);
    }
    return new InkWell(
        onTap: () async {
          ///跳转对应链接
          ///
          if (type == 'webapp') {
            launchWeChatMiniProgram(username: appId, path: path);
            return;
          }
          if (type == 'app') {
            if (path == 'pdd_index') {
//                          NavigatorUtils.navigatorRouter(context, PddHomeIndexPage());
              return;
            }
            if (path == 'pdd_goods') {
              NavigatorUtils.navigatorRouter(
                  context,
                  PddGoodsListPage(
                    showAppBar: true,
                    type: pddType,
                    title: CommonUtils.isEmpty(name) ? "精选" : name,
                    categoryId: catId,
                  ));
              return;
            }
            switch (path) {
              case "recharge":
                NavigatorUtils.navigatorRouter(context, RechargeListPage());
                break;
            }
            return;
          }
          if (type == 'toast') {
            CommonUtils.showToast("敬请期待");
            return;
          }
          if (type == 'link') {
            if (path.toString().startsWith("pinduoduo")) {
              if (await canLaunch(path)) {
                await launch(path);
              } else {
                if (path.startsWith("pinduoduo://")) {
                  CommonUtils.showToast("亲，您还未安装拼多多客户端哦！");
                  NavigatorUtils.navigatorRouter(
                      context,
                      WebViewPluginPage(
                        initialUrl: "$path",
                        showActions: true,
                        title: "拼多多",
                        appBarBackgroundColor: Colors.white,
                      ));
                } else {}
                return;
              }
            }
            if (path.contains("yangkeduo")) {
              var pddPath = path.replaceAll("https://mobile.yangkeduo.com/",
                  "pinduoduo://com.xunmeng.pinduoduo/");
              if (await canLaunch(pddPath)) {
                await launch(pddPath);
                return;
              } else {
                NavigatorUtils.navigatorRouter(
                    context,
                    WebViewPluginPage(
                      initialUrl: "$path",
                      showActions: true,
                      title: "拼多多",
                      appBarBackgroundColor: Colors.white,
                    ));
                return;
              }
            }
            Utils.launchUrl(path);
            return;
          }

          ///
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
        return GestureDetector(
          onTap: () {
            NavigatorUtils.navigatorRouter(
                context,
                PddGoodsListPage(
                  categoryId: "-1",
                  showAppBar: true,
                  title: '精选',
                ));
          },
          child: Container(
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "更多>>",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color(0xff999999),
                      fontSize: ScreenUtil().setSp(38),
                    ),
                  ),
                ),
              ],
            ),
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
          buildBuyTopContainer(),
          buildAdRowContainer(),
        ],
      ), //
    );
  }

  Widget buildAdRowContainer() {
    return Container(
      margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: Row(
        children: [
          buildBuyLeftWidget(),
          buildBuyRightWidget(),
        ],
      ),
    );
  }

  Widget buildBuyRightWidget() {
    var item = _buyRight;
    String icon = '';
    String name = '';
    String type = '';
    String appId = '';
    String path = '';
    String imgPath = '';
    String subtitle = '';
    String params = '';
    String catId = '';
    String pddType = '';
    try {
      icon = item.icon;
      name = item.name;
      type = item.type;
      appId = item.appId;
      path = !CommonUtils.isEmpty(item.path) ? item.path : item.uri;
      subtitle = item.subtitle;
      params = item.params;
      imgPath = item.imgPath;
//      print("iconsubtitle=${icon + name + type + appId + path + subtitle}");
      if (params.contains("&")) {}
      List<String> pList = params.split("&");
      for (var itemString in pList) {
        List<String> itemList = itemString.split("=");
        if (!CommonUtils.isEmpty(itemList)) {
          switch (itemList[0]) {
            case "cat_id":
              catId = itemList[1];
              break;
            case "type":
              pddType = itemList[1];
              break;
          }
        }
      }
    } catch (e) {
      print(e);
    }
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          ///跳转对应链接
          ///
          if (type == 'webapp') {
            launchWeChatMiniProgram(username: appId, path: path);
            return;
          }
          if (type == 'app') {
            if (path == 'pdd_index') {
//                          NavigatorUtils.navigatorRouter(context, PddHomeIndexPage());
              return;
            }
            if (path == 'pdd_goods') {
              NavigatorUtils.navigatorRouter(
                  context,
                  PddGoodsListPage(
                    showAppBar: true,
                    type: pddType,
                    title: CommonUtils.isEmpty(name) ? "精选" : name,
                    categoryId: catId,
                  ));
              return;
            }
            switch (path) {
              case "recharge":
                NavigatorUtils.navigatorRouter(context, RechargeListPage());
                break;
            }
            return;
          }
          if (type == 'toast') {
            CommonUtils.showToast("敬请期待");
            return;
          }
          if (type == 'link') {
            if (path.toString().startsWith("pinduoduo")) {
              if (await canLaunch(path)) {
                await launch(path);
              } else {
                if (path.startsWith("pinduoduo://")) {
                  CommonUtils.showToast("亲，您还未安装拼多多客户端哦！");
                  NavigatorUtils.navigatorRouter(
                      context,
                      WebViewPluginPage(
                        initialUrl: "$path",
                        showActions: true,
                        title: "拼多多",
                        appBarBackgroundColor: Colors.white,
                      ));
                } else {}
                return;
              }
            }
            if (path.contains("yangkeduo")) {
              var pddPath = path.replaceAll("https://mobile.yangkeduo.com/",
                  "pinduoduo://com.xunmeng.pinduoduo/");
              if (await canLaunch(pddPath)) {
                await launch(pddPath);
                return;
              } else {
                NavigatorUtils.navigatorRouter(
                    context,
                    WebViewPluginPage(
                      initialUrl: "$path",
                      showActions: true,
                      title: "拼多多",
                      appBarBackgroundColor: Colors.white,
                    ));
                return;
              }
            }
            Utils.launchUrl(path);
            return;
          }

          ///
        },
        child: Visibility(
          visible: !CommonUtils.isEmpty(
            imgPath,
          ),
          child: Container(
            alignment: Alignment.centerRight,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  ScreenUtil().setWidth(20),
                ),
              ),
              child: CachedNetworkImage(
                imageUrl: "$imgPath",
                fit: BoxFit.fitWidth,
                placeholder: (context, url) => Center(
                  child: Loading(
                    indicator: BallSpinFadeLoaderIndicator(),
                    size: 50.0,
                    color: GlobalConfig.colorPrimary,
                  ),
                ),
                width: ScreenUtil().setWidth(492),
                height: ScreenUtil().setWidth(600),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBuyLeftWidget() {
    var item = _buyLeft;
    String icon = '';
    String name = '';
    String type = '';
    String appId = '';
    String path = '';
    String imgPath = '';
    String subtitle = '';
    String params = '';
    String catId = '';
    String pddType = '';
    try {
      icon = item.icon;
      name = item.name;
      type = item.type;
      appId = item.appId;
      path = !CommonUtils.isEmpty(item.path) ? item.path : item.uri;
      subtitle = item.subtitle;
      params = item.params;
      imgPath = item.imgPath;
//      print("iconsubtitle=${icon + name + type + appId + path + subtitle}");
      if (params.contains("&")) {}
      List<String> pList = params.split("&");
      for (var itemString in pList) {
        List<String> itemList = itemString.split("=");
        if (!CommonUtils.isEmpty(itemList)) {
          switch (itemList[0]) {
            case "cat_id":
              catId = itemList[1];
              break;
            case "type":
              pddType = itemList[1];
              break;
          }
        }
      }
    } catch (e) {
      print(e);
    }
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          ///跳转对应链接
          ///
          if (type == 'webapp') {
            launchWeChatMiniProgram(username: appId, path: path);
            return;
          }
          if (type == 'app') {
            if (path == 'pdd_index') {
//                          NavigatorUtils.navigatorRouter(context, PddHomeIndexPage());
              return;
            }
            if (path == 'pdd_goods') {
              NavigatorUtils.navigatorRouter(
                  context,
                  PddGoodsListPage(
                    showAppBar: true,
                    type: pddType,
                    title: CommonUtils.isEmpty(name) ? "精选" : name,
                    categoryId: catId,
                  ));
              return;
            }
            switch (path) {
              case "recharge":
                NavigatorUtils.navigatorRouter(context, RechargeListPage());
                break;
            }
            return;
          }
          if (type == 'toast') {
            CommonUtils.showToast("敬请期待");
            return;
          }
          if (type == 'link') {
            if (path.toString().startsWith("pinduoduo")) {
              if (await canLaunch(path)) {
                await launch(path);
              } else {
                if (path.startsWith("pinduoduo://")) {
                  CommonUtils.showToast("亲，您还未安装拼多多客户端哦！");
                  NavigatorUtils.navigatorRouter(
                      context,
                      WebViewPluginPage(
                        initialUrl: "$path",
                        showActions: true,
                        title: "拼多多",
                        appBarBackgroundColor: Colors.white,
                      ));
                } else {}
                return;
              }
            }
            if (path.contains("yangkeduo")) {
              var pddPath = path.replaceAll("https://mobile.yangkeduo.com/",
                  "pinduoduo://com.xunmeng.pinduoduo/");
              if (await canLaunch(pddPath)) {
                await launch(pddPath);
                return;
              } else {
                NavigatorUtils.navigatorRouter(
                    context,
                    WebViewPluginPage(
                      initialUrl: "$path",
                      showActions: true,
                      title: "拼多多",
                      appBarBackgroundColor: Colors.white,
                    ));
                return;
              }
            }
            Utils.launchUrl(path);
            return;
          }

          ///
        },
        child: Visibility(
          visible: !CommonUtils.isEmpty(
            imgPath,
          ),
          child: Container(
            alignment: Alignment.centerLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  ScreenUtil().setWidth(20),
                ),
              ),
              child: CachedNetworkImage(
                imageUrl: "$imgPath",
                fit: BoxFit.fitWidth,
                width: ScreenUtil().setWidth(492),
                height: ScreenUtil().setWidth(600),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBuyTopContainer() {
    var item = _buyTop;
    String icon = '';
    String name = '';
    String type = '';
    String appId = '';
    String path = '';
    String imgPath = '';
    String subtitle = '';
    String params = '';
    String catId = '';
    String pddType = '';
    try {
      icon = item.icon;
      name = item.name;
      type = item.type;
      appId = item.appId;
      path = !CommonUtils.isEmpty(item.path) ? item.path : item.uri;
      subtitle = item.subtitle;
      params = item.params;
      imgPath = item.imgPath;
//      print("iconsubtitle=${icon + name + type + appId + path + subtitle}");
      if (params.contains("&")) {}
      List<String> pList = params.split("&");
      for (var itemString in pList) {
        List<String> itemList = itemString.split("=");
        if (!CommonUtils.isEmpty(itemList)) {
          switch (itemList[0]) {
            case "cat_id":
              catId = itemList[1];
              break;
            case "type":
              pddType = itemList[1];
              break;
          }
        }
      }
    } catch (e) {
      print(e);
    }

    return GestureDetector(
      onTap: () async {
        ///跳转对应链接
        ///
        if (type == 'webapp') {
          launchWeChatMiniProgram(username: appId, path: path);
          return;
        }
        if (type == 'app') {
          if (path == 'pdd_index') {
//                          NavigatorUtils.navigatorRouter(context, PddHomeIndexPage());
            return;
          }
          if (path == 'pdd_goods') {
            NavigatorUtils.navigatorRouter(
                context,
                PddGoodsListPage(
                  showAppBar: true,
                  type: pddType,
                  title: CommonUtils.isEmpty(name) ? "精选" : name,
                  categoryId: catId,
                ));
            return;
          }
          switch (path) {
            case "recharge":
              NavigatorUtils.navigatorRouter(context, RechargeListPage());
              break;
          }
          return;
        }
        if (type == 'toast') {
          CommonUtils.showToast("敬请期待");
          return;
        }
        if (type == 'link') {
          if (path.toString().startsWith("pinduoduo")) {
            if (await canLaunch(path)) {
              await launch(path);
            } else {
              if (path.startsWith("pinduoduo://")) {
                CommonUtils.showToast("亲，您还未安装拼多多客户端哦！");
                NavigatorUtils.navigatorRouter(
                    context,
                    WebViewPluginPage(
                      initialUrl: "$path",
                      showActions: true,
                      title: "拼多多",
                      appBarBackgroundColor: Colors.white,
                    ));
              } else {}
              return;
            }
          }
          if (path.contains("yangkeduo")) {
            var pddPath = path.replaceAll("https://mobile.yangkeduo.com/",
                "pinduoduo://com.xunmeng.pinduoduo/");
            if (await canLaunch(pddPath)) {
              await launch(pddPath);
              return;
            } else {
              NavigatorUtils.navigatorRouter(
                  context,
                  WebViewPluginPage(
                    initialUrl: "$path",
                    showActions: true,
                    title: "拼多多",
                    appBarBackgroundColor: Colors.white,
                  ));
              return;
            }
          }

          Utils.launchUrl(path);
          return;
        }

        ///
      },
      child: Visibility(
        visible: !CommonUtils.isEmpty(
          imgPath,
        ),
        child: Container(
          margin: EdgeInsets.only(bottom: 16, top: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(
                ScreenUtil().setWidth(20),
              ),
            ),
            child: CachedNetworkImage(
//              imageUrl: "www.baidu.com",
              imageUrl: "$imgPath",
              fit: BoxFit.fitWidth,
              width: ScreenUtil().setWidth(1029),
              height: ScreenUtil().setWidth(414),
              placeholder: (context, url) => Center(
                child: Loading(
                  indicator: BallSpinFadeLoaderIndicator(),
                  size: 50.0,
                  color: GlobalConfig.colorPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
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
            itemCount:
                CommonUtils.isEmpty(pddGoodsList) ? 0 : pddGoodsList.length,
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

  var _priceColor = const Color(0xffF93736);

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
      if (CommonUtils.isEmpty(couponAmount)) {
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
                Visibility(
                  visible: !CommonUtils.isEmpty(_gBonus),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    color:_priceColor,
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Visibility(
                          visible: !CommonUtils.isEmpty(_shopName),
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
                        visible: !CommonUtils.isEmpty(couponAmount),
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
                                child: DashedRect(
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
