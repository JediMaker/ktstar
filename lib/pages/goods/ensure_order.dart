import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/order_detail_entity.dart';
import 'package:star/pages/adress/my_adress.dart';
import 'package:star/pages/goods/checkout_counter.dart';
import 'package:star/pages/widget/PriceText.dart';
import 'package:star/utils/common_utils.dart';

import '../../global_config.dart';

class EnsureOrderPage extends StatefulWidget {
  List<String> cartIdList;
  String orderId;

  EnsureOrderPage({@required this.orderId});

  @override
  _EnsureOrderPageState createState() => _EnsureOrderPageState();
}

class _EnsureOrderPageState extends State<EnsureOrderPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  var entity;
  var selectedAddress;
  var addressDetail = "";
  var iphone = "";
  var name = "";
  var totalPrice = "";
  var payPrice = "";

  List<OrderDetailDataGoodsList> goodsList;

  /*OrderCheckoutEntity entity;
  OrderCheckoutDataAddress selectedAddress;*/

  Future _initData({bool onlyChangeAddress = false}) async {
    try {
      EasyLoading.show();
    } catch (e) {}
    try {
      var entityResult = await HttpManage.orderDetail(widget.orderId);
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
            goodsList = entityResult.data.goodsList;
            totalPrice = entityResult.data.totalPrice;
            payPrice = entityResult.data.payPrice;
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
                                  return new AddressListPage(
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
                              title: CommonUtils.isEmpty(iphone)
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
                                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(18)),
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
                      child: Row(
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
                        if (!CommonUtils.isEmpty(iphone)) {
                          var result =
                              await HttpManage.orderSubmit(widget.orderId);
                          if (result.status) {
                            Navigator.of(context).pop();
                            //跳转到结算台
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return new CheckOutCounterPage(
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
