import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/ktxxhttp/ktxx_http_manage.dart';
import 'package:star/ktxxmodels/ktxx_order_detail_entity.dart';
import 'package:star/ktxxpages/ktxxadress/ktxx_my_adress.dart';
import 'package:star/ktxxpages/ktxxgoods/ktxx_checkout_counter.dart';
import 'package:star/ktxxpages/ktxxwidget/ktxx_price_text.dart';
import 'package:star/ktxxutils/ktxx_common_utils.dart';

import '../../ktxx_global_config.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedEnsureOrderPage extends StatefulWidget {
  List<String> cartIdList;
  String orderId;
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;

  KeTaoFeaturedEnsureOrderPage({@required this.orderId});

  @override
  _KeTaoFeaturedEnsureOrderPageState createState() =>
      _KeTaoFeaturedEnsureOrderPageState();
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
class _KeTaoFeaturedEnsureOrderPageState
    extends State<KeTaoFeaturedEnsureOrderPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  var entity;
  var selectedAddress;
  var addressDetail = "";
  var iphone = "";
  var name = "";
  var totalPrice = "";
  var payPrice = "";

  List<KeTaoFeaturedOrderDetailDataGoodsList> goodsList;

  var isCoupon = '2';

  var _leftAmount = "0";
  var _availableAmount = "0";
  var _totalAmount = "0";
  bool showEnvelope = false;

  /*OrderCheckoutEntity entity;
  OrderCheckoutDataAddress selectedAddress;*/

  Future _initData({bool onlyChangeAddress = false}) async {
    try {
      EasyLoading.show();
    } catch (e) {}
    try {
      var entityResult =
          await KeTaoFeaturedHttpManage.orderDetail(widget.orderId);
/*
    OrderCheckoutEntity entityResult =
        await HttpManage.orderCheckout(widget.cartIdList);
*/
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
            if (double.parse(_totalAmount) > double.parse(totalPrice)) {
              _availableAmount = double.parse(totalPrice).toStringAsFixed(2);
            } else {
              _availableAmount = double.parse(_totalAmount).toStringAsFixed(2);
            }
            _leftAmount =
                (double.parse(_totalAmount) - double.parse(_availableAmount))
                    .toStringAsFixed(2);
            payPrice =
                (double.parse(totalPrice) - double.parse(_availableAmount))
                    .toStringAsFixed(2);
            if (double.parse(_availableAmount) > 0) {
              showEnvelope = true;
            }
          }
        });
      }
    } catch (e) {
      try {
        EasyLoading.dismiss();
      } catch (e) {}
    }
    try {
      EasyLoading.dismiss();
    } catch (e) {}
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _initData();
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
            child: CachedNetworkImage(
              imageUrl:
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
          backgroundColor: KeTaoFeaturedGlobalConfig.taskNomalHeadColor,
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
                                bool needRefresh = await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (BuildContext context) {
                                  return new KeTaoFeaturedAddressListPage(
                                    type: 0,
                                    orderId: widget.orderId,
                                  );
                                }));
                                print("needRefresh=$needRefresh");
                                if (needRefresh) {
                                  _initData(onlyChangeAddress: true);
                                }
//                                _initData();
                              },
                              title: KeTaoFeaturedCommonUtils.isEmpty(iphone)
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
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      var product = goodsList[index];
/*
                            OrderCheckoutDataProduct product =
                                entity.data.products[index];
*/
                      return Container(
                        color: Colors.white,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
                              child: CachedNetworkImage(
                                fadeInDuration: Duration(milliseconds: 0),
                                fadeOutDuration: Duration(milliseconds: 0),
                                fit: BoxFit.fill,
                                width: 74,
                                height: 74,
                                imageUrl: product.goodsImg == null
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
                                                overflow: TextOverflow.ellipsis,
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
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(20)),
                                  ),
                                ],
                              ),
                            ))
                          ],
                        ),
                      );
                    }, childCount: goodsList == null ? 0 : goodsList.length),
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
                          KeTaoFeaturedPriceText(
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
                        if (!KeTaoFeaturedCommonUtils.isEmpty(iphone)) {
                          var result =
                              await KeTaoFeaturedHttpManage.orderSubmit(
                                  widget.orderId, isCoupon);
                          if (result.status) {
                            Navigator.of(context).pop();
                            //跳转到结算台
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return new KeTaoFeaturedCheckOutCounterPage(
                                orderMoney: payPrice,
                                orderId: widget.orderId,
                              );
                            }));
                          } else {}
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
