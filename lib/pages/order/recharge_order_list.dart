import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/message_list_entity.dart';
import 'package:star/models/order_detail_entity.dart';
import 'package:star/models/order_list_entity.dart';
import 'package:star/models/phone_charge_list_entity.dart';
import 'package:star/pages/goods/checkout_counter.dart';
import 'package:star/pages/goods/free_queue_persional.dart';
import 'package:star/pages/goods/goods_detail.dart';
import 'package:star/pages/order/order_detail.dart';
import 'package:star/pages/recharge/recharge_list.dart';
import 'package:star/pages/task/task_index.dart';
import 'package:star/pages/widget/no_data.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';

import '../../global_config.dart';

class RechargeOrderListPage extends StatefulWidget {
  RechargeOrderListPage({Key key}) : super(key: key);
  final String title = "我的订单";

  @override
  _RechargeOrderListPageState createState() => _RechargeOrderListPageState();
}

class _RechargeOrderListPageState extends State<RechargeOrderListPage> {
  int page = 1;
  EasyRefreshController _refreshController;
  bool isFirstLoading = true;
  List<OrderListDataList> _orderList;
  String contactPhone = ""; //
  _initData() async {
    OrderListEntity result = await HttpManage.getOrderList(page, 10);
    if (result.status) {
      if (mounted) {
        setState(() {
          if (page == 1) {
            _orderList = result.data.xList;
          } else {
            if (result == null ||
                result.data == null ||
                result.data.xList == null ||
                result.data.xList.length == 0) {
              //              _refreshController.resetLoadState();
              _refreshController.finishLoad(noMore: true);
            } else {
              _orderList += result.data.xList;
            }
          }
          isFirstLoading = false;
        });
      }
    } else {
      CommonUtils.showToast(result.errMsg);
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
          backgroundColor: GlobalConfig.taskNomalHeadColor,
          elevation: 0,
        ),
        body: EasyRefresh.custom(
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
          emptyWidget: _orderList == null || _orderList.length == 0
              ? NoDataPage()
              : null,
          slivers: <Widget>[buildCenter()],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget buildCenter() {
    return SliverToBoxAdapter(
      child: Container(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            OrderListDataList listItem = _orderList[index];
            return buildItemLayout(listItem: listItem);
          },
          itemCount: _orderList == null ? 0 : _orderList.length,
        ),
      ),
    );
  }

