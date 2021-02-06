import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:search_page/search_page.dart';
import 'package:star/generated/json/home_goods_list_entity_helper.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/home_goods_list_entity.dart';
import 'package:star/models/pdd_goods_list_entity.dart';
import 'package:star/pages/goods/goods_detail.dart';
import 'package:star/pages/goods/pdd/pdd_goods_detail.dart';
import 'package:star/pages/login/login.dart';
import 'package:star/pages/widget/PriceText.dart';
import 'package:star/pages/widget/dashed_rect.dart';
import 'package:star/pages/widget/my_webview_plugin.dart';
import 'package:star/pages/widget/no_data.dart';
import 'package:star/pages/widget/round_tab_indicator.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global_config.dart';

/// This is a very simple class, used to
/// demo the `SearchPage` package
class Person {
  final String name, surname;
  final num age;

  Person(this.name, this.surname, this.age);
}

class SearchGoodsPage extends StatefulWidget {
  SearchGoodsPage({Key key}) : super(key: key);
  final String title = "";

  @override
  _SearchGoodsPageState createState() => _SearchGoodsPageState();
}

class _SearchGoodsPageState extends State<SearchGoodsPage>
    with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  TabController _tabController;
  TextEditingController _textEditingController;
  var _searchWord = '';
  int page = 1;
  EasyRefreshController _refreshController;
  bool isFirstLoading = true;

  ///热搜商品词汇
  var _popularProductWords = [];

  ///历史搜索关键词
  List<String> _hisArray;

  @override
  void initState() {
    super.initState();
    _getHotWordsData();
    _tabController = new TabController(
        vsync: this, length: channelType == null ? 0 : channelType.length);
    _textEditingController = TextEditingController();
    _tabController.addListener(() {
      if (mounted) {
        setState(() {
          if (_tabController.index == _tabController.animation.value) {
            _selectedTabIndex = _tabController.index;
          }
        });
        return;
      }
    });
    _refreshController = EasyRefreshController();
    _hisArray = GlobalConfig.getSearchList();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _textEditingController.dispose();
    _refreshController.dispose();
  }

  _searchData() async {
    try {
      EasyLoading.show();
    } catch (e) {}
    var result =
        await HttpManage.getSearchedGoodsList(page, keyword: _searchWord);
    try {
      EasyLoading.dismiss();
    } catch (e) {}
    if (result.status) {
      if (mounted) {
        setState(() {
          print("result.data.goodsList=${result.data.goodsList.length}");
          if (page == 1) {
            goodsList = result.data.goodsList;
            _refreshController.finishLoad(noMore: true);
          } else {
            if (result == null ||
                result.data == null ||
                result.data.goodsList == null ||
                result.data.goodsList.length == 0) {
              //              _refreshController.resetLoadState();
              _refreshController.finishLoad(noMore: true);
            } else {
              goodsList += result.data.goodsList;
            }
          }
          isFirstLoading = false;
        });
      }
    } else {
      CommonUtils.showToast(result.errMsg);
    }
  }

  _getHotWordsData() async {
    try {
      EasyLoading.show();
    } catch (e) {}
    var result = await HttpManage.getHotSearchWords();
    try {
      EasyLoading.dismiss();
    } catch (e) {}
    if (result.status) {
      if (mounted) {
        setState(() {
          _popularProductWords = result.data;
        });
      }
    } else {
      CommonUtils.showToast(result.errMsg);
    }
  }

  Future _searchPddData() async {
    /* HomeResultBeanEntity result = await HttpManage.getHome();
    if (mounted) {
      setState(() {
        widget.slideshow = result.data.slideshow;
        widget.products = result.data.products;
        widget.items = result.data.items;
      });
    }*/
    if (!GlobalConfig.isLogin()) {
      CommonUtils.showToast("未获取到登录信息，，请登录！");
      Future.delayed(Duration(seconds: 1), () {
        NavigatorUtils.navigatorRouter(context, LoginPage());
      });
      return;
    }
    try {
      EasyLoading.show();
    } catch (e) {}
    var result2 =
        await HttpManage.getSearchedPddGoodsList(page, keyword: _searchWord);
    try {
      EasyLoading.dismiss();
    } catch (e) {}
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
              _refreshController.finishLoad(noMore: true);
            } else {
              pddGoodsList += result2.data.xList;
            }
          }
          isFirstLoading = false;
        });
      }
    } else {
      print("result2.errCode.toString()=${result2.errCode.toString()}");
      if (result2.errCode.toString() == "50001") {
        showPddAuthorizationDialog();
      } else {
        CommonUtils.showToast(result2.errMsg);
      }
    }
  }

  ///渠道类型
  var channelType = [
    '自营',
    '拼多多',
  ];

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
              child: Container(
                width: ScreenUtil().setWidth(63),
                height: ScreenUtil().setHeight(63),
                child: Center(
                  child: Image.asset(
                    "static/images/icon_ios_back.png",
                    width: ScreenUtil().setWidth(36),
                    height: ScreenUtil().setHeight(63),
                    fit: BoxFit.fill,
                  ),
                ),
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
            child: Container(
              height: ScreenUtil().setWidth(100),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: Color(0xffF6F6F6),
              ),
              margin: EdgeInsets.only(left: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    width: ScreenUtil().setWidth(48),
                    height: ScreenUtil().setWidth(48),
                    imageUrl:
                        "https://alipic.lanhuapp.com/xd8f3e4512-742b-425a-8660-1feddac4e231",
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 4),
                      child: TextFormField(
                        controller: _textEditingController,
                        autofocus: false,
                        onChanged: (value) {
                          if (mounted) {
                            setState(() {
                              _searchWord = value;
                              if (CommonUtils.isEmpty(_searchWord)) {
                                _hisArray = GlobalConfig.getSearchList();
                                _showSearchList = false;
                              }
                            });
                          }
                        },
                        decoration: InputDecoration.collapsed(
                          hintText: '搜索你想要的~',
                          hintStyle: TextStyle(
                            color: Color(0xff999999),
                            fontSize: ScreenUtil().setSp(42),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(42),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                ///  关键字搜索对应渠道商品
                search();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                child: Text(
                  "搜索",
                  style: TextStyle(
                      color: Color(0xff222222),
                      fontSize: ScreenUtil().setSp(42),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void search() {
    if (CommonUtils.isEmpty(_searchWord)) {
      return;
    }
    if (mounted) {
      setState(() {
        _textEditingController.text = _searchWord;
        if (!_hisArray.contains(_searchWord)) {
          _hisArray.add(_searchWord);
        }
        GlobalConfig.setSearchList(searchList: _hisArray);
        _showSearchList = true;
      });
    }

    if (_selectedTabIndex == 0) {
      ///自营
      _searchData();
    } else {
      _searchPddData();
    }
  }

  ///商品渠道类型
  List<Widget> buildTabs() {
    List<Widget> tabs = <Widget>[];
    if (channelType != null) {
      for (var index = 0; index < channelType.length; index++) {
        var classify = channelType[index];
        tabs.add(Container(
          height: ScreenUtil().setWidth(80),
          margin: EdgeInsets.only(bottom: 4),
          child: Tab(
            child: Text(
              "$classify",
              style: TextStyle(
                fontSize: ScreenUtil().setSp(42),
                color: _selectedTabIndex == index
                    ? Color(0xff222222)
                    : Color(0xffAFAFAF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));
      }
    }
    return tabs;
  }

  ///热门搜索
  buildPopularSearches() {
    if (CommonUtils.isEmpty(_popularProductWords)) {
      return SliverToBoxAdapter();
    }
    return SliverToBoxAdapter(
      child: Visibility(
        visible: !_showSearchList,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.symmetric(
                    horizontal: 16, vertical: ScreenUtil().setWidth(38)),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "热门搜索",
                        style: TextStyle(
                          fontSize: ScreenUtil().setWidth(42),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: ScreenUtil().setWidth(45),
                        height: ScreenUtil().setWidth(48),
                        /* child: CachedNetworkImage(
                          width: ScreenUtil().setWidth(45),
                          height: ScreenUtil().setWidth(48),
                          imageUrl:
                              "https://alipic.lanhuapp.com/xdef7c1966-aea1-4092-a336-329a4eba3428",
                        ),*/
                      ),
                    )
                  ],
                )),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Wrap(
                spacing: ScreenUtil().setWidth(20),
                runSpacing: ScreenUtil().setWidth(24),
                alignment: WrapAlignment.start,
                children: List.generate(
                    _popularProductWords.length,
                    (index) => InkWell(
                          onTap: () {
                            // 点击关键字搜索
                            _searchWord = _popularProductWords[index];
                            search();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: ScreenUtil().setWidth(16)),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(33),
                                ),
                                border: Border.all(
                                  color: Color(0xffefefef),
                                  width: ScreenUtil().setWidth(1),
                                )),
                            child: Text(
                              "${_popularProductWords[index]}",
                              style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: ScreenUtil().setSp(32),
                              ),
                            ),
                          ),
                        )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///搜索历史
  Widget getHistoryWidget() {
    if (CommonUtils.isEmpty(_hisArray)) {
      return SliverToBoxAdapter();
    }
    return SliverToBoxAdapter(
      child: Visibility(
        visible: !_showSearchList && !CommonUtils.isEmpty(_hisArray),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.symmetric(
                    horizontal: 16, vertical: ScreenUtil().setWidth(38)),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "历史搜索",
                        style: TextStyle(
                          fontSize: ScreenUtil().setWidth(42),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showClearDialog();
                      },
                      child: CachedNetworkImage(
                        width: ScreenUtil().setWidth(45),
                        height: ScreenUtil().setWidth(48),
                        imageUrl:
                            "https://alipic.lanhuapp.com/xdef7c1966-aea1-4092-a336-329a4eba3428",
                      ),
                    )
                  ],
                )),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Wrap(
                spacing: ScreenUtil().setWidth(20),
                runSpacing: ScreenUtil().setWidth(24),
                alignment: WrapAlignment.start,
                children: List.generate(
                    _hisArray.length,
                    (index) => InkWell(
                          onTap: () {
                            // 点击历史关键字搜索
                            _searchWord = _hisArray[index];
                            search();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: ScreenUtil().setWidth(16)),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(33),
                                ),
                                border: Border.all(
                                  color: Color(0xffefefef),
                                  width: ScreenUtil().setWidth(1),
                                )),
                            child: Text(
                              "${_hisArray[index]}",
                              style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: ScreenUtil().setSp(32),
                              ),
                            ),
                          ),
                        )),
              ),
            ),
          ],
        ),
      ),
    );
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

  ///清除历史记录弹窗
  showClearDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(""),
            content: Text(
              "确认清除所有搜索记录吗？",
              style: TextStyle(
                fontSize: ScreenUtil().setSp(42),
              ),
            ),
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
                  print("取消");
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  "确定",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(42),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _hisArray = List<String>();
                    GlobalConfig.setSearchList(searchList: _hisArray);
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
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
          _refreshController.finishLoad(noMore: false);
          page = 1;
          search();
        },
        onLoad: () {
          /*  page++;
          _initData();*/
          page++;
          search();
        },
        topBouncing: false,
        bottomBouncing: false,
        slivers: <Widget>[
          buildPopularSearches(),
          getHistoryWidget(),
          buildSearchProductList(),
          buildSearchPddProductList(),
        ],
      ),
    );
  }

  List<HomeGoodsListGoodsList> goodsList = List<HomeGoodsListGoodsList>();

  Widget buildSearchProductList() {
    if (!CommonUtils.isEmpty(goodsList)) {
      print(" goodsList.length=${goodsList.length}");
    }
    return SliverToBoxAdapter(
      child: Visibility(
        visible: _showSearchList && _selectedTabIndex == 0,
        child: Center(
          child: Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//          height: double.infinity,
            child: new StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              itemCount: CommonUtils.isEmpty(goodsList) ? 0 : goodsList.length,
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
              mainAxisSpacing: ScreenUtil().setWidth(20),
              crossAxisSpacing: ScreenUtil().setWidth(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget productItem({HomeGoodsListGoodsList item}) {
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
        NavigatorUtils.navigatorRouter(
            context,
            GoodsDetailPage(
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
                              bottom: ScreenUtil().setHeight(6)),
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

  List<PddGoodsListDataList> pddGoodsList = List<PddGoodsListDataList>();
  var listId;
  bool _showSearchList = false;

  ///拼多多商品列表
  Widget buildSearchPddProductList() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Visibility(
            visible: !CommonUtils.isEmpty(pddGoodsList) &&
                _showSearchList &&
                _selectedTabIndex == 1,
            child: Center(
              child: Container(
//            color: Color(0xffefefef),
                width: double.maxFinite,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//          height: double.infinity,
                child: new StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  itemCount: CommonUtils.isEmpty(pddGoodsList)
                      ? 0
                      : pddGoodsList.length,
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
          ),
        ],
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
                Stack(
                  children: [
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
                    Visibility(
                      visible: !CommonUtils.isEmpty(_gBonus),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        margin: EdgeInsets.only(
                          top: ScreenUtil().setSp(492),
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
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: AppBar(
          title: buildSearchBarLayout(),
          automaticallyImplyLeading: false,
          brightness: Brightness.light,
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(
              ScreenUtil().setWidth(80),
            ),
            child: Container(
              alignment: AlignmentDirectional.centerStart,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TabBar(
                controller: _tabController,
                indicatorColor: Color(0xffF32E43),
                indicatorSize: TabBarIndicatorSize.label,
                isScrollable: true,
                labelColor: Color(0xffF32E43),
                indicatorWeight: 2,
                indicatorPadding: EdgeInsets.only(top: 4, bottom: 2),
                unselectedLabelColor: Colors.black,
                indicator: RoundUnderlineTabIndicator(
                    borderSide: BorderSide(
                  width: 3.5,
                  color: Color(0xffF32E43),
                )),
                onTap: (index) {
                  setState(() {
                    _selectedTabIndex = _tabController.index;
                    print("_selectedTabIndex=$_selectedTabIndex");
                    search();
                  });
                },
                /*  indicator: BoxDecoration(

                ),*/
                tabs: buildTabs(),
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: buildView(),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
