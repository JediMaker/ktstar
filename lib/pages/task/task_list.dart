import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluwx/fluwx.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/indicator/ball_grid_pulse_indicator.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/indicator/ball_scale_indicator.dart';
import 'package:loading/indicator/ball_scale_multiple_indicator.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/indicator/line_scale_indicator.dart';
import 'package:loading/indicator/line_scale_party_indicator.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
import 'package:loading/indicator/pacman_indicator.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:star/bus/my_event_bus.dart';
import 'package:star/global_config.dart';
import 'package:star/http/http.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/home_entity.dart';
import 'package:star/models/home_goods_list_entity.dart';
import 'package:star/models/home_icon_list_entity.dart';
import 'package:star/models/user_info_entity.dart';
import 'package:star/pages/goods/category/classify.dart';
import 'package:star/pages/goods/goods_detail.dart';
import 'package:star/pages/goods/goods_list.dart';
import 'package:star/pages/goods/pdd/pdd_goods_list.dart';
import 'file:///E:/devDemoCode/star/lib/pages/goods/pdd/pdd_home.dart';
import 'package:star/pages/recharge/recharge_list.dart';
import 'package:star/pages/search/search_page.dart';
import 'package:star/pages/shareholders/micro_equity.dart';
import 'package:star/pages/task/invitation_poster.dart';
import 'package:star/pages/task/task_detail.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:star/pages/task/task_detail_other.dart';
import 'package:star/pages/task/task_gallery.dart';
import 'package:star/pages/task/task_hall.dart';
import 'package:star/pages/task/task_message.dart';
import 'package:star/pages/task/task_open_diamond.dart';
import 'package:star/pages/task/task_open_diamond_dialog.dart';
import 'package:star/pages/task/task_open_vip.dart';
import 'package:star/pages/task/task_share.dart';
import 'package:star/pages/task/task_submission.dart';
import 'package:star/pages/widget/PriceText.dart';
import 'package:star/pages/widget/my_webview.dart';
import 'package:star/pages/goods/home_goods_list.dart';
import 'package:star/pages/widget/my_webview_plugin.dart';
import 'package:star/pages/widget/persistent_header_builder.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading/loading.dart';
import 'package:star/utils/utils.dart';
import 'package:star/pages/widget/round_tab_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:star/models/home_pdd_category_entity.dart';
import 'package:star/pages/widget/my_tab.dart';

class TaskListPage extends StatefulWidget {
  TaskListPage({Key key}) : super(key: key);
  final String title = "首页";

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage>
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

//分类页签
  List<Widget> buildTabs() {
    List<Widget> tabs = <Widget>[];
    if (!CommonUtils.isEmpty(cats)) {
      for (var index = 0; index < cats.length; index++) {
        var classify = cats[index];
        tabs.add(Container(
          height: 36,
          child: Tab(
            iconMargin: EdgeInsets.all(0),
            child: Text(
              "${classify.catName}",
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(42),
                  fontWeight: FontWeight.bold,
                  color: index == _selectedTabIndex
                      ? Color(0xffCE0100)
                      : Color(0xff222222)),
            ),
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
    _initData();
    _swiperController = new SwiperController();
    _marqueeSwiperController = SwiperController();
    _marqueeSwiperController.startAutoplay();

//    try {
//      userType = GlobalConfig.getUserInfo().type;
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
    });
    super.initState();
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
        delegate: PersistentHeaderBuilder(
            max: 60,
            min: 48,
            builder: (ctx, offset) => Container(
                  alignment: Alignment.center,
                  color: Color(0xFFFAFAFA),
//                  height: 26,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: TabBar(
                    labelColor: Color(0xff222222),
                    controller: this._pddTabController,
                    indicatorColor: Color(0xffCE0100),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 2,
                    isScrollable: true,
                    indicator: RoundUnderlineTabIndicator(
                        borderSide: BorderSide(
                      width: 0,
                      color: Colors.white,
                    )),
                    tabs: _tabs,
                    onTap: (index) {
                      setState(() {
                        if (mounted) {
                          setState(() {
                            _selectedTabIndex = _pddTabController.index;
                            _tabs = buildTabs();
                            pddcategoryTabsView = buildPddCategoryTabBar();
                            bus.emit("changePddListViewData",
                                cats[_selectedTabIndex].catId);
                          });
                        }
                      });
                    },
                  ),
                )));
  }

