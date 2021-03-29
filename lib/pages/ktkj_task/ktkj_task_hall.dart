import 'dart:io';
import 'dart:ui';

import 'package:star/pages/ktkj_widget/ktkj_my_octoimage.dart';
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
import 'package:palette_generator/palette_generator.dart';
import 'package:star/bus/ktkj_my_event_bus.dart';
import 'package:star/global_config.dart';
import 'package:star/http/ktkj_http.dart';
import 'package:star/http/ktkj_http_manage.dart';
import 'package:star/models/home_entity.dart';
import 'package:star/models/home_goods_list_entity.dart';
import 'package:star/models/home_icon_list_entity.dart';
import 'package:star/models/user_info_entity.dart';
import 'package:star/pages/ktkj_goods/ktkj_category/ktkj_classify.dart';
import 'package:star/pages/ktkj_goods/ktkj_goods_detail.dart';
import 'package:star/pages/ktkj_goods/ktkj_goods_list.dart';
import 'package:star/pages/ktkj_recharge/ktkj_recharge_list.dart';
import 'package:star/pages/ktkj_task/ktkj_task_detail.dart';
import 'package:star/pages/ktkj_task/ktkj_task_detail_other.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:star/pages/ktkj_task/ktkj_task_gallery.dart';
import 'package:star/pages/ktkj_task/ktkj_task_open_diamond.dart';
import 'package:star/pages/ktkj_task/ktkj_task_open_diamond_dialog.dart';
import 'package:star/pages/ktkj_task/ktkj_task_open_vip.dart';
import 'package:star/pages/ktkj_task/ktkj_task_share.dart';
import 'package:star/pages/ktkj_task/ktkj_task_submission.dart';
import 'package:star/pages/ktkj_widget/ktkj_PriceText.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_webview.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_webview_plugin.dart';
import 'package:star/utils/ktkj_common_utils.dart';
import 'package:star/utils/ktkj_navigator_utils.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:star/utils/ktkj_utils.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJTaskHallPage extends StatefulWidget {
  KTKJTaskHallPage({Key key}) : super(key: key);
  final String title = "任务大厅";

  @override
  _TaskHallPageState createState() => _TaskHallPageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _TaskHallPageState extends State<KTKJTaskHallPage>
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

  var _marqueeSwiperController = SwiperController();

  @override
  initState() {
    weChatResponseEventHandler.listen((res) {
      if (res is WeChatLaunchMiniProgramResponse) {
//        print("拉起小程序isSuccessful:${res.isSuccessful}");
      }
    });
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
//      userType = KTKJGlobalConfig.getUserInfo().type;
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
    bus.on("refreshData", (data) {
      _initData(isRefresh: true);
    });
    super.initState();
  }

  Future _initData({bool isRefresh = false}) async {
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
    /* if (mounted) {
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
    }*/
    if (bannerList.length > 1) {
      _swiperController.startAutoplay();
    }
  }

  ///
  /// 确认账户信息是否绑定手机号以及微信授权
  static checkUserBind({bool isTaskWall = false}) async {
    UserInfoData userInfoData = KTKJGlobalConfig.getUserInfo();
    if (KTKJCommonUtils.isEmpty(userInfoData)) {
      print("userInfoData is empty is true");
      var result = await HttpManage.getUserInfo();
      if (result.status) {
        userInfoData = KTKJGlobalConfig.getUserInfo();
      } else {
        KTKJCommonUtils.showToast("${result.errMsg}");
        return false;
      }
    }
    if (!isTaskWall) {
      if (userInfoData.bindThird == 1) {
        KTKJCommonUtils.showToast("请先绑定微信后领取任务");
        return false;
      }
    }

    if (KTKJCommonUtils.isEmpty(userInfoData.tel)) {
      KTKJCommonUtils.showToast("请先绑定手机号后领取任务");
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

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
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
          title: Text(
            widget.title,
            style: TextStyle(fontSize: ScreenUtil().setSp(54)),
          ),
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
//                  completeDuration: Duration(seconds: 2),
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
                          color: KTKJGlobalConfig.colorPrimary,
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
                            color: KTKJGlobalConfig.colorPrimary,
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
                SliverToBoxAdapter(child: taskCard2(context)),
              ],
              onRefresh: () async {
//              _initData();
                if (!isFirstLoading) {
                  bus.emit("refreshData");
                }
              },
            );
          },
        ), // This trailing comma makes auto-formatting nicer for build methods.
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
    double topMargin = 0;
    try {
      id = item.id;
      goodsName = item.goodsName;
      goodsImg = item.goodsImg;
      originalPrice = item.originalPrice;
      salePrice = item.salePrice;
      if (goodsName.length < 8) {
        topMargin = ScreenUtil().setHeight(70);
      } else {
        topMargin = ScreenUtil().setHeight(10);
      }
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
          width: ScreenUtil().setWidth(340),
          margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
          constraints: BoxConstraints(
            minHeight: ScreenUtil().setHeight(560),
          ),
          decoration: BoxDecoration(
            color: Color(0xffFFF0E8),
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
                  color: Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(ScreenUtil().setWidth(30)),
                      topLeft: Radius.circular(ScreenUtil().setWidth(30)),
                    ),
                    child: KTKJMyOctoImage(
                      fadeInDuration: Duration(milliseconds: 0),
                      fadeOutDuration: Duration(milliseconds: 0),
                      height: ScreenUtil().setWidth(340),
                      width: ScreenUtil().setWidth(340),
                      fit: BoxFit.fitWidth,
                      image: "$goodsImg",
                    ),
                  ),
                ),