  buildItemLayout({OrderListDataList listItem}) {
    String createTime = "";
    String phoneNumber = "";
    String phoneMoney = "";
    String totalMoney = "";
    String payMoney = ""; //

    String orderNo = ""; //
    String btnTxt = ""; //
    Color btnTxtColor = Color(0xFF222222); //
    Color btnTxtBorderColor = Color(0xFF999999); //
    String orderStatus = "";
    String orderStatusText = "";
    bool showContact = false;
    bool showBtn = true;
    String orderType;
    String orderId;
    List<OrderListDataListGoodsList> goodsList =
        List<OrderListDataListGoodsList>();
    createTime = listItem.createTime;
    phoneNumber = listItem.mobile;
    phoneMoney = listItem.faceMoney;
    totalMoney = listItem.totalPrice;
    payMoney = listItem.payPrice;
    orderNo = listItem.orderno;
    orderType = listItem.orderType;
    orderId = listItem.orderId;
    orderStatus = listItem.status;
    contactPhone = listItem.phone;
    goodsList = listItem.goodsList;
    if (orderType == "1") {
      btnTxt = "再次充值";
      switch (orderStatus) {
        case "1":
          orderStatusText = "充值成功"; //chinaUnicom china_mobile china_telecom
          break;
        case "9":
          orderStatusText = "充值失败";
          showContact = true;
          break;
        case "0":
          orderStatusText = "充值中";
          break;
      }
    } else if (orderType == "2") {
      switch (orderStatus) {
        case "1":
          orderStatusText = "待付款"; //chinaUnicom china_mobile china_telecom
          btnTxt = "去付款";
          break;
        case "2":
          orderStatusText = "待发货";
          showBtn = false;
          break;
        case "3":
          orderStatusText = "待收货";
          btnTxt = "确认收货";
          btnTxtColor = Colors.redAccent; //
          btnTxtBorderColor = Colors.redAccent; //
          break;
        case "5":
          orderStatusText = "已完成";
          showBtn = false;
          break;
      }
    }
    return GestureDetector(
      onTap: () {
        if (orderType == "2") {
          NavigatorUtils.navigatorRouter(
              context,
              OrderDetailPage(
                orderId: orderId,
              ));
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: 16, vertical: ScreenUtil().setHeight(16)),
        padding: EdgeInsets.all(ScreenUtil().setWidth(32)),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setWidth(30))),
            border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                color: Colors.white,
                width: 0.5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "创建：$createTime",
                        style: TextStyle(
//                color:  Color(0xFF222222) ,
                            fontSize: ScreenUtil().setSp(32)),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Text(
                    orderStatusText,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(36),
                      color: Color(0xffFD8B4E),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
            Builder(
              builder: (context) {
                switch (orderType) {
                  case "1": //话费订单
                    return Column(
                      children: goodsList == null
                          ? Container()
                          : List.generate(goodsList.length, (index) {
                              return buildRechargeItemRow(
                                  phoneNumber, phoneMoney, goodsList[index]);
                            }),
                    );
                    break;
                  case "2": //商品订单
                    return buildGoodsList(goodsList);
                    break;
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  //状态：
                  "总价",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(42),
                    color: Color(0xFF999999),
                  ),
                ),
                Text(
                  //状态：
                  " ￥ ",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(30),
                    color: Color(0xFF999999),
                  ),
                ),
                Text(
                  //状态：
                  "$totalMoney",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(42),
                    color: Color(0xFF999999),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(29),
                ),
                Text(
                  //状态：
                  "实付款",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(42),
                  ),
                ),
                Text(
                  //状态：
                  " ￥ ",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(30),
                  ),
                ),
                Text(
                  //状态：
                  "$payMoney",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(42),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: ScreenUtil().setHeight(37),
            ),
            Divider(
              height: ScreenUtil().setHeight(1),
              color: Color(0xFFdddddd),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(37),
            ),
            Visibility(
              visible: showContact,
              child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "联系我们：$contactPhone",
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(42),
                    ),
                  )),
            ),
            Visibility(
              visible: !showContact,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        child: Text(
                      "订单编号：$orderNo",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(32),
                          color: Color(0xff666666)),
                    )),
                  ),
                  Visibility(
                    visible: showBtn,
                    child: GestureDetector(
                      onTap: () async {
                        if (Platform.isIOS) {
                          CommonUtils.showIosPayDialog();
                          return;
                        }
                        if (orderType == "1") {
                          NavigatorUtils.navigatorRouter(
                              context, RechargeListPage());
                        } else if (orderType == "2") {
                          switch (orderStatus) {
                            case "1":
                              NavigatorUtils.navigatorRouter(
                                  context,
                                  CheckOutCounterPage(
                                    orderId: orderId,
                                    orderMoney: payMoney,
                                  ));
                              break;
                            case "2":
                              break;
                            case "3":
                              showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildReceiveDialog(context, orderId),
                                barrierDismissible: false,
                              );
                              break;
                            case "5":
                              orderStatusText = "已完成";
                              break;
                          }
                        }
                      },
                      child: Container(
                        width: ScreenUtil().setWidth(235),
                        height: ScreenUtil().setHeight(77),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(ScreenUtil().setWidth(39))),
                            border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                                color: btnTxtBorderColor,
                                width: 0.5)),
                        child: Text(
                          //状态：
                          "$btnTxt",
                          style: TextStyle(
                            color: btnTxtColor,
                            fontSize: ScreenUtil().setSp(42),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDialog(BuildContext context, orderId) {
    return CupertinoAlertDialog(
      title: Text('提示'),
      content: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          '当前订单商品可参与消费补贴，获取现金补贴,是否参与排队补贴？',
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(
            '返回首页',
            style: TextStyle(
              color: Color(0xff222222),
              fontSize: ScreenUtil().setSp(42),
            ),
          ),
          onPressed: () async {
            var result = await HttpManage.orderIsJoinQueue(orderId, "2");
            /* if (!CommonUtils.isEmpty(result.errMsg)) {
              CommonUtils.showToast(result.errMsg);
            }*/
            Navigator.pop(context, false);
            NavigatorUtils.navigatorRouterAndRemoveUntil(
                context, TaskIndexPage());
          },
        ),
        CupertinoDialogAction(
          child: Text(
            '加入排队',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(42),
            ),
          ),
          onPressed: () async {
            var result = await HttpManage.orderIsJoinQueue(orderId, "1");
            if (!CommonUtils.isEmpty(result.errMsg)) {
              CommonUtils.showToast(result.errMsg);
            }
            Navigator.pop(context, false);
            if (result.status) {
              NavigatorUtils.navigatorRouter(context, FreeQueuePersonalPage());
            }
          },
        ),
      ],
    );
  }

  Widget _buildReceiveDialog(BuildContext context, orderId) {
    return CupertinoAlertDialog(
      title: Text('提示'),
      content: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          '是否确认收货？',
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(
            '取消',
            style: TextStyle(
              color: Color(0xff222222),
              fontSize: ScreenUtil().setSp(42),
            ),
          ),
          onPressed: () async {
            Navigator.pop(context, false);
          },
        ),
        CupertinoDialogAction(
          child: Text(
            '确定',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(42),
            ),
          ),
          onPressed: () async {
            //确认收货

            var result = await HttpManage.orderConfirm(orderId);
            if (result.status) {
              Navigator.pop(context, false);
              CommonUtils.showToast("确认收货成功");
              showDialog<bool>(
                context: context,
                builder: (BuildContext context) =>
                    _buildDialog(context, orderId),
                barrierDismissible: false,
              );
              page = 1;
              _initData();
              _refreshController.finishLoad(noMore: false);
            } else {
              CommonUtils.showToast("${result.errMsg}");
            }
          },
        ),
      ],
    );
  }

  Widget buildGoodsList(List<OrderListDataListGoodsList> goodsList) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          OrderListDataListGoodsList product = goodsList[index];
          return Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: CachedNetworkImage(
                          fadeInDuration: Duration(milliseconds: 0),
                          fadeOutDuration: Duration(milliseconds: 0),
                          fit: BoxFit.fill,
                          width: ScreenUtil().setWidth(243),
                          height: ScreenUtil().setWidth(243),
                          imageUrl:
                              product.goodsImg == null ? "" : product.goodsImg,
                          /*   imageUrl: item.imageUrl,
                                  width: ScreenUtil().L(120),
                                  height: ScreenUtil().L(120),*/
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              product.goodsName == null
                                  ? ""
                                  : product.goodsName,
//                                  item.wareName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xff222222),
                                fontSize: ScreenUtil().setSp(42),
                              ),
                            ),
                            Container(
                              child: Text(
                                product.specItem == null
                                    ? ""
                                    : product.specItem,
//                                  item.wareName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(38),
                                  color: Color(0xff666666),
                                ),
                              ),
                              margin: EdgeInsets.only(top: ScreenUtil().setHeight(18)),
                            ),
                            /*Wrap(
                            children: product.option.map((op) {
                              return Container(
                                child: Text(
                                  "${op.value} ",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              );
                            }).toList(),
                          ),*/
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: Row(
//                            crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
//                              Expanded(child:,),
                                    Flexible(
                                      child: Text(
                                        '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(),
                                      ),
//                                flex: 2,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "￥${product.salePrice == null ? "" : product.salePrice}",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(42),
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFF93736),
                                      ),
                                    ),
                                  ],
                                )),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'x${product.goodsNum}',
                                    style: TextStyle(
                                      color: Color(0xff222222),
                                      fontSize: ScreenUtil().setSp(36),
                                    ),
                                  ),
                                ),
