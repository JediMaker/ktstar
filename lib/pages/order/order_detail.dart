import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/order_detail_entity.dart';
import 'package:star/pages/goods/goods_detail.dart';
import 'package:star/pages/order/order_logistics_tracking.dart';
import 'package:star/pages/order/return/return_option.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';

import '../../global_config.dart';

class OrderDetailPage extends StatefulWidget {
  OrderDetailPage({Key key, this.orderId}) : super(key: key);
  final String title = "订单详情";
  String orderId;

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  OrderDetailEntity entity;
  String orderStatus;
  String orderNum;
  String dateAdded;
  String defProductId;
  int sum;
  var total;
  var addressDetail = "";
  var iphone = "";
  var name = "";
  var totalPrice = "";
  var payment = "";
  var _payWayText = "--";
  var payPrice;
  var orderStatusText = '';

  String payTime;
  String sendTime;
  String confirmTime;
  String sendName;
  String sendNumber;
  List<OrderDetailDataGoodsList> goodsList;

  Future _initData({bool onlyChangeAddress = false}) async {
    EasyLoading.show();
    var entityResult = await HttpManage.orderDetail(widget.orderId);
/*
    OrderCheckoutEntity entityResult =
        await HttpManage.orderCheckout(widget.cartIdList);
*/
    try {
      if (mounted) {
        setState(() {
          entity = entityResult;
          addressDetail = entityResult.data.address;
          iphone = entityResult.data.mobile;
          name = entityResult.data.consignee;
          goodsList = entityResult.data.goodsList;
          totalPrice = entityResult.data.totalPrice;
          payPrice = entityResult.data.payPrice;
          orderNum = entityResult.data.orderno;
          payment = entityResult.data.payment;
          dateAdded = entityResult.data.createTime;
          payTime = entityResult.data.payTime;
          sendTime = entityResult.data.sendTime;
          confirmTime = entityResult.data.confirmTime;
          sendName = entityResult.data.sendName;
          sendNumber = entityResult.data.sendNumber;
          orderStatus = entityResult.data.status.toString();
          if (!CommonUtils.isEmpty(goodsList) && goodsList.length > 0) {
            try {
              defProductId = goodsList[0].goodsId;
            } catch (e) {}
          }
          sum = goodsList.length;

          switch (orderStatus) {
            case "1":
              orderStatusText = "待付款"; //chinaUnicom china_mobile china_telecom
              break;
            case "2":
              orderStatusText = "待发货";
              break;
            case "3":
              orderStatusText = "待收货";
              break;
            case "5":
              orderStatusText = "已完成";
              break;
          }
          if (orderStatus != "1") {
            switch (payment) {
              case "2":
                _payWayText = "微信支付"; //chinaUnicom china_mobile china_telecom
                break;
              case "1":
                _payWayText = "支付宝支付";
                break;
              case "3":
                _payWayText = "余额支付";
                break;
            }
          }
        });
      }
    } catch (e) {}
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    _initData();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.title,
              style: TextStyle(
                  color: Color(0xFF222222), fontSize: ScreenUtil().setSp(54)),
            ),
            brightness: Brightness.light,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(
                  ScreenUtil().setHeight(ScreenUtil().setHeight(5))),
              child: CachedNetworkImage(
                imageUrl:
                    "https://alipic.lanhuapp.com/xd1503b270-f796-4b53-8146-3ba0d3a09a34",
              ),
            ),
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
          body: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 50),
                child: CustomScrollView(
                  slivers: <Widget>[
                    buildAddressInfoContainer(),
                    buildGoodsList(),
                    buildTotalBox(),
                    buildOrderInfoBox(),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 50,
                  color: Colors.white,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Visibility(
                          visible: orderStatus != '1',
                          child: GestureDetector(
                            onTap: () {
                              NavigatorUtils.navigatorRouter(
                                  context,
                                  OrderLogisticsTrackingPage(
                                    orderId: widget.orderId,
                                  ));
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                margin: EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  border: Border(
                                    top: BorderSide(
                                        width: 0.5, color: Colors.black26),
                                    left: BorderSide(
                                        width: 0.5, color: Colors.black26),
                                    right: BorderSide(
                                        width: 0.5, color: Colors.black26),
                                    bottom: BorderSide(
                                        width: 0.5, color: Colors.black26),
                                  ),
                                ),
                                child: Text(
                                  '查看物流',
                                  //Logistics物流跟踪 order_logistics_tracking
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: ScreenUtil().setSp(42)),
                                )),
                          )),
                      GestureDetector(
                        onTap: () {
                          if (defProductId != null) {
                            NavigatorUtils.navigatorRouter(
                                context,
                                GoodsDetailPage(
                                  productId: defProductId,
                                ));
                          }
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              border: Border(
                                top: BorderSide(
                                    width: 0.5, color: Colors.redAccent),
                                left: BorderSide(
                                    width: 0.5, color: Colors.redAccent),
                                right: BorderSide(
                                    width: 0.5, color: Colors.redAccent),
                                bottom: BorderSide(
                                    width: 0.5, color: Colors.redAccent),
                              ),
                            ),
                            child: Text(
                              '再次购买',
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: ScreenUtil().setSp(42)),
                            )),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ) // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }

  Widget buildTotalBox() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
        child: Row(
          children: <Widget>[
            Text(
              '${orderStatusText == null ? "" : orderStatusText}',
              style: TextStyle(
                color: Color(0xff222222),
                fontSize: ScreenUtil().setSp(42),
              ),
            ),
            Expanded(child: Text("")),
            Text(
              "${sum == null || sum == 0 ? "" : "共$sum件商品  "}",
              style: TextStyle(
                color: Color(0xff222222),
                fontSize: ScreenUtil().setSp(42),
              ),
            ),
            Text(
              "￥${payPrice == null ? "" : payPrice}",
              style: TextStyle(
                color: Color(0xFFF93736),
                fontSize: ScreenUtil().setSp(42),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOrderInfoBox() {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              children: <Widget>[
                Text(
                  '订单详情',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(42),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
                horizontal: 16, vertical: ScreenUtil().setHeight(10)),
            child: Divider(
              height: ScreenUtil().setHeight(1),
              color: Color(0xFFefefef),
            ),
          ),
          Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              children: <Widget>[
                Text(
                  '订单编号',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ScreenUtil().setSp(36),
                  ),
                ),
                Expanded(child: Text("")),
                SelectableText(
                  "${orderNum == null ? "" : orderNum}",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ScreenUtil().setSp(36),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
                horizontal: 16, vertical: ScreenUtil().setHeight(10)),
            child: Divider(
              height: ScreenUtil().setHeight(1),
              color: Color(0xFFefefef),
            ),
          ),
          Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              children: <Widget>[
                Text(
                  '支付方式',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ScreenUtil().setSp(36),
                  ),
                ),
                Expanded(child: Text("")),
                Text(
                  "$_payWayText",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ScreenUtil().setSp(36),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: ScreenUtil().setHeight(10)),
                  child: Divider(
                    height: ScreenUtil().setHeight(1),
                    color: Color(0xFFefefef),
                  ),
                ),
                Container(
                  color: Colors.white,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '下单日期',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(36),
                        ),
                      ),
                      Expanded(child: Text("")),
                      Text(
                        "${dateAdded == null ? "" : dateAdded}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(36),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: !CommonUtils.isEmpty(payTime),
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: ScreenUtil().setHeight(10)),
                  child: Divider(
                    height: ScreenUtil().setHeight(1),
                    color: Color(0xFFefefef),
                  ),
                ),
                Container(
                  color: Colors.white,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '付款时间',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(36),
                        ),
                      ),
                      Expanded(child: Text("")),
                      Text(
                        "${payTime == null ? "" : payTime}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(36),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: !CommonUtils.isEmpty(sendTime),
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: ScreenUtil().setHeight(10)),
                  child: Divider(
                    height: ScreenUtil().setHeight(1),
                    color: Color(0xFFefefef),
                  ),
                ),
                Container(
                  color: Colors.white,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '发货时间',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(36),
                        ),
                      ),
                      Expanded(child: Text("")),
                      Text(
                        "${sendTime == null ? "" : sendTime}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(36),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: !CommonUtils.isEmpty(sendName),
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: ScreenUtil().setHeight(10)),
                  child: Divider(
                    height: ScreenUtil().setHeight(1),
                    color: Color(0xFFefefef),
                  ),
                ),
                Container(
                  color: Colors.white,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '快递公司',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(36),
                        ),
                      ),
                      Expanded(child: Text("")),
                      Text(
                        "${sendName == null ? "" : sendName}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(36),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: !CommonUtils.isEmpty(sendNumber),
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: ScreenUtil().setHeight(10)),
                  child: Divider(
                    height: ScreenUtil().setHeight(1),
                    color: Color(0xFFefefef),
                  ),
                ),
                Container(
                  color: Colors.white,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '快递单号',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(36),
                        ),
                      ),
                      Expanded(child: Text("")),
                      SelectableText(
                        "${sendNumber == null ? "" : sendNumber}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(36),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: !CommonUtils.isEmpty(confirmTime),
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: ScreenUtil().setHeight(10)),
                  child: Divider(
                    height: ScreenUtil().setHeight(1),
                    color: Color(0xFFefefef),
                  ),
                ),
                Container(
                  color: Colors.white,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '收货时间',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(36),
                        ),
                      ),
                      Expanded(child: Text("")),
                      Text(
                        "${confirmTime == null ? "" : confirmTime}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(36),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget buildGoodsList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        OrderDetailDataGoodsList product = goodsList[index];
        var itemTotalPrice = 0.0;
        try {
          itemTotalPrice =
              double.parse(product.salePrice) * double.parse(product.goodsNum);
        } catch (e) {}
        return Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                NavigatorUtils.navigatorRouter(
                    context,
                    GoodsDetailPage(
                      productId: product.goodsId,
                    ));
              },
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
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                  horizontal: 16, vertical: ScreenUtil().setHeight(10)),
              child: Divider(
                height: ScreenUtil().setHeight(1),
                color: Color(0xFFefefef),
              ),
            ),
            Visibility(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                    horizontal: 16, vertical: ScreenUtil().setHeight(30)),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Expanded(
                      child: Text.rich(TextSpan(
                          text: '小计：',
                          style: TextStyle(fontSize: ScreenUtil().setSp(32)),
                          children: [
                            TextSpan(
                              text: '￥$totalPrice',
                              style: TextStyle(
                                color: Color(0xFFF93736),
                              ),
                            ),
                          ])),
                    ),
                    Visibility(
                      visible: !GlobalConfig.isRelease, //todo 去除展示控制
                      child: GestureDetector(
                        onTap: () async {
                          NavigatorUtils.navigatorRouter(
                              context,
                              ReturnGoodsOptionPage(
                                product: product,
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
                                  color: Color(0xff999999),
                                  width: 0.5)),
                          child: Text(
                            //状态：
                            "退换",
                            style: TextStyle(
                              color: Color(0xff666666),
                              fontSize: ScreenUtil().setSp(42),
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
        );
      }, childCount: goodsList == null ? 0 : goodsList.length),
    );
  }

  ///地址信息布局
  Widget buildAddressInfoContainer() {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              onTap: () async {},
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        style: TextStyle(
                          color: Color(0xff222222),
                          fontSize: ScreenUtil().setSp(48),
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(30),
                      ),
                      Text(
                        iphone,
                        style: TextStyle(
                          color: Color(0xff222222),
                          fontSize: ScreenUtil().setSp(48),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: <Widget>[
                      Text(
                        '${addressDetail}',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(36),
                            color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
