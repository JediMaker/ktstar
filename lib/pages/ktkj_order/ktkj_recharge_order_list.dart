import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:star/global_config.dart';
import 'package:star/http/ktkj_http_manage.dart';
import 'package:star/models/order_list_entity.dart';
import 'package:star/pages/ktkj_goods/ktkj_checkout_counter.dart';
import 'package:star/pages/ktkj_goods/ktkj_free_queue_persional.dart';
import 'package:star/pages/ktkj_goods/ktkj_pdd/ktkj_pdd_goods_detail.dart';
import 'package:star/pages/ktkj_order/ktkj_order_detail.dart';
import 'package:star/pages/ktkj_order/ktkj_order_logistics_tracking.dart';
import 'package:star/pages/ktkj_recharge/ktkj_recharge_list.dart';
import 'package:star/pages/ktkj_task/ktkj_task_index.dart';
import 'package:star/pages/ktkj_widget/ktkj_PriceText.dart';
import 'package:star/pages/ktkj_widget/ktkj_extra_coin_text.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_octoimage.dart';
import 'package:star/pages/ktkj_widget/ktkj_no_data.dart';
import 'package:star/utils/ktkj_common_utils.dart';
import 'package:star/utils/ktkj_navigator_utils.dart';
import 'package:url_launcher/url_launcher.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

///订单列表
class KTKJRechargeOrderListPage extends StatefulWidget {
  KTKJRechargeOrderListPage({Key key, this.orderSource}) : super(key: key);
  final String title = "我的订单";
  String orderSource = "1";

