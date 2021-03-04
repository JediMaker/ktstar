import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:star/ktxx_global_config.dart';
import 'package:star/ktxxhttp/ktxx_http_manage.dart';
import 'package:star/ktxxmodels/ktxx_category_bean_entity.dart';
import 'package:star/ktxxpages/ktxxgoods/ktxx_goods_list.dart';
import 'package:star/ktxxutils/ktxx_common_utils.dart';
import 'package:star/ktxxutils/ktxx_navigator_utils.dart';

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
// ignore: must_be_immutable
class KeTaoFeaturedClassifyListPage extends StatefulWidget {
  @override
  _KeTaoFeaturedClassifyListPageState createState() =>
      _KeTaoFeaturedClassifyListPageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _KeTaoFeaturedClassifyListPageState
    extends State<KeTaoFeaturedClassifyListPage>
    with AutomaticKeepAliveClientMixin {
  List<CategoryBeanData> leftListData;
  List<CategoryBeanData> rightListData;

  Future _initData(id) async {
    List<CategoryBeanData> categoryList =
        await KeTaoFeaturedHttpManage.getCategoryList(id);
    if (mounted) {
      setState(() {
        try {
          leftListData = categoryList;
          rightListData = leftListData[selectedIndex].children;
        } catch (e) {}
      });
    }
  }

  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;
  @override
  void initState() {
    super.initState();
    _initData(0);
  }

  int selectedIndex = 0;

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
        title: Text(
          '商品分类',
          style: TextStyle(
              color: Color(0xFF222222), fontSize: ScreenUtil().setSp(54)),
        ),
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
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: KeTaoFeaturedGlobalConfig.taskNomalHeadColor,
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
                      child: Text(
                        category == null ? '' : category.name,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(38),
                          color: _selected ? Colors.red : Color(0xff222222),
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        rightListData = leftListData[index].children;
                      });
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
//              child: buildRightClassfyGridView(),
//                  child:Text('hhh'),
            ),
          ),
        ],
      ),
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
//        SliverGrid(
//          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//              crossAxisCount: 3,
//              // 左右间隔
//              crossAxisSpacing: 8,
//              // 上下间隔
//              mainAxisSpacing: 8,
//              childAspectRatio: 3 / 4),
//          delegate: SliverChildBuilderDelegate(
//            (BuildContext context, int index) {
//              CategoryBeanData category;
//              if (rightListData != null) {
//                category = rightListData[index];
//              }
//              return GestureDetector(
//                onTap: () {
//                  if (category != null) {
//                    KeTaoFeaturedNavigatorUtils.navigatorRouter(
//                        context,
//                        KeTaoFeaturedGoodsListPage(
//                          categoryId: category.id,
//                          title: category.name,
//                        ));
//                  }
//                },
//                behavior: HitTestBehavior.opaque,
//                child: Container(
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    children: <Widget>[
//                      CachedNetworkImage(
//                        fit: BoxFit.cover,
//                        imageUrl: category.imgUrl == null
//                            ? 'https://www.elegantthemes.com/blog/wp-content/uploads/2020/02/000-404.png'
//                            : category.imgUrl,
//                        /* imageUrl:
//                            "https://www.elegantthemes.com/blog/wp-content/uploads/2020/02/000-404.png",*/
//                        width: ScreenUtil().setWidth(270),
//                        height: ScreenUtil().setWidth(270),
////            placeholder: (context, url) => new CircularProgressIndicator(),
//                        errorWidget: (context, url, error) =>
//                            new Icon(Icons.error),
//                      ),
//                      SizedBox(
//                        height: 6,
//                      ),
//                      Text(
//                        category.name,
//                        style: TextStyle(
//                          fontSize: ScreenUtil().setSp(38),
//                          color: Color(0xff222222),
//                        ),
//                      )
//                    ],
//                  ),
//                ),
//              );
//            },
//            childCount: rightListData == null ? 0 : rightListData.length,
//          ),
//        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
