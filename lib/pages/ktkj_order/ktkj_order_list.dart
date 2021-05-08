import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:star/pages/ktkj_order/ktkj_recharge_order_list.dart';
import 'package:star/pages/ktkj_widget/ktkj_round_tab_indicator.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJOrderListPage extends StatefulWidget {
  KTKJOrderListPage({Key key}) : super(key: key);
  final String title = "我的订单";

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _OrderListPageState extends State<KTKJOrderListPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  int _selectedTabIndex = 0;

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
    '自营',
    '拼多多',
    '美团',
    '饿了么',
    '话费充值',
    '线下商家',
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

//分类下对应页面
  List<Widget> buildTabViews() {
    List<Widget> tabViews = <Widget>[];
    if (orderType != null) {
      for (var index = 0; index < orderType.length; index++) {
        print("orderType.name=${orderType[index]}&&index=$index");
        var orderSource = "${index}";
        if (orderType[index] == '话费充值') {
          orderSource = "4";
        }
        if (orderType[index] == '线下商家') {
          orderSource = "5";
        }
        if (orderType[index] == '饿了么') {
          orderSource = "-1";
        }
        tabViews.add(KTKJRechargeOrderListPage(
          orderSource: orderSource,
        ));
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
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            ScreenUtil().setWidth(80),
          ),
          child: Container(
            alignment: AlignmentDirectional.centerStart,
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(30),
              right: ScreenUtil().setWidth(30),
              bottom: ScreenUtil().setWidth(20),
            ),
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Color(0xffF32E43),
              indicatorSize: TabBarIndicatorSize.tab,
              isScrollable: true,
              labelColor: Color(0xffF32E43),
              indicatorWeight: 2,
              indicatorPadding: EdgeInsets.only(top: 4, bottom: 2),
              unselectedLabelColor: Colors.black,
              indicator: KTKJRoundUnderlineTabIndicator(
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

  @override
  bool get wantKeepAlive => true;
}
