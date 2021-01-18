import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:star/bus/my_event_bus.dart';
import 'package:star/global_config.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/pages/goods/pdd/featured_tab.dart';
import 'package:star/pages/search/search_page.dart';
import 'package:star/pages/task/task_message.dart';
import 'package:star/utils/navigator_utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  var categroy = [
    '百货',
    '母婴',
    '食品',
    '女装',
    '',
  ];
  var slideshow;
  var products;
  var items;
  var _mFuture;
  bool isFirstLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(
        vsync: this, length: categroy == null ? 0 : categroy.length);
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
              onTap: () {},
              child: IconButton(
                icon: Image.asset(
                  "static/images/icon_ios_back.png",
                  width: ScreenUtil().setWidth(36),
                  height: ScreenUtil().setHeight(63),
                  fit: BoxFit.fill,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
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
                height: 40,
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
    if (categroy != null) {
      for (var classify in categroy) {
        tabs.add(Tab(
          text: classify,
        ));
      }
    }
    return tabs;
  }

//分类下对应页面
  List<Widget> buildTabViews() {
    List<Widget> tabViews = <Widget>[];
    if (categroy != null) {
      for (var classify in categroy) {
        /*if ('精选' == classify.name) {
          tabViews.add(FeaturedTabPage(
            products: products,
            items: items,
            slideshow: slideshow,
          ));
        } else {
          tabViews.add(HomeCategoryGoodsPage(
            category_id: classify.categoryId,
          ));
        }*/
        tabViews.add(FeaturedTabPage());
      }
    }
    return tabViews;
  }

//初始化精选tab数据
  Future _initData() async {
    /*HomeResultBeanEntity result = await HttpManage.getHome();
    if (mounted) {
      setState(() {
        resultData = result;
        categroy = resultData.data.categroy;
        slideshow = resultData.data.slideshow;
        products = resultData.data.products;
        items = resultData.data.items;
        HomeResultBeanDataCategroy homeTab = HomeResultBeanDataCategroy();
        homeTab.name = '精选';
        categroy.insert(0, homeTab);
      });
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildSearchBarLayout(),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        brightness: Brightness.dark,
        backgroundColor: Color(0xffF32E43),
        bottom: TabBar(
          labelColor: Colors.white,
          controller: this._tabController,
          indicatorColor: Colors.white,
          isScrollable: true,
          tabs: buildTabs(),
        ),
      ),
      body: TabBarView(
        controller: this._tabController,
        children: buildTabViews(),
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
    );
  }
}