  Future _initData({bool isRefresh = false}) async {
    var categoryResult = await HttpManage.getHomePagePddProductCategory();
    try {
      if (categoryResult.status) {
        if (mounted) {
          setState(() {
            cats = categoryResult.data.cats;
            initPddTabbar();
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
    if (bannerList.length > 1) {
      _swiperController.startAutoplay();
    }
  }

  ///
  /// 确认账户信息是否绑定手机号以及微信授权
  static checkUserBind({bool isTaskWall = false}) async {
    UserInfoData userInfoData = GlobalConfig.getUserInfo();
    if (CommonUtils.isEmpty(userInfoData)) {
      print("userInfoData is empty is true");
      var result = await HttpManage.getUserInfo();
      if (result.status) {
        userInfoData = GlobalConfig.getUserInfo();
      } else {
        CommonUtils.showToast("${result.errMsg}");
        return false;
      }
    }
    if (!isTaskWall) {
      if (userInfoData.bindThird == 1) {
        CommonUtils.showToast("请先绑定微信后领取任务");
        return false;
      }
    }

    if (CommonUtils.isEmpty(userInfoData.tel)) {
      CommonUtils.showToast("请先绑定手机号后领取任务");
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
    _isLoop = false;
    _isMarqueeLoop = false;
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

  Widget buildSearchBarLayout() {
    return Container(
      height: 50,
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                NavigatorUtils.navigatorRouter(context, SearchGoodsPage());
              },
              child: Container(
                height: ScreenUtil().setWidth(100),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: Colors.white,
                ),
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      width: ScreenUtil().setWidth(48),
                      height: ScreenUtil().setWidth(48),
                      imageUrl:
                          "https://alipic.lanhuapp.com/xd8f3e4512-742b-425a-8660-1feddac4e231",
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        "搜索你想要的吧",
                        style: TextStyle(
                          color: Color(0xff666666),
                          fontSize: ScreenUtil().setSp(42),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                NavigatorUtils.navigatorRouter(context, TaskMessagePage());
              },
              child: CachedNetworkImage(
                width: ScreenUtil().setWidth(78),
                height: ScreenUtil().setWidth(78),
                imageUrl:
                    "https://alipic.lanhuapp.com/xd63f13c86-a6db-4057-a97c-86aa31c9f283",
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///广告占位
  Widget buildAdRowContainer() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 8, left: 16, right: 16),
        child: Row(
          children: List.generate(
              CommonUtils.isEmpty(adList) ? 0 : adList.length,
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
          ///
          print(
              "type=$type&&name=$name&&icon=$icon&&path=$path&&catId=$catId&&pddType=$pddType&&");
          if (type == 'webapp') {
            launchWeChatMiniProgram(username: appId, path: path);
            return;
          }
          if (type == 'app') {
            if (path == 'pdd_index') {
              NavigatorUtils.navigatorRouter(context, PddHomeIndexPage());
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
            alignment:
                index % 2 == 0 ? Alignment.centerLeft : Alignment.centerRight,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  ScreenUtil().setWidth(30),
                ),
              ),
              child: CachedNetworkImage(
                imageUrl: "$imgPath",
                fit: BoxFit.fitWidth,
                width: ScreenUtil().setWidth(502),
                height: ScreenUtil().setWidth(322),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!CommonUtils.isEmpty(iconList)) {
      } else {
        print("$context WidgetsBinding_initData");
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
      ),
      body: Builder(
        builder: (context) {
          return EasyRefresh.custom(
            enableControlFinishLoad: false,
            header: CustomHeader(
                completeDuration: Duration(seconds: 2),
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
                            color: GlobalConfig.colorPrimary,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
            footer: CustomFooter(
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
                        child: Container(
                          width: 30.0,
                          height: 30.0,
                          child: SpinKitCircle(
                            color: GlobalConfig.colorPrimary,
                            size: 30.0,
                          ),
                        ),
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
                          color: GlobalConfig.colorPrimary,
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
                    color: GlobalConfig.colorPrimary,
                  ),
                  Loading(
                    indicator: BallGridPulseIndicator(),
                    size: 100.0,
                    color: GlobalConfig.colorPrimary,
                  ),
                  Loading(
                    indicator: BallPulseIndicator(),
                    size: 100.0,
                    color: GlobalConfig.colorPrimary,
                  ),
                  Loading(
                    indicator: BallScaleIndicator(),
                    size: 100.0,
                    color: GlobalConfig.colorPrimary,
                  ),
                  Loading(
                    indicator: BallScaleMultipleIndicator(),
                    size: 100.0,
                    color: GlobalConfig.colorPrimary,
                  ),
                  Loading(
                    indicator: BallSpinFadeLoaderIndicator(),
                    size: 100.0,
                    color: GlobalConfig.colorPrimary,
                  ),
                  Loading(
                    indicator: LineScaleIndicator(),
                    size: 100.0,
                    color: GlobalConfig.colorPrimary,
                  ),
                  Loading(
                    indicator: LineScalePartyIndicator(),
                    size: 100.0,
                    color: GlobalConfig.colorPrimary,
                  ),
                  Loading(
                    indicator: LineScalePulseOutIndicator(),
                    size: 100.0,
                    color: GlobalConfig.colorPrimary,
                  ),
                  Loading(
                    indicator: PacmanIndicator(),
                    size: 100.0,
                    color: GlobalConfig.colorPrimary,
                  ),
                ],
              )),*/
              buildGoodsListSliverToBoxAdapter(context),
              buildApplyForMicroShareholders(),
              buildAdRowContainer(),
              pddcategoryTabsView,
              HomeGoodsListPage(),
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

  ///自营消费补贴商品列表
  Widget buildGoodsListSliverToBoxAdapter(BuildContext context) {
    return SliverToBoxAdapter(
        child: Visibility(
      visible: goodsList.length > 0,
      child: Container(
        margin: EdgeInsets.only(
            top: ScreenUtil().setHeight(30), left: 16, right: 16),
        padding: EdgeInsets.all(ScreenUtil().setWidth(32)),
        decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(colors: [
              Color(0xffE7665C),
              Color(0xffD54035),
            ]),
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(32))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                NavigatorUtils.navigatorRouter(context, GoodsListPage());
              },
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://alipic.lanhuapp.com/xde2fb8570-f7e3-47a5-9220-217c64821d87",
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(525),
                            height: ScreenUtil().setHeight(93),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://alipic.lanhuapp.com/xd8efb617a-af45-4ef1-bf07-2dba466fe026",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(162),
                      height: ScreenUtil().setWidth(63),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color(0xffFFEDD8),
                          Color(0xffFEC7B7),
                        ]),
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
                              fontSize: ScreenUtil().setSp(42),
                            ),
                          ),
                          CachedNetworkImage(
                            imageUrl:
                                "https://alipic.lanhuapp.com/xdb2ba7101-ff5b-42ae-a6e7-f890b3b83e91",
                            fit: BoxFit.fill,
                            width: ScreenUtil().setWidth(33),
                            height: ScreenUtil().setWidth(33),
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
            SingleChildScrollView(
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
          ],
        ),
      ),
    ));
  }

  ///申请微股东
  Widget buildApplyForMicroShareholders() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              NavigatorUtils.navigatorRouter(
                  context, MicroShareHolderEquityPage());
            },
            child: Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 10),
              height: ScreenUtil().setHeight(188),
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
                  Container(
                    width: ScreenUtil().setWidth(235),
                    height: ScreenUtil().setWidth(235),
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://alipic.lanhuapp.com/xd3342447e-ba65-4d86-91eb-edfe87de5ca3",
                      fit: BoxFit.fill,
                    ),
                  ),
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
                      gradient: LinearGradient(colors: [
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
                  top: ScreenUtil().setHeight(30), left: 16, right: 16),
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
        NavigatorUtils.navigatorRouter(
            context,
            GoodsDetailPage(
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
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
          ),
          child: Padding(
//                  padding: const EdgeInsets.only(left: 4,right: 4,top: 4,bottom: 4),
            padding: EdgeInsets.all(ScreenUtil().setWidth(14)),
//            child: InkWell(
//              splashColor: Colors.yellow,

//        onDoubleTap: () => showSnackBar(),
            child: Container(
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
                        height: ScreenUtil().setWidth(246),
                        width: ScreenUtil().setWidth(305),
                        fit: BoxFit.fill,
                        imageUrl: "$goodsImg",
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
        margin: EdgeInsets.only(left: 16, top: 8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CachedNetworkImage(
                        imageUrl:
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            "https://alipic.lanhuapp.com/xd3a1dc3af-ad52-48db-bac9-d65d055bda2e",
                        width: ScreenUtil().setWidth(42),
                        height: ScreenUtil().setWidth(42),
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
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            "https://alipic.lanhuapp.com/xd4b9bfe6d-b3c3-4e21-9489-3d377e6774eb",
                        width: ScreenUtil().setWidth(42),
                        height: ScreenUtil().setWidth(42),
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
          left: 16,
          right: 16,
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
    String path = '';
    String subtitle = '';
    String params = '';
    String catId = '';
    String pddType = '';
    bool needShow = true;
    bool isUnderReview = false;
    try {
      icon = item.icon;
      name = item.name;
      type = item.type;
      appId = item.appId;
      path = item.path;
      subtitle = item.subtitle;
      params = item.params;
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
    if ((name.contains('游戏') ||
            name.contains('赚钱') ||
            name.contains('会员') ||
            name.contains('加油')) &&
        GlobalConfig.isHuaweiUnderReview) {
      needShow = false;
    }
    if (Platform.isIOS) {
      isUnderReview = GlobalConfig.prefs.getBool("isHuaweiUnderReview");
    }

    if ((name.contains('游戏') ||
            name.contains('赚钱') ||
            name.contains('会员') ||
            name.contains('加油')) &&
        GlobalConfig.isHuaweiUnderReview) {
      needShow = false;
    }
    if ((name.contains('游戏') ||
            name.contains('赚钱') ||
            name.contains('会员') ||
            name.contains('星选')) &&
        isUnderReview) {
      needShow = false;
    }
    return new InkWell(
        onTap: () async {
          if (name.contains('赚钱') && Platform.isIOS) {
            if (!GlobalConfig.isHuaweiUnderReview) {
              NavigatorUtils.navigatorRouter(context, TaskHallPage());
            } else {}
            return;
          }
          if (name.contains('美团')) {
            if (isUnderReview) {
              path = 'http://dpurl.cn/cENLteO';
              Utils.launchUrl(path);
              return;
            }
          }
          if (name.contains('饿') && Platform.isIOS) {
            if (isUnderReview) {
              path =
                  'https://sheng.bainianmao.com/app/index.php?i=550&c=entry&do=elm&m=bsht_tbk&type=1';
              Utils.launchUrl(path);
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
            launchWeChatMiniProgram(username: appId, path: path);
            return;
          }
          if (type == 'app') {
            if (path == 'pdd_index') {
              NavigatorUtils.navigatorRouter(context, PddHomeIndexPage());
              return;
            }
            if (path == 'pdd_goods') {
              NavigatorUtils.navigatorRouter(
                  context,
                  PddGoodsListPage(
                    showAppBar: true,
                    type: pddType,
                    title: name,
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
            if (path.contains("yangkeduo")) {
              var pddPath = path.replaceAll("https://mobile.yangkeduo.com/",
                  "pinduoduo://com.xunmeng.pinduoduo/");
              if (await canLaunch(pddPath)) {
                await launch(pddPath);
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
              child: CachedNetworkImage(
                imageUrl:
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
        NavigatorUtils.navigatorRouter(context, TaskOpenDiamondPage());
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
      height: ScreenUtil().setHeight(566),
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
              left: 16,
              right: 16,
              top: 6,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(ScreenUtil().setWidth(30)),
              ),
              child: Swiper(
                itemCount: bannerList == null ? 0 : bannerList.length,
                /*itemWidth: ScreenUtil().setWidth(1125),
                itemHeight: ScreenUtil().setHeight(623),
                transformer: ScaleAndFadeTransformer(scale: 0, fade: 0),*/
                //bannerList == null ? 0 : bannerList.length,
                loop: _isLoop,
                autoplay: false,
                duration: 50,
                autoplayDisableOnInteraction: true,
                key: ValueKey(context),
                controller: _swiperController,
//          indicatorLayout: PageIndicatorLayout.COLOR,
                onIndexChanged: (index) async {
                  if (!CommonUtils.isEmpty(bannerColorList)) {
                    if (!CommonUtils.isEmpty(bannerColorList[index]) &&
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
                  PaletteGenerator generator =
                      await PaletteGenerator.fromImageProvider(
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
                        activeColor: GlobalConfig.taskHeadColor,
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
                          case "upgrade":
                            NavigatorUtils.navigatorRouter(
                                context, TaskOpenVipPage());
/*
                          NavigatorUtils.navigatorRouter(
                              context, TaskOpenDiamondPage());
*/
                            break;
                          case "recharge":
                            NavigatorUtils.navigatorRouter(
                                context, RechargeListPage());
                            break;
                          case "goods_list":
                            NavigatorUtils.navigatorRouter(
                                context, GoodsListPage());
                            break;
                          case "upgrade_diamond":
                            NavigatorUtils.navigatorRouter(
                                context,
                                TaskOpenVipPage(
                                  taskType: 2,
                                ));
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
                      switch (bannerList[bannerIndex].uri.toString().trim()) {
                        case "upgrade":
                          NavigatorUtils.navigatorRouter(
                              context, TaskOpenVipPage());
/*
                          NavigatorUtils.navigatorRouter(
                              context, TaskOpenDiamondPage());
*/
                          break;
                        case "recharge":
                          NavigatorUtils.navigatorRouter(
                              context, RechargeListPage());
                          break;
                        case "goods_list":
                          NavigatorUtils.navigatorRouter(
                              context, GoodsListPage());
                          break;
                        case "upgrade_diamond":
                          NavigatorUtils.navigatorRouter(
                              context,
                              TaskOpenVipPage(
                                taskType: 2,
                              ));
                          break;
                      }
                      if (bannerList[bannerIndex]
                          .uri
                          .toString()
                          .startsWith("http")) {
                        Utils.launchUrl(bannerList[bannerIndex].uri.toString());
                        /*bool isImage = false;
                        Response resust = await Dio().get(bannerList[bannerIndex].uri);
                        String contentType = resust.headers['content-type'].toString();
                        if (contentType.startsWith("[image/")) {
                          isImage = true;
                        }
                        if (isImage) {
                          NavigatorUtils.navigatorRouter(
                              context,
                              TaskGalleryPage(
                                galleryItems: [bannerList[bannerIndex].uri.toString()],
                              ));
                          return;
                        }
                        */ /*print("contentType=$contentType");
                        print(
                            "contentTypeIsImage=${contentType.startsWith("[image/")}");*/ /*
                        var hColor = GlobalConfig.taskHeadColor;
                        NavigatorUtils.navigatorRouter(
                            context,
                            WebViewPage(
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
                    child: CachedNetworkImage(
                      imageUrl: bannerData.imgPath,
//              width: ScreenUtil().setWidth(1125),
                      placeholder: (context, url) => Center(
                        child: Loading(
                          indicator: BallSpinFadeLoaderIndicator(),
                          size: 50.0,
                          color: GlobalConfig.colorPrimary,
                        ),
                      ),
                      fit: BoxFit.fill,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
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
            */ /* NavigatorUtils.navigatorRouter(
                context,
                WebViewPage(
                  initialUrl: HttpManage.getTheMissionWallEntranceUrl(
                      "${GlobalConfig.getUserInfo().tel}"),
                  showActions: true,
                  title: "任务墙",
                  appBarBackgroundColor: Color(0xFFD72825),
                ));*/ /*

          }*/
          NavigatorUtils.navigatorRouter(
              context,
              TaskOpenVipPage(
                taskType: 2,
              ));
//          HttpManage.getTheMissionWallEntrance("13122336666");
        },
        child: Container(
          height: ScreenUtil().setHeight(550),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          alignment: Alignment.center,
          child: CachedNetworkImage(
            imageUrl:
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
    var bgColor = GlobalConfig.taskBtnBgColor;
    var txtColor = GlobalConfig.taskBtnTxtColor;
    var category = '';
    category = taskItem.category;
    switch (taskItem.taskStatus) {
      case -2:
        bgColor = GlobalConfig.taskBtnBgGreyColor;
        txtColor = GlobalConfig.taskBtnTxtGreyColor;
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
        bgColor = GlobalConfig.taskBtnBgGreyColor;
        txtColor = GlobalConfig.taskBtnTxtGreyColor;
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
              CommonUtils.showIosPayDialog();
              return;
            }
            var result = await showDialog(
                context: context,
                builder: (context) {
                  return TaskOpenDiamondDialogPage();
                });
            break;
          case 0: // 领任务
            if (await checkUserBind(isTaskWall: !GlobalConfig.isBindWechat)) {
              switch (category) {
                case "1":
                  var result = await HttpManage.taskReceive(taskItem.id);
                  if (result.status) {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return TaskDetailPage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  } else {
                    CommonUtils.showToast(result.errMsg);
                  }
                  break;
                case "2":
                  var result = await HttpManage.taskReceiveOther(taskItem.id);
                  if (result.status) {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return TaskDetailOtherPage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  } else {
                    CommonUtils.showToast(result.errMsg);
                  }
                  break;
              }
            }

            break;
          case 1: //待提交
            if (category == "1") {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return TaskDetailPage(
                  taskId: taskItem.id,
                );
              }));
              _initData();
            } else {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return TaskDetailOtherPage(
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
                return TaskDetailPage(
                  taskId: taskItem.id,
                  pageType: 1,
                );
              }));
              _initData();
            } else {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return TaskDetailOtherPage(
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
              return TaskDetailPage();
            }));
          } else if (index == 2) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return TaskSubmissionPage();
            }));
          } else {
            var result = await showDialog(
                context: context,
                builder: (context) {
                  return TaskOpenDiamondDialogPage();
                });
            print('$result');
          }
        }*/
      },
      leading: ClipOval(
        child: CachedNetworkImage(
          fit: BoxFit.fill,
          width: ScreenUtil().setWidth(110),
          height: ScreenUtil().setWidth(110),
          imageUrl: taskItem.icons,
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

      /* CachedNetworkImage(
        width: 40,
        height: 40,
        imageUrl:
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
    var bgColor = GlobalConfig.taskBtnBgColor;
    var txtColor = GlobalConfig.taskBtnTxtColor;
    var category = '';
    category = taskItem.category;
    switch (taskItem.taskStatus) {
      case -2:
        bgColor = GlobalConfig.taskBtnBgGreyColor;
        txtColor = GlobalConfig.taskBtnTxtGreyColor;
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
        bgColor = GlobalConfig.taskBtnBgGreyColor;
        txtColor = GlobalConfig.taskBtnTxtGreyColor;
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
              CommonUtils.showIosPayDialog();
              return;
            }
            var result = await showDialog(
                context: context,
                builder: (context) {
                  return TaskOpenDiamondDialogPage();
                });
            break;
          case 0: // 领任务
            if (await checkUserBind(isTaskWall: !GlobalConfig.isBindWechat)) {
              switch (category) {
                case "1":
                  var result = await HttpManage.taskReceive(taskItem.id);
                  if (result.status) {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return TaskDetailPage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  } else {
                    CommonUtils.showToast(result.errMsg);
                  }
                  break;
                case "2":
                  var result = await HttpManage.taskReceiveOther(taskItem.id);
                  if (result.status) {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return TaskDetailOtherPage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  } else {
                    CommonUtils.showToast(result.errMsg);
                  }
                  break;
              }
            }

            break;
          case 1: //待提交
            if (category == "1") {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return TaskDetailPage(
                  taskId: taskItem.id,
                );
              }));
              _initData();
            } else {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return TaskDetailOtherPage(
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
                return TaskDetailPage(
                  taskId: taskItem.id,
                  pageType: 1,
                );
              }));
              _initData();
            } else {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return TaskDetailOtherPage(
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
              return TaskDetailPage();
            }));
          } else if (index == 2) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return TaskSubmissionPage();
            }));
          } else {
            var result = await showDialog(
                context: context,
                builder: (context) {
                  return TaskOpenDiamondDialogPage();
                });
            print('$result');
          }
        }*/
      },
      leading: ClipOval(
        child: CachedNetworkImage(
          fit: BoxFit.fill,
          width: ScreenUtil().setWidth(110),
          height: ScreenUtil().setWidth(110),
          imageUrl: taskItem.icons,
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

      /* CachedNetworkImage(
        width: 40,
        height: 40,
        imageUrl:
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
          left: 16, right: 16, top: ScreenUtil().setHeight(655)),
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
                      color: GlobalConfig.taskBtnTxtGreyColor,
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
                  color: GlobalConfig.taskBtnTxtGreyColor,
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
      margin:
          EdgeInsets.only(left: 16, right: 16, top: ScreenUtil().setHeight(32)),
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
      if (!CommonUtils.isEmpty(taskList)) {
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
    UserInfoData userInfoData = GlobalConfig.getUserInfo();
    if (CommonUtils.isEmpty(userInfoData)) {
      print("userInfoData is empty is true");
      var result = await HttpManage.getUserInfo();
      if (result.status) {
        userInfoData = GlobalConfig.getUserInfo();
      } else {
        CommonUtils.showToast("${result.errMsg}");
        return false;
      }
    }
    if (!isTaskWall) {
      if (userInfoData.bindThird == 1) {
        CommonUtils.showToast("请先绑定微信后领取任务");
        return false;
      }
    }

    if (CommonUtils.isEmpty(userInfoData.tel)) {
      CommonUtils.showToast("请先绑定手机号后领取任务");
      return false;
    }
    return true;
  }

  ///任务状态 -2不可领取 -1去开通 0领任务 1待提交 2待审核 3已完成 4被驳回
  Widget buildTaskItemLayout(context, HomeDataTaskListList taskItem, index) {
    var bgColor = Color(0xffF32E43); // GlobalConfig.taskBtnBgColor;
    var txtColor = Colors.white; //GlobalConfig.taskBtnTxtColor;
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
    if (GlobalConfig.isHuaweiUnderReview) {
      _isShow = !taskItem.title.contains("代购");
    }
    bool _isNewTask = taskItem.isNew == '1';
    switch (taskItem.taskStatus) {
      case -2:
        bgColor = GlobalConfig.taskBtnBgGreyColor;
        txtColor = GlobalConfig.taskBtnTxtGreyColor;
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
        bgColor = GlobalConfig.taskBtnBgGreyColor;
        txtColor = GlobalConfig.taskBtnTxtGreyColor;
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
              color: GlobalConfig.taskNomalHeadColor,
              height: 8,
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              /*      if (true) {
                NavigatorUtils.navigatorRouter(context, TaskSharePage());
                return;
              }*/
              switch (taskItem.taskStatus) {
                case -2:
                  break;
                case -1: //-1去开通
                  if (Platform.isIOS) {
                    CommonUtils.showIosPayDialog();
                    return;
                  }
                  var result = await showDialog(
                      context: context,
                      builder: (context) {
                        return TaskOpenDiamondDialogPage(
                          taskType: widget.taskType,
                        );
                      });
                  break;
                case 0: // 领任务
                  if (await checkUserBind(
                      isTaskWall: !GlobalConfig.isBindWechat)) {
                    switch (userType) {
                      case "0": //普通
                        break;
                      case "1": //体验
                        break;
                      case "2": //vip
                        if (widget.taskType != 1) {
                          CommonUtils.showToast("请到vip专区领取任务");
                          return;
                        }
                        break;
                      case "4": //钻石
                        if (widget.taskType != 2) {
                          CommonUtils.showToast("请到钻石专区领取任务");
                          return;
                        }
                        break;
                    }
                    switch (category) {
                      case "1":
                        /*if (userType == "0") {
                          CommonUtils.showToast("您只能领取非朋友圈任务");
                          return;
                        }*/
                        var result = await HttpManage.taskReceive(taskItem.id);
                        if (result.status) {
                          var result = await Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return TaskDetailPage(
                              taskId: taskItem.id,
                            );
                          }));
                          _initData();
                        } else {
                          CommonUtils.showToast(result.errMsg);
                        }
                        break;
                      case "2":
                        var result =
                            await HttpManage.taskReceiveOther(taskItem.id);
                        if (result.status) {
                          var result = await Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return TaskDetailOtherPage(
                              taskId: taskItem.id,
                            );
                          }));
                          _initData();
                        } else {
                          CommonUtils.showToast(result.errMsg);
                        }
                        break;
                      case "3":
                        var result =
                            await HttpManage.taskReceiveWechat(taskItem.id);
                        if (result.status) {
                          var result = await Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return TaskSharePage(
                              taskId: taskItem.id,
                            );
                          }));
                          _initData();
                        } else {
                          CommonUtils.showToast(result.errMsg);
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
                        CommonUtils.showToast("请到vip专区提交任务");
                        return;
                      }
                      break;
                    case "4": //钻石
                      if (widget.taskType != 2) {
                        CommonUtils.showToast("请到钻石专区提交任务");
                        return;
                      }
                      break;
                  }
                  if (category == "1") {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return TaskDetailPage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  } else {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return TaskDetailOtherPage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  }

                  break;
                case 2: //2待审核
                  switch (category) {
                    case "3":
                      NavigatorUtils.navigatorRouter(
                          context,
                          TaskSharePage(
                            taskId: taskItem.id,
                          ));
                      break;
                    case "4": //商品补贴任务
                      NavigatorUtils.navigatorRouter(
                          context,
                          TaskDetailOtherPage(
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
                        CommonUtils.showToast("请到vip专区提交任务");
                        return;
                      }
                      break;
                    case "4": //钻石
                      if (widget.taskType != 2) {
                        CommonUtils.showToast("请到钻石专区提交任务");
                        return;
                      }
                      break;
                  }
                  if (category == "1") {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return TaskDetailPage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  } else {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return TaskDetailOtherPage(
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
                                return TaskDetailPage();
                              }));
                            } else if (index == 2) {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return TaskSubmissionPage();
                              }));
                            } else {
                              var result = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return TaskOpenDiamondDialogPage();
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
                              child: CachedNetworkImage(
                                fit: BoxFit.fill,
                                width: ScreenUtil().setWidth(110),
                                height: ScreenUtil().setWidth(110),
                                imageUrl: taskItem.icons,
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
                                child: CachedNetworkImage(
                                  imageUrl: "$_taskIcon",
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
                                    ? CachedNetworkImage(
                                        imageUrl:
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
