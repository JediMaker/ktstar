import 'dart:io';

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
import 'package:star/ktxx_global_config.dart';
import 'package:star/ktxxhttp/ktxx_http_manage.dart';
import 'package:star/ktxxmodels/ktxx_home_entity.dart';
import 'package:star/ktxxmodels/ktxx_home_goods_list_entity.dart';
import 'package:star/ktxxmodels/ktxx_home_icon_list_entity.dart';
import 'package:star/ktxxmodels/ktxx_home_pdd_category_entity.dart';
import 'package:star/ktxxmodels/ktxx_pdd_goods_list_entity.dart';
import 'package:star/ktxxmodels/ktxx_pdd_home_entity.dart';
import 'package:star/ktxxpages/ktxxgoods/ktxx_goods_detail.dart';
import 'package:star/ktxxpages/ktxxgoods/ktxx_goods_list.dart';
import 'package:star/ktxxpages/ktxxgoods/ktxxpdd/ktxx_pdd_goods_detail.dart';
import 'package:star/ktxxpages/ktxxgoods/ktxxpdd/ktxx_pdd_goods_list.dart';
import 'package:star/ktxxpages/ktxxgoods/ktxxpdd/ktxx_pdd_home.dart';
import 'package:star/ktxxpages/ktxxlogin/ktxx_login.dart';
import 'package:star/ktxxpages/ktxxrecharge/ktxx_recharge_list.dart';
import 'package:star/ktxxpages/ktxxshareholders/ktxx_micro_equity.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_invitation_poster.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_hall.dart';
import 'package:star/ktxxpages/ktxxwidget/ktxx_price_text.dart';
import 'package:star/ktxxpages/ktxxwidget/ktxx_dashed_rect.dart';
import 'package:star/ktxxpages/ktxxwidget/ktxx_my_webview_plugin.dart';
import 'package:star/ktxxutils/ktxx_common_utils.dart';
import 'package:star/ktxxutils/ktxx_navigator_utils.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:star/ktxxutils/ktxx_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:star/ktxxbus/kt_my_event_bus.dart';

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
class KeTaoFeaturedHomeTabPage extends StatefulWidget {
  PddHomeData pddHomeData;
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;

  @override
  _KeTaoFeaturedHomeTabPageState createState() =>
      _KeTaoFeaturedHomeTabPageState();

