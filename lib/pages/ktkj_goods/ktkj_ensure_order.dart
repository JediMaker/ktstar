import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/bus/ktkj_my_event_bus.dart';
import 'package:star/global_config.dart';
import 'package:star/http/ktkj_http_manage.dart';
import 'package:star/models/address_list_entity.dart';
import 'package:star/models/cart_settlement_entity.dart';
import 'package:star/models/order_detail_entity.dart';
import 'package:star/pages/ktkj_adress/ktkj_my_adress.dart';
import 'package:star/pages/ktkj_goods/ktkj_checkout_counter.dart';
import 'package:star/pages/ktkj_widget/ktkj_PriceText.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_octoimage.dart';
import 'package:star/utils/ktkj_common_utils.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJEnsureOrderPage extends StatefulWidget {
  List<String> cartIdList;
  String orderId;

  ///选中购物车商品id集合
  final String cartIds;

  /// 下单类型 0 立即下单； 1  购物车结算
  int type;

  KTKJEnsureOrderPage({@required this.orderId, this.type = 0, this.cartIds});

  @override
  _EnsureOrderPageState createState() => _EnsureOrderPageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _EnsureOrderPageState extends State<KTKJEnsureOrderPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  var entity;
  var selectedAddress;
  var addressDetail = "";
  var iphone = "";
  var name = "";
  var totalPrice = "";
  var payPrice = "";

  List<OrderDetailDataGoodsList> goodsList = List<OrderDetailDataGoodsList>();
  List<CartSettlemantDataList> cartGoodsList = List<CartSettlemantDataList>();

  var isCoupon = '2';

  var _leftAmount = "0";
  var _availableAmount = "0";
  var _totalAmount = "0";
  var _coin = "";
  bool showEnvelope = false;
  String defaultAddressId;

  /*OrderCheckoutEntity entity;
  OrderCheckoutDataAddress selectedAddress;*/

  Future _initData({bool onlyChangeAddress = false}) async {
    try {
      EasyLoading.show();
      Future.delayed(Duration(seconds: 5)).then((value) {
        try {
          EasyLoading.dismiss();
        } catch (e) {}
      });
    } catch (e) {}
    try {
      if (widget.type == 0) {
        var entityResult = await HttpManage.orderDetail(widget.orderId);
        try {
          EasyLoading.dismiss();
        } catch (e) {}
/*
    OrderCheckoutEntity entityResult =
        await HttpManage.orderCheckout(widget.cartIdList);
*/
        if (entityResult.status) {
          if (mounted) {
            setState(() {
              entity = entityResult;
              addressDetail = entityResult.data.address;
              iphone = entityResult.data.mobile;
              name = entityResult.data.consignee;
              if (!onlyChangeAddress) {
                isCoupon = entityResult.data.isCoupon;
                _totalAmount = entityResult.data.usableDeduct;
                _availableAmount = entityResult.data.deductPrice;
                goodsList = entityResult.data.goodsList;
                totalPrice = entityResult.data.totalPrice;
                payPrice = entityResult.data.payPrice;
                _coin = entityResult.data.orderBonus;
                if (isCoupon == "1") {
                  if (double.parse(_totalAmount) > double.parse(totalPrice)) {
                    _availableAmount =
                        double.parse(totalPrice).toStringAsFixed(2);
                  } else {
                    _availableAmount =
                        double.parse(_totalAmount).toStringAsFixed(2);
                  }
                  _leftAmount = (double.parse(_totalAmount) -
                          double.parse(_availableAmount))
                      .toStringAsFixed(2);
                  payPrice = (double.parse(totalPrice) -
                          double.parse(_availableAmount))
                      .toStringAsFixed(2);
                  if (double.parse(_availableAmount) > 0) {
                    showEnvelope = true;
                  }
                }
              }
            });
          }
        }
      } else {
        var entityResult =
            await HttpManage.cartGetSettlementData(cartIds: widget.cartIds);
        try {
          EasyLoading.dismiss();
        } catch (e) {}
        if (entityResult.status) {
          if (mounted) {
            setState(() {
              entity = entityResult;
//              addressDetail = entityResult.data.address;
//              iphone = entityResult.data.mobile;
//              name = entityResult.data.consignee;
              if (!onlyChangeAddress) {
                isCoupon = entityResult.data.isCoupon;
                _totalAmount = entityResult.data.usableDeduct;
                _availableAmount = entityResult.data.deductPrice;
                cartGoodsList = entityResult.data.xList;
                totalPrice = entityResult.data.totalPrice;
                payPrice = totalPrice;
                if (isCoupon == "1") {
                  if (double.parse(_totalAmount) > double.parse(totalPrice)) {
                    _availableAmount =
                        double.parse(totalPrice).toStringAsFixed(2);
                  } else {
                    _availableAmount =
                        double.parse(_totalAmount).toStringAsFixed(2);
                  }
                  _leftAmount = (double.parse(_totalAmount) -
                          double.parse(_availableAmount))
                      .toStringAsFixed(2);
                  payPrice = (double.parse(totalPrice) -
                          double.parse(_availableAmount))
                      .toStringAsFixed(2);
                  if (double.parse(_availableAmount) > 0) {
                    showEnvelope = true;
                  }
                }
              }
            });
          }
        }
      }
    } catch (e) {
      try {
        EasyLoading.dismiss();
      } catch (e) {}
    }
  }

  Future _initDefaultAddressData() async {
    //    AddressBeanEntity resultData = await HttpManage.getListOfAddresses();
    var entityResult = await HttpManage.getListOfAddresses(isDefault: "2");
    if (entityResult.status) {
      if (mounted) {
        setState(() {
          if (!KTKJCommonUtils.isEmpty(entityResult.data)) {
            defaultAddressId = entityResult.data[0].id;
            addressDetail = entityResult.data[0].address;
            iphone = entityResult.data[0].mobile;
            name = entityResult.data[0].consignee;
          } else {
            addressDetail = "";
            iphone = "";
            name = "";
          }
        });
      }
    }
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _initData();
    _initDefaultAddressData();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '确认订单',
            style: TextStyle(
                color: Color(0xFF222222), fontSize: ScreenUtil().setSp(54)),
          ),
          brightness: Brightness.light,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(
                ScreenUtil().setHeight(ScreenUtil().setHeight(5))),
            child: KTKJMyOctoImage(
              image:
                  "https://alipic.lanhuapp.com/xd1503b270-f796-4b53-8146-3ba0d3a09a34",
            ),
          ),
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
          backgroundColor: KTKJGlobalConfig.taskNomalHeadColor,
          elevation: 0,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 50),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            color: Colors.white,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              onTap: () async {
                                if (widget.type == 0) {
                                  bool needRefresh = await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return new KTKJAddressListPage(
                                      type: 0,
                                      orderId: widget.orderId,
                                    );
                                  }));
                                  print("needRefresh=$needRefresh");
                                  if (needRefresh) {
                                    _initData(onlyChangeAddress: true);
                                  }
                                } else {
                                  AddressListData item =
                                      await Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                    return new KTKJAddressListPage(
                                      type: 0,
                                      orderId: widget.orderId,
                                    );
                                  }));
                                  if (KTKJCommonUtils.isEmpty(item)) {
                                    _initDefaultAddressData();
                                    return;
                                  }
                                  setState(() {
                                    defaultAddressId = item.id;
                                    addressDetail = item.address;
                                    iphone = item.mobile;
                                    name = item.consignee;
                                  });
                                }
