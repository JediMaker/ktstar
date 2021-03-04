import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:star/ktxxbus/kt_my_event_bus.dart';
import 'package:star/ktxx_global_config.dart';
import 'package:star/ktxxhttp/ktxx_http_manage.dart';
import 'package:star/ktxxmodels/ktxx_category_bean_entity.dart';
import 'package:star/ktxxpages/ktxxgoods/ktxx_goods_list.dart';
import 'package:star/ktxxpages/ktxxsearch/ktxx_search_page.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_message.dart';
import 'package:star/ktxxutils/ktxx_common_utils.dart';
import 'package:star/ktxxutils/ktxx_navigator_utils.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
// ignore: must_be_immutable
class KeTaoFeaturedNewClassifyListPage extends StatefulWidget {
  @override
  _KeTaoFeaturedNewClassifyListPageState createState() =>
      _KeTaoFeaturedNewClassifyListPageState();
}

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
class _KeTaoFeaturedNewClassifyListPageState
    extends State<KeTaoFeaturedNewClassifyListPage>
    with AutomaticKeepAliveClientMixin {
  List<CategoryBeanData> leftListData;
  List<CategoryBeanData> rightListData;
  ScrollController _leftScrollController;
  ScrollController _rightScrollController;
  final dataKey = new GlobalKey();
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;
  Future _initData(id) async {
    List<CategoryBeanData> categoryList =
        await KeTaoFeaturedHttpManage.getCategoryList(id);
    if (mounted) {
      setState(() {
        try {
          leftListData = categoryList;
          rightListData = leftListData[selectedIndex].children;
          if (selIndex == -1) {
            changeSelCategory(selCid);
          }
        } catch (e) {}
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _leftScrollController.dispose();
    _rightScrollController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initData(0);
    _leftScrollController = ScrollController();
    _rightScrollController = ScrollController();
    _rightScrollController.addListener(() {
      ///计算左侧分类需要选中的索引下标
      var totalItemHeight = 0.00;
      var _needSelIndex = -1;
      for (var i = 0; i < leftListData.length; i++) {
        var rightList = leftListData[i].children;
        var len = rightList.length;
        var itemH = ScreenUtil().setWidth(360);
        var itemTitleHeight = ScreenUtil().setWidth(100);
        var itemHWithSpace = ScreenUtil().setWidth(372);
        totalItemHeight += itemTitleHeight;
        var itemHeight = 0.00;
        if (len % 3 == 0) {
          itemHeight = itemHWithSpace * len / 3;
        } else {
          if (len > 3) {
            var s = (len - len % 3) / 3; //
            itemHeight = itemHWithSpace * s + itemH;
          } else {
            itemHeight = itemH;
          }
        }
        totalItemHeight += itemHeight;
        if (totalItemHeight >= _rightScrollController.offset) {
          _needSelIndex = i;
          break;
        }
      }
      if (mounted) {
        setState(() {
          if (_needSelIndex != -1 && _needSelIndex != selectedIndex) {
            selectedIndex = _needSelIndex;
          }
        });
      }
    });

    bus.on("changeSelCategory", (cid) {
      print("busCid=$cid");
      selCid = cid;
      changeSelCategory(cid);
    });
  }

  changeSelCategory(cid) {
    print("cid=$cid");
    if (KeTaoFeaturedCommonUtils.isEmpty(cid)) {
      cid = KeTaoFeaturedGlobalConfig.prefs.getString("cid");
    }
    for (var i = 0; i < leftListData.length; i++) {
      if (leftListData[i].id == cid) {
        selIndex = i;
      }
    }
    print("selIndex=$selIndex");
    if (selIndex != -1) {
      changeScrollOffset(selIndex);
    }
  }

  int selIndex = -1;
  String selCid = '';
  int selectedIndex = 0;

  Widget buildSearchBarLayout() {
    return Container(
      height: 50,
      child: Row(
        children: <Widget>[
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
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(1, 1), //x,y轴
                        color: Color(0x29000000), //投影颜色
                        blurRadius: ScreenUtil().setWidth(10), //投影距离
                      )
                    ]),
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(35)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      width: ScreenUtil().setWidth(36),
                      height: ScreenUtil().setWidth(36),
                      imageUrl:
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
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                KeTaoFeaturedNavigatorUtils.navigatorRouter(
                    context, KeTaoFeaturedSearchGoodsPage());
//                NavigatorUtils.navigatorRouter(context, TaskMessagePage());
              },
              child: Container(
//                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
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

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!KeTaoFeaturedCommonUtils.isEmpty(rightListData)) {
      } else {
        _initData(0);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: buildSearchBarLayout(),
        /*leading: IconButton(
          icon: Image.asset(
            "static/images/icon_ios_back.png",
            width: ScreenUtil().setWidth(36),
            height: ScreenUtil().setHeight(63),
            fit: BoxFit.fill,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),*/
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            ScreenUtil().setWidth(1),
          ),
          child: Divider(
            height: ScreenUtil().setHeight(1),
            color: Color(0xFFefefef),
          ),
        ),
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(270),
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                CategoryBeanData category;
                if (leftListData != null) {
                  category = leftListData[index];
                }
                var _selected = index == selectedIndex ? true : false;
                return Container(
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(
                      color: Color(0xffefefef),
                      width: ScreenUtil().setWidth(1),
                    ),
                  )),
                  child: ListTile(
                    selected: _selected,
                    selectedTileColor: Colors.white,
                    title: Center(
                      child: Column(
                        children: [
                          Text(
                            category == null ? '' : category.name,
                            style: TextStyle(
                              fontSize: _selected
                                  ? ScreenUtil().setSp(42)
                                  : ScreenUtil().setSp(38),
                              color: Color(0xff222222),
                              fontWeight: _selected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(20),
                            height: ScreenUtil().setWidth(10),
                            margin: EdgeInsets.only(
                              top: ScreenUtil().setWidth(10),
                            ),
                            decoration: BoxDecoration(
                              color: _selected
                                  ? Color(0xffce0010)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(5)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      changeScrollOffset(index);
                    },
                  ),
                );
              },
              itemCount: leftListData == null ? 0 : leftListData.length,
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 8, left: 8),
              child: buildRightListView(),
//                  child:Text('hhh'),
            ),
          ),
        ],
      ),
    );
  }

  changeScrollOffset(int index) {
    ///计算需要滚动的高度
    var totalItemHeight = 0.00;
    var totalTitleHeight = (index) * ScreenUtil().setWidth(100);
    totalItemHeight += totalTitleHeight;
    for (var i = 0; i < index; i++) {
      var rightList = leftListData[i].children;
      var len = rightList.length;
      var itemH = ScreenUtil().setWidth(360);
      var itemHWithSpace = ScreenUtil().setWidth(372);
      var itemHeight = 0.00;
      if (len % 3 == 0) {
        itemHeight = itemHWithSpace * len / 3;
      } else {
        if (len > 3) {
          var s = (len - len % 3) / 3; //
          itemHeight = itemHWithSpace * s + itemH;
        } else {
          itemHeight = itemH;
        }
      }
      totalItemHeight += itemHeight;
    }
    var scrollOffset = totalItemHeight;
    setState(() {
      _rightScrollController.animateTo(scrollOffset,
          duration: new Duration(milliseconds: 200), curve: Curves.ease);
      Future.delayed(Duration(milliseconds: 500))
          .then((value) => resetSelectIndex(index));
    });
  }

  resetSelectIndex(int index) {
    if (mounted) {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  Widget buildRightListView() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      controller: _rightScrollController,
      itemBuilder: (BuildContext context, int index) {
        CategoryBeanData category;
        if (leftListData != null) {
          category = leftListData[index];
          rightListData = leftListData[index].children;
        }
        var _selected = index == selectedIndex ? true : false;
        return Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
              height: ScreenUtil().setWidth(100),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  /*border: Border(
                  bottom: BorderSide(
                    color: Color(0xffefefef),
                    width: ScreenUtil().setWidth(1),
                  ),
                ),*/
                  ),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  category == null ? '' : category.name,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(42),
                    color: Color(0xff222222),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: rightListData == null ? 0 : rightListData.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    // 左右间隔
                    crossAxisSpacing: ScreenUtil().setWidth(16),
                    // 上下间隔
                    mainAxisSpacing: 8,
                    childAspectRatio: 3 / 4),
                itemBuilder: (BuildContext context, int index) {
                  CategoryBeanData category;

                  if (rightListData != null) {
                    category = rightListData[index];
                  }
                  return GestureDetector(
                    onTap: () {
                      if (category != null) {
                        KeTaoFeaturedNavigatorUtils.navigatorRouter(
                            context,
                            KeTaoFeaturedGoodsListPage(
                              categoryId: category.id,
                              title: category.name,
                            ));
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      height: ScreenUtil().setWidth(330),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: category.imgUrl == null
                                ? 'https://www.elegantthemes.com/blog/wp-content/uploads/2020/02/000-404.png'
                                : category.imgUrl,
                            /* imageUrl:
                            "https://www.elegantthemes.com/blog/wp-content/uploads/2020/02/000-404.png",*/
                            width: ScreenUtil().setWidth(270),
                            height: ScreenUtil().setWidth(270),
//            placeholder: (context, url) => new CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                          ),
                          SizedBox(
                            height: ScreenUtil().setWidth(15),
                          ),
                          Text(
                            category.name,
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(38),
                              color: Color(0xff222222),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                })
          ],
        );
      },
      itemCount: rightListData == null ? 0 : leftListData.length,
    );
  }

  Widget buildRightClassfyGridView() {
    return EasyRefresh.custom(
      emptyWidget: rightListData != null
          ? null
          : Container(
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: SizedBox(),
                    flex: 2,
                  ),
                  SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: Image.asset('static/images/c_defull_null.png'),
                  ),
                  Text(
                    '暂无数据',
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[400]),
                  ),
                  Expanded(
                    child: SizedBox(),
                    flex: 3,
                  ),
                ],
              ),
            ),
      onRefresh: () {
        _initData(0);
      },
      header: MaterialHeader(),
      slivers: <Widget>[
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              // 左右间隔
              crossAxisSpacing: 8,
              // 上下间隔
              mainAxisSpacing: 8,
              childAspectRatio: 3 / 4),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              CategoryBeanData category;
              if (rightListData != null) {
                category = rightListData[index];
              }
              return GestureDetector(
                onTap: () {
                  if (category != null) {
                    KeTaoFeaturedNavigatorUtils.navigatorRouter(
                        context,
                        KeTaoFeaturedGoodsListPage(
                          categoryId: category.id,
                          title: category.name,
                        ));
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: category.imgUrl == null
                            ? 'https://www.elegantthemes.com/blog/wp-content/uploads/2020/02/000-404.png'
                            : category.imgUrl,
                        /* imageUrl:
                            "https://www.elegantthemes.com/blog/wp-content/uploads/2020/02/000-404.png",*/
                        width: ScreenUtil().setWidth(270),
                        height: ScreenUtil().setWidth(270),
//            placeholder: (context, url) => new CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(38),
                          color: Color(0xff222222),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            childCount: rightListData == null ? 0 : rightListData.length,
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