  KeTaoFeaturedHomeTabPage({Key key, this.pddHomeData}) : super(key: key);
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _KeTaoFeaturedHomeTabPageState extends State<KeTaoFeaturedHomeTabPage>
    with AutomaticKeepAliveClientMixin {
  bool isFirstLoading = true;
  List<HomeIconListIconList> _banner;
  List<HomeIconListIconList> _ads;
  HomeIconListIconList _buyTop;
  HomeIconListIconList _buyLeft;
  HomeIconListIconList _buyRight;
  int page = 1;
  EasyRefreshController _refreshController;

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

//    Container(
//height: 6.0,
//width: 6.0,
//decoration: BoxDecoration(
//color: furnitureCateDisableColor,
//shape: BoxShape.circle,
//),
//),
//SizedBox(
//width: 5.0,
//),
//Container(
//height: 5.0,
//width: 20.0,
//decoration: BoxDecoration(
//color: Colors.blue[700],
//borderRadius: BorderRadius.circular(10.0)),
//),
  ///当前用户等级 0普通用户 1体验用户 2VIP用户 3代理 4钻石用户
  var userType;
  var _tabIndexBeforeRefresh = 0;
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
  var iconUrlList = [
    'https://alipic.lanhuapp.com/xdc181602b-826d-4828-8d6d-94e9c86f26ed', //星选
    'https://alipic.lanhuapp.com/xd4f5a9fd6-ee97-4394-96c3-ff4965597f3a', //话费
    'https://alipic.lanhuapp.com/xd119b664f-7ed4-482a-9a6b-df50e4131cf8', //加油
    'https://alipic.lanhuapp.com/xd248cdbbe-5bf3-4d20-ba6b-bc15cf5ac126', //美团
    'https://alipic.lanhuapp.com/xd3231e35d-92b3-4c46-9ce9-16057e128dca', //饿了
    'https://alipic.lanhuapp.com/xdc05ad33f-5c80-475a-a395-3724ef148b6d', //食品
    'https://alipic.lanhuapp.com/xdd1719150-91de-4acc-a03f-d2383cb1b33f', //百货
    'https://alipic.lanhuapp.com/xded1f6a08-e9c3-4e61-a8fd-662807c190b2', //美妆
    'https://alipic.lanhuapp.com/xdfc53f58b-9934-42c6-9750-3335c149bceb', //母婴
    'https://alipic.lanhuapp.com/xd487dbe14-b368-4d68-a5b6-868db055b792', //更多
  ];
  var iconNameList = [
    '拼多多', //星选
    '话费中心', //话费
    '邀请好友', //邀请好友
    '日用百货', //日用百货
    '办公文具', //办公文具
    '食品酒饮', //食品
    '果品生鲜', //果品生鲜
    '个护清洁', //个护清洁
    '母婴玩具', //母婴
    '更多优惠', //更多
  ];

  var _tabs;
  int _selectedTabIndex = 0;
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;

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

  Future _initPddGoodsListData() async {
    var result2 = await KeTaoFeaturedHttpManage.getGoodsList(
        cId: "", type: "", page: page, pageSize: 20, firstId: "");
//    var result2 = await KeTaoFeaturedHttpManage.getPddGoodsList(page,
//        listId: listId, categoryId: -1);
    if (result2.status) {
      if (mounted) {
        setState(() {
//          listId = result2.data.listId;
          if (page == 1) {
            //下拉刷新
            pddGoodsList = result2.data.xList;
            _refreshController.resetLoadState();
          } else {
            //加载更多
            if (result2 == null ||
                result2.data == null ||
                result2.data.xList == null ||
                result2.data.xList.length == 0) {
              _refreshController.finishLoad(noMore: true);
            } else {
              pddGoodsList += result2.data.xList;
//              _refreshController.finishLoad(noMore: true);
            }
          }
          isFirstLoading = false;
        });
      }
    } else {
      KeTaoFeaturedCommonUtils.showToast(result2.errMsg);
    }
  }

  Future _initData({bool isRefresh = false}) async {
    var categoryResult =
        await KeTaoFeaturedHttpManage.getHomePagePddProductCategory();
    try {
      if (categoryResult.status) {
        if (mounted) {
          setState(() {
            cats = categoryResult.data.cats;
          });
        }
      }
    } catch (e) {}
    var result = await KeTaoFeaturedHttpManage.getHomeInfo();
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
//        initBannerListColor();
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
    /*  if (bannerList.length > 1) {
      _swiperController.startAutoplay();
    } else {
      _swiperController.stopAutoplay();
    }*/
  }

  @override
  void initState() {
    super.initState();
    _initCacheHomeData();
    _initData();
    _initPddGoodsListData();
    _refreshController = EasyRefreshController();
    try {
//      iconList = widget.pddHomeData.tools;
      _banner = widget.pddHomeData.banner;
      _ads = widget.pddHomeData.ads;

      if (!KeTaoFeaturedCommonUtils.isEmpty(_ads)) {
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

  _initCacheHomeData() {
    var data = KeTaoFeaturedGlobalConfig.getHomeInfo();
    if (KeTaoFeaturedCommonUtils.isEmpty(data)) {
      return;
    }
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
  void didUpdateWidget(KeTaoFeaturedHomeTabPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!KeTaoFeaturedCommonUtils.isEmpty(pddGoodsList)) {
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

          page = 1;
          _refreshController.resetLoadState();
          _initData();
          _initPddGoodsListData();
        },
        onLoad: () {
          page++;
          _initPddGoodsListData();
        },
        topBouncing: false,
        bottomBouncing: false,
        slivers: <Widget>[
//          buildBannerContainer(),
//          buildItemsLayout(),
          itemsLayout(),
          buildAdRowContainer(),
          buildGoodsListSliverToBoxAdapter(context),
//          buildBuyToday(),
          buildRowHot(),
          buildProductList(),
        ],
      ),
    );
  }

  ///拼多多专区首页轮播
  Widget buildSwiper() {
    return Visibility(
      visible: !KeTaoFeaturedCommonUtils.isEmpty(_banner),
      child: new Container(
        margin: EdgeInsets.only(
            top: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
            bottom: 5.0,
            left: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
            right: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
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
//                          NavigatorUtils.navigatorRouter(context, PddHomeIndexPage());
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
                              KeTaoFeaturedCommonUtils.showToast(
                                  "亲，您还未安装拼多多客户端哦！");
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
                          var pddPath = path.replaceAll(
                              "https://mobile.yangkeduo.com/",
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
                    child: new ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        child: CachedNetworkImage(
                          imageUrl: "${item.imgPath}",
                          placeholder: (context, url) => Center(
                            child: Loading(
                              indicator: BallSpinFadeLoaderIndicator(),
                              size: 50.0,
                              color: KeTaoFeaturedGlobalConfig.colorPrimary,
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
                itemCount: KeTaoFeaturedCommonUtils.isEmpty(_banner)
                    ? 0
                    : _banner.length,
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

  /* List<KeTaoFeaturedHomeIconListIconList> iconList =
      List<KeTaoFeaturedHomeIconListIconList>();*/

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
          left: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
          right: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
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
          runSpacing: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
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

  /*Widget iconItem(Color _itemsTextColor, {KeTaoFeaturedHomeIconListIconList item}) {
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
      path = !KeTaoFeaturedCommonUtils.isEmpty(item.path) ? item.path : item.uri;
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
                KeTaoFeaturedNavigatorUtils.navigatorRouter(context, KeTaoFeaturedRechargeListPage());
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
  }*/

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
          top: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
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
            return iconItem(_itemsTextColor, item: item, index: index);
          }).toList(),
        ),
      ),
    );
  }

  Widget iconItem(Color _itemsTextColor,
      {HomeIconListIconList item, int index}) {
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
//      icon = item.icon;
      icon = iconUrlList[index];
//      name = item.name;
      name = iconNameList[index];
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
          GlobalConfig.isHuaweiUnderReview) {
        needShow = false;
      }
      if ((name.contains('游戏') ||
              name.contains('赚钱') ||
              name.contains('会员') ) &&
          GlobalConfig.isHuaweiUnderReview) {
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
          KeTaoFeaturedGlobalConfig.prefs.getBool("isIosUnderReview");
    }

    return new InkWell(
        onTap: () async {
          /// 判断功能是否需要登录
          if (needLogin && !name.contains('百货')) {
            KeTaoFeaturedCommonUtils.showToast("未获取到登录信息，，请登录！");
            KeTaoFeaturedNavigatorUtils.navigatorRouter(
                context, KeTaoFeaturedLoginPage());
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
              path = 'https://s.click.ele.me/Je507ru';
              KeTaoFeaturedUtils.launchUrl(path);
              return;
            }
          }
          if (name.contains('邀请')) {
            KeTaoFeaturedNavigatorUtils.navigatorRouter(
                context, KeTaoFeaturedInvitationPosterPage());
            return;
          }
          if (name.contains('百货')) {
            KeTaoFeaturedGlobalConfig.prefs.setString("cid", "1");
            bus.emit("changeBottomNavigatorBarWithCategoryId", cId);
            return;
          }
          if (name.contains('办公')) {
            KeTaoFeaturedGlobalConfig.prefs.setString("cid", "98");
            bus.emit("changeBottomNavigatorBarWithCategoryId", cId);
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
//              _tabController.animateTo(index);
//              Scrollable.ensureVisible(dataKey.currentContext);
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
              KeTaoFeaturedNavigatorUtils.navigatorRouter(
                  context,
                  KeTaoFeaturedWebViewPluginPage(
                    initialUrl: path,
                    showActions: true,
                    title: "优惠加油",
                    appBarBackgroundColor: Colors.white,
                  ));
              return;
              /* NavigatorUtils.navigatorRouter(context, MyTestApp());
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
                  child: CachedNetworkImage(
                    imageUrl: "$icon",
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

  var adUrlList = [
    "https://alipic.lanhuapp.com/xda7e5cbd6-fb3d-42d6-a253-ca2de34919c8",
    "https://alipic.lanhuapp.com/xd7be0aa76-3a81-45a3-bc1b-9fdb973d8475",
  ];

  ///广告占位
  Widget buildAdRowContainer() {
    return SliverToBoxAdapter(
      child: Container(
//        padding: EdgeInsets.all( KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setWidth(28))),
            border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                color: Colors.white,
                width: 0.5)),
        margin: EdgeInsets.only(
            top: ScreenUtil().setWidth(30),
            left: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
            right: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
        child: Column(
          children: [
            Row(
              children: List.generate(
                  KeTaoFeaturedCommonUtils.isEmpty(adList) ? 0 : adList.length,
                  (index) => buildAdWidget(adList[index], index)),
            ),
            buildApplyForMicroShareholders(),
          ],
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
      icon = adUrlList[index];
//      icon = item.icon;
      name = item.name;
      type = item.type;
      appId = item.appId;
      path =
          !KeTaoFeaturedCommonUtils.isEmpty(item.path) ? item.path : item.uri;
      subtitle = item.subtitle;
      params = item.params;
//      imgPath = item.imgPath;
      imgPath = adUrlList[index];
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(
                    ScreenUtil().setWidth(30),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        ScreenUtil().setWidth(30),
                      ),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: "$imgPath",
                      fit: BoxFit.fitWidth,
                      width: ScreenUtil().setWidth(450),
                      height: ScreenUtil().setWidth(324),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: index % 2 == 0,
                child: Container(
                  width: ScreenUtil().setWidth(1),
                  color: Color(0xffd1d1d1),
                  height: ScreenUtil().setWidth(324),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///申请微股东
  Widget buildApplyForMicroShareholders() {
    return Stack(
//        alignment: Alignment.centerLeft,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            KeTaoFeaturedNavigatorUtils.navigatorRouter(
                context, KeTaoFeaturedMicroShareHolderEquityPage());
          },
          child: Container(
            /*margin: EdgeInsets.only(
                left: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
                right: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
                top: 10),*/
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(200),
              right: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
            ),
            height: ScreenUtil().setWidth(200),
            decoration: BoxDecoration(
//                            color: Colors.white,
                /*  gradient: LinearGradient(colors: [
                  Color(0xffA10011),
                  Color(0xff590600),
                ]),*/
                image: DecorationImage(
                  image: Image.network(
                    "https://alipic.lanhuapp.com/xd7924a807-acda-4816-8208-214c25d2947d",
                    fit: BoxFit.fill,
                  ).image,
                ),
                borderRadius: BorderRadius.only(
//                  topLeft: Radius.circular(ScreenUtil().setWidth(30)),
//                  topRight: Radius.circular(ScreenUtil().setWidth(30)),
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
                        fontSize: ScreenUtil().setSp(48),
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
                          Color(0xffFF6E6D),
                          Color(0xffFF4344),
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
                        child: CachedNetworkImage(
                          imageUrl:
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
          width: ScreenUtil().setWidth(177),
          height: ScreenUtil().setWidth(177),
          margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(10),
              right: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
              top: ScreenUtil().setWidth(15)),
          child: CachedNetworkImage(
            imageUrl:
                "https://alipic.lanhuapp.com/xdf98219dc-f1ae-4cf6-8b27-db8e78247175",
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }

  ///自营消费补贴商品列表
  Widget buildGoodsListSliverToBoxAdapter(BuildContext context) {
    return SliverToBoxAdapter(
        child: Visibility(
      visible: goodsList.length > 0,
      child: Container(
//        height: ScreenUtil().setWidth(664),
        margin: EdgeInsets.only(
            top: ScreenUtil().setHeight(30),
            left: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
            right: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
        /* padding: EdgeInsets.all(
          ScreenUtil().setWidth(32),
        ),*/
        decoration: BoxDecoration(
//            color: Colors.white,
            /* gradient: LinearGradient(colors: [
                  Color(0xffE7665C),
                  Color(0xffD54035),
                ]),*/
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
                        context, KeTaoFeaturedGoodsListPage());
                  },
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(2),
                                ),
                                width: ScreenUtil().setWidth(57),
                                height: ScreenUtil().setWidth(57),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "https://alipic.lanhuapp.com/xde80ed39f-fdfb-4336-8bf7-fab615389e33",
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(15),
                                ),
                                child: Text(
                                  '今日爆款',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(48),
                                    color: Color(0xff222222),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
//                          width: ScreenUtil().setWidth(162),
//                          height: ScreenUtil().setWidth(63),
                          decoration: BoxDecoration(
                              /*gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xffFFEDD8),
                                  Color(0xffFEC7B7),
                                ]),*/
//                            border: Border.all(
//                              color: Color(0xffF8A699),
//                              width: ScreenUtil().setWidth(3),
//                            ),
                              /*borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().setWidth(32)),
                            ),*/
                              ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "查看全部 ",
                                style: TextStyle(
                                  color: Color(0xff666666),
//                                  fontWeight: FontWeight.w600,
                                  fontSize: ScreenUtil().setSp(30),
                                ),
                              ),
                              CachedNetworkImage(
                                imageUrl:
                                    "https://alipic.lanhuapp.com/xd8fc49915-7ca7-4e3c-b902-c8bf94e4683d",
                                fit: BoxFit.fill,
                                width: ScreenUtil().setWidth(12),
                                height: ScreenUtil().setWidth(21),
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
                    top: ScreenUtil().setWidth(110),
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
                        return productItem(item: item, index: index);
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

  var _priceColor = const Color(0xffCE0100);

  Widget productItem({HomeGoodsListGoodsList item, int index}) {
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
          width: ScreenUtil().setWidth(397),
          margin: EdgeInsets.only(
            left: index == 0 ? 0 : ScreenUtil().setWidth(30),
          ),
//          margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
          constraints: BoxConstraints(),
          decoration: BoxDecoration(
//            color: Color(0xffFee2cd),
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(20)),
          ),
          child: Padding(
//                  padding: const EdgeInsets.only(left: 4,right: 4,top: 4,bottom: 4),
            padding: EdgeInsets.all(ScreenUtil().setWidth(0)),
//            child: InkWell(
//              splashColor: Colors.yellow,

//        onDoubleTap: () => showSnackBar(),
            child: Container(
              width: ScreenUtil().setWidth(397),
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
                      child: CachedNetworkImage(
                        fadeInDuration: Duration(milliseconds: 0),
                        fadeOutDuration: Duration(milliseconds: 0),
                        height: ScreenUtil().setWidth(397),
                        width: ScreenUtil().setWidth(397),
//                        fit: BoxFit.fill,
                        imageUrl: "$goodsImg",
                      ),
                    ),
                  ),

//                          SizedBox(
//                            height: 10,
//                          ),
                  Visibility(
                    visible: true,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(20),
                        vertical: ScreenUtil().setHeight(16),
                      ),
                      child: Text(
                        "$goodsName",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(38),
                          color: Color(0xff222222),
                        ),
                      ),
                    ),
                  ),
                  Container(
//                    margin: EdgeInsets.only(top: topMargin),
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
                        Visibility(
                          visible: false,
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
                                /*Container(
                                  margin: EdgeInsets.symmetric(horizontal: 2),
                                  child: Text(
                                    "${couponAmount.toString()}元",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(32),
                                    ),
                                  ),
                                ),*/
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: false,
                    child: Container(
                      height: ScreenUtil().setWidth(55),
                      margin:
                          EdgeInsets.only(top: topMargin, left: 4, right: 4),
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
                                  child: KeTaoFeaturedPriceText(
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
                                CachedNetworkImage(
                                  fadeInDuration: Duration(milliseconds: 0),
                                  fadeOutDuration: Duration(milliseconds: 0),
                                  fit: BoxFit.fitWidth,
                                  height: ScreenUtil().setWidth(26),
                                  width: ScreenUtil().setWidth(26),
                                  imageUrl:
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

  ///精选热销商品模块
  Widget buildRowHot() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((content, index) {
        return GestureDetector(
          onTap: () {
            /*KeTaoFeaturedNavigatorUtils.navigatorRouter(
                context,
                KeTaoFeaturedPddGoodsListPage(
                  categoryId: "-1",
                  showAppBar: true,
                  title: '精选',
                ));*/
          },
          child: Container(
            padding: EdgeInsets.only(
                left: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
                right: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
            margin: EdgeInsets.only(
                bottom: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
                top: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: ScreenUtil().setWidth(9),
                    height: ScreenUtil().setWidth(9),
                    child: CircleAvatar(backgroundColor: Color(0xFFEE262B))),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: ScreenUtil().setWidth(15),
                  height: ScreenUtil().setWidth(15),
                  child: CircleAvatar(backgroundColor: Color(0xFFEE262B)),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: ScreenUtil().setWidth(19),
                  height: ScreenUtil().setWidth(19),
                  child: CircleAvatar(backgroundColor: Color(0xFFEE262B)),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "精选好物",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(48),
                    color: Color(0xff222222),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: ScreenUtil().setWidth(19),
                  height: ScreenUtil().setWidth(19),
                  child: CircleAvatar(backgroundColor: Color(0xFFEE262B)),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: ScreenUtil().setWidth(15),
                  height: ScreenUtil().setWidth(15),
                  child: CircleAvatar(backgroundColor: Color(0xFFEE262B)),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                    width: ScreenUtil().setWidth(9),
                    height: ScreenUtil().setWidth(9),
                    child: CircleAvatar(backgroundColor: Color(0xFFEE262B))),
                /*CachedNetworkImage(
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
                ),*/
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
        ],
      ), //
    );
  }

/*
  Widget buildAdRowContainer() {
    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
        left: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
        right: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
      ),
      child: Row(
        children: [
          buildBuyLeftWidget(),
          buildBuyRightWidget(),
        ],
      ),
    );
  }
*/

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
      path =
          !KeTaoFeaturedCommonUtils.isEmpty(item.path) ? item.path : item.uri;
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
                    color: KeTaoFeaturedGlobalConfig.colorPrimary,
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
      path =
          !KeTaoFeaturedCommonUtils.isEmpty(item.path) ? item.path : item.uri;
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
      path =
          !KeTaoFeaturedCommonUtils.isEmpty(item.path) ? item.path : item.uri;
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
//                          NavigatorUtils.navigatorRouter(context, PddHomeIndexPage());
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
                  color: KeTaoFeaturedGlobalConfig.colorPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<HomeGoodsListGoodsList> pddGoodsList = List<HomeGoodsListGoodsList>();
  var listId;

  ///热销商品
  Widget buildProductList() {
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(
            horizontal: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
          ),
//          height: double.infinity,
          child: new StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            itemCount: KeTaoFeaturedCommonUtils.isEmpty(pddGoodsList)
                ? 0
                : pddGoodsList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              HomeGoodsListGoodsList item;
              try {
                item = pddGoodsList[index];
              } catch (e) {}
              return productItem3(item: item);
            },
            staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
            mainAxisSpacing: ScreenUtil().setWidth(20),
            crossAxisSpacing: ScreenUtil().setWidth(20),
          ),
        ),
      ),
    );
  }

  Widget productItem3({HomeGoodsListGoodsList item}) {
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
            KeTaoFeaturedGoodsDetailPage(
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

//  var _priceColor = const Color(0xffF93736);

  /* Widget productItem2({PddGoodsListDataList item}) {
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
      */ /*  if (goodsName.length < 8) {
        topMargin = ScreenUtil().setHeight(70);
      } else {
        topMargin = ScreenUtil().setHeight(10);
      }*/ /*
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
          */ /*constraints: BoxConstraints(
            minHeight: ScreenUtil().setHeight(560),
          ),*/ /*
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
                      */ /*WidgetSpan(
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
                      )),*/ /*
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
                      KeTaoFeaturedPriceText(
                        text: '$_discountPrice',
                        textColor: _priceColor,
                        fontSize: ScreenUtil().setSp(32),
                        fontBigSize: ScreenUtil().setSp(42),
//                          '27.5',
                        */ /*style: TextStyle(
                          fontSize: ScreenUtil().setSp(42),
                          color: _priceColor,
                          fontWeight: FontWeight.bold,
                        ),*/ /*
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
                        visible:
                            !KeTaoFeaturedCommonUtils.isEmpty(couponAmount),
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
  }*/
  Widget productItem2({HomeGoodsListGoodsList item}) {
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
            KeTaoFeaturedGoodsDetailPage(
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
