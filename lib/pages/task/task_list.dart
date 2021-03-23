import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluwx/fluwx.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:star/bus/my_event_bus.dart';
import 'package:star/generated/json/home_goods_list_entity_helper.dart';
import 'package:star/global_config.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/home_entity.dart';
import 'package:star/models/home_goods_list_entity.dart';
import 'package:star/models/home_icon_list_entity.dart';
import 'package:star/models/home_pdd_category_entity.dart';
import 'package:star/models/user_info_entity.dart';
import 'package:star/pages/goods/goods_detail.dart';
import 'package:star/pages/goods/goods_list.dart';
import 'package:star/pages/goods/home_goods_list.dart';
import 'package:star/pages/goods/newcomers/newcomers_goods_list.dart';
import 'package:star/pages/goods/pdd/pdd_goods_list.dart';
import 'package:star/pages/goods/pdd/pdd_home.dart';
import 'package:star/pages/login/login.dart';
import 'package:star/pages/merchantssettle/shop_payment.dart';
import 'package:star/pages/recharge/recharge_list.dart';
import 'package:star/pages/search/search_page.dart';
import 'package:star/pages/shareholders/micro_equity.dart';
import 'package:star/pages/task/task_detail.dart';
import 'package:star/pages/task/task_detail_other.dart';
import 'package:star/pages/task/task_hall.dart';
import 'package:star/pages/task/task_message.dart';
import 'package:star/pages/task/task_open_diamond.dart';
import 'package:star/pages/task/task_open_diamond_dialog.dart';
import 'package:star/pages/task/task_open_vip.dart';
import 'package:star/pages/task/task_share.dart';
import 'package:star/pages/widget/PriceText.dart';
import 'package:star/pages/widget/my_octoimage.dart';
import 'package:star/pages/widget/my_webview_plugin.dart';
import 'package:star/pages/widget/persistent_header_builder.dart';
import 'package:star/pages/widget/round_tab_indicator.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';
import 'package:star/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

///首页
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedTaskListPage extends StatefulWidget {
  KeTaoFeaturedTaskListPage({Key key}) : super(key: key);
  final String title = "首页";

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _TaskListPageState extends State<KeTaoFeaturedTaskListPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final dataKey = new GlobalKey();
  String taskCompletedNum = "";
  String taskTotalNum = "";
  int bannerIndex = 0;
  HomeEntity entity;
  TabController _tabController;
  List<HomeIconListIconList> bannerList;
  List<Color> bannerColorList;
  static List<HomeDataTaskListList> taskList;
  static List<HomeDataTaskListList> taskVipList;
  static List<HomeDataTaskListList> taskDiamondVipList;
  List<HomeDataTaskList> taskListAll;
  SwiperController _swiperController;
  bool _isLoop = false;
  bool _isMarqueeLoop = false;
  List<HomeGoodsListGoodsList> goodsList = List<HomeGoodsListGoodsList>();
  List<HomeIconListIconList> iconList = List<HomeIconListIconList>();
  List<HomeIconListIconList> adList = List<HomeIconListIconList>();

  ///新人专享自营商品列表
  List<HomeGoodsListGoodsList> newcomersGoodsList =
      List<HomeGoodsListGoodsList>();

  ///当前用户等级 0普通用户 1体验用户 2VIP用户 3代理 4钻石用户
  var userType;
  var _tabIndexBeforeRefresh = 0;
  bool isFirstLoading = true;
  List<String> _tabValues = [
    "新人专区",
    "vip专区",
    "钻石专区",
  ];
  List<String> nomalItems = [
    "新人专区",
    "vip专区",
    "钻石专区",
  ];
  List<String> experienceItems = [
    "体验专区",
    "vip专区",
    "钻石专区",
  ];
  List<String> _tabValuesRemote = List<String>();
  List<Widget> _tabViews = [
/*    buildTaskListTabView(
      taskType: 0,
    ),
    Container(),
    buildTaskListTabView(
      taskType: 1,
    ),
    buildTaskListTabView(
      taskType: 2,
    ),*/
    Container(),
    Container(),
    Container(),
  ];
  Widget pddcategoryTabsView;
  List<HomePddCategoryDataCat> cats;

  var _marqueeSwiperController = SwiperController();

  var _tabs;
  int _selectedTabIndex = 0;

  var _categoryId;

//分类页签
  List<Widget> buildTabs() {
    List<Widget> tabs = <Widget>[];
    if (!KeTaoFeaturedCommonUtils.isEmpty(cats)) {
      for (var index = 0; index < cats.length; index++) {
        var classify = cats[index];
        tabs.add(Container(
          height: ScreenUtil().setWidth(150),
          width: ScreenUtil().setWidth(227),
          padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(20),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "${classify.catName}",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(42),
                          fontWeight: FontWeight.bold,
                          color: index == _selectedTabIndex
                              ? Color(0xffCE0100)
                              : Color(0xff222222)),
                    ),
                    Visibility(
                      visible: !KeTaoFeaturedCommonUtils.isEmpty(
                          "${classify.subtitle}"),
                      child: Container(
                        height: ScreenUtil().setWidth(46),
                        width: ScreenUtil().setWidth(150),
                        alignment: Alignment.center,
                        /* padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(14),
                        ),*/
                        margin: EdgeInsets.only(
                          top: ScreenUtil().setWidth(6),
                        ),
                        decoration: BoxDecoration(
                          color: index == _selectedTabIndex
                              ? Color(0xffCE0100)
                              : Colors.transparent,
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setWidth(23)),
                        ),
                        child: Text(
                          "${classify.subtitle}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              color: index == _selectedTabIndex
                                  ? Color(0xffffffff)
                                  : Color(0xffafafaf)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: index != cats.length - 1,
                child: Center(
                  child: Container(
//                      color: Color(0xffCE0100),
                    margin: EdgeInsets.only(
//                        left: ScreenUtil().setWidth(30),
                        ),
                    color: Color(0xffb9b9b9),
                    width: ScreenUtil().setWidth(1),
                    height: ScreenUtil().setWidth(43),
                  ),
                ),
              ),
            ],
          ),
        ));
      }
    } else {
      /*tabs.add(Container(
        height: 36,
        child: Tab(
          child: Text(
            "",
            style: TextStyle(
              fontSize: ScreenUtil().setSp(36),
            ),
          ),
        ),
      ));*/
    }
    return tabs;
  }

  TabController _pddTabController;

  @override
  initState() {
    weChatResponseEventHandler.listen((res) {
      if (res is WeChatLaunchMiniProgramResponse) {
//        print("拉起小程序isSuccessful:${res.isSuccessful}");
      }
    });
    _refreshController = EasyRefreshController();
    initPddTabbar();
    _tabController =
        TabController(length: _tabViews.length, vsync: ScrollableState());
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        try {
          _tabIndexBeforeRefresh = _tabController.index;
          if (taskListAll != null && taskListAll.length > 0) {
            bus.emit("taskListChanged", 0);
            bus.emit("taskListChanged",
                taskListAll[_tabController.index].xList.length);
          }
        } catch (e) {}
      }
    });

    _initCacheHomeData();
    _initData();
    _swiperController = new SwiperController();
    _marqueeSwiperController = SwiperController();
    _marqueeSwiperController.startAutoplay();