//                                _initData();
                              },
                              title: KTKJCommonUtils.isEmpty(iphone)
                                  ? Text(
                                      '暂无收货地址信息，点击添加',
                                      style: TextStyle(
                                        color: Colors.black12,
                                        fontSize: ScreenUtil().setSp(48),
                                      ),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              name,
                                              style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(48),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              iphone,
                                              style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(48),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Wrap(
                                          alignment: WrapAlignment.start,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '$addressDetail',
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(32),
                                                  color:
                                                      const Color(0xff999999)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                              trailing: Icon(
                                CupertinoIcons.forward,
                                size: 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverVisibility(
                    visible: widget.type == 0,
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: List.generate(goodsList.length, (index) {
                          var product = goodsList[index];
/*
                                OrderCheckoutDataProduct product =
                                    entity.data.products[index];
*/
                          return Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6.0),
//                        child: Image.network(
////                          item.imageUrl,
//                          'http://img10.360buyimg.com/mobilecms/s270x270_jfs/t1/23943/7/13139/130737/5c9dbe4bEd77d9e09/a371d9345e1774e2.jpg',
//                          width: ScreenUtil().L(120),
//                          height: ScreenUtil().L(120),
//                        )
                                  child: KTKJMyOctoImage(
                                    fadeInDuration: Duration(milliseconds: 0),
                                    fadeOutDuration: Duration(milliseconds: 0),
                                    fit: BoxFit.fill,
                                    width: 74,
                                    height: 74,
                                    image: product.goodsImg == null
                                        ? ""
                                        : product.goodsImg,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        product.goodsName == null
                                            ? ""
                                            : product.goodsName,
//                                  item.wareName,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(42),
                                          color: Color(0xff222222),
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
                                        margin: EdgeInsets.only(
                                            top: ScreenUtil().setHeight(18)),
                                      ),
                                      /* Wrap(
                                        children: product.option.map((op) {
                                          return Container(
                                            child: Text(
                                              "${op.value} ",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: ScreenUtil().setSp(42),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),*/
                                      Container(
                                        child: Row(
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
//                            Expanded(child: Text('进店',style: TextStyle(fontSize: 12),),),
                                                Text(
                                                  "￥${product.salePrice == null ? "" : product.salePrice}",
//                          '27.5',,
                                                  style: TextStyle(
                                                    fontSize:
                                                        ScreenUtil().setSp(42),
                                                    color: Color(0xFFF93736),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
//                          Icon(Icons.chevron_right,size: 18,color: Colors.grey,) ,
//                              Expanded(
//                              ),
                                              ],
//                           ),
                                            )),
                                            Container(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                'x${product.goodsNum}',
                                                style: TextStyle(
                                                  color: Color(0xff222222),
                                                  fontSize:
                                                      ScreenUtil().setSp(36),
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
                                        margin: EdgeInsets.only(
                                            top: ScreenUtil().setHeight(20)),
                                      ),
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  SliverVisibility(
                    visible: widget.type == 1,
                    sliver: SliverToBoxAdapter(
                      child: Container(
                        child: Column(
                          children:
                              List.generate(cartGoodsList.length, (index) {
                            var product = cartGoodsList[index];
                            var productSpec = product.specItem;
                            var productCoin = product.goodsCoin;
                            if (productCoin != null) {
                              productCoin = "分红金：$productCoin";
                            }

                            return Container(
                              color: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6.0),
//                        child: Image.network(
////                          item.imageUrl,
//                          'http://img10.360buyimg.com/mobilecms/s270x270_jfs/t1/23943/7/13139/130737/5c9dbe4bEd77d9e09/a371d9345e1774e2.jpg',
//                          width: ScreenUtil().L(120),
//                          height: ScreenUtil().L(120),
//                        )
                                    child: KTKJMyOctoImage(
                                      fadeInDuration: Duration(milliseconds: 0),
                                      fadeOutDuration:
                                          Duration(milliseconds: 0),
                                      fit: BoxFit.fill,
                                      width: 74,
                                      height: 74,
                                      image: product.goodsImg == null
                                          ? ""
                                          : product.goodsImg,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          product.goodsName == null
                                              ? ""
                                              : product.goodsName,
//                                  item.wareName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(42),
                                            color: Color(0xff222222),
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: !KTKJCommonUtils
                                                                .isEmpty(
                                                                    productSpec)
                                                            ? Color(0xfff6f5f5)
                                                            : Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          ScreenUtil()
                                                              .setWidth(10),
                                                        ),
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: ScreenUtil()
                                                            .setWidth(22),
                                                        vertical: ScreenUtil()
                                                            .setWidth(16),
                                                      ),
                                                      child: Text(
                                                        "$productSpec",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setSp(36),
                                                          color:
                                                              Color(0xffa0a0a0),
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  'x${product.goodsNum}',
                                                  style: TextStyle(
                                                    color: Color(0xff222222),
                                                    fontSize:
                                                        ScreenUtil().setSp(36),
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
                                          margin: EdgeInsets.only(
                                              top: ScreenUtil().setHeight(20)),
                                        ),
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                  child: Row(
//                            crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                      top: ScreenUtil()
                                                          .setWidth(0),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color:
                                                            Color(0xfff32e43),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        ScreenUtil()
                                                            .setWidth(10),
                                                      ),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: ScreenUtil()
                                                          .setWidth(22),
                                                      vertical: ScreenUtil()
                                                          .setWidth(10),
                                                    ),
                                                    child: Text(
                                                      "$productCoin",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(30),
                                                        color:
                                                            Color(0xfff32e43),
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      '',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
//                            Expanded(child: Text('进店',style: TextStyle(fontSize: 12),),),

//                          Icon(Icons.chevron_right,size: 18,color: Colors.grey,) ,
//                              Expanded(
//                              ),
                                                ],
//                           ),
                                              )),
                                              Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  "￥${product.goodsPrice == null ? "" : product.goodsPrice}",
//                          '27.5',,
                                                  style: TextStyle(
                                                    fontSize:
                                                        ScreenUtil().setSp(42),
                                                    color: Color(0xFFF93736),
                                                    fontWeight: FontWeight.bold,
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
                                          margin: EdgeInsets.only(
                                              top: ScreenUtil().setHeight(20)),
                                        ),
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                      color: Colors.white,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Text(
                                "商品总额",
                                style: TextStyle(
                                  color: Color(0xff999999),
                                  fontSize: ScreenUtil().setSp(36),
                                ),
                              ),
                              Expanded(child: Text("")),
                              Text(
                                "￥$totalPrice",
                                style: TextStyle(
                                  color: Color(0xff222222),
                                  fontSize: ScreenUtil().setSp(36),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: !KTKJCommonUtils.isEmpty(_coin) &&
                                widget.type == 0,
                            child: Column(
                              children: [
                                Center(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setWidth(30),
                                    ),
                                    color: Color(0xffd1d1d1),
                                    height: ScreenUtil().setWidth(1),
                                    width: ScreenUtil().setWidth(1029),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "分红金",
                                      style: TextStyle(
                                        color: Color(0xff999999),
                                        fontSize: ScreenUtil().setSp(36),
                                      ),
                                    ),
                                    Expanded(child: Text("")),
                                    Text(
                                      "￥$_coin",
                                      style: TextStyle(
                                        color: Color(0xff222222),
                                        fontSize: ScreenUtil().setSp(36),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: isCoupon == "1" && showEnvelope,
                            child: Column(
                              children: [
                                Center(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setWidth(30),
                                    ),
                                    color: Color(0xffd1d1d1),
                                    height: ScreenUtil().setWidth(1),
                                    width: ScreenUtil().setWidth(1029),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Column(
                                      children: [
                                        Text(
                                          "可用红包抵用$_availableAmount元",
                                          style: TextStyle(
                                            color: Color(0xff666666),
                                            fontSize: ScreenUtil().setSp(36),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: ScreenUtil().setWidth(20),
                                          ),
                                          child: Text(
                                            "抵用后可用红包金额$_leftAmount元",
                                            style: TextStyle(
                                              color: Color(0xffb9b9b9),
                                              fontSize: ScreenUtil().setSp(28),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(child: Text("")),
                                    Text(
                                      "-￥$_availableAmount",
                                      style: TextStyle(
                                        color: Color(0xffCE0100),
                                        fontSize: ScreenUtil().setSp(36),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
                child: Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 50,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      child: Row(
                        children: <Widget>[
                          Text(
                            "实付款：",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(48),
                            ),
                          ),
                          PriceText(
                            text: "$payPrice",
                            textColor: Color(0xFFF32e43),
                            fontSize: ScreenUtil().setSp(42),
                            fontBigSize: ScreenUtil().setSp(56),
                            /*  style: TextStyle(
                                color: const Color(0xFFF32e43),
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(56),
                              )，*/
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    )),
                    GestureDetector(
                      onTap: () async {
                        if (!KTKJCommonUtils.isEmpty(iphone)) {
                          if (widget.type == 0) {
                            ///正常订单
                            var result = await HttpManage.orderSubmit(
                                widget.orderId, isCoupon);
                            if (result.status) {
                              Navigator.of(context).pop();
                              //跳转到结算台
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return new KTKJCheckOutCounterPage(
                                  orderMoney: payPrice,
                                  orderId: widget.orderId,
                                );
                              }));
                            }
                          } else {
                            ///购物车订单
                            var result = await HttpManage.cartCreateOrder(
                                cartIds: widget.cartIds,
                                addressId: defaultAddressId,
                                needDeduct: isCoupon);
//                                widget.orderId, isCoupon);
                            if (result.status) {
                              Navigator.of(context).pop();
                              bus.emit("changeCheckStatus");
                              //跳转到结算台
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return new KTKJCheckOutCounterPage(
                                  orderMoney: payPrice,
                                  orderId: result.data.orderAttachId,
                                  type: 1,
                                );
                              }));
                            }
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "收货地址不能为空！",
                              textColor: Colors.white,
                              backgroundColor: Colors.grey,
                              gravity: ToastGravity.BOTTOM);
                        }
                      },
                      child: Container(
                        width: 150,
                        height: 50,
                        color: Color(0xFFF93736),
                        alignment: Alignment.center,
                        child: Text(
                          '提交订单',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