//                            Icon(
//                              Icons.more_horiz,
//                              size: 15,
//                              color: Color(0xFF979896),
//                            ),
                              ],
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        itemCount: goodsList == null ? 0 : goodsList.length);
  }

  Widget buildRechargeItemRow(String phoneNumber, String phoneMoney,
      OrderListDataListGoodsList goodsItem) {
    var imageUrl = '';
    var title = '';
    var saleMoney = '';
    try {
      imageUrl = goodsItem.goodsImg;
      saleMoney = goodsItem.salePrice;
    } catch (e) {}
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CachedNetworkImage(
          imageUrl: "$imageUrl",
          width: ScreenUtil().setWidth(243),
          height: ScreenUtil().setWidth(243),
          fit: BoxFit.fill,
        ),
        SizedBox(
          width: ScreenUtil().setWidth(29),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                child: Text(
                  //状态：
                  goodsItem.goodsName,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(42),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(12),
              ),
              Container(
                child: Text(
                  //状态：
                  "充值号码：$phoneNumber",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(30),
                    color: Color(0xFF999999),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(12),
              ),
              Container(
                child: Text(
                  //状态：
                  "充值金额：$phoneMoney 元",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(30),
                    color: Color(0xFF999999),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: ScreenUtil().setWidth(29),
        ),
        Container(
          width: ScreenUtil().setWidth(200),
          alignment: Alignment.centerRight,
          child: Text(
            "￥$saleMoney",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(42),
            ),
          ),
        ),
      ],
    );
  }
}