//    try {
//      userType = KeTaoFeaturedGlobalConfig.getUserInfo().type;
//    } catch (e) {
//      print(e);
//    }

    bus.on("taskListChanged", (listSize) {
      if (mounted) {
        setState(() {
          if (listSize == 0) {
            _tabBarViewHeight = ScreenUtil().setHeight(330);
            return;
          }
          if (listSize > 0) {
            _tabBarViewHeight = ScreenUtil().setHeight(listSize * 300) + 48;
            return;
          }
          _tabBarViewHeight = ScreenUtil()
              .setHeight(listSize * (388 - listSize * (12 - listSize * 0.5)));
        });
      }
    });
    bus.on("refreshHomeData", (data) {
      _initData(isRefresh: true);
      _refreshController.finishLoad(noMore: false);
    });
    bus.on("changeRefreshControllerState", (noMore) {
      _refreshController.finishLoad(noMore: noMore);
    });
    super.initState();
  }

  _initCacheHomeData() {
    var data = KeTaoFeaturedGlobalConfig.getHomeInfo();
    if (!KeTaoFeaturedCommonUtils.isEmpty(data)) {
      if (mounted) {
        setState(() {
          bannerList = data.banner;
          taskListAll = data.taskList;
          userType = data.userLevel;
          goodsList = data.goodsList;
          iconList = data.iconList;
          adList = data.adList;
        });
      }
    }
    var newcomersGoodsData = KeTaoFeaturedGlobalConfig.getHomeNewcomersInfo();
    if (!KeTaoFeaturedCommonUtils.isEmpty(newcomersGoodsData)) {
      if (mounted) {
        setState(() {
          newcomersGoodsList = newcomersGoodsData;
        });
      }
    }
  }

  initPddTabbar() {
    _pddTabController =
        new TabController(vsync: this, length: cats == null ? 0 : cats.length);
    _pddTabController.addListener(() {
      if (mounted) {
        setState(() {
          if (_pddTabController.index == _pddTabController.animation.value) {
            _selectedTabIndex = _pddTabController.index;
          }
        });
      }
    });
    _tabs = buildTabs();
    pddcategoryTabsView = buildPddCategoryTabBar();
  }

  ///拼多多商品分类
  Widget buildPddCategoryTabBar() {
    return SliverPersistentHeader(
        pinned: true,
        delegate: KeTaoFeaturedPersistentHeaderBuilder(
            max: ScreenUtil().setWidth(180),
            min: ScreenUtil().setWidth(150),
            builder: (ctx, offset) => Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(
                      horizontal: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
                  color: Color(0xFFFAFAFA),
//                  height: 26,
                  child: TabBar(
                    labelColor: Color(0xff222222),
                    controller: this._pddTabController,
                    indicatorColor: Color(0xffCE0100),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 2,
                    isScrollable: true,
                    indicator: KeTaoFeaturedRoundUnderlineTabIndicator(
                        borderSide: BorderSide(
                      width: 0,
                      color: Colors.white,
                    )),
                    labelPadding: EdgeInsets.all(0),
                    tabs: _tabs,
                    onTap: (index) {
                      setState(() {
                        if (mounted) {
                          setState(() {
                            _selectedTabIndex = _pddTabController.index;
                            _tabs = buildTabs();
                            pddcategoryTabsView = buildPddCategoryTabBar();
                            bus.emit("changePddListViewData",
                                cats[_selectedTabIndex]);
                          });
                        }
                      });
                    },
                  ),
                )));
  }

  Future _initData({bool isRefresh = false}) async {
    var newcomersGoodsResult = await HttpManage.getGoodsList(
        type: "new", page: 1, pageSize: 2, firstId: '');
    if (newcomersGoodsResult.status) {
      HomeGoodsListEntity entity = HomeGoodsListEntity();
      homeGoodsListEntityFromJson(entity, newcomersGoodsResult.data);
      if (mounted) {
        setState(() {
          newcomersGoodsList = entity.goodsList;
        });
      }
    }
    var categoryResult = await HttpManage.getHomePagePddProductCategory();
    try {
      if (categoryResult.status) {
        if (mounted) {
          setState(() {
            cats = categoryResult.data.cats;
            initPddTabbar();
            _selectedTabIndex = 0;
            _tabs = buildTabs();
            pddcategoryTabsView = buildPddCategoryTabBar();
            bus.emit("changePddListViewData", cats[_selectedTabIndex]);
          });
        }
      }
    } catch (e) {}
    var result = await HttpManage.getHomeInfo();
    if (mounted) {
      setState(() {
        try {
          entity = result;
          bannerList = entity.data.banner;
          taskListAll = entity.data.taskList;
          userType = entity.data.userLevel;
          goodsList = entity.data.goodsList;
          iconList = entity.data.iconList;
          adList = entity.data.adList;
        } catch (e) {
          print('init data err=$e');
        }
//        _tabController = TabController(length: 3, vsync: this);
        _tabController =
            TabController(length: taskListAll.length, vsync: ScrollableState());
        _tabController.addListener(() {
          try {
            _tabIndexBeforeRefresh = _tabController.index;
            if (taskListAll != null && taskListAll.length > 0) {
              bus.emit("taskListChanged", 0);
              bus.emit("taskListChanged",
                  taskListAll[_tabController.index].xList.length);
            }
          } catch (e) {
            print('init data taskListChanged err=$e');
          }
        });
        _tabValuesRemote.clear();
        List<Widget> listTabViews = List<Widget>();
        for (var valueItem in taskListAll) {
          _tabValuesRemote.add(valueItem.name);
        }
        for (int i = 0; i < taskListAll.length; i++) {
          try {
            listTabViews.add(TaskListTabView(
              taskType: i,
              taskList: taskListAll[i].xList,
              userType: userType,
            ));
            /* print(
                ' listTabViews.add(TaskListTabViewexception=$i&&taskListAll[i].xList=${taskListAll[i].xList}');
          */
          } catch (e) {
            //print(' listTabViews.add(TaskListTabViewexception=$e');
          }
        }
        isFirstLoading = false;
        _tabValues = _tabValuesRemote;
        _tabViews = listTabViews;
        if (!isRefresh) {
          switch (userType) {
            case "1": //体验
//            _tabValues = experienceItems;
              _tabController.animateTo(0);
              break;
            case "2": //vip
              _tabController.animateTo(1);
              break;
            case "4": //钻石
              _tabController.animateTo(2);
              break;
            default:
              _tabController.animateTo(0);
              break;
          }
        } else {
          _tabController.animateTo(_tabIndexBeforeRefresh);
        }

        _isLoop = true;
        _isMarqueeLoop = true;
        initBannerListColor();
      });
    }
  }

  initBannerListColor() async {
    bannerColorList = List<Color>();
    bannerColorList.clear();
    for (var bannerItem in bannerList) {
      PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
          Image.network("${bannerItem.imgPath}").image);
      bannerColorList.add(generator.dominantColor.color);
    }
    if (mounted) {
      setState(() {
        try {
          _gradientCorlor = LinearGradient(colors: [
            bannerColorList[bannerIndex],
            bannerColorList[bannerIndex],
          ]);
        } catch (e) {
          print('change bannerColorList color err = $e');
        }
      });
    }

    ///
    if (bannerList.length > 1) {
      _swiperController.startAutoplay();
    } else {
      _swiperController.stopAutoplay();
    }
  }

  ///
  /// 确认账户信息是否绑定手机号以及微信授权
  static checkUserBind({bool isTaskWall = false}) async {
    UserInfoData userInfoData = KeTaoFeaturedGlobalConfig.getUserInfo();
    if (KeTaoFeaturedCommonUtils.isEmpty(userInfoData)) {
      print("userInfoData is empty is true");
      var result = await HttpManage.getUserInfo();
      if (result.status) {
        userInfoData = KeTaoFeaturedGlobalConfig.getUserInfo();
      } else {
        KeTaoFeaturedCommonUtils.showToast("${result.errMsg}");
        return false;
      }
    }
    if (!isTaskWall) {
      if (userInfoData.bindThird == 1) {
        KeTaoFeaturedCommonUtils.showToast("请先绑定微信后领取任务");
        return false;
      }
    }

    if (KeTaoFeaturedCommonUtils.isEmpty(userInfoData.tel)) {
      KeTaoFeaturedCommonUtils.showToast("请先绑定手机号后领取任务");
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _swiperController.stopAutoplay();
    _swiperController.dispose();
    _marqueeSwiperController.stopAutoplay();
    _marqueeSwiperController.dispose();
    _tabController.dispose();
    _pddTabController.dispose();
    _isLoop = false;
    _isMarqueeLoop = false;
    _refreshController.dispose();
    super.dispose();
  }

  var images = [
    /* "https://dss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1906469856,4113625838&fm=26&gp=0.jpg",
    "https://dss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1141259048,554497535&fm=26&gp=0.jpg",
    "https://dss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2396361575,51762536&fm=26&gp=0.jpg",*/
  ];

  var iconsUrls = [
    /*"static/images/task_icon_1.png",
    "static/images/task_icon_2.png",
    "static/images/task_icon_3.png",
    "static/images/task_icon_4.png",
    "static/images/task_icon_5.png",*/
  ];
  LinearGradient _gradientCorlor = LinearGradient(colors: [
    Color(0xFFB43733),
    Color(0xFFB43733),
    Color(0xFFB43733),
  ]);

  // 默认值
  String value;

  // 最前面的组件
  Widget leading;

  // 搜索框后缀组件
  Widget suffix;
  List<Widget> actions;

  // 提示文字
  String hintText;

  // 输入框点击
  VoidCallback _onTap;

  // 单独清除输入框内容
  VoidCallback _onClear;

  // 清除输入框内容并取消输入
  VoidCallback _onCancel;

  // 输入框内容改变
  ValueChanged _onInputChanged;

  // 点击键盘搜索
  ValueChanged _onSearch;
  bool _autoFocus;
  String _hintText;
  TextEditingController _controller;
  FocusNode _focusNode;

  EasyRefreshController _refreshController;

  ///扫一扫
  scan() async {
    var shopId;
    var _balance;
    var _hasPayPassword;
    var _shopName;
    var _shopCode;

    /// 调用扫一扫
    String cameraScanResult = await scanner.scan();
    var scanResult =
        await HttpManage.getScanResultRemote(qrCodeResult: cameraScanResult);
    if (scanResult.status) {
      shopId = scanResult.data.storeId;
      _shopName = scanResult.data.name;
      _shopCode = scanResult.data.code;
    } else {
      KeTaoFeaturedCommonUtils.showToast("${scanResult.errMsg}");
      return;
    }
    //  获取店铺支付相关信息
    var entityResult = await HttpManage.getShopPayInfo(storeId: shopId);
    if (entityResult.status) {
      _balance = entityResult.data.user.price;
      _hasPayPassword = entityResult.data.user.payPwdFlag;
      _shopName = entityResult.data.store.storeName;
      _shopCode = entityResult.data.store.storeCode;
    }

    ///进入支付页面
    KeTaoFeaturedNavigatorUtils.navigatorRouter(
        context,
        KeTaoFeaturedShopPaymentPage(
          shopId: shopId,
          shopName: _shopName,
          shopCode: _shopCode,
          balance: _balance,
          hasPayPassword: _hasPayPassword,
        ));

    ///
  }

  Widget buildSearchBarLayout() {
    return Container(
      height: 50,
      child: Row(
        children: <Widget>[
//          https://alipic.lanhuapp.com/xdbb9d62a1-36c2-496b-8c01-8bc79436d834
          IconButton(
            icon: Container(
              width: ScreenUtil().setWidth(78),
              height: ScreenUtil().setWidth(78),
              child: Center(
                child: KeTaoFeaturedMyOctoImage(
                  image:
                      "https://alipic.lanhuapp.com/xdbb9d62a1-36c2-496b-8c01-8bc79436d834",
                  width: ScreenUtil().setWidth(78),
                  height: ScreenUtil().setWidth(78),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            onPressed: () async {
              KeTaoFeaturedCommonUtils.requestPermission(
                  Permission.camera, scan());
            },
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                KeTaoFeaturedNavigatorUtils.navigatorRouter(
                    context, KeTaoFeaturedSearchGoodsPage());
              },
              child: Container(
                height: ScreenUtil().setWidth(100),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(
                    horizontal: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: Colors.white,
                ),
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(35)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    KeTaoFeaturedMyOctoImage(
                      width: ScreenUtil().setWidth(36),
                      height: ScreenUtil().setWidth(36),
                      image:
                          "https://alipic.lanhuapp.com/xd8f3e4512-742b-425a-8660-1feddac4e231",
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(10)),
                      child: Text(
                        "搜索你想要的吧",
                        style: TextStyle(
                          color: Color(0xff666666),
                          fontSize: ScreenUtil().setSp(36),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: Container(
              width: ScreenUtil().setWidth(78),
              height: ScreenUtil().setWidth(78),
              child: Center(
                child: KeTaoFeaturedMyOctoImage(
                  width: ScreenUtil().setWidth(78),
                  height: ScreenUtil().setWidth(78),
                  image:
                      "https://alipic.lanhuapp.com/xd63f13c86-a6db-4057-a97c-86aa31c9f283",
                ),
              ),
            ),
            onPressed: () {
              KeTaoFeaturedNavigatorUtils.navigatorRouter(
                  context, KeTaoFeaturedTaskMessagePage());
            },
          ),
          /*Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {

              },
              child: KeTaoFeaturedMyOctoImage(
                width: ScreenUtil().setWidth(78),
                height: ScreenUtil().setWidth(78),
                image:
                    "https://alipic.lanhuapp.com/xd63f13c86-a6db-4057-a97c-86aa31c9f283",
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  ///广告占位
  Widget buildAdRowContainer() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(
//            top: 8,
            left: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
            right: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
        child: Row(
          children: List.generate(
              KeTaoFeaturedCommonUtils.isEmpty(adList) ? 0 : adList.length,
              (index) => buildAdWidget(adList[index], index)),
        ),
      ),
    );
  }

  ///广告单元
  Widget buildAdWidget(HomeIconListIconList item, int index) {
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
    bool needLogin = false;
    try {
      icon = item.icon;

      name = item.name;
      type = item.type;
      appId = item.appId;
      path =
          !KeTaoFeaturedCommonUtils.isEmpty(item.path) ? item.path : item.uri;
      subtitle = item.subtitle;
      params = item.params;
      imgPath = item.imgPath;
      needLogin = item.needLogin;
      if (params.contains("&")) {}
      List<String> pList = params.split("&");
      for (var itemString in pList) {
        List<String> itemList = itemString.split("=");
        if (!KeTaoFeaturedCommonUtils.isEmpty(itemList)) {
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
          ///
          ///

          if (type == 'webapp') {
            launchWeChatMiniProgram(username: appId, path: path);
            return;
          }
          if (type == 'app') {
            if (path == 'pdd_index') {
              KeTaoFeaturedNavigatorUtils.navigatorRouter(
                  context, KeTaoFeaturedPddHomeIndexPage());
              return;
            }
            if (path == 'pdd_goods') {
              KeTaoFeaturedNavigatorUtils.navigatorRouter(
                  context,
                  KeTaoFeaturedPddGoodsListPage(
                    showAppBar: true,
                    type: pddType,
                    title: KeTaoFeaturedCommonUtils.isEmpty(name) ? "精选" : name,
                    categoryId: catId,
                  ));
              return;
            }
            switch (path) {
              case "recharge":
                KeTaoFeaturedNavigatorUtils.navigatorRouter(
                    context, KeTaoFeaturedRechargeListPage());
                break;
            }
            return;
          }
          if (type == 'toast') {
            KeTaoFeaturedCommonUtils.showToast("敬请期待");
            return;
          }
          if (type == 'link') {
            if (path.toString().startsWith("pinduoduo")) {
              if (await canLaunch(path)) {
                await launch(path);
              } else {
                if (path.startsWith("pinduoduo://")) {
                  KeTaoFeaturedCommonUtils.showToast("亲，您还未安装拼多多客户端哦！");
                  KeTaoFeaturedNavigatorUtils.navigatorRouter(
                      context,
                      KeTaoFeaturedWebViewPluginPage(
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
                KeTaoFeaturedNavigatorUtils.navigatorRouter(
                    context,
                    KeTaoFeaturedWebViewPluginPage(
                      initialUrl: "$path",
                      showActions: true,
                      title: "拼多多",
                      appBarBackgroundColor: Colors.white,
                    ));
                return;
              }
            }
            KeTaoFeaturedUtils.launchUrl(path);
            return;
          }

          ///
        },
        child: Visibility(
          visible: !KeTaoFeaturedCommonUtils.isEmpty(
            imgPath,
          ),
          child: Container(
            alignment:
                index % 2 == 0 ? Alignment.centerLeft : Alignment.centerRight,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  ScreenUtil().setWidth(30),
                ),
              ),
              child: KeTaoFeaturedMyOctoImage(
                image: "$imgPath",
                fit: BoxFit.fitWidth,
                width: ScreenUtil().setWidth(522),
                height: ScreenUtil().setWidth(322),
              ),
            ),
          ),
        ),
      ),
    );
  }

//偏移量的值
  double _offsetValue;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!KeTaoFeaturedCommonUtils.isEmpty(iconList)) {
      } else {
        _initData();
      }
    });
    return Scaffold(
      /* appBar: PreferredSize(
        preferredSize: Size.fromHeight(56 + MediaQuery.of(context).padding.top),
        child: AnimatedContainer(
          width: double.maxFinite,
//          height: 56 + ScreenUtil.statusBarHeight,
          alignment: Alignment.center,
          height: 56 + MediaQuery.of(context).padding.top,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
          decoration: BoxDecoration(
            gradient: _gradientCorlor,
          ),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(54),
              color: Colors.white,
            ),
          ),
        ),
      ),*/
      appBar: GradientAppBar(
        title: buildSearchBarLayout(),
        /* Row(
          children: [
            Text(
              widget.title,
              style: TextStyle(fontSize: ScreenUtil().setSp(54)),
            ),
          ],
        ),*/
        centerTitle: true,
        elevation: 0,
        brightness: Brightness.dark,
        gradient: _gradientCorlor,
        titleSpacing: 0,
      ),
      body: Builder(
        builder: (context) {
          return EasyRefresh.custom(
            enableControlFinishLoad: false,
            topBouncing: false,
            bottomBouncing: false,
            controller: _refreshController,
            header: CustomHeader(
                completeDuration: Duration(milliseconds: 1000),
                headerBuilder: (context,
                    refreshState,
                    pulledExtent,
                    refreshTriggerPullDistance,
                    refreshIndicatorExtent,
                    axisDirection,
                    float,
                    completeDuration,
                    enableInfiniteRefresh,
                    success,
                    noMore) {
                  return Stack(
                    children: <Widget>[
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          width: 30.0,
                          height: 30.0,
                          child: SpinKitCircle(
                            color: KeTaoFeaturedGlobalConfig.colorPrimary,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
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
//                            color: KeTaoFeaturedGlobalConfig.colorPrimary,
//                            size: 30.0,
//                          ),*/
//                  ),
                      ),
                    ],
                  );
                }),
            firstRefreshWidget: Container(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                  child: SizedBox(
                height: 200.0,
                width: 300.0,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        height: 50.0,
                        child: SpinKitFadingCube(
                          color: KeTaoFeaturedGlobalConfig.colorPrimary,
                          size: 25.0,
                        ),
                      ),
                      Container(
                        child: Text("正在加载。。。"),
                      )
                    ],
                  ),
                ),
              )),
            ),
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Stack(
                  children: <Widget>[
                    buildBannerLayout(),
//                    _buildHotspot(),
                  ],
                ),
              ),
              desLayout(),
              itemsLayout(),

              ///测试查看loading效果
              /* SliverToBoxAdapter(
                  child: Column(
                children: [
                  Loading(
                    indicator: BallBeatIndicator(),
                    size: 100.0,
                    color: KeTaoFeaturedGlobalConfig.colorPrimary,
                  ),
                  Loading(
                    indicator: BallGridPulseIndicator(),
                    size: 100.0,
                    color: KeTaoFeaturedGlobalConfig.colorPrimary,
                  ),
                  Loading(
                    indicator: BallPulseIndicator(),
                    size: 100.0,
                    color: KeTaoFeaturedGlobalConfig.colorPrimary,
                  ),
                  Loading(
                    indicator: BallScaleIndicator(),
                    size: 100.0,
                    color: KeTaoFeaturedGlobalConfig.colorPrimary,
                  ),
                  Loading(
                    indicator: BallScaleMultipleIndicator(),
                    size: 100.0,
                    color: KeTaoFeaturedGlobalConfig.colorPrimary,
                  ),
                  Loading(
                    indicator: BallSpinFadeLoaderIndicator(),
                    size: 100.0,
                    color: KeTaoFeaturedGlobalConfig.colorPrimary,
                  ),
                  Loading(
                    indicator: LineScaleIndicator(),
                    size: 100.0,
                    color: KeTaoFeaturedGlobalConfig.colorPrimary,
                  ),
                  Loading(
                    indicator: LineScalePartyIndicator(),
                    size: 100.0,
                    color: KeTaoFeaturedGlobalConfig.colorPrimary,
                  ),
                  Loading(
                    indicator: LineScalePulseOutIndicator(),
                    size: 100.0,
                    color: KeTaoFeaturedGlobalConfig.colorPrimary,
                  ),
                  Loading(
                    indicator: PacmanIndicator(),
                    size: 100.0,
                    color: KeTaoFeaturedGlobalConfig.colorPrimary,
                  ),
                ],
              )),*/
              buildLayoutNewcomers(),
              buildAdRowContainer(),
              buildGoodsListSliverToBoxAdapter(context),
//              buildApplyForMicroShareholders(),
              pddcategoryTabsView,
              SliverToBoxAdapter(
                child: GestureDetector(
                  child: KeTaoFeaturedHomeGoodsListPage(
                    categoryId: _categoryId,
                  ),
                  onHorizontalDragStart: (DragStartDetails details) {},
                  onHorizontalDragUpdate: (DragUpdateDetails details) {
                    _offsetValue = details.primaryDelta;
                  },
                  onHorizontalDragEnd: (DragEndDetails details) {
                    setState(() {
                      if (_offsetValue > 0) {
                        //向左滑动
                        if (_selectedTabIndex > 0) {
                          _selectedTabIndex = _selectedTabIndex - 1;
                          _tabs = buildTabs();
                          pddcategoryTabsView = buildPddCategoryTabBar();
                          _pddTabController.animateTo(_selectedTabIndex);
                          bus.emit(
                              "changePddListViewData", cats[_selectedTabIndex]);
                        }
                      } else {
                        //向右滑动
                        if (_selectedTabIndex < cats.length - 1) {
                          _selectedTabIndex = _selectedTabIndex + 1;
                          _tabs = buildTabs();
                          pddcategoryTabsView = buildPddCategoryTabBar();
                          _pddTabController.animateTo(_selectedTabIndex);
                          bus.emit(
                              "changePddListViewData", cats[_selectedTabIndex]);
                        }
                      }
                    });
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  child: SizedBox(
                    height: 8,
                  ),
                ),
              ),
              //  SliverToBoxAdapter(child: taskCard2(context)),
              // buildTaskWall(),
            ],
            onRefresh: () async {
//              _initData();
              if (!isFirstLoading) {
                bus.emit("refreshHomeData");
              }
            },
            onLoad: () async {
//              _initData();
              if (!isFirstLoading) {
                bus.emit("loadMoreHomeData");
              }
            },
          );
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  var _newcomersLayoutTextColor = Color(0xffFEF7EA);

  ///新人专享
  ///
  ///
  Widget buildLayoutNewcomers() {
    return SliverToBoxAdapter(
      child: Visibility(
        visible: newcomersGoodsList.length > 0,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(20),
            vertical: ScreenUtil().setWidth(30),
          ),
          margin: EdgeInsets.only(
              top: ScreenUtil().setHeight(30),
              left: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
              right: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              ScreenUtil().setWidth(30),
            ),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  KeTaoFeaturedNavigatorUtils.navigatorRouter(
                    context,
                    KeTaoFeaturedNewcomersGoodsListPage(),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: ScreenUtil().setWidth(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      KeTaoFeaturedMyOctoImage(
                        image:
                            "https://alipic.lanhuapp.com/xd9bd6d3e5-7922-4d3e-ae54-7d4c033c0b71",
                        width: ScreenUtil().setWidth(161),
                        height: ScreenUtil().setWidth(65),
                        fit: BoxFit.fill,
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "新人专享",
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(54),
                                  color: Color(0xff222222),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
//                                      top: ScreenUtil().setWidth(60),
                                  left: ScreenUtil().setWidth(15),
                                ),
                                child: Text(
                                  "下单立享50%分红金",
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(34),
                                    color: Color(0xff666666),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "更多",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xff999999),
                              fontSize: ScreenUtil().setSp(30),
                            ),
//                            https://alipic.lanhuapp.com/xd8d557d60-d753-42a5-9955-ba264728afb7
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: KeTaoFeaturedMyOctoImage(
                              image:
                                  "https://alipic.lanhuapp.com/xd8d557d60-d753-42a5-9955-ba264728afb7",
                              fit: BoxFit.fill,
                              width: ScreenUtil().setWidth(13),
                              height: ScreenUtil().setWidth(22),
//                                color: Color(0xffce0100),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(1022),
                height: ScreenUtil().setWidth(424),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "static/images/bg_newcomers.png",
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "50",
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(160),
                                  color: _newcomersLayoutTextColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
//                                      top: ScreenUtil().setWidth(60),
                                      left: ScreenUtil().setWidth(25),
                                    ),
                                    child: Text(
                                      "分红金",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(48),
                                        color: _newcomersLayoutTextColor,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
//                                      top: ScreenUtil().setWidth(60),
                                      left: ScreenUtil().setWidth(5),
                                      right: ScreenUtil().setWidth(15),
                                    ),
                                    child: Text(
                                      "%",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(57),
                                        color: _newcomersLayoutTextColor,
                                      ),
                                    ),
                                  ),
                                  /*Text(
                                    "体验金",
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(33),
                                      color: _newcomersLayoutTextColor,
                                    ),
                                  ),*/
                                ],
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              KeTaoFeaturedNavigatorUtils.navigatorRouter(
                                  context, KeTaoFeaturedNewcomersGoodsListPage());
                            },
                            child: Container(
                              width: ScreenUtil().setWidth(327),
                              height: ScreenUtil().setWidth(84),
                              margin: EdgeInsets.only(
                                top: ScreenUtil().setWidth(16),
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xffF9F3F3),
                                      Color(0xffFFC37D),
                                    ]),
                                /*border: Border.all(
                                  color: Color(0xffF8A699),
                                  width: ScreenUtil().setWidth(3),
                                ),*/
                                borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(50)),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "立即领取",
                                    style: TextStyle(
                                      color: Color(0xffFF4662),
                                      fontWeight: FontWeight.w600,
                                      fontSize: ScreenUtil().setSp(46),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(16),
                                    ),
                                    child: KeTaoFeaturedMyOctoImage(
                                      image:
                                          "https://alipic.lanhuapp.com/xd45793b57-8b32-4675-bea9-bd30fa7e5a13",
                                      fit: BoxFit.fill,
                                      width: ScreenUtil().setWidth(41),
                                      height: ScreenUtil().setWidth(41),
//                                color: Color(0xffce0100),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 11,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: List.generate(
                                newcomersGoodsList.length,
                                (index) {
                                  var item = newcomersGoodsList[index];
                                  var salePrice = '';
                                  var imgUrl = '';
                                  var goodId = '';
                                  try {
                                    salePrice = "￥${item.salePrice}";
                                    imgUrl = item.goodsImg;
                                    goodId = item.id;
                                  } catch (e) {}
                                  return GestureDetector(
                                    onTap: () {
                                      KeTaoFeaturedNavigatorUtils
                                          .navigatorRouter(
                                        context,
                                        KeTaoFeaturedNewcomersGoodsListPage(),
                                      );
                                      /* KeTaoFeaturedNavigatorUtils.navigatorRouter(
                                        context,
                                        KeTaoFeaturedGoodsDetailPage(productId: goodId),
                                      );*/
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(30),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                              bottom: ScreenUtil().setWidth(20),
                                            ),
                                            child: KeTaoFeaturedMyOctoImage(
                                              image: "$imgUrl",
                                              fit: BoxFit.fill,
                                              width: ScreenUtil().setWidth(224),
                                              height:
                                                  ScreenUtil().setWidth(224),
//                                color: Color(0xffce0100),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                  top: ScreenUtil().setWidth(3),
                                                  bottom:
                                                      ScreenUtil().setWidth(3),
                                                  left:
                                                      ScreenUtil().setWidth(6),
                                                  right:
                                                      ScreenUtil().setWidth(6),
                                                ),
                                                margin: EdgeInsets.only(
                                                  right:
                                                      ScreenUtil().setWidth(12),
                                                ),
                                                decoration: BoxDecoration(
                                                  color: _newcomerPriceColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(ScreenUtil()
                                                        .setWidth(10)),
                                                  ),
                                                ),
                                                child: Text(
                                                  "新人价",
                                                  style: TextStyle(
                                                    fontSize:
                                                        ScreenUtil().setSp(32),
                                                    color:
                                                        _newcomersLayoutTextColor,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "$salePrice",
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(38),
                                                  color: _newcomerPriceColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///自营消费补贴商品列表
  Widget buildGoodsListSliverToBoxAdapter(BuildContext context) {
    return SliverToBoxAdapter(
        child: Visibility(
      visible: goodsList.length > 0,
      child: Container(
        height: ScreenUtil().setWidth(664),
        margin: EdgeInsets.only(
            top: ScreenUtil().setHeight(30),
            left: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
            right: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
        padding: EdgeInsets.all(ScreenUtil().setWidth(32)),
        decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(colors: [
              Color(0xffE7665C),
              Color(0xffD54035),
            ]),
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(32))),
        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    KeTaoFeaturedNavigatorUtils.navigatorRouter(
                        context,
                        KeTaoFeaturedGoodsListPage(
                          type: "hot",
                        ));
                  },
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Container(
                                width: ScreenUtil().setWidth(844),
                                height: ScreenUtil().setWidth(152),
                                child: KeTaoFeaturedMyOctoImage(
                                  image:
                                      "https://alipic.lanhuapp.com/xde2fb8570-f7e3-47a5-9220-217c64821d87",
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                width: ScreenUtil().setWidth(525),
                                height: ScreenUtil().setWidth(93),
                                child: KeTaoFeaturedMyOctoImage(
                                  image:
                                      "https://alipic.lanhuapp.com/xdde41acb8-afe5-4d8d-bd12-e9dc417c3894",
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: ScreenUtil().setWidth(162),
                          height: ScreenUtil().setWidth(63),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xffFFEDD8),
                                  Color(0xffFEC7B7),
                                ]),
                            border: Border.all(
                              color: Color(0xffF8A699),
                              width: ScreenUtil().setWidth(3),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().setWidth(32)),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "GO",
                                style: TextStyle(
                                  color: Color(0xffC61513),
                                  fontWeight: FontWeight.w600,
                                  fontSize: ScreenUtil().setSp(42),
                                ),
                              ),
                              KeTaoFeaturedMyOctoImage(
                                image:
                                    "https://alipic.lanhuapp.com/xdb2ba7101-ff5b-42ae-a6e7-f890b3b83e91",
                                fit: BoxFit.fill,
                                width: ScreenUtil().setWidth(33),
                                height: ScreenUtil().setWidth(33),
//                                color: Color(0xffce0100),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(
                      bottom: ScreenUtil().setHeight(30),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setWidth(140),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(goodsList.length, (index) {
                        HomeGoodsListGoodsList item;
                        try {
                          item = goodsList[index];
                        } catch (e) {}
                        return productItem(item: item);
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  ///申请微股东
  Widget buildApplyForMicroShareholders() {
    return SliverToBoxAdapter(
      child: Stack(
//        alignment: Alignment.centerLeft,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              KeTaoFeaturedNavigatorUtils.navigatorRouter(
                  context, KeTaoFeaturedMicroShareHolderEquityPage());
            },
            child: Container(
              margin: EdgeInsets.only(
                  left: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
                  right: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
                  top: 10),
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(211),
                right: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
              ),
              height: ScreenUtil().setWidth(158),
              decoration: BoxDecoration(
//                            color: Colors.white,
                  gradient: LinearGradient(colors: [
                    Color(0xffA10011),
                    Color(0xff590600),
                  ]),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(ScreenUtil().setWidth(30)),
                    topRight: Radius.circular(ScreenUtil().setWidth(30)),
                    bottomLeft: Radius.circular(ScreenUtil().setWidth(30)),
                    bottomRight: Radius.circular(ScreenUtil().setWidth(30)),
                  )),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text(
                        "申请微股东 享受每日分红",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(46),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(211),
                    height: ScreenUtil().setWidth(77),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(right: 10, left: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xffE43E32),
                            Color(0xffAB221B),
                          ]),
                      borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(39)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "立即申请",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(32),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 3),
                          child: KeTaoFeaturedMyOctoImage(
                            image:
                                "https://alipic.lanhuapp.com/xd18562122-edcf-4b8a-8f6d-4528530150ea",
                            fit: BoxFit.fill,
                            width: ScreenUtil().setWidth(12),
                            height: ScreenUtil().setWidth(21),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(207),
            height: ScreenUtil().setWidth(207),
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(40),
                right: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
                top: ScreenUtil().setWidth(10)),
            child: KeTaoFeaturedMyOctoImage(
              image:
                  "https://alipic.lanhuapp.com/xd3342447e-ba65-4d86-91eb-edfe87de5ca3",
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContent() {
    return Builder(
      builder: (context) => SliverToBoxAdapter(
        child: CustomScrollView(
          slivers: <Widget>[
//              buildBannerLayout(),
//              buildBannerLayout2(),
            SliverToBoxAdapter(
              child: Stack(
                children: <Widget>[
                  buildBannerLayout(),
                  _buildHotspot(),
                ],
              ),
            ),

            SliverToBoxAdapter(
                child: Container(
              margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(30),
                  left: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
                  right: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
              padding: EdgeInsets.all(ScreenUtil().setWidth(32)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(ScreenUtil().setWidth(32))),
              child: Column(
                children: <Widget>[
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        productItem(),
                        productItem(),
                        productItem(),
                        productItem(),
                        productItem(),
                        productItem(),
                        productItem(),
                        productItem(),
                        productItem(),
                      ],
                    ),
                  ),
                ],
              ),
            )),
            SliverToBoxAdapter(child: taskCard2(context)),
//            buildTaskWall(),
          ],
        ),
      ),
    );
  }

  var _priceColor = const Color(0xffe31735);
  var _newcomerPriceColor = const Color(0xffF32E43);

  Widget productItem({HomeGoodsListGoodsList item}) {
    String id = '';
    String goodsName = '';
    String goodsImg = '';
    String originalPrice = '';
    String salePrice = '';
    double topMargin = 10;
    try {
      id = item.id;
      goodsName = item.goodsName;
      goodsImg = item.goodsImg;
      originalPrice = item.originalPrice;
      salePrice = item.salePrice;
      /* if (goodsName.length < 8) {
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
            KeTaoFeaturedGoodsDetailPage(
              productId: id,
            ));
      },
      child: Container(
//            color: Colors.blue ,商学院
          width: ScreenUtil().setWidth(331),
          margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
          constraints: BoxConstraints(),
          decoration: BoxDecoration(
            color: Color(0xffFee2cd),
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(20)),
          ),
          child: Padding(
//                  padding: const EdgeInsets.only(left: 4,right: 4,top: 4,bottom: 4),
            padding: EdgeInsets.all(ScreenUtil().setWidth(14)),
//            child: InkWell(
//              splashColor: Colors.yellow,

//        onDoubleTap: () => showSnackBar(),
            child: Container(
              width: ScreenUtil().setWidth(305),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(ScreenUtil().setWidth(10)),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
//                        fit: StackFit.expand,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(ScreenUtil().setWidth(30)),
                        topLeft: Radius.circular(ScreenUtil().setWidth(30)),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(ScreenUtil().setWidth(10)),
                        topLeft: Radius.circular(ScreenUtil().setWidth(10)),
                      ),
                      child: KeTaoFeaturedMyOctoImage(
                        fadeInDuration: Duration(milliseconds: 0),
                        fadeOutDuration: Duration(milliseconds: 0),
                        height: ScreenUtil().setWidth(305),
                        width: ScreenUtil().setWidth(305),
                        fit: BoxFit.fill,
                        image: "$goodsImg",
                      ),
                    ),
                  ),

//                          SizedBox(
//                            height: 10,
//                          ),
                  Visibility(
                    visible: false,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(20),
                        vertical: ScreenUtil().setHeight(16),
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
                  ),
                  Container(
                    height: ScreenUtil().setWidth(55),
                    margin: EdgeInsets.only(top: topMargin, left: 4, right: 4),
                    decoration: BoxDecoration(
                      color: Color(0xffe8e8e8),
                      borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(28)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        /* SizedBox(
                          width: 5,
                        ),*/
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                              bottom: ScreenUtil().setHeight(2),
                            ),
                            padding: EdgeInsets.only(
                              left: ScreenUtil().setHeight(12),
                            ),
                            child: Visibility(
//                              visible: salePrice != originalPrice,
                              child: Text(
                                "￥$originalPrice",
                                overflow: TextOverflow.ellipsis,
//                            '${0}人评价',
//                            '23234人评价',
//                          product
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: ScreenUtil().setSp(24),
                                    color: Color(0xFFafafaf)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(20),
                        ),
                        Container(
                          height: ScreenUtil().setWidth(55),
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: Color(0xffE32024),
                            borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().setWidth(28)),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                child: PriceText(
                                  text: '$salePrice',
                                  textColor: Colors.white,
                                  fontSize: ScreenUtil().setSp(32),
                                  fontBigSize: ScreenUtil().setSp(32),
                                  fontWeight: FontWeight.normal,
                                  /*style: TextStyle(
                                    fontSize: ScreenUtil().setSp(42),
                                    color: _priceColor,
                                    fontWeight: FontWeight.bold,
                                  ),*/
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4),
                              ),
                              KeTaoFeaturedMyOctoImage(
                                fadeInDuration: Duration(milliseconds: 0),
                                fadeOutDuration: Duration(milliseconds: 0),
                                fit: BoxFit.fitWidth,
                                height: ScreenUtil().setWidth(26),
                                width: ScreenUtil().setWidth(26),
                                image:
                                    "https://alipic.lanhuapp.com/xd00b6d1cd-b672-41f7-89ea-806d7c3aef94",
                              ),
                            ],
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
            ),
          )),
    );
  }

  var _desTextColor = Color(0xffCE0100);

  ///描述信息
  Widget desLayout() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(47),
          top: 8,
          right: ScreenUtil().setWidth(47),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      KeTaoFeaturedMyOctoImage(
                        image:
                            "https://alipic.lanhuapp.com/xd269728c1-1bf9-4bfe-9b86-06af0fabca98",
                        width: ScreenUtil().setWidth(42),
                        height: ScreenUtil().setWidth(42),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 4),
                        child: Text(
                          "可淘自营品牌",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(28),
                            color: _desTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
//                'https://alipic.lanhuapp.com/xd8c969d26-126e-4eeb-abf8-c58086628934',
                        'static/images/icon_seven.svg',
                        width: ScreenUtil().setWidth(42),
                        height: ScreenUtil().setWidth(42),
                        color: Color(0xffce0100),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 4),
                        child: Text(
                          "7天无忧退换货",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(28),
                            color: _desTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
//                'https://alipic.lanhuapp.com/xd8c969d26-126e-4eeb-abf8-c58086628934',
                        'static/images/icon_return.svg',
                        width: ScreenUtil().setWidth(42),
                        height: ScreenUtil().setWidth(42),
                        color: Color(0xffce0100),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 4),
                        child: Text(
                          "48小时快速退款",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(28),
                            color: _desTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///icon 操作列表
  Widget itemsLayout() {
    Color _itemsTextColor = Color(0xff222222);
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(
          top: 16,
          bottom: 16,
        ),
        margin: EdgeInsets.only(
          left: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
          right: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
          top: 8,
//          top: ScreenUtil().setHeight(655),
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
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
    String appPath = '';
    String path = '';
    String subtitle = '';
    String params = '';

    ///拼多多分类id
    String catId = '';

    ///自营分类id
    String cId = '';
    String pddType = '';
    String flag = '';
    bool needShow = true;
    bool isUnderReview = false;
    bool needLogin = false;
    try {
      icon = item.icon;
      name = item.name;
      type = item.type;
      appId = item.appId;
      appPath = item.appPath;
      flag = item.flag;
      path = item.path;
      subtitle = item.subtitle;
      params = item.params;
      needLogin = item.needLogin;
//      print("iconsubtitle=${icon + name + type + appId + path + subtitle}");
      if (params.contains("&")) {}
      List<String> pList = params.split("&");
      for (var itemString in pList) {
        List<String> itemList = itemString.split("=");
        if (!KeTaoFeaturedCommonUtils.isEmpty(itemList)) {
          switch (itemList[0]) {
            case "cat_id":
              catId = itemList[1];
              break;
            case "type":
              pddType = itemList[1];
              break;
            case "cid":
              cId = itemList[1];
              break;
          }
        }
      }
    } catch (e) {
      print(e);
    }
    if (!KeTaoFeaturedCommonUtils.isEmpty(name)) {
      /*if ((name.contains('游戏') ||
              name.contains('赚钱') ||
              name.contains('会员') ) &&
          KeTaoFeaturedGlobalConfig.isHuaweiUnderReview) {
        needShow = false;
      }
      if ((name.contains('游戏') ||
              name.contains('赚钱') ||
              name.contains('会员') ) &&
          KeTaoFeaturedGlobalConfig.isHuaweiUnderReview) {
        needShow = false;
      }
      if ((name.contains('游戏') ||
              name.contains('赚钱') ||
              name.contains('会员') ||
              name.contains('星选')) &&
          isUnderReview) {
        needShow = false;
      }*/
      if (type == 'toast') {
        needShow = false;
      }
    }

    if (Platform.isIOS) {
      isUnderReview =
          KeTaoFeaturedGlobalConfig.prefs.getBool("isHuaweiUnderReview");
    }

    return new InkWell(
        onTap: () async {
          /// 判断功能是否需要登录
          if (needLogin) {
            KeTaoFeaturedCommonUtils.showToast("未获取到登录信息，，请登录！");
            KeTaoFeaturedNavigatorUtils.navigatorRouter(context, KeTaoFeaturedLoginPage());
            return;
          }

          ///
          if (name.contains('赚钱') && Platform.isIOS) {
            if (!KeTaoFeaturedGlobalConfig.isHuaweiUnderReview) {
              KeTaoFeaturedNavigatorUtils.navigatorRouter(
                  context, KeTaoFeaturedTaskHallPage());
            } else {}
            return;
          }
          if (name.contains('美团')) {
            if (isUnderReview) {
              path = 'http://dpurl.cn/cENLteO';
              KeTaoFeaturedUtils.launchUrl(path);
              return;
            }
          }
          if (name.contains('饿') && Platform.isIOS) {
            if (isUnderReview) {
              path =
                  'https://sheng.bainianmao.com/app/index.php?i=550&c=entry&do=elm&m=bsht_tbk&type=1';
              KeTaoFeaturedUtils.launchUrl(path);
              return;
            }
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
            if (flag == 'mei') {
              if (await canLaunch(appPath)) {
                await launch(appPath);
                return;
              }
            }
            launchWeChatMiniProgram(username: appId, path: path);
            return;
          }
          if (type == 'app') {
            if (path == 'pdd_index') {
              KeTaoFeaturedNavigatorUtils.navigatorRouter(
                  context, KeTaoFeaturedPddHomeIndexPage());
              return;
            }
            if (path == 'pdd_goods') {
              KeTaoFeaturedNavigatorUtils.navigatorRouter(
                  context,
                  KeTaoFeaturedPddGoodsListPage(
                    showAppBar: true,
                    type: pddType,
                    title: name,
                    categoryId: catId,
                  ));
              return;
            }
            if (path == 'category') {
              KeTaoFeaturedGlobalConfig.prefs.setString("cid", cId);
              bus.emit("changeBottomNavigatorBarWithCategoryId", cId);
              return;
            }
            switch (path) {
              case "recharge":
                KeTaoFeaturedNavigatorUtils.navigatorRouter(
                    context, KeTaoFeaturedRechargeListPage());
                break;
            }
            return;
          }
          if (type == 'toast') {
            needShow = false;
            KeTaoFeaturedCommonUtils.showToast("敬请期待");
            needShow = false;
            return;
          }
          if (type == 'link') {
            /*PaletteGenerator generator =
                await PaletteGenerator.fromImageProvider(
                    Image.network("$icon").image);
            KeTaoFeaturedNavigatorUtils.navigatorRouter(
                context,
                KeTaoFeaturedWebViewPage(
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
              KeTaoFeaturedNavigatorUtils.navigatorRouter(
                  context,
                  KeTaoFeaturedWebViewPluginPage(
                    initialUrl: path,
                    showActions: true,
                    title: "优惠加油",
                    appBarBackgroundColor: Colors.white,
                  ));
              return;
              /* KeTaoFeaturedNavigatorUtils.navigatorRouter(context, MyTestApp());
              return;*/
            }
            if (name.contains('游戏') &&
                KeTaoFeaturedGlobalConfig.isHuaweiUnderReview) {
              needShow = false;
              KeTaoFeaturedCommonUtils.showToast("敬请期待");
              return;
            }
            if (path.contains("yangkeduo")) {
              var pddPath = path.replaceAll("https://mobile.yangkeduo.com/",
                  "pinduoduo://com.xunmeng.pinduoduo/");
              if (await canLaunch(pddPath)) {
                await launch(pddPath);
                return;
              } else {
                KeTaoFeaturedNavigatorUtils.navigatorRouter(
                    context,
                    KeTaoFeaturedWebViewPluginPage(
                      initialUrl: "$path",
                      showActions: true,
                      title: "拼多多",
                      appBarBackgroundColor: Colors.white,
                    ));
                return;
              }
            }

            KeTaoFeaturedUtils.launchUrl(path);
            return;
          }
        },
        child: Visibility(
          visible: needShow,
          child: Container(
            width: (ScreenUtil.screenWidth - 40) / 5,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: KeTaoFeaturedMyOctoImage(
                    image: "$icon",
                    width: ScreenUtil().setWidth(155),
                    height: ScreenUtil().setWidth(155),
                  ),
                ),
                new Container(
                  child: new Text(
                    "$name",
                    style: new TextStyle(
                      fontSize: ScreenUtil().setSp(38),
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

  ///实时动态热点轮播
  ///
  Widget _buildHotspot() {
    return GestureDetector(
      onTap: () {
        launchWeChatMiniProgram(username: "gh_7b424680d04a");
      },
      child: Container(
        height: ScreenUtil().setHeight(140),
        margin: EdgeInsets.only(
            left: 16, right: 16, top: ScreenUtil().setHeight(655)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(
                vertical: ScreenUtil().setWidth(32),
                horizontal: ScreenUtil().setWidth(32),
              ),
              child: KeTaoFeaturedMyOctoImage(
                image:
                    "https://alipic.lanhuapp.com/xd9a50a007-6769-44e8-93ed-3e33e099a277",
                width: ScreenUtil().setWidth(236),
                height: ScreenUtil().setHeight(66),
              ),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setWidth(32),
                    ),
                    child: Swiper(
                      key: ValueKey(context),
                      controller: _marqueeSwiperController,
                      loop: true,
                      autoplay: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: Alignment.center,
                          child: Text(
                            "用户￥$index刚刚获得了免单奖励",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xff666666),
                              fontSize: ScreenUtil().setSp(36),
                            ),
                          ),
                        );
                      },
                      itemCount: 6,
                      curve: Curves.linear,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildBannerLayout2() {
    return GestureDetector(
      onTap: () {
        KeTaoFeaturedNavigatorUtils.navigatorRouter(
            context, KeTaoFeaturedTaskOpenDiamondPage());
      },
      child: Image.asset(
        "static/images/home_banner.png",
        height: ScreenUtil().setHeight(623),
        width: ScreenUtil().setWidth(1125),
        fit: BoxFit.fill,
      ),
    );
  }

  ///轮播区域
  Widget buildBannerLayout() {
    return Container(
      height: ScreenUtil().setWidth(466),
      width: double.maxFinite,
//      width: ScreenUtil().setWidth(1125),
      /*  decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),*/
      child: Stack(
        children: [
          ClipPath(
            // 只裁切底部的方法
            clipper: BottomClipper(),
            child: Container(
              decoration: BoxDecoration(gradient: _gradientCorlor),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
              right: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
              top: 6,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(ScreenUtil().setWidth(30)),
              ),
              child: buildSwiper(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSwiper() {
    if (KeTaoFeaturedCommonUtils.isEmpty(bannerList)) {
      return Center(
        child: Loading(
          indicator: BallSpinFadeLoaderIndicator(),
          size: 50.0,
          color: KeTaoFeaturedGlobalConfig.colorPrimary,
        ),
      );
    } else {
      _isLoop = true;
      return Swiper(
        itemCount: KeTaoFeaturedCommonUtils.isEmpty(bannerList)
            ? 0
            : bannerList.length,
        /*itemWidth: ScreenUtil().setWidth(1125),
              itemHeight: ScreenUtil().setHeight(623),
              transformer: ScaleAndFadeTransformer(scale: 0, fade: 0),*/
        //bannerList == null ? 0 : bannerList.length,
        loop: _isLoop,
        autoplay: true,
        duration: 30,
        autoplayDisableOnInteraction: true,
        key: ValueKey(context),
        controller: _swiperController,
//          indicatorLayout: PageIndicatorLayout.COLOR,
        onIndexChanged: (index) async {
          if (!KeTaoFeaturedCommonUtils.isEmpty(bannerColorList)) {
            if (!KeTaoFeaturedCommonUtils.isEmpty(bannerColorList[index]) &&
                bannerColorList.length == bannerList.length) {
              if (mounted) {
                setState(() {
                  _gradientCorlor = LinearGradient(colors: [
                    bannerColorList[index],
                    bannerColorList[index],
                  ]);
                  /*print(
                            "index=$index&&  bannerColorList[index]=${bannerColorList[index]}");*/
                  bannerIndex = index;
                });
              }
              return;
            }
          }
          PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
              Image.network("${bannerList[index].imgPath}").image);
          if (mounted) {
            setState(() {
              bannerIndex = index;
              /*switch (bannerList[index].uri.toString().trim()) {
                      case "upgrade":
                        _gradientCorlor = LinearGradient(colors: [
                          Color(0xFF7E090F),
                          Color(0xFF810A0C),
                          Color(0xFF7D0A0F),
                        ]);

                        break;
                      case "recharge":
                        _gradientCorlor = LinearGradient(colors: [
                          Color(0xFF4A07C6),
                          Color(0xFF4A07C6),
                        ]);
                        break;
                      case "upgrade_diamond":
                        _gradientCorlor = LinearGradient(colors: [
                          Color(0xFFB43733),
                          Color(0xFFB43733),
                          Color(0xFFB43733),
                        ]);
                        break;
                    }*/
              try {
                _gradientCorlor = LinearGradient(colors: [
                  generator.dominantColor.color,
                  generator.dominantColor.color,
                ]);
              } catch (e) {}
              /*_gradientCorlor = LinearGradient(colors: [
                      generator.dominantColor.color,
                      generator.dominantColor.color,
                    ]);*/
            });
          }
        },
        /*pagination: SwiperPagination(
                  builder: DotSwiperPaginationBuilder(
                      //自定义指示器颜色
                      color: Colors.white,
                      size: 8.0,
                      activeColor: KeTaoFeaturedGlobalConfig.taskHeadColor,
                      activeSize: 10.0)),*/
        itemBuilder: (context, index) {
          var bannerData = bannerList[index];
          var item = bannerList[index];
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
            path = !KeTaoFeaturedCommonUtils.isEmpty(item.path)
                ? item.path
                : item.uri;
            subtitle = item.subtitle;
            params = item.params;
            imgPath = item.imgPath;
//      print("iconsubtitle=${icon + name + type + appId + path + subtitle}");
            if (params.contains("&")) {}
            List<String> pList = params.split("&");
            for (var itemString in pList) {
              List<String> itemList = itemString.split("=");
              if (!KeTaoFeaturedCommonUtils.isEmpty(itemList)) {
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
//                          KeTaoFeaturedNavigatorUtils.navigatorRouter(context, KeTaoFeaturedPddHomeIndexPage());
                  return;
                }
                if (path == 'pdd_goods') {
                  KeTaoFeaturedNavigatorUtils.navigatorRouter(
                      context,
                      KeTaoFeaturedPddGoodsListPage(
                        showAppBar: true,
                        type: pddType,
                        title: KeTaoFeaturedCommonUtils.isEmpty(name)
                            ? "精选"
                            : name,
                        categoryId: catId,
                      ));
                  return;
                }
                switch (path) {
                  case "recharge":
                    KeTaoFeaturedNavigatorUtils.navigatorRouter(
                        context, KeTaoFeaturedRechargeListPage());
                    break;
                  case "upgrade":
                    KeTaoFeaturedNavigatorUtils.navigatorRouter(
                        context, KeTaoFeaturedTaskOpenVipPage());
/*
                        KeTaoFeaturedNavigatorUtils.navigatorRouter(
                            context, KeTaoFeaturedTaskOpenDiamondPage());
*/
                    break;
                  case "recharge":
                    KeTaoFeaturedNavigatorUtils.navigatorRouter(
                        context, KeTaoFeaturedRechargeListPage());
                    break;
                  case "goods_list":
                    KeTaoFeaturedNavigatorUtils.navigatorRouter(
                        context, KeTaoFeaturedGoodsListPage());
                    break;
                  case "upgrade_diamond":
                    KeTaoFeaturedNavigatorUtils.navigatorRouter(
                        context,
                        KeTaoFeaturedTaskOpenVipPage(
                          taskType: 2,
                        ));
                    break;
                }
                return;
              }
              if (type == 'toast') {
                KeTaoFeaturedCommonUtils.showToast("敬请期待");
                return;
              }
              if (type == 'link') {
                if (path.toString().startsWith("pinduoduo")) {
                  if (await canLaunch(path)) {
                    await launch(path);
                  } else {
                    if (path.startsWith("pinduoduo://")) {
                      KeTaoFeaturedCommonUtils.showToast("亲，您还未安装拼多多客户端哦！");
                      KeTaoFeaturedNavigatorUtils.navigatorRouter(
                          context,
                          KeTaoFeaturedWebViewPluginPage(
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
                    KeTaoFeaturedNavigatorUtils.navigatorRouter(
                        context,
                        KeTaoFeaturedWebViewPluginPage(
                          initialUrl: "$path",
                          showActions: true,
                          title: "拼多多",
                          appBarBackgroundColor: Colors.white,
                        ));
                    return;
                  }
                }
                KeTaoFeaturedUtils.launchUrl(path);
                return;
              }

              ///
              switch (bannerList[bannerIndex].uri.toString().trim()) {
                case "upgrade":
                  KeTaoFeaturedNavigatorUtils.navigatorRouter(
                      context, KeTaoFeaturedTaskOpenVipPage());
/*
                        KeTaoFeaturedNavigatorUtils.navigatorRouter(
                            context, KeTaoFeaturedTaskOpenDiamondPage());
*/
                  break;
                case "recharge":
                  KeTaoFeaturedNavigatorUtils.navigatorRouter(
                      context, KeTaoFeaturedRechargeListPage());
                  break;
                case "goods_list":
                  KeTaoFeaturedNavigatorUtils.navigatorRouter(
                      context, KeTaoFeaturedGoodsListPage());
                  break;
                case "upgrade_diamond":
                  KeTaoFeaturedNavigatorUtils.navigatorRouter(
                      context,
                      KeTaoFeaturedTaskOpenVipPage(
                        taskType: 2,
                      ));
                  break;
              }
              if (bannerList[bannerIndex].uri.toString().startsWith("http")) {
                KeTaoFeaturedUtils.launchUrl(
                    bannerList[bannerIndex].uri.toString());
                /*bool isImage = false;
                      Response resust = await Dio().get(bannerList[bannerIndex].uri);
                      String contentType = resust.headers['content-type'].toString();
                      if (contentType.startsWith("[image/")) {
                        isImage = true;
                      }
                      if (isImage) {
                        KeTaoFeaturedNavigatorUtils.navigatorRouter(
                            context,
                            KeTaoFeaturedTaskGalleryPage(
                              galleryItems: [bannerList[bannerIndex].uri.toString()],
                            ));
                        return;
                      }
                      */ /*print("contentType=$contentType");
                      print(
                          "contentTypeIsImage=${contentType.startsWith("[image/")}");*/ /*
                      var hColor = KeTaoFeaturedGlobalConfig.taskHeadColor;
                      KeTaoFeaturedNavigatorUtils.navigatorRouter(
                          context,
                          KeTaoFeaturedWebViewPage(
                            initialUrl: bannerList[bannerIndex].uri.toString(),
                            showActions: true,
                            title: "",
                            appBarBackgroundColor: hColor,
                          ));*/
                /*try {
                        PaletteGenerator generator =
                            await PaletteGenerator.fromImageProvider(Image.network(
                                    "${bannerList[bannerIndex].uri.toString()}")
                                .image);
                        hColor = generator.dominantColor.color;
                      } catch (e) {}*/
              }
            },
            child: KeTaoFeaturedMyOctoImage(
              image: bannerData.imgPath,
//              width: ScreenUtil().setWidth(1125),
              placeholderBuilder: (context) => Center(
                child: Loading(
                  indicator: BallSpinFadeLoaderIndicator(),
                  size: 50.0,
                  color: KeTaoFeaturedGlobalConfig.colorPrimary,
                ),
              ),
              placeholder: (context, url) => Center(
                child: Loading(
                  indicator: BallSpinFadeLoaderIndicator(),
                  size: 50.0,
                  color: KeTaoFeaturedGlobalConfig.colorPrimary,
                ),
              ),
              fit: BoxFit.fill,
            ),
          );
        },
      );
    }
  }

  ///邀请好友
  ///
  Widget buildLayoutForInvitingFriends() {
    return SliverToBoxAdapter(
      child: Container(
        height: ScreenUtil().setWidth(158),
        decoration: BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(colors: [
            Color(0xffA10011),
            Color(0xff590600),
          ]),
          borderRadius: BorderRadius.all(
            Radius.circular(
              ScreenUtil().setWidth(30),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTaskWall() {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () {
          /* if (checkUserBind(isTaskWall: true)) {
            */ /* KeTaoFeaturedNavigatorUtils.navigatorRouter(
                context,
                KeTaoFeaturedWebViewPage(
                  initialUrl: HttpManage.getTheMissionWallEntranceUrl(
                      "${KeTaoFeaturedGlobalConfig.getUserInfo().tel}"),
                  showActions: true,
                  title: "任务墙",
                  appBarBackgroundColor: Color(0xFFD72825),
                ));*/ /*

          }*/
          KeTaoFeaturedNavigatorUtils.navigatorRouter(
              context,
              KeTaoFeaturedTaskOpenVipPage(
                taskType: 2,
              ));
//          HttpManage.getTheMissionWallEntrance("13122336666");
        },
        child: Container(
          height: ScreenUtil().setHeight(550),
          margin: EdgeInsets.symmetric(
              horizontal: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
              vertical: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
          alignment: Alignment.center,
          child: KeTaoFeaturedMyOctoImage(
            image:
                'https://alipic.lanhuapp.com/xddcdf45d1-4fd3-47e6-9326-88bb1cfd4edf',
            width: ScreenUtil().setWidth(1061),
            height: ScreenUtil().setHeight(550),
            fit: BoxFit.fill,
          ),
/*
          child: Image.asset(
            'static/images/task_wall.png',
            width: ScreenUtil().setWidth(1061),
            height: ScreenUtil().setHeight(550),
            fit: BoxFit.fill,
          ),
*/
        ),
      ),
    );
  }

  ///任务状态 -2不可领取 -1去开通 0领任务 1待提交 2待审核 3已完成 4被驳回
  Widget buildTaskItemLayout(context, HomeDataTaskListList taskItem, index) {
    var bgColor = KeTaoFeaturedGlobalConfig.taskBtnBgColor;
    var txtColor = KeTaoFeaturedGlobalConfig.taskBtnTxtColor;
    var category = '';
    category = taskItem.category;
    switch (taskItem.taskStatus) {
      case -2:
        bgColor = KeTaoFeaturedGlobalConfig.taskBtnBgGreyColor;
        txtColor = KeTaoFeaturedGlobalConfig.taskBtnTxtGreyColor;
        break;
      case -1:
        break;
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        bgColor = KeTaoFeaturedGlobalConfig.taskBtnBgGreyColor;
        txtColor = KeTaoFeaturedGlobalConfig.taskBtnTxtGreyColor;
        break;
      case 4:
        break;
    }
    return ListTile(
      onTap: () async {
        switch (taskItem.taskStatus) {
          case -2:
            break;
          case -1: //-1去开通
            if (Platform.isIOS) {
              KeTaoFeaturedCommonUtils.showIosPayDialog();
              return;
            }
            var result = await showDialog(
                context: context,
                builder: (context) {
                  return KeTaoFeaturedTaskOpenDiamondDialogPage();
                });
            break;
          case 0: // 领任务
            if (await checkUserBind(
                isTaskWall: !KeTaoFeaturedGlobalConfig.isBindWechat)) {
              switch (category) {
                case "1":
                  var result = await HttpManage.taskReceive(taskItem.id);
                  if (result.status) {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return KeTaoFeaturedTaskDetailPage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  } else {
                    KeTaoFeaturedCommonUtils.showToast(result.errMsg);
                  }
                  break;
                case "2":
                  var result = await HttpManage.taskReceiveOther(taskItem.id);
                  if (result.status) {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return KeTaoFeaturedTaskDetailOtherPage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  } else {
                    KeTaoFeaturedCommonUtils.showToast(result.errMsg);
                  }
                  break;
              }
            }

            break;
          case 1: //待提交
            if (category == "1") {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return KeTaoFeaturedTaskDetailPage(
                  taskId: taskItem.id,
                );
              }));
              _initData();
            } else {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return KeTaoFeaturedTaskDetailOtherPage(
                  taskId: taskItem.id,
                );
              }));
              _initData();
            }

            break;
          case 2: //2待审核
            break;
          case 3: //3已完成
            break;
          case 4: //--4被驳回
            if (category == "1") {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return KeTaoFeaturedTaskDetailPage(
                  taskId: taskItem.id,
                  pageType: 1,
                );
              }));
              _initData();
            } else {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return KeTaoFeaturedTaskDetailOtherPage(
                  taskId: taskItem.id,
                  pageType: 1,
                );
              }));
              _initData();
            }
            break;
        }

        /*if (checkUserBind()) {
          if (index == taskStatus) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return KeTaoFeaturedTaskDetailPage();
            }));
          } else if (index == 2) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return KeTaoFeaturedTaskSubmissionPage();
            }));
          } else {
            var result = await showDialog(
                context: context,
                builder: (context) {
                  return KeTaoFeaturedTaskOpenDiamondDialogPage();
                });
            print('$result');
          }
        }*/
      },
      leading: ClipOval(
        child: KeTaoFeaturedMyOctoImage(
          fit: BoxFit.fill,
          width: ScreenUtil().setWidth(110),
          height: ScreenUtil().setWidth(110),
          image: taskItem.icons,
        ),
/*
        child: Image.asset(
          taskItem,
          fit: BoxFit.fill,
          width: ScreenUtil().setWidth(110),
          height: ScreenUtil().setWidth(110),
        ),
*/
      ),

      /* KeTaoFeaturedMyOctoImage(
        width: 40,
        height: 40,
        image:
        "https://img2020.cnblogs.com/blog/2016690/202009/2016690-20200901173254702-27754128.png",
      ),*/
      title: Text(
        '${taskItem.title}',
        style: TextStyle(fontSize: ScreenUtil().setSp(42)),
      ),
      subtitle: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                width: ScreenUtil().setWidth(48),
                height: ScreenUtil().setHeight(48),
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  "static/images/task_img_star.png",
                  width: ScreenUtil().setWidth(36),
                  height: ScreenUtil().setWidth(36),
                  fit: BoxFit.fill,
                )),
            Text('+${taskItem.sharePrice}元现金奖励',
                style: TextStyle(fontSize: ScreenUtil().setSp(36))),
          ],
        ),
      ),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: bgColor,
            border: Border.all(
                width: 0.5, color: bgColor, style: BorderStyle.solid)),
        child: Text(
          "${taskItem.statusDesc}",
          style: TextStyle(color: txtColor, fontSize: ScreenUtil().setSp(36)),
        ),
      ),
    );
  }

  ///任务状态 -2不可领取 -1去开通 0领任务 1待提交 2待审核 3已完成 4被驳回
  Widget buildTaskItemLayout2(context, HomeDataTaskListList taskItem, index) {
    var bgColor = KeTaoFeaturedGlobalConfig.taskBtnBgColor;
    var txtColor = KeTaoFeaturedGlobalConfig.taskBtnTxtColor;
    var category = '';
    category = taskItem.category;
    switch (taskItem.taskStatus) {
      case -2:
        bgColor = KeTaoFeaturedGlobalConfig.taskBtnBgGreyColor;
        txtColor = KeTaoFeaturedGlobalConfig.taskBtnTxtGreyColor;
        break;
      case -1:
        break;
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        bgColor = KeTaoFeaturedGlobalConfig.taskBtnBgGreyColor;
        txtColor = KeTaoFeaturedGlobalConfig.taskBtnTxtGreyColor;
        break;
      case 4:
        break;
    }
    return ListTile(
      onTap: () async {
        switch (taskItem.taskStatus) {
          case -2:
            break;
          case -1: //-1去开通
            if (Platform.isIOS) {
              KeTaoFeaturedCommonUtils.showIosPayDialog();
              return;
            }
            var result = await showDialog(
                context: context,
                builder: (context) {
                  return KeTaoFeaturedTaskOpenDiamondDialogPage();
                });
            break;
          case 0: // 领任务
            if (await checkUserBind(
                isTaskWall: !KeTaoFeaturedGlobalConfig.isBindWechat)) {
              switch (category) {
                case "1":
                  var result = await HttpManage.taskReceive(taskItem.id);
                  if (result.status) {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return KeTaoFeaturedTaskDetailPage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  } else {
                    KeTaoFeaturedCommonUtils.showToast(result.errMsg);
                  }
                  break;
                case "2":
                  var result = await HttpManage.taskReceiveOther(taskItem.id);
                  if (result.status) {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return KeTaoFeaturedTaskDetailOtherPage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  } else {
                    KeTaoFeaturedCommonUtils.showToast(result.errMsg);
                  }
                  break;
              }
            }

            break;
          case 1: //待提交
            if (category == "1") {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return KeTaoFeaturedTaskDetailPage(
                  taskId: taskItem.id,
                );
              }));
              _initData();
            } else {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return KeTaoFeaturedTaskDetailOtherPage(
                  taskId: taskItem.id,
                );
              }));
              _initData();
            }

            break;
          case 2: //2待审核
            break;
          case 3: //3已完成
            break;
          case 4: //--4被驳回
            if (category == "1") {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return KeTaoFeaturedTaskDetailPage(
                  taskId: taskItem.id,
                  pageType: 1,
                );
              }));
              _initData();
            } else {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return KeTaoFeaturedTaskDetailOtherPage(
                  taskId: taskItem.id,
                  pageType: 1,
                );
              }));
              _initData();
            }
            break;
        }

        /*if (checkUserBind()) {
          if (index == taskStatus) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return KeTaoFeaturedTaskDetailPage();
            }));
          } else if (index == 2) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return KeTaoFeaturedTaskSubmissionPage();
            }));
          } else {
            var result = await showDialog(
                context: context,
                builder: (context) {
                  return KeTaoFeaturedTaskOpenDiamondDialogPage();
                });
            print('$result');
          }
        }*/
      },
      leading: ClipOval(
        child: KeTaoFeaturedMyOctoImage(
          fit: BoxFit.fill,
          width: ScreenUtil().setWidth(110),
          height: ScreenUtil().setWidth(110),
          image: taskItem.icons,
        ),
/*
        child: Image.asset(
          taskItem,
          fit: BoxFit.fill,
          width: ScreenUtil().setWidth(110),
          height: ScreenUtil().setWidth(110),
        ),
*/
      ),

      /* KeTaoFeaturedMyOctoImage(
        width: 40,
        height: 40,
        image:
        "https://img2020.cnblogs.com/blog/2016690/202009/2016690-20200901173254702-27754128.png",
      ),*/
      title: Text(
        '${taskItem.title}',
        style: TextStyle(fontSize: ScreenUtil().setSp(42)),
      ),
      subtitle: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                width: ScreenUtil().setWidth(48),
                height: ScreenUtil().setHeight(48),
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  "static/images/task_img_star.png",
                  width: ScreenUtil().setWidth(36),
                  height: ScreenUtil().setWidth(36),
                  fit: BoxFit.fill,
                )),
            Text('+${taskItem.sharePrice}元现金奖励',
                style: TextStyle(fontSize: ScreenUtil().setSp(36))),
          ],
        ),
      ),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: bgColor,
            border: Border.all(
                width: 0.5, color: bgColor, style: BorderStyle.solid)),
        child: Text(
          "${taskItem.statusDesc}",
          style: TextStyle(color: txtColor, fontSize: ScreenUtil().setSp(36)),
        ),
      ),
    );
  }

  Widget taskCard(context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(
          left: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
          right: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
          top: ScreenUtil().setHeight(655)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  "每日任务",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(48)),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "$taskCompletedNum/$taskTotalNum",
                  style: TextStyle(
                      color: KeTaoFeaturedGlobalConfig.taskBtnTxtGreyColor,
                      fontSize: ScreenUtil().setSp(36)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "完成每日任务可领取更多奖励",
              style: TextStyle(
                  color: KeTaoFeaturedGlobalConfig.taskBtnTxtGreyColor,
                  fontSize: ScreenUtil().setSp(36)),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return buildTaskItemLayout(context, taskList[index], index);
            },
            itemCount: taskList == null ? 0 : taskList.length,
          ),
          SizedBox(
            height: 20,
          ),
