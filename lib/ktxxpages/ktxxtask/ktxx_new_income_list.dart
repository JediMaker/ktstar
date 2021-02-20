import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:star/ktxxpages/ktxxorder/ktxx_recharge_order_list.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_income_list.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_shareholder_income_list.dart';
import 'package:star/ktxxpages/ktxxwidget/ktxx_round_tab_indicator.dart';

import '../../ktxx_global_config.dart';
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedNewIncomeListPage extends StatefulWidget {
  KeTaoFeaturedNewIncomeListPage({Key key}) : super(key: key);
  final String title = "收益列表";
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

  @override
  _KeTaoFeaturedNewIncomeListPageState createState() => _KeTaoFeaturedNewIncomeListPageState();
}
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _KeTaoFeaturedNewIncomeListPageState extends State<KeTaoFeaturedNewIncomeListPage>
    with TickerProviderStateMixin {
  TabController _tabController;
  int _selectedTabIndex = 0;
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(
        vsync: this, length: orderType == null ? 0 : orderType.length);
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
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  var orderType = [
    '全部',
    '个人分红',
    '好友分红',
    '邀请奖励',
  ];

//订单类型
  List<Widget> buildTabs() {
    List<Widget> tabs = <Widget>[];
    if (orderType != null) {
      for (var index = 0; index < orderType.length; index++) {
        var classify = orderType[index];
        tabs.add(Container(
          height: ScreenUtil().setWidth(80),
          margin: EdgeInsets.only(bottom: 4),
          child: Tab(
            child: Text(
              "$classify",
              style: TextStyle(
                fontSize: ScreenUtil().setSp(38),
                color: _selectedTabIndex == index
                    ? Color(0xff222222)
                    : Color(0xffAFAFAF),
                fontWeight: _selectedTabIndex == index
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
        ));
      }
    }
    return tabs;
  }

//分类下对应页面
  List<Widget> buildTabViews() {
    List<Widget> tabViews = <Widget>[];
    int profitType = 6;
    if (orderType != null) {
      for (var index = 0; index < orderType.length; index++) {
        if (index == 0) {
          tabViews.add(KeTaoFeaturedIncomeListPage(
            pageType: 0,
          ));
        } else {
          tabViews.add(KeTaoFeaturedShareHolderIncomeListPage(
            pageType: 0,
            profitType: profitType + index,
          ));
        }
      }
    }
    return tabViews;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
              color: Color(0xFF222222), fontSize: ScreenUtil().setSp(54)),
        ),
        brightness: Brightness.light,
        leading: IconButton(
          icon: Container(
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
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        backgroundColor: KeTaoFeaturedGlobalConfig.taskNomalHeadColor,
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
              isScrollable: orderType.length < 4 ? true : false,
              labelColor: Color(0xffF32E43),
              indicatorWeight: 2,
              indicatorPadding: EdgeInsets.only(top: 4, bottom: 2),
              unselectedLabelColor: Colors.black,
              indicator: KeTaoFeaturedRoundUnderlineTabIndicator(
                  borderSide: BorderSide(
                width: 3.5,
                color: Color(0xffF32E43),
              )),
              onTap: (index) {
                setState(() {
                  _selectedTabIndex = _tabController.index;
                });
              },
              /*  indicator: BoxDecoration(

              ),*/
              tabs: buildTabs(),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: buildTabViews(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
