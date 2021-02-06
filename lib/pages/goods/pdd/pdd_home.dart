import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:star/bus/my_event_bus.dart';
import 'package:star/global_config.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/pdd_home_entity.dart';
import 'package:star/pages/goods/pdd/featured_tab.dart';
import 'package:star/pages/goods/pdd/pdd_goods_list.dart';
import 'package:star/pages/search/search_page.dart';
import 'package:star/pages/task/task_message.dart';
import 'package:star/pages/widget/my_webview_plugin.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:star/pages/widget/round_tab_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

///拼多多首页
class PddHomeIndexPage extends StatefulWidget {
  PddHomeIndexPage({Key key}) : super(key: key);
  final String title = "";

  @override
  _PddHomeIndexPageState createState() => _PddHomeIndexPageState();
}

class _PddHomeIndexPageState extends State<PddHomeIndexPage>
    with TickerProviderStateMixin {
  TabController _tabController;
  var resultData;
  bool isFirstLoading = true;
  List<PddHomeDataCat> cats;
  PddHomeData _homeData;
  var _tabViews;
  var _tabs;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _initData();
    _tabController =
        new TabController(vsync: this, length: cats == null ? 0 : cats.length);
    _tabController.addListener(() {
      if (mounted) {
        setState(() {
          if (_tabController.index == _tabController.animation.value) {
            _selectedTabIndex = _tabController.index;
          }
        });
      }
    });
    _tabs = buildTabs();
    _tabViews = buildTabViews();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  ///搜索栏ui
  Widget buildSearchBarLayout() {
    return Container(
      height: 50,
      child: Row(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Image.asset(
                "static/images/icon_ios_back_white.png",
                width: ScreenUtil().setWidth(36),
                height: ScreenUtil().setHeight(63),
                fit: BoxFit.fill,
              ),
/*
              child: CachedNetworkImage(
                width: ScreenUtil().setWidth(78),
                height: ScreenUtil().setWidth(78),
                imageUrl:
                    "https://alipic.lanhuapp.com/xd815e5762-05d1-4721-993a-0b866db87c4d",
              ),
*/
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                NavigatorUtils.navigatorRouter(context, SearchGoodsPage());
              },
              child: Container(
                height: ScreenUtil().setHeight(100),
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

//分类页签
  List<Widget> buildTabs() {
    List<Widget> tabs = <Widget>[];
    if (!CommonUtils.isEmpty(cats)) {
      for (var index = 0; index < cats.length; index++) {
        var classify = cats[index];
        tabs.add(Container(
          height: 36,
          child: Tab(
            child: Text(
              "${classify.catName}",
              style: TextStyle(
                fontSize: _selectedTabIndex == index
                    ? ScreenUtil().setSp(42)
                    : ScreenUtil().setSp(36),
                fontWeight: _selectedTabIndex == index
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
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

//分类下对应页面
  List<Widget> buildTabViews() {
    List<Widget> tabViews = <Widget>[];

    if (!CommonUtils.isEmpty(cats)) {
      for (var index = 0; index < cats.length; index++) {
        var classify = cats[index];
        if ('精选' == classify.catName) {
          tabViews.add(
            FeaturedTabPage(pddHomeData: _homeData),
          );
        } else {
          tabViews.add(PddGoodsListPage(
            categoryId: classify.catId,
            tabIndex: index,
          ));
        }
      }
    } else {
//      tabViews.add(Text(""));
    }
    return tabViews;
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
                      if (CommonUtils.isEmpty(url)) {
                        return;
                      }
                      NavigatorUtils.navigatorRouter(
                          this.context,
                          WebViewPluginPage(
                            initialUrl: "$url",
                            showActions: true,
                            title: "拼多多",
                            appBarBackgroundColor: Colors.white,
                          ));
                    }

                    ///
                  } else {
                    CommonUtils.showToast(result.errMsg);
                  }
                },
              ),
            ],
          );
        });
  }

//初始化精选tab数据
  Future _initData() async {
    var authResult = await HttpManage.getPddAuth();
    if (authResult.errCode.toString() == "50001" ||
        authResult.errCode.toString() == "60001") {
      showPddAuthorizationDialog();
      return;
    }
    try {
      EasyLoading.show();
    } catch (e) {}
    PddHomeEntity result = await HttpManage.getPddHomeData();
    try {
      EasyLoading.dismiss();
    } catch (e) {}
    if (result.status) {
      if (mounted) {
        setState(() {
          _homeData = result.data;
          cats = _homeData.cats;
          _tabController = new TabController(
              vsync: this, length: cats == null ? 0 : cats.length);
          _tabController.addListener(() {
            if (mounted) {
              setState(() {
                if (_tabController.index == _tabController.animation.value) {
                  _selectedTabIndex = _tabController.index;
                  print("_selectedTabIndex=$_selectedTabIndex");
                  _tabs = buildTabs();
                }
              });
            }
          });
          _tabs = buildTabs();
          _tabViews = buildTabViews();
        });
      }
    } else {
      CommonUtils.showToast("${result.errMsg}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
      child: Scaffold(
        appBar: AppBar(
          title: buildSearchBarLayout(),
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          brightness: Brightness.dark,
          backgroundColor: Color(0xffF32E43),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(36),
            child: TabBar(
              labelColor: Colors.white,
              controller: this._tabController,
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 2,
              isScrollable: true,
              indicator: RoundUnderlineTabIndicator(
                  borderSide: BorderSide(
                width: 3.5,
                color: Colors.white,
              )),
              tabs: _tabs,
              onTap: (index) {
                setState(() {
                  if (mounted) {
                    setState(() {
                      _selectedTabIndex = _tabController.index;
                    });
                  }
                });
              },
            ),
          ),
        ),
        body: TabBarView(
          controller: this._tabController,
          children: _tabViews,
          /* <Widget>[
            RefreshIndicator(
              onRefresh: () {
                print(('onRefresh'));
              },
              child: Center(
                child: FeaturedTabPage(prodproducts),
              ),
//              child: _buildTabNewsList(_newsKey, _newsList),
            ),
            Center(
              child: Text('其他'),
            ),
//            _buildTabNewsList(_technologyKey, _technologyList),
          ],*/
        ),
      ),
    );
  }
}