//        Container(height: 400,width: 400,color: Colors.red, child: _buildPhotosWidget(post),),

//          post.messageImage != null
//              ? Image.network(
//                  post.messageImage,
//                  fit: BoxFit.cover,
//                )
//              : Container(),
//          post.messageImage != null
//              ? Container()
//              : Divider(
//                  color: Colors.grey.shade300,
//                  height: 8.0,
//                ),
        ],
      ),
    );
  }

  ///2.0版本任务列表
  Widget taskCard2(context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(
          left: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
          right: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
          top: ScreenUtil().setHeight(32)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 48,
            key: dataKey,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            child: Center(
              child: TabBar(
                tabs: _tabValues.map((f) {
                  return Container(
                    width: (ScreenUtil.screenWidth - 80) / 4,
                    child: Text(
                      f,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: ScreenUtil().setSp(38)),
                    ),
                  );
                }).toList(),
                controller: _tabController,
                indicatorColor: Color(0xffF93736),
                indicatorSize: TabBarIndicatorSize.label,
                isScrollable: true,
                labelColor: Color(0xffF93736),
                unselectedLabelColor: Colors.black,
              ),
            ),
          ),
          Container(
            height: _tabBarViewHeight,
            child: TabBarView(
              controller: _tabController,
              children: _tabViews,
            ),
          ),
        ],
      ),
    );
  }

  var _tabBarViewHeight = ScreenUtil().setHeight(330);

  Widget buildTaskListTabView({int taskType}) {
    var taskList;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 16,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return buildTaskItemLayout2(context, taskList[index], index);
            },
            itemCount: taskList == null ? 0 : taskList.length,
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class TaskListTabView extends StatefulWidget {
  int taskType;
  List<HomeDataTaskListList> taskList;
  String userType;

  @override
  _TaskListTabViewState createState() => _TaskListTabViewState();

  TaskListTabView(
      {Key key, @required this.taskList, this.taskType, this.userType})
      : super(key: key);
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _TaskListTabViewState extends State<TaskListTabView>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController _controller;
  String taskCompletedNum = "";
  String taskTotalNum = "";
  int bannerIndex = 0;
  HomeEntity entity;
  List<HomeIconListIconList> bannerList;
  List<HomeDataTaskListList> taskList = List<HomeDataTaskListList>();

  List<HomeDataTaskList> taskListAll;
  String userType;

  ///是否是首个
  ///高佣任务
  bool _isFirstHighCommissionTask = true;

  ///首个高佣任务索引
  int firstHighIndex = -1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: ScrollableState());
    try {
      taskList = widget.taskList;
      userType = widget.userType;
      //print("_initData  widget.taskList=${taskList.length}");
      //print("_initData taskList=${taskList.length}");
      //print("_initData userType=${widget.userType}");
    } catch (e) {
      print("_initData err=$e");
    }

    /*  if (taskList == null || taskList.length <= 0) {
      _initData();
    }*/
    /* bus.on("refreshHomeData", (data) {
      _initData();
    });*/
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ///初始化任务列表数据
  Future _initData() async {
    var result = await HttpManage.getHomeInfo();
    if (mounted) {
      setState(() {
        try {
          bus.emit("taskListChanged", 0);
          entity = result;
          bannerList = entity.data.banner;
          taskListAll = entity.data.taskList;
          userType = entity.data.userLevel;
          taskList = taskListAll[widget.taskType].xList;
          bus.emit("taskListChanged", taskList.length);
        } catch (e) {
          print("_initData err=$e");
        }
        var length = 0;
        /* switch (widget.taskType) {
          case 0: //普通/体验
            for (var taskListItem in taskListAll) {
              if (taskListItem.name == "新人专区" || taskListItem.name == "体验专区") {
                taskList = taskListItem.xList;
                bus.emit("taskListChanged", taskList.length);
                return;
              }
            }
            break;[图片]
          case 1: //vip
            for (var taskListItem in taskListAll) {
              if (taskListItem.name == "VIP专区") {
                taskList = taskListItem.xList;
                bus.emit("taskListChanged", taskList.length);
                return;
              }
            }
            break;
          case 2: //钻石
            for (var taskListItem in taskListAll) {
              if (taskListItem.name == "钻石专区") {
                taskList = taskListItem.xList;
                bus.emit("taskListChanged", taskList.length);
                return;
              }
            }
            break;
        }*/
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildTaskListTabView();
  }

  Widget buildTaskListTabView() {
    ///    组件创建完成的回调通知方法
    ///解决首次数据加载失败问题
    ///
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!KeTaoFeaturedCommonUtils.isEmpty(taskList)) {
        bus.emit("taskListChanged", 0);
        bus.emit("taskListChanged", taskList.length);
        print('taskListChangedtaskList", taskList.length=${taskList.length}');
      } else {
        _initData();
        print(
            "widget.taskType=${widget.taskType} has zero length data && taskList=$taskList");
      }
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return buildTaskItemLayout(context, taskList[index], index);
          },
          itemCount: taskList == null ? 0 : taskList.length,
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  /// 确认账户信息是否绑定手机号以及微信授权
  checkUserBind({bool isTaskWall = false}) async {
    UserInfoData userInfoData = KeTaoFeaturedGlobalConfig.getUserInfo();
    if (KeTaoFeaturedCommonUtils.isEmpty(userInfoData)) {
      print("userInfoData is empty is true");
      var result = await HttpManage.getUserInfo();
      if (result.status) {
        userInfoData = KeTaoFeaturedGlobalConfig.getUserInfo();
      } else {
        KeTaoFeaturedCommonUtils.showToast("${result.errMsg}");
        return false;
      }
    }
    if (!isTaskWall) {
      if (userInfoData.bindThird == 1) {
        KeTaoFeaturedCommonUtils.showToast("请先绑定微信后领取任务");
        return false;
      }
    }

    if (KeTaoFeaturedCommonUtils.isEmpty(userInfoData.tel)) {
      KeTaoFeaturedCommonUtils.showToast("请先绑定手机号后领取任务");
      return false;
    }
    return true;
  }

  ///任务状态 -2不可领取 -1去开通 0领任务 1待提交 2待审核 3已完成 4被驳回
  Widget buildTaskItemLayout(context, HomeDataTaskListList taskItem, index) {
    var bgColor =
        Color(0xffF32E43); // KeTaoFeaturedGlobalConfig.taskBtnBgColor;
    var txtColor = Colors.white; //KeTaoFeaturedGlobalConfig.taskBtnTxtColor;
    var category = '';
    bool _isSimpleTask = taskItem.isHigher == '2';
    bool _isShow = true;
    var _taskIcon = _isSimpleTask
        ? 'https://alipic.lanhuapp.com/xd56dccbf4-9fcf-46e6-84dd-831e424dacac'
        : 'https://alipic.lanhuapp.com/xd68fb6c67-b856-405d-9902-0da1a0b6a56f';
    if (!_isSimpleTask && _isFirstHighCommissionTask) {
      firstHighIndex = index;
      _isFirstHighCommissionTask = false;
    }
    category = taskItem.category;
    if (KeTaoFeaturedGlobalConfig.isHuaweiUnderReview) {
      _isShow = !taskItem.title.contains("代购");
    }
    bool _isNewTask = taskItem.isNew == '1';
    switch (taskItem.taskStatus) {
      case -2:
        bgColor = KeTaoFeaturedGlobalConfig.taskBtnBgGreyColor;
        txtColor = KeTaoFeaturedGlobalConfig.taskBtnTxtGreyColor;
        break;
      case -1:
        break;
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        bgColor = KeTaoFeaturedGlobalConfig.taskBtnBgGreyColor;
        txtColor = KeTaoFeaturedGlobalConfig.taskBtnTxtGreyColor;
        break;
      case 4:
        break;
    }

    return Visibility(
      visible: _isShow,
      child: Column(
        children: [
          Visibility(
            visible: firstHighIndex == index,
            child: Container(
              color: KeTaoFeaturedGlobalConfig.taskNomalHeadColor,
              height: 8,
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              /*      if (true) {
                KeTaoFeaturedNavigatorUtils.navigatorRouter(context, KeTaoFeaturedTaskSharePage());
                return;
              }*/
              switch (taskItem.taskStatus) {
                case -2:
                  break;
                case -1: //-1去开通
                  if (Platform.isIOS) {
                    KeTaoFeaturedCommonUtils.showIosPayDialog();
                    return;
                  }
                  var result = await showDialog(
                      context: context,
                      builder: (context) {
                        return KeTaoFeaturedTaskOpenDiamondDialogPage(
                          taskType: widget.taskType,
                        );
                      });
                  break;
                case 0: // 领任务
                  if (await checkUserBind(
                      isTaskWall: !KeTaoFeaturedGlobalConfig.isBindWechat)) {
                    switch (userType) {
                      case "0": //普通
                        break;
                      case "1": //体验
                        break;
                      case "2": //vip
                        if (widget.taskType != 1) {
                          KeTaoFeaturedCommonUtils.showToast("请到vip专区领取任务");
                          return;
                        }
                        break;
                      case "4": //钻石
                        if (widget.taskType != 2) {
                          KeTaoFeaturedCommonUtils.showToast("请到钻石专区领取任务");
                          return;
                        }
                        break;
                    }
                    switch (category) {
                      case "1":
                        /*if (userType == "0") {
                          KeTaoFeaturedCommonUtils.showToast("您只能领取非朋友圈任务");
                          return;
                        }*/
                        var result = await HttpManage.taskReceive(taskItem.id);
                        if (result.status) {
                          var result = await Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return KeTaoFeaturedTaskDetailPage(
                              taskId: taskItem.id,
                            );
                          }));
                          _initData();
                        } else {
                          KeTaoFeaturedCommonUtils.showToast(result.errMsg);
                        }
                        break;
                      case "2":
                        var result =
                            await HttpManage.taskReceiveOther(taskItem.id);
                        if (result.status) {
                          var result = await Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return KeTaoFeaturedTaskDetailOtherPage(
                              taskId: taskItem.id,
                            );
                          }));
                          _initData();
                        } else {
                          KeTaoFeaturedCommonUtils.showToast(result.errMsg);
                        }
                        break;
                      case "3":
                        var result =
                            await HttpManage.taskReceiveWechat(taskItem.id);
                        if (result.status) {
                          var result = await Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return KeTaoFeaturedTaskSharePage(
                              taskId: taskItem.id,
                            );
                          }));
                          _initData();
                        } else {
                          KeTaoFeaturedCommonUtils.showToast(result.errMsg);
                        }
                        break;
                    }
                  }

                  break;
                case 1: //待提交
                  switch (userType) {
                    case "0": //普通
                      break;
                    case "1": //体验
                      break;
                    case "2": //vip
                      if (widget.taskType != 1) {
                        KeTaoFeaturedCommonUtils.showToast("请到vip专区提交任务");
                        return;
                      }
                      break;
                    case "4": //钻石
                      if (widget.taskType != 2) {
                        KeTaoFeaturedCommonUtils.showToast("请到钻石专区提交任务");
                        return;
                      }
                      break;
                  }
                  if (category == "1") {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return KeTaoFeaturedTaskDetailPage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  } else {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return KeTaoFeaturedTaskDetailOtherPage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  }

                  break;
                case 2: //2待审核
                  switch (category) {
                    case "3":
                      KeTaoFeaturedNavigatorUtils.navigatorRouter(
                          context,
                          KeTaoFeaturedTaskSharePage(
                            taskId: taskItem.id,
                          ));
                      break;
                    case "4": //商品补贴任务
                      KeTaoFeaturedNavigatorUtils.navigatorRouter(
                          context,
                          KeTaoFeaturedTaskDetailOtherPage(
                            taskId: taskItem.id,
                          ));
                      break;
                  }
                  break;
                case 3: //3已完成
                  break;
                case 4: //--4被驳回
                  switch (userType) {
                    case "0": //普通
                      break;
                    case "1": //体验
                      break;
                    case "2": //vip
                      if (widget.taskType != 1) {
                        KeTaoFeaturedCommonUtils.showToast("请到vip专区提交任务");
                        return;
                      }
                      break;
                    case "4": //钻石
                      if (widget.taskType != 2) {
                        KeTaoFeaturedCommonUtils.showToast("请到钻石专区提交任务");
                        return;
                      }
                      break;
                  }
                  if (category == "1") {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return KeTaoFeaturedTaskDetailPage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  } else {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return KeTaoFeaturedTaskDetailOtherPage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  }
                  break;
              }

              /*if (checkUserBind()) {
                            if (index == taskStatus) {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return KeTaoFeaturedTaskDetailPage();
                              }));
                            } else if (index == 2) {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return KeTaoFeaturedTaskSubmissionPage();
                              }));
                            } else {
                              var result = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return KeTaoFeaturedTaskOpenDiamondDialogPage();
                                  });
                              print('$result');
                            }
                          }*/
            },
            child: Container(
              height: ScreenUtil().setHeight(300),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(184),
                    height: ScreenUtil().setHeight(216),
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setWidth(24))),
                      border: Border.all(
                          color: Color(0xffF32E43),
                          width: ScreenUtil().setWidth(2)),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: ScreenUtil().setHeight(141),
                          decoration: BoxDecoration(
                            color: Color(0xffF32E43),
                            borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(ScreenUtil().setHeight(24)),
                                topRight: Radius.circular(
                                    ScreenUtil().setHeight(24))),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "${taskItem.sharePrice}",
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(54),
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                      ScreenUtil().setHeight(24)),
                                  bottomRight: Radius.circular(
                                      ScreenUtil().setHeight(24))),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "奖励(元)",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(30),
                                color: Color(0xffF32E43),
                              ),
                            ),
                          ),
                        ),
                        /* ClipOval(
                              child: KeTaoFeaturedMyOctoImage(
                                fit: BoxFit.fill,
                                width: ScreenUtil().setWidth(110),
                                height: ScreenUtil().setWidth(110),
                                image: taskItem.icons,
                              ),
                            ),*/
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: true,
                              child: Container(
                                child: KeTaoFeaturedMyOctoImage(
                                  image: "$_taskIcon",
                                  width: ScreenUtil().setWidth(70),
                                  height: ScreenUtil().setHeight(50),
                                ),
                                margin: EdgeInsets.only(
                                  right: ScreenUtil().setWidth(8),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  '${taskItem.title}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(42)),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Text('${taskItem.subtitle}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(32),
                                        color: Color(0xff999999))),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: ScreenUtil().setWidth(48),
                                height: ScreenUtil().setHeight(48),
                                alignment: Alignment.centerLeft,
                                child: _isNewTask
                                    ? KeTaoFeaturedMyOctoImage(
                                        image:
                                            "https://alipic.lanhuapp.com/xdaaa3829c-8973-49d5-ae2a-715583553432",
                                        width: ScreenUtil().setWidth(30),
                                        height: ScreenUtil().setHeight(54),
                                      )
                                    : Icon(
                                        CupertinoIcons.news_solid,
                                        size: ScreenUtil().setWidth(36),
                                        color: Color(0XFF666666),
                                      ),
                              ),
/*
                                  child: Image.asset(
                                    "static/images/task_img_star.png",
                                    width: ScreenUtil().setWidth(36),
                                    height: ScreenUtil().setWidth(36),
                                    fit: BoxFit.fill,
                                  )),
*/
                              Text('剩余任务：${taskItem.num}条',
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(32),
                                      color: Color(0xff666666))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          color: bgColor,
                          border: Border.all(
                              width: 0.5,
                              color: bgColor,
                              style: BorderStyle.solid)),
                      child: Text(
                        "${taskItem.statusDesc}",
                        style: TextStyle(
                            color: txtColor, fontSize: ScreenUtil().setSp(36)),
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

  @override
  bool get wantKeepAlive => true;
}