  @override
  _RechargeOrderListPageState createState() => _RechargeOrderListPageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _RechargeOrderListPageState extends State<KTKJRechargeOrderListPage>
    with AutomaticKeepAliveClientMixin {
  int page = 1;
  EasyRefreshController _refreshController;
  bool isFirstLoading = true;
  List<OrderListDataList> _orderList;
  String contactPhone = ""; //
  _initData() async {
    if (widget.orderSource == '-1') {
      return;
    }
    OrderListEntity result =
        await HttpManage.getOrderList(page, 10, widget.orderSource);
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
      KTKJCommonUtils.showToast(result.errMsg);
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
          ? KTKJNoDataPage()
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
    String orderSource = ""; //

    String orderNo = ""; //
    String btnTxt = ""; //
    Color btnTxtColor = Color(0xFF222222); //
    Color btnTxtBorderColor = Color(0xFF999999); //
    String orderStatus = "";
    String refundStatus = "0";
    String refundMsg = "";
    String orderStatusText = "";
    bool showContact = false;
    bool showBtn = true;
    bool _showItem = false;
    String orderType;
    String orderId;
    String goodsId;
    String goodsSign;
    String coin;
    String extraCoin;
    List<OrderListDataListGoodsList> goodsList =
        List<OrderListDataListGoodsList>();
    try {
      createTime = listItem.createTime;
      phoneNumber = listItem.mobile;
      phoneMoney = listItem.faceMoney;
      totalMoney = listItem.totalPrice;
      payMoney = listItem.payPrice;
      orderNo = listItem.orderno;
      orderType = listItem.orderType;
      orderId = listItem.orderId;
      orderStatus = listItem.status;
      refundStatus = listItem.refundStatus;
      refundMsg = listItem.refundMsg;
      contactPhone = listItem.phone;
      coin = listItem.coin;
      if (KTKJCommonUtils.isEmpty(listItem.tryCoin)) {
      } else {
        try {
          extraCoin = double.parse(listItem.tryCoin) != 0
              ? "￥${listItem.tryCoin}"
              : null;
        } catch (e) {}
      }

      goodsList = listItem.goodsList;
      try {
        if (!KTKJCommonUtils.isEmpty(goodsList)) {
          goodsSign = goodsList[0].goodsSign;
          goodsId = goodsList[0].goodsId;
          print("goodsSign=$goodsSign&&goodsId=$goodsId");
        }
      } catch (e) {}
    } catch (e) {}
//    orderSource = listItem.orderSource;
    if (orderType == "1") {
      //话费订单
      btnTxt = "再次充值";
      switch (orderStatus) {
        case "1":
          orderStatusText = "充值成功"; //chinaUnicom china_mobile china_telecom
          break;
        case "9":
          orderStatusText = "充值失败";
          if (refundStatus == "0") {
            showContact = true;
          } else if (refundStatus == "1") {
            orderStatusText = "话费退款";
            refundMsg = '退款审核中';
          } else if (refundStatus == "2") {
            orderStatusText = "话费退款";
            refundMsg = '退款已完成';
          } else if (refundStatus == "3") {
            orderStatusText = "话费退款";
            var newMsgTxt = "已拒绝,$refundMsg";
            refundMsg = newMsgTxt;
          }

          break;
        case "0":
          orderStatusText = "充值中";
          break;
      }
    } else if (orderType == "2" || orderType == "3") {
      //自营商城订单
      switch (orderStatus) {
        case "-1":
          orderStatusText = "已取消"; //chinaUnicom china_mobile china_telecom
          showBtn = false;
          break;
        case "0":
          orderStatusText = "未提交"; //chinaUnicom china_mobile china_telecom
          showBtn = false;
          break;
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
          btnTxtColor = Color(0xFFF93736); //
          btnTxtBorderColor = Color(0xFFF93736); //油卡充值
          break;
        case "5":
          orderStatusText = "已完成";
          showBtn = false;
          break;
        case "9":
          orderStatusText = "退款成功";
          showBtn = false;
          break;
      }
    } else if (orderType == "4") {
      switch (orderStatus) {
        case "8":
          orderStatusText = "已完成";
          showBtn = false;
          break;
      }
    } else {
      showBtn = false;
    }
    if (orderType == "3") {
      //拼多多订单
      showBtn = false;
    }

    ///仅展示现有的订单类型
    ///订单来源 1-平台自营 ，2-拼多多 ，3-美团订单 ，4-话费订单 ，5-商家订单 其它-全部
    switch (orderType) {
      case "1":
      case "2":
      case "3":
      case "4":
      case "5":
        _showItem = true;
        break;
    }
    return Visibility(
      visible: _showItem,
      child: GestureDetector(
        onTap: () {
          if (orderType == "3") {
            //拼多多平台订单
            if (KTKJCommonUtils.isEmpty(goodsList)) {
              return;
            }
            KTKJNavigatorUtils.navigatorRouter(
                context,
                KTKJPddGoodsDetailPage(
                  gId: goodsId,
                  goodsSign: goodsSign,
//                searchId: searchId,
                ));
            return;
          }
          if (orderType == "2") {
            //自营商城订单
            KTKJNavigatorUtils.navigatorRouter(
                context,
                KTKJOrderDetailPage(
                  orderId: orderId,
                ));
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: KTKJGlobalConfig.LAYOUT_MARGIN,
              vertical: ScreenUtil().setHeight(16)),
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
                        color: Color(0xff222222),
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
                            ? Container(
                                child: Text(''),
                              )
                            : List.generate(goodsList.length, (index) {
                                return buildRechargeItemRow(phoneNumber,
                                    phoneMoney, goodsList[index], refundMsg);
                              }),
                      );
                      break;
                    case "2": //商品订单
                      return buildGoodsList(goodsList);
                      break;
                    case "3": //拼多多订单
                      return buildGoodsList(goodsList);
                      break;
                    case "4": //美团订单
                      return buildGoodsList(goodsList);
                      break;
                    default:
                      return buildGoodsList(goodsList);
                      break;
                  }
                },
              ),
              Container(
                alignment: Alignment.centerRight,
                child: KTKJExtraCoinTextPage(
                  borderRadius: 15,
                  coinDescFontSize: ScreenUtil().setSp(32),
                  coinFontSize: ScreenUtil().setSp(32),
                  height: ScreenUtil().setWidth(62),
                  rightMargin: 0,
                  coin: extraCoin,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    //状态：
                    "分红金 ",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(32),
                      color: Color(0xFF999999),
                    ),
                  ),
                  PriceText(
                    text: "$coin",
                    textColor: Color(0xFF999999),
                    fontSize: ScreenUtil().setSp(32),
                    fontBigSize: ScreenUtil().setSp(42),
                    fontWeight: FontWeight.normal,
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(29),
                  ),
                  Text(
                    //状态：
                    "总价 ",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(32),
                      color: Color(0xFF999999),
                    ),
                  ),
                  PriceText(
                    text: "$totalMoney",
                    textColor: Color(0xFF999999),
                    fontSize: ScreenUtil().setSp(32),
                    fontBigSize: ScreenUtil().setSp(42),
                    fontWeight: FontWeight.normal,
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(29),
                  ),
                  Text(
                    //状态：
                    "实付款 ",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(32),
                    ),
                  ),
                  PriceText(
                    text: "$payMoney",
                    textColor: Color(0xff222222),
                    fontSize: ScreenUtil().setSp(32),
                    fontBigSize: ScreenUtil().setSp(42),
                    fontWeight: FontWeight.normal,
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(37),
              ),
              Divider(
                height: ScreenUtil().setHeight(1),
                color: Color(0xFFefefef),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(37),
              ),
              Visibility(
                visible: showContact,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        var result = await HttpManage.chargeRefund(orderId);
                        if (result.status) {
                          KTKJCommonUtils.showToast("申请已提交");
                          page = 1;
                          _initData();
                          _refreshController.finishLoad(noMore: false);
                        } else {
                          KTKJCommonUtils.showToast("${result.errMsg}");
                        }
                      },
                      child: Container(
                        width: ScreenUtil().setWidth(235),
                        height: ScreenUtil().setHeight(77),
                        margin: EdgeInsets.only(
                          right: ScreenUtil().setWidth(20),
                        ),
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
                          "申请退款",
                          style: TextStyle(
                            color: btnTxtColor,
                            fontSize: ScreenUtil().setSp(42),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        var result = await HttpManage.chargeRetry(orderId);
                        if (result.status) {
                          KTKJCommonUtils.showToast("申请已提交");
                          page = 1;
                          _initData();
                          _refreshController.finishLoad(noMore: false);
                        } else {
                          KTKJCommonUtils.showToast("${result.errMsg}");
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
                          "重新充值",
                          style: TextStyle(
                            color: btnTxtColor,
                            fontSize: ScreenUtil().setSp(42),
                          ),
                        ),
                      ),
                    ),
                    /*Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "联系我们：$contactPhone",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(42),
                          ),
                        )),*/
                  ],
                ),
              ),
              Visibility(
                visible: !showContact,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Visibility(
//                      visible: orderType == "1",
                        child: Container(
                            child: Text(
                          "订单编号：$orderNo",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(32),
                              color: Color(0xff666666)),
                        )),
                      ),
                    ),
                    Visibility(
                      visible: orderType == "2" &&
                          orderStatus != '1' &&
                          orderStatus != '-1',
                      child: GestureDetector(
                        onTap: () async {
                          KTKJNavigatorUtils.navigatorRouter(
                              context,
                              KTKJOrderLogisticsTrackingPage(
                                orderId: orderId,
                              ));
                        },
                        child: Container(
                          width: ScreenUtil().setWidth(235),
                          height: ScreenUtil().setHeight(77),
                          margin: EdgeInsets.only(
                            right: ScreenUtil().setWidth(16),
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(39))),
                              border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                                  color: Color(0xFF999999),
                                  width: 0.5)),
                          child: Text(
                            //状态：
                            "查看物流",
                            style: TextStyle(
                              color: Color(0xFF222222),
                              fontSize: ScreenUtil().setSp(42),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: showBtn,
                      child: GestureDetector(
                        onTap: () async {
                          if (orderType == "1") {
                            KTKJNavigatorUtils.navigatorRouter(
                                context, KTKJRechargeListPage());
                          } else if (orderType == "2") {
                            switch (orderStatus) {
                              case "1":
                                /* if (Platform.isIOS) {
                                  KTKJCommonUtils.showIosPayDialog();
                                  return;
                                }*/
                                KTKJNavigatorUtils.navigatorRouter(
                                    context,
                                    KTKJCheckOutCounterPage(
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
                    Visibility(
                      visible: orderType == "3" && orderStatusText == "待收货",
                      child: GestureDetector(
                        onTap: () async {
                          ///打开拼多多
                          var url = "pinduoduo://";
                          if (await canLaunch(url) != null) {
                            await launch(url, forceSafariVC: false);
                          } else {
//      throw 'Could not launch $url';
                          }
                        },
                        child: Container(
                          height: ScreenUtil().setHeight(77),
                          alignment: Alignment.center,
                          /* decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(39))),
                              border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                                  color: btnTxtBorderColor,
                                  width: 0.5)),*/
                          child: Text(
                            //状态：
                            "前往拼多多确认收货",
                            style: TextStyle(
                              color: btnTxtColor,
                              fontSize: ScreenUtil().setSp(32),
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
            /* if (!KTKJCommonUtils.isEmpty(result.errMsg)) {
              KTKJCommonUtils.showToast(result.errMsg);
            }*/
            Navigator.pop(context, false);
            KTKJNavigatorUtils.navigatorRouterAndRemoveUntil(
                context, KTKJTaskIndexPage());
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
            if (!KTKJCommonUtils.isEmpty(result.errMsg)) {
              KTKJCommonUtils.showToast(result.errMsg);
            }
            Navigator.pop(context, false);
            if (result.status) {
              KTKJNavigatorUtils.navigatorRouter(
                  context, KTKJFreeQueuePersonalPage());
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
              KTKJCommonUtils.showToast("确认收货成功");
              /*showDialog<bool>(
                context: context,
                builder: (BuildContext context) =>
                    _buildDialog(context, orderId),
                barrierDismissible: false,
              );*/
              page = 1;
              _initData();
              _refreshController.finishLoad(noMore: false);
            } else {
              KTKJCommonUtils.showToast("${result.errMsg}");
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setWidth(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: KTKJMyOctoImage(
                          fadeInDuration: Duration(milliseconds: 0),
                          fadeOutDuration: Duration(milliseconds: 0),
                          fit: BoxFit.fill,
                          width: ScreenUtil().setWidth(243),
                          height: ScreenUtil().setWidth(243),
                          image:
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
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            product.goodsName == null ? "" : product.goodsName,
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
                              product.specItem == null ? "" : product.specItem,
//                                  item.wareName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(38),
                                color: Color(0xff666666),
                              ),
                            ),
                            margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(18)),
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
                          /* SizedBox(
                                height: ScreenUtil().setWidth(16),
                              ),*/
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
      OrderListDataListGoodsList goodsItem, String refundMsg) {
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
        KTKJMyOctoImage(
          image: "$imageUrl",
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
              Visibility(
                visible: !KTKJCommonUtils.isEmpty(refundMsg),
                child: Column(
                  children: [
                    SizedBox(
                      height: ScreenUtil().setHeight(12),
                    ),
                    Container(
                      child: Text(
                        //状态：
                        "退款描述：$refundMsg",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(30),
                          color: Color(0xFF999999),
                        ),
                      ),
                    ),
                  ],
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

  @override
  bool get wantKeepAlive => true;
}