//                          SizedBox(
//                            height: 10,
//                          ),
                Container(
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
                              bottom: ScreenUtil().setHeight(2)),
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

  ///icon 操作列表
  Widget itemsLayout() {
    Color _itemsTextColor = Color(0xff222222);
    return Container(
      padding: EdgeInsets.only(
        top: 16,
        bottom: 16,
      ),
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        top: ScreenUtil().setHeight(655),
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
    );
  }

  Widget iconItem(Color _itemsTextColor, {HomeIconListIconList item}) {
    String icon = '';
    String name = '';
    String type = '';
    String appId = '';
    String path = '';
    String subtitle = '';
    try {
      icon = item.icon;
      name = item.name;
      type = item.type;
      appId = item.appId;
      path = item.path;
      subtitle = item.subtitle;
//      print("iconsubtitle=${icon + name + type + appId + path + subtitle}");
    } catch (e) {}
    return new InkWell(
        onTap: () async {
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
                KTKJNavigatorUtils.navigatorRouter(
                    context, KTKJRechargeListPage());
                break;
            }
            return;
          }
          if (type == 'toast') {
            KTKJCommonUtils.showToast("敬请期待");
            return;
          }
          if (type == 'link') {
            /*PaletteGenerator generator =
                await PaletteGenerator.fromImageProvider(
                    Image.network("$icon").image);
            KTKJNavigatorUtils.navigatorRouter(
                context,
                KTKJWebViewPage(
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
              KTKJNavigatorUtils.navigatorRouter(
                  context,
                  KTKJWebViewPluginPage(
                    initialUrl: path,
                    showActions: true,
                    title: "优惠加油",
                    appBarBackgroundColor: Colors.white,
                  ));
              return;
              /* KTKJNavigatorUtils.navigatorRouter(context, MyTestApp());
              return;*/
            }
            if (name.contains('游戏') && KTKJGlobalConfig.isHuaweiUnderReview) {
              KTKJCommonUtils.showToast("敬请期待");
              KTKJNavigatorUtils.navigatorRouter(
                  context, KTKJClassifyListPage());
              return;
            }
            KTKJUtils.launchUrl(path);
            return;
          }
        },
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
                  child: KTKJMyOctoImage(
                    image: "$icon",
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
              child: KTKJMyOctoImage(
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
        KTKJNavigatorUtils.navigatorRouter(context, KTKJTaskOpenDiamondPage());
      },
      child: Image.asset(
        "static/images/home_banner.png",
        height: ScreenUtil().setHeight(623),
        width: ScreenUtil().setWidth(1125),
        fit: BoxFit.fill,
      ),
    );
  }

  Widget buildBannerLayout() {
    return Container(
      height: ScreenUtil().setHeight(741),
      width: double.maxFinite,
//      width: ScreenUtil().setWidth(1125),
      /*  decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),*/
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
          if (!KTKJCommonUtils.isEmpty(bannerColorList)) {
            if (!KTKJCommonUtils.isEmpty(bannerColorList[index]) &&
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
                activeColor: KTKJGlobalConfig.taskHeadColor,
                activeSize: 10.0)),*/
        itemBuilder: (context, index) {
          var bannerData = bannerList[index];
          return GestureDetector(
            onTap: () async {
              if (Platform.isIOS) {
                KTKJCommonUtils.showIosPayDialog();
                return;
              }

              switch (bannerList[bannerIndex].uri.toString().trim()) {
                case "upgrade":
                  KTKJNavigatorUtils.navigatorRouter(
                      context, KTKJTaskOpenVipPage());
/*
                  KTKJNavigatorUtils.navigatorRouter(
                      context, KTKJTaskOpenDiamondPage());
*/
                  break;
                case "recharge":
                  KTKJNavigatorUtils.navigatorRouter(
                      context, KTKJRechargeListPage());
                  break;
                case "goods_list":
                  KTKJNavigatorUtils.navigatorRouter(
                      context, KTKJGoodsListPage());
                  break;
                case "upgrade_diamond":
                  KTKJNavigatorUtils.navigatorRouter(
                      context,
                      KTKJTaskOpenVipPage(
                        taskType: 2,
                      ));
                  break;
              }
              if (bannerList[bannerIndex].uri.toString().startsWith("http")) {
                KTKJUtils.launchUrl(bannerList[bannerIndex].uri.toString());
                /*bool isImage = false;
                Response resust = await Dio().get(bannerList[bannerIndex].uri);
                String contentType = resust.headers['content-type'].toString();
                if (contentType.startsWith("[image/")) {
                  isImage = true;
                }
                if (isImage) {
                  KTKJNavigatorUtils.navigatorRouter(
                      context,
                      KTKJTaskGalleryPage(
                        galleryItems: [bannerList[bannerIndex].uri.toString()],
                      ));
                  return;
                }
                */ /*print("contentType=$contentType");
                print(
                    "contentTypeIsImage=${contentType.startsWith("[image/")}");*/ /*
                var hColor = KTKJGlobalConfig.taskHeadColor;
                KTKJNavigatorUtils.navigatorRouter(
                    context,
                    KTKJWebViewPage(
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
            child: KTKJMyOctoImage(
              image: bannerData.imgPath,
              height: ScreenUtil().setHeight(623),
//              width: ScreenUtil().setWidth(1125),
              fit: BoxFit.fill,
            ),
          );
        },
      ),
    );
  }

  Widget buildTaskWall() {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () {
          /* if (checkUserBind(isTaskWall: true)) {
            */ /* KTKJNavigatorUtils.navigatorRouter(
                context,
                KTKJWebViewPage(
                  initialUrl: HttpManage.getTheMissionWallEntranceUrl(
                      "${KTKJGlobalConfig.getUserInfo().tel}"),
                  showActions: true,
                  title: "任务墙",
                  appBarBackgroundColor: Color(0xFFD72825),
                ));*/ /*

          }*/
          KTKJNavigatorUtils.navigatorRouter(
              context,
              KTKJTaskOpenVipPage(
                taskType: 2,
              ));
//          HttpManage.getTheMissionWallEntrance("13122336666");
        },
        child: Container(
          height: ScreenUtil().setHeight(550),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          alignment: Alignment.center,
          child: KTKJMyOctoImage(
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
    var bgColor = KTKJGlobalConfig.taskBtnBgColor;
    var txtColor = KTKJGlobalConfig.taskBtnTxtColor;
    var category = '';
    category = taskItem.category;
    switch (taskItem.taskStatus) {
      case -2:
        bgColor = KTKJGlobalConfig.taskBtnBgGreyColor;
        txtColor = KTKJGlobalConfig.taskBtnTxtGreyColor;
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
        bgColor = KTKJGlobalConfig.taskBtnBgGreyColor;
        txtColor = KTKJGlobalConfig.taskBtnTxtGreyColor;
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
              KTKJCommonUtils.showIosPayDialog();
              return;
            }
            var result = await showDialog(
                context: context,
                builder: (context) {
                  return KTKJTaskOpenDiamondDialogPage();
                });
            break;
          case 0: // 领任务
            if (await checkUserBind(
                isTaskWall: !KTKJGlobalConfig.isBindWechat)) {
              switch (category) {
                case "1":
                  var result = await HttpManage.taskReceive(taskItem.id);
                  if (result.status) {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return KTKJTaskDetailPage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  } else {
                    KTKJCommonUtils.showToast(result.errMsg);
                  }
                  break;
                case "2":
                  var result = await HttpManage.taskReceiveOther(taskItem.id);
                  if (result.status) {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return KTKJTaskDetailOtherPage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  } else {
                    KTKJCommonUtils.showToast(result.errMsg);
                  }
                  break;
              }
            }

            break;
          case 1: //待提交
            if (category == "1") {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return KTKJTaskDetailPage(
                  taskId: taskItem.id,
                );
              }));
              _initData();
            } else {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return KTKJTaskDetailOtherPage(
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
                return KTKJTaskDetailPage(
                  taskId: taskItem.id,
                  pageType: 1,
                );
              }));
              _initData();
            } else {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return KTKJTaskDetailOtherPage(
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
              return KTKJTaskDetailPage();
            }));
          } else if (index == 2) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return KTKJTaskSubmissionPage();
            }));
          } else {
            var result = await showDialog(
                context: context,
                builder: (context) {
                  return KTKJTaskOpenDiamondDialogPage();
                });
            print('$result');
          }
        }*/
      },
      leading: ClipOval(
        child: KTKJMyOctoImage(
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

      /* KTKJMyOctoImage(
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
    var bgColor = KTKJGlobalConfig.taskBtnBgColor;
    var txtColor = KTKJGlobalConfig.taskBtnTxtColor;
    var category = '';
    category = taskItem.category;
    switch (taskItem.taskStatus) {
      case -2:
        bgColor = KTKJGlobalConfig.taskBtnBgGreyColor;
        txtColor = KTKJGlobalConfig.taskBtnTxtGreyColor;
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
        bgColor = KTKJGlobalConfig.taskBtnBgGreyColor;
        txtColor = KTKJGlobalConfig.taskBtnTxtGreyColor;
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
              KTKJCommonUtils.showIosPayDialog();
              return;
            }
            var result = await showDialog(
                context: context,
                builder: (context) {
                  return KTKJTaskOpenDiamondDialogPage();
                });
            break;
          case 0: // 领任务
            if (await checkUserBind(
                isTaskWall: !KTKJGlobalConfig.isBindWechat)) {
              switch (category) {
                case "1":
                  var result = await HttpManage.taskReceive(taskItem.id);
                  if (result.status) {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return KTKJTaskDetailPage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  } else {
                    KTKJCommonUtils.showToast(result.errMsg);
                  }
                  break;
                case "2":
                  var result = await HttpManage.taskReceiveOther(taskItem.id);
                  if (result.status) {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return KTKJTaskDetailOtherPage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  } else {
                    KTKJCommonUtils.showToast(result.errMsg);
                  }
                  break;
              }
            }

            break;
          case 1: //待提交
            if (category == "1") {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return KTKJTaskDetailPage(
                  taskId: taskItem.id,
                );
              }));
              _initData();
            } else {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return KTKJTaskDetailOtherPage(
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
                return KTKJTaskDetailPage(
                  taskId: taskItem.id,
                  pageType: 1,
                );
              }));
              _initData();
            } else {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return KTKJTaskDetailOtherPage(
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
              return KTKJTaskDetailPage();
            }));
          } else if (index == 2) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return KTKJTaskSubmissionPage();
            }));
          } else {
            var result = await showDialog(
                context: context,
                builder: (context) {
                  return KTKJTaskOpenDiamondDialogPage();
                });
            print('$result');
          }
        }*/
      },
      leading: ClipOval(
        child: KTKJMyOctoImage(
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

      /* KTKJMyOctoImage(
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
                      color: KTKJGlobalConfig.taskBtnTxtGreyColor,
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
                  color: KTKJGlobalConfig.taskBtnTxtGreyColor,
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

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _TaskListTabViewState extends State<TaskListTabView>
    with SingleTickerProviderStateMixin {
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
    /* bus.on("refreshData", (data) {
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
      if (!KTKJCommonUtils.isEmpty(taskList)) {
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
    UserInfoData userInfoData = KTKJGlobalConfig.getUserInfo();
    if (KTKJCommonUtils.isEmpty(userInfoData)) {
      print("userInfoData is empty is true");
      var result = await HttpManage.getUserInfo();
      if (result.status) {
        userInfoData = KTKJGlobalConfig.getUserInfo();
      } else {
        KTKJCommonUtils.showToast("${result.errMsg}");
        return false;
      }
    }
    if (!isTaskWall) {
      if (userInfoData.bindThird == 1) {
        KTKJCommonUtils.showToast("请先绑定微信后领取任务");
        return false;
      }
    }

    if (KTKJCommonUtils.isEmpty(userInfoData.tel)) {
      KTKJCommonUtils.showToast("请先绑定手机号后领取任务");
      return false;
    }
    return true;
  }

  ///任务状态 -2不可领取 -1去开通 0领任务 1待提交 2待审核 3已完成 4被驳回
  Widget buildTaskItemLayout(context, HomeDataTaskListList taskItem, index) {
    var bgColor = Color(0xffF32E43); // KTKJGlobalConfig.taskBtnBgColor;
    var txtColor = Colors.white; //KTKJGlobalConfig.taskBtnTxtColor;
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
    if (KTKJGlobalConfig.isHuaweiUnderReview) {
      _isShow = !taskItem.title.contains("代购");
    }
    bool _isNewTask = taskItem.isNew == '1';
    switch (taskItem.taskStatus) {
      case -2:
        bgColor = KTKJGlobalConfig.taskBtnBgGreyColor;
        txtColor = KTKJGlobalConfig.taskBtnTxtGreyColor;
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
        bgColor = KTKJGlobalConfig.taskBtnBgGreyColor;
        txtColor = KTKJGlobalConfig.taskBtnTxtGreyColor;
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
              color: KTKJGlobalConfig.taskNomalHeadColor,
              height: 8,
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              /*      if (true) {
                KTKJNavigatorUtils.navigatorRouter(context, KTKJTaskSharePage());
                return;
              }*/
              switch (taskItem.taskStatus) {
                case -2:
                  break;
                case -1: //-1去开通
                  if (Platform.isIOS) {
                    KTKJCommonUtils.showIosPayDialog();
                    return;
                  }
                  var result = await showDialog(
                      context: context,
                      builder: (context) {
                        return KTKJTaskOpenDiamondDialogPage(
                          taskType: widget.taskType,
                        );
                      });
                  break;
                case 0: // 领任务
                  if (await checkUserBind(
                      isTaskWall: !KTKJGlobalConfig.isBindWechat)) {
                    switch (userType) {
                      case "0": //普通
                        break;
                      case "1": //体验
                        break;
                      case "2": //vip
                        if (widget.taskType != 1) {
                          KTKJCommonUtils.showToast("请到vip专区领取任务");
                          return;
                        }
                        break;
                      case "4": //钻石
                        if (widget.taskType != 2) {
                          KTKJCommonUtils.showToast("请到钻石专区领取任务");
                          return;
                        }
                        break;
                    }
                    switch (category) {
                      case "1":
                        /*if (userType == "0") {
                          KTKJCommonUtils.showToast("您只能领取非朋友圈任务");
                          return;
                        }*/
                        var result = await HttpManage.taskReceive(taskItem.id);
                        if (result.status) {
                          var result = await Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return KTKJTaskDetailPage(
                              taskId: taskItem.id,
                            );
                          }));
                          _initData();
                        } else {
                          KTKJCommonUtils.showToast(result.errMsg);
                        }
                        break;
                      case "2":
                        var result =
                            await HttpManage.taskReceiveOther(taskItem.id);
                        if (result.status) {
                          var result = await Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return KTKJTaskDetailOtherPage(
                              taskId: taskItem.id,
                            );
                          }));
                          _initData();
                        } else {
                          KTKJCommonUtils.showToast(result.errMsg);
                        }
                        break;
                      case "3":
                        var result =
                            await HttpManage.taskReceiveWechat(taskItem.id);
                        if (result.status) {
                          var result = await Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return KTKJTaskSharePage(
                              taskId: taskItem.id,
                            );
                          }));
                          _initData();
                        } else {
                          KTKJCommonUtils.showToast(result.errMsg);
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
                        KTKJCommonUtils.showToast("请到vip专区提交任务");
                        return;
                      }
                      break;
                    case "4": //钻石
                      if (widget.taskType != 2) {
                        KTKJCommonUtils.showToast("请到钻石专区提交任务");
                        return;
                      }
                      break;
                  }
                  if (category == "1") {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return KTKJTaskDetailPage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  } else {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return KTKJTaskDetailOtherPage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  }

                  break;
                case 2: //2待审核
                  switch (category) {
                    case "3":
                      KTKJNavigatorUtils.navigatorRouter(
                          context,
                          KTKJTaskSharePage(
                            taskId: taskItem.id,
                          ));
                      break;
                    case "4": //商品补贴任务
                      KTKJNavigatorUtils.navigatorRouter(
                          context,
                          KTKJTaskDetailOtherPage(
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
                        KTKJCommonUtils.showToast("请到vip专区提交任务");
                        return;
                      }
                      break;
                    case "4": //钻石
                      if (widget.taskType != 2) {
                        KTKJCommonUtils.showToast("请到钻石专区提交任务");
                        return;
                      }
                      break;
                  }
                  if (category == "1") {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return KTKJTaskDetailPage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  } else {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return KTKJTaskDetailOtherPage(
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
                                return KTKJTaskDetailPage();
                              }));
                            } else if (index == 2) {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return KTKJTaskSubmissionPage();
                              }));
                            } else {
                              var result = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return KTKJTaskOpenDiamondDialogPage();
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
                              child: KTKJMyOctoImage(
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
                                child: KTKJMyOctoImage(
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
                                    ? KTKJMyOctoImage(
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
}
