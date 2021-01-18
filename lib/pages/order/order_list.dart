import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:star/pages/order/recharge_order_list.dart';

import '../../global_config.dart';

class OrderListPage extends StatefulWidget {
  OrderListPage({Key key}) : super(key: key);
  final String title = "我的订单";

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(
        vsync: this, length: orderType == null ? 0 : orderType.length);
  }

  @override
  void dispose() {
    super.dispose();
  }

  var orderType = [
    '自营',
    '拼多多',
  ];

//订单类型
  List<Widget> buildTabs() {
    List<Widget> tabs = <Widget>[];
    if (orderType != null) {
      for (var classify in orderType) {
        tabs.add(Container(
          height: 20,
          child: Tab(
            child: Text(
              "$classify",
              style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
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
      for (var classify in orderType) {
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
        tabViews.add(RechargeOrderListPage());
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
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(5),
          child: TabBar(
            controller: _tabController,
            indicatorColor: Color(0xffF93736),
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: orderType.length > 4 ? true : false,
            labelColor: Color(0xffF93736),
            unselectedLabelColor: Colors.black,
            tabs: buildTabs(),
          ),
        ),
      ),
      body: TabBarView(
        controller: this._tabController,
        children: buildTabViews(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  bool get wantKeepAlive => true;
}
