import 'package:star/pages/widget/my_octoimage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/shop_order_list_entity.dart';
import 'package:star/pages/merchantssettle/shop_qrcode.dart';
import 'package:star/pages/widget/no_data.dart';
import 'package:star/pages/widget/round_tab_indicator.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedShopBackstagePage extends StatefulWidget {
  var shopId;

  KeTaoFeaturedShopBackstagePage({Key key, this.shopId = ''}) : super(key: key);
  final String title = "商家后台";

  @override
  _ShopBackstagePageState createState() => _ShopBackstagePageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _ShopBackstagePageState extends State<KeTaoFeaturedShopBackstagePage>
    with TickerProviderStateMixin {
  var _receivedPayNum = '0';
  var _receivedMoney = '0';
  var _qrCodeUrl = '';

  TabController _tabController;
  List<Widget> _tabViews;
  List<String> _tabValues;

  _initShopBackStageData() async {
    var result = await HttpManage.getShopBackStageInfo(shopId: widget.shopId);
    if (result.status) {
      if (mounted) {
        setState(() {
          try {
            _receivedMoney = result.data.todayAmount;
            _receivedPayNum = result.data.todayOrders;
            _qrCodeUrl = result.data.storeQrcode;
          } catch (e) {
            print(e);
          }
        });
      }
    } else {}
  }

  @override
  void initState() {
    super.initState();
    _initShopBackStageData();
    _tabValues = [
      '全部',
      '昨日',
      '近一周',
      '月收款',
    ];
    _tabViews = [
      ShopOrderTabView(
        tab: "0",
        shopId: widget.shopId,
      ),
      ShopOrderTabView(
        tab: "1",
        shopId: widget.shopId,
      ),
      ShopOrderTabView(
        tab: "2",
        shopId: widget.shopId,
      ),
      ShopOrderTabView(
        tab: "3",
        shopId: widget.shopId,
      ),
    ];
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  var _bgColor = Color(0xffF32E43);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                widget.title,
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(54)),
              ),
              leading: IconButton(
                icon: Container(
                  width: ScreenUtil().setWidth(63),
                  height: ScreenUtil().setHeight(63),
                  child: Center(
                    child: Image.asset(
                      "static/images/icon_ios_back_white.png",
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
              brightness: Brightness.dark,
              backgroundColor: _bgColor,
              elevation: 0,
            ),
            body: Container(
              child: Stack(
//                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: ScreenUtil().setWidth(368),
                    alignment: Alignment.bottomCenter,
                    color: _bgColor,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(30),
                      ),
                      margin: EdgeInsets.only(
                        top: ScreenUtil().setWidth(120),
                      ),
                      child: Row(
                        children: [
                          buildItemDesc(
                              content: "$_receivedPayNum", desc: "今日收款笔数"),
                          buildItemDesc(
                              content: "$_receivedMoney", desc: "今日收款"),
                          buildItemDesc(
                              content:
                                  "https://alipic.lanhuapp.com/xd9ca01692-8703-44b2-a4e5-5e18ee16500a",
                              desc: "收款二维码"),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: double.maxFinite,
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setWidth(310),
                      left: ScreenUtil().setWidth(30),
                      right: ScreenUtil().setWidth(30),
                      bottom: ScreenUtil().setWidth(48),
                    ),
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          ScreenUtil().setWidth(30),
                        ),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                ScreenUtil().setWidth(30),
                              ),
                            ),
                          ),
                          child: Center(
                            child: TabBar(
                              tabs: _tabValues.map((f) {
                                return Container(
                                  height: ScreenUtil().setWidth(60),
                                  alignment: Alignment.center,
                                  child: Text(
                                    f,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(38),
                                    ),
                                  ),
                                );
                              }).toList(),
                              controller: _tabController,
                              indicatorColor: Color(0xffF32E43),
                              indicatorSize: TabBarIndicatorSize.label,
                              isScrollable:
                                  _tabValues.length > 4 ? true : false,
                              labelColor: Color(0xff222222),
                              labelStyle: TextStyle(
                                fontSize: ScreenUtil().setSp(38),
                                fontWeight: FontWeight.bold,
                              ),
                              unselectedLabelColor: Color(0xff666666),
                              unselectedLabelStyle: TextStyle(
                                fontSize: ScreenUtil().setSp(38),
                                fontWeight: FontWeight.normal,
                              ),
                              indicatorPadding:
                                  EdgeInsets.only(top: 4, bottom: 2),
                              indicator: KeTaoFeaturedRoundUnderlineTabIndicator(
                                  borderSide: BorderSide(
                                width: 3.5,
                                color: Color(0xffF32E43),
                              )),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: _tabViews,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ) // This trailing comma makes auto-formatting nicer for build methods.
            ));
  }

  Widget buildItemDesc({
    String content,
    String desc,
  }) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (!KeTaoFeaturedCommonUtils.isEmpty(content) && content.startsWith("http")) {
            ///跳转收款二维码页面
            KeTaoFeaturedNavigatorUtils.navigatorRouter(
                context,
                KeTaoFeaturedShopQrCodePage(
                  qrCodeUrl: _qrCodeUrl,
                ));
          }
        },
        child: Column(
          children: [
            Visibility(
              visible:
                  !KeTaoFeaturedCommonUtils.isEmpty(content) && !content.startsWith("http"),
              child: Container(
                height: ScreenUtil().setWidth(78),
                child: Text(
                  "$content",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(56),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Visibility(
              visible:
                  !KeTaoFeaturedCommonUtils.isEmpty(content) && content.startsWith("http"),
              child: Container(
                margin: EdgeInsets.only(
                  bottom: ScreenUtil().setWidth(22),
                ),
                child: Container(
                  width: ScreenUtil().setWidth(56),
                  height: ScreenUtil().setWidth(56),
                  child: KeTaoFeaturedMyOctoImage(
                    image: "$content",
                    width: ScreenUtil().setWidth(56),
                    height: ScreenUtil().setWidth(56),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Container(
              child: Text(
                "$desc",
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(36),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShopOrderTabView extends StatefulWidget {
  ///[tab] 	列表类型 0全部 1昨日 2近一周 3近一月
  String tab;
  var shopId;

  ShopOrderTabView({Key key, this.tab = "", this.shopId = false})
      : super(key: key);

  @override
  _ShopOrderTabViewState createState() => _ShopOrderTabViewState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _ShopOrderTabViewState extends State<ShopOrderTabView>
    with AutomaticKeepAliveClientMixin {
  int page = 1;
  EasyRefreshController _refreshController;
  bool isFirstLoading = true;
  List<ShopOrderListDataList> _shopOrderList;

  _initData() async {
    var result = await HttpManage.getShopOrderList(
        page: page, pageSize: 10, tab: widget.tab, shopId: widget.shopId);
    if (result.status) {
      if (mounted) {
        setState(() {
          if (page == 1) {
            _shopOrderList = result.data.xList;
          } else {
            if (result == null ||
                result.data == null ||
                result.data.xList == null ||
                result.data.xList.length == 0) {
              //              _refreshController.resetLoadState();
              _refreshController.finishLoad(noMore: true);
            } else {
              _shopOrderList += result.data.xList;
            }
          }
          isFirstLoading = false;
        });
      }
    } else {
      KeTaoFeaturedCommonUtils.showToast(result.errMsg);
    }
  }

  @override
  void initState() {
    _refreshController = EasyRefreshController();
    _initData();
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.custom(
      topBouncing: false,
      bottomBouncing: false,
      header: MaterialHeader(),
      footer: MaterialFooter(),
      enableControlFinishLoad: true,
      enableControlFinishRefresh: true,
      controller: _refreshController,
      onRefresh: () {
        page = 1;
        _initData();
        _refreshController.finishLoad(noMore: false);
      },
      onLoad: () {
        if (!isFirstLoading) {
          page++;
          _initData();
        }
      },
      emptyWidget: _shopOrderList == null || _shopOrderList.length == 0
          ? KeTaoFeaturedNoDataPage()
          : null,
      slivers: <Widget>[buildCenter()],
    );
  }

  Widget buildCenter() {
    return SliverToBoxAdapter(
      child: Container(
        child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            ShopOrderListDataList listItem = _shopOrderList[index];
            return buildItemLayout(listItem: listItem);
          },
          itemCount: _shopOrderList == null ? 0 : _shopOrderList.length,
          separatorBuilder: (context, index) {
            return Center(
              child: Container(
                height: ScreenUtil().setWidth(1),
                width: double.maxFinite,
                margin: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(20),
                ),
                color: Color(0xffE6E5E5),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildItemLayout({ShopOrderListDataList listItem}) {
    String text = "";
    String headUrl;
    String nickName;
    String payTime;
    String payMoney;

    ///账户类型 0普通用户 1体验用户 2VIP用户 3 钻石用户
    String userType;
    //微股东类型
    String shareHolderType;
    String completeTaskNum = '';
    String totalTaskNum = '';
    bool taskComplete = false;
    /*switch (userType) {
      case "0":
        text = "普通会员";
        break;
      case "1":
        text = "体验会员";
        break;
      case "2":
        text = "钻石vip";
        break;
      case "3":
        text = "代理";
        break;
    }*/
    try {
//      headUrl = listItem.avatar;
      nickName = listItem.username;
      payTime = listItem.payTime;
      payMoney = listItem.payPrice;
//      bindTime = listItem.createdTime;
//      userType = listItem.isVip;
//      shareHolderType = listItem.isPartner;
//      completeTaskNum = listItem.completeCount;
//      totalTaskNum = listItem.totalCount;
//      taskComplete = listItem.completeStatus == "2";
    } catch (e) {}
    return ListTile(
      onTap: () async {},
      title: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                "${nickName == null ? '' : nickName}",
                overflow: TextOverflow.ellipsis,
                /*style: TextStyle(
                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(42)),*/
                style: TextStyle(
                    color: Color(0xFF222222),
//                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(42)),
                maxLines: 1,
              ),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(26),
            ),
//            Image.asset("", width:)
          ],
        ),
      ),
      subtitle: Row(
        children: <Widget>[
          Text(
            "${payTime == null ? '' : payTime}",
            style: TextStyle(
                color: Color(0xFF999999), fontSize: ScreenUtil().setSp(36)),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(26),
          ),
          Visibility(
            visible: false,
            child: Container(
              width: ScreenUtil().setWidth(98),
              height: ScreenUtil().setWidth(49),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: !taskComplete ? Color(0xffFFE1E1) : Color(0xffE1EAFF),
                borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().setWidth(25))),
                border: Border.all(
                    color:
                        !taskComplete ? Color(0xffFFE1E1) : Color(0xffE1EAFF),
                    width: 0.5),
              ),
              child: Text(
                "${'$completeTaskNum/$totalTaskNum'}",
                style: TextStyle(
                    color:
                        !taskComplete ? Color(0xffF32E43) : Color(0xff2E5CF3),
                    fontSize: ScreenUtil().setSp(36)),
              ),
            ),
          ),
        ],
      ),
      trailing: GestureDetector(
        child: Text(
          "+ ${payMoney == null ? '' : payMoney}",
          style: TextStyle(
              color: Color(0xFF222222),
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil().setSp(42)),
        ),
      ),
    );
  }

  String _getImgName(_type) {
//    账户类型 1见习股东 2普通用户 3vip股东 4高级股东
    switch (_type) {
      case "1":
        return "https://alipic.lanhuapp.com/xd5002e038-9179-4c95-9a49-09e0d0e53590";
      case "2":
        return "https://alipic.lanhuapp.com/xd5fafac9d-1d56-49a0-b658-04a43e50582a";
      case "3":
        return "https://alipic.lanhuapp.com/xdf964acde-df69-493b-8547-ce8bf626e734";
      case "4":
        return "https://alipic.lanhuapp.com/xd533cce7c-b6f4-47fc-9051-2c3d186e1df4";
    }
    return "";
  }

  @override
  bool get wantKeepAlive => true;
}
