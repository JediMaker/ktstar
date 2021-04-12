import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:star/bus/ktkj_my_event_bus.dart';
import 'package:star/generated/json/base/json_field.dart';
import 'package:star/global_config.dart';
import 'package:star/http/ktkj_http_manage.dart';
import 'package:star/models/cart_list_entity.dart';
import 'package:star/pages/ktkj_goods/ktkj_ensure_order.dart';
import 'package:star/pages/ktkj_widget/ktkj_PriceText.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_octoimage.dart';
import 'package:star/pages/ktkj_widget/ktkj_no_data.dart';
import 'package:star/utils/ktkj_common_utils.dart';
import 'package:star/utils/ktkj_navigator_utils.dart';
import 'package:star/utils/ktkj_utils.dart';

class KTKJShoppingCartPage extends StatefulWidget {
  KTKJShoppingCartPage({Key key}) : super(key: key);
  final String title = "购物车";
  List<ShoppingCartBeanDataProduct> products;

  @override
  _KTKJShoppingCartPageState createState() => _KTKJShoppingCartPageState();
}

class _KTKJShoppingCartPageState extends State<KTKJShoppingCartPage>
    with AutomaticKeepAliveClientMixin {
  var _colorRed = Color(0xffF32E43);

  int page = 1;
  EasyRefreshController _refreshController;
  bool isFirstLoading = true;
  List<CartListDataList> goodsList = List<CartListDataList>();

  _initData() async {
//    KTKJGlobalConfig.prefs.setString(key, value)
    var entity = await HttpManage.cartGetGoodsList();
    if (entity.status) {
      if (mounted) {
        setState(() {
          goodsList = List<CartListDataList>();
          goodsList = entity.data.xList;
          _refreshController.finishLoad(noMore: true);
          isFirstLoading = false;
          for (var product in goodsList) {
            if (KTKJCommonUtils.isEmpty(checkedMap[product.cartId])) {
              checkedMap[product.cartId] = false;
            }
          }
//        KTKJGlobalConfig.prefs.setString(key, value)
          _countTotalPrice();
        });
      }
    }
  }

  var _isEditStatus = false;
  double totalPrice = 0.0;
  bool _isAllCheckedValue = false;
  Map<String, bool> checkedMap = Map();

  _isAllSelected() {
    setState(() {
      _isAllCheckedValue = !_isAllCheckedValue;
      if (_isAllCheckedValue) {
        totalPrice = 0.0;
        for (var product in goodsList) {
          checkedMap[product.cartId] = true;
          _countTotalPrice();
        }
      } else {
        for (var product in goodsList) {
          checkedMap[product.cartId] = false;
        }
        totalPrice = 0.0;
      }
      bus.emit("isAllSelectTap", _isAllCheckedValue);
    });
  }

  _countTotalPrice({CartListDataList selProduct}) {
    totalPrice = 0.0;
    for (var product in goodsList) {
      if (KTKJCommonUtils.isEmpty(checkedMap[product.cartId])) {
        checkedMap[product.cartId] = false;
      }

      /// 价格金额计算
      ///
      ///
      if (checkedMap[product.cartId]) {
        if (selProduct != null) {
          if (selProduct.cartId == product.cartId) {
            product = selProduct;
            totalPrice += double.parse(selProduct.goodsNum) *
                double.parse(selProduct.goodsPrice);
          } else {
            totalPrice += double.parse(product.goodsNum) *
                double.parse(product.goodsPrice);
          }
        } else {
          totalPrice +=
              double.parse(product.goodsNum) * double.parse(product.goodsPrice);
        }
      }
    }
    totalPrice = KTKJUtils.formatNum(totalPrice, 2);
  }

  Widget _buildBottomLayout() {
    return Container(
      height: ScreenUtil().setWidth(160),
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(30),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(
                0,
                -ScreenUtil().setWidth(10),
              ), //x,y轴
              color: Color(0x0d777777), //投影颜色
              blurRadius: ScreenUtil().setWidth(2), //投影距离
            )
          ]),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: _isAllSelected,
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                child: Row(children: <Widget>[
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      /* Checkbox(
                        value: _isAllCheckedValue,
                        onChanged: _isAllSelected2,
                      ),*/
                      Container(
                        margin: EdgeInsets.only(
                          right: ScreenUtil().setWidth(30),
                        ),
                        child: KTKJMyOctoImage(
                          width: ScreenUtil().setWidth(60),
                          height: ScreenUtil().setWidth(60),
                          image:
                              "${_isAllCheckedValue ? "https://alipic.lanhuapp.com/xde378dbfe-8b40-49d3-a858-3e70c8c4a71a" : "https://alipic.lanhuapp.com/xdd733d4bc-a5f5-4439-8c87-f454642467a5"}",
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: _isEditStatus,
                    child: Text(
                      '全选',
                      style: TextStyle(
                        fontSize: ScreenUtil().setWidth(48),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !_isEditStatus,
                    child: Row(
                      children: [
                        Text(
                          '合计：',
                          style: TextStyle(
                            fontSize: ScreenUtil().setWidth(48),
                          ),
                        ),
                        PriceText(
                          text: totalPrice.toStringAsFixed(2),
                          textColor: _colorRed,
                          fontSize: ScreenUtil().setSp(56),
                          fontBigSize: ScreenUtil().setSp(72),
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _isEditStatus
                ? MaterialButton(
//              color: _colorRed,
//              textColor: Color(0xff707070),
                    textColor: Color(0xff666666),
                    child: Text(
                      '删除',
                      style: TextStyle(
                        fontSize: ScreenUtil().setWidth(48),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Color(0xff707070),
                        width: ScreenUtil().setWidth(1),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          ScreenUtil().setWidth(76),
                        ),
                      ),
                    ),
                    onPressed: _delCartGoods,
                  )
                : MaterialButton(
                    color: _colorRed,
                    textColor: Colors.white,
                    child: Text(
                      '去结算',
                      style: TextStyle(
                        fontSize: ScreenUtil().setWidth(48),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          ScreenUtil().setWidth(76),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      var cartIds = '';
                      for (var product in goodsList) {
                        if (checkedMap[product.cartId]) {
                          cartIds += product.cartId + ",";
                        }
                      }
                      if (cartIds.contains(",")) {
                        cartIds = cartIds.substring(0, cartIds.length - 1);
                      }
                      if (cartIds.length == 0) {
                        KTKJCommonUtils.showToast("请选择要结算的商品 ！");
                      } else {
                        ///  跳转确认订单页面
                        ///
                        var context = KTKJGlobalConfig
                            .navigatorKey.currentState.overlay.context;
                        await KTKJNavigatorUtils.navigatorRouter(
                            context,
                            KTKJEnsureOrderPage(
                              cartIds: cartIds,
                              type: 1,
                            ));
                        _initData();

                        ///
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

//  List<CartListDataList> selectedProducts;

  //调用接口删除所有选中的购物车商品
  Future<void> _delCartGoods() async {
    var cartIds = '';
//    product = List<CartListDataList>();
    for (var product in goodsList) {
      if (checkedMap[product.cartId]) {
        cartIds += product.cartId + ",";
//        selectedProducts.add(product);
      }
    }
    if (cartIds.contains(",")) {
      cartIds = cartIds.substring(0, cartIds.length - 1);
    }
    if (cartIds.length == 0) {
      KTKJCommonUtils.showToast("请选择要删除的商品 ！");
    } else {
      var delResult = await HttpManage.cartDeleteGoods(
        cartIds: cartIds,
      );
      if (delResult.status) {
        delCartAllSelected(cartIds);
      } else {
        KTKJCommonUtils.showToast("${delResult.errMsg}");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController();
    _initData();
    /*bus.on("allCheckedneedsChange", (cartId) {
      print("cartId=$cartId");
      print("allCheckedneedsChange");
      print("checkedMap[cartId]=${checkedMap[cartId]}");
      */ /*try {
          print("checkedMap[cartId]=${checkedMap[cartId]}");
//          checkedMap[cartId];
        } catch (e) {
          print(e);
        }*/ /*
      if (mounted) {
        setState(() {
          var isAllChecked = true;
          for (var product in goodsList) {
            if (!checkedMap[product.cartId]) {
              isAllChecked = false;
            }
          }
          if (isAllChecked) {
            _isAllCheckedValue = true;
          } else {
            _isAllCheckedValue = false;
          }
          _countTotalPrice();
        });
      }
    });*/

    /*bus.on("countPrice", (selProduct) {
      if (mounted) {
        setState(() {
          _countTotalPrice(selProduct: selProduct);
//              _initData();
        });
      }
    });*/
    bus.on("isEditStatus", (isEditStatus) {
      if (mounted) {
        setState(() {
          _isEditStatus = isEditStatus;
        });
      }
    });
  }

  allCheckedNeedsChange() {
    if (mounted) {
      setState(() {
        var isAllChecked = true;
        if (!KTKJCommonUtils.isEmpty(goodsList)) {
          for (var product in goodsList) {
            if (!checkedMap[product.cartId]) {
              isAllChecked = false;
            }
          }
          if (isAllChecked) {
            _isAllCheckedValue = true;
          } else {
            _isAllCheckedValue = false;
          }
          _countTotalPrice();
        } else {
          _isAllCheckedValue = false;
        }
      });
    }
  }

  delCartAllSelected(cartIds) {
    if (mounted) {
      setState(() {
        if (KTKJCommonUtils.isEmpty(goodsList)) {
          goodsList = List<CartListDataList>();
          return;
        }
//            Dart循环并删除的方法，removeWhere()。
        List<String> cartIdList = cartIds.toString().split(",");
        for (var cartId in cartIdList) {
          goodsList.removeWhere((product) => cartId == product.cartId);
        }
        _countTotalPrice();
//            _initData();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '购物车',
          style: TextStyle(
              color: Color(0xFF222222), fontSize: ScreenUtil().setSp(54)),
        ),
        brightness: Brightness.light,
        actions: <Widget>[ActionButton()],
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: buildContent(),
    );
  }

  Widget buildContent() {
    return new Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
          margin: EdgeInsets.only(
            top: ScreenUtil().setWidth(30),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: ScreenUtil().setWidth(160),
                top: ScreenUtil().setWidth(74),
              ),
              child: buildEasyRefresh(),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _buildBottomLayout(),
        )
      ],
    );
  }

  Widget buildGoodsList() {
    return Column(
        children: List.generate(
      goodsList.length,
      (index) => buildShoppingCartRow(
        product: goodsList[index],
      ),
    )

        /*[
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return ShoppingCartRow(
              product: goodsList[index],
              checkedMap: checkedMap,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Visibility(child: Text(""));
          },
          itemCount: goodsList.length,
//                            itemCount: widget.products.length,
          */ /*children: widget.products
                            .map((product) => ShoppingCartRow(
                                product: product, checkedMap: checkedMap))
                            .toList(),*/ /*
        ),
      ],*/
        );
  }

  EasyRefresh buildEasyRefresh() {
    return EasyRefresh.custom(
      topBouncing: false,
      bottomBouncing: false,
      header: MaterialHeader(),
      footer: CustomFooter(
//          triggerDistance: ScreenUtil().setWidth(180),
          completeDuration: Duration(seconds: 1),
          footerBuilder: (context,
              loadState,
              pulledExtent,
              loadTriggerPullDistance,
              loadIndicatorExtent,
              axisDirection,
              float,
              completeDuration,
              enableInfiniteLoad,
              success,
              noMore) {
            return Stack(
              children: <Widget>[
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Visibility(
                    visible: noMore,
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: ScreenUtil().setWidth(30),
                          bottom: ScreenUtil().setWidth(30),
                        ),
                        child: Text(
                          "~我是有底线的~",
                          style: TextStyle(
                            color: Color(0xff666666),
                            fontSize: ScreenUtil().setSp(32),
                          ),
                        ),
                      ),
                    ),
                  ),
//                  child: Container(
//                    width: 30.0,
//                    height: 30.0,
//                    /* child: SpinKitCircle(
//                            color: KTKJGlobalConfig.colorPrimary,
//                            size: 30.0,
//                          ),*/
//                  ),
                ),
              ],
            );
          }),
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
      emptyWidget:
          goodsList == null || goodsList.length == 0 ? KTKJNoDataPage() : null,
      slivers: <Widget>[buildCenter()],
    );
  }

  Widget buildCenter() {
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          width: double.maxFinite,
//          height: double.infinity,
          child: buildGoodsList(),
        ),
      ),
    );
  }

  Widget buildShoppingCartRow({CartListDataList product}) {
    var cartId;
    var productId;
    var productName;
    var productPrice;
    var productImg;
    var productSpec;
    var productCoin;
    var productQuantity;

//  var minTotals = '10';
    var isSel = false;
    try {
      cartId = product.cartId;
      productId = product.goodsId;
      productName = product.goodsName;
      productPrice = product.goodsPrice;
      productImg = product.goodsImg;
      productSpec = product.specItem;
      productCoin = product.goodsCoin;
      if (productCoin != null) {
        productCoin = "分红金：$productCoin";
      }
      productQuantity = product.goodsNum;
//      minTotals = '10';
      isSel = checkedMap[product.cartId];
    } catch (e) {}
    return GestureDetector(
      key: ValueKey(cartId),
      onTap: () {
        if (product != null) {
          /// todo 跳转商品详情
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setWidth(20),
        ),
        /* decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color:
                      GlobalConfig.dark == true ? Colors.white12 : Colors.black12,
                  width: 1.0)),
        ),*/
        child: Row(
//          key: ValueKey<String>(widget.product.productId),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                try {
                  checkedMap[product.cartId] = !checkedMap[product.cartId];
                  isSel = checkedMap[product.cartId];
                } catch (e) {}
                allCheckedNeedsChange();
                if (mounted) {
                  setState(() {});
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      height: ScreenUtil().setWidth(345),
                      margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(30),
                        right: ScreenUtil().setWidth(30),
                      ),
                      child: KTKJMyOctoImage(
                        width: ScreenUtil().setWidth(60),
                        height: ScreenUtil().setWidth(60),
                        image:
                            "${isSel ? "https://alipic.lanhuapp.com/xde378dbfe-8b40-49d3-a858-3e70c8c4a71a" : "https://alipic.lanhuapp.com/xdd733d4bc-a5f5-4439-8c87-f454642467a5"}",
                      ),
                    ),
                  ),
                  /*Checkbox(
                    value: widget.checkedMap == null ||
                            widget.product == null ||
                            widget.checkedMap[widget.product] == null
                        ? false
                        : widget.checkedMap[widget.product],
                    onChanged: (isSelect) {
                      setState(() {
                        widget.checkedMap[widget.product] =
                            !widget.checkedMap[widget.product];
                        bus.emit("allCheckedneedsChange", true);
                      });
                    },
                  ),*/
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                ScreenUtil().setWidth(30),
              ),
              child: KTKJMyOctoImage(
                image: "$productImg",
                fit: BoxFit.fill,
                width: ScreenUtil().setWidth(345),
                height: ScreenUtil().setWidth(345),
                alignment: Alignment.center,
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(30),
                right: ScreenUtil().setWidth(48),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
//                verticalDirection: ,
                children: <Widget>[
                  Text(
                    "$productName",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(42),
                      fontWeight: FontWeight.w600,
                      color: Color(0xff222222),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Visibility(
//                    visible: !KTKJCommonUtils.isEmpty(productSpec),
                    child: Container(
                      margin: EdgeInsets.only(
                        top: !KTKJCommonUtils.isEmpty(productSpec)
                            ? ScreenUtil().setWidth(20)
                            : 0,
                      ),
                      decoration: BoxDecoration(
                        color: !KTKJCommonUtils.isEmpty(productSpec)
                            ? Color(0xfff6f5f5)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(
                          ScreenUtil().setWidth(10),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(22),
                        vertical: ScreenUtil().setWidth(10),
                      ),
                      child: Text(
                        "$productSpec",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(36),
                          color: Color(0xffa0a0a0),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setWidth(20),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xfff32e43),
                      ),
                      borderRadius: BorderRadius.circular(
                        ScreenUtil().setWidth(10),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(22),
                      vertical: ScreenUtil().setWidth(10),
                    ),
                    child: Text(
                      "$productCoin",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        color: Color(0xfff32e43),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "$productPrice",
                          style: TextStyle(
                            color: Color(0xfff93736),
                            fontSize: ScreenUtil().setSp(48),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !_isEditStatus,
                        child: Container(
                          height: ScreenUtil().setWidth(120),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              _reduceBtn(product: product),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: ScreenUtil().setWidth(100),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "$productQuantity",
                                    style: TextStyle(
                                      color: Color(0xff666666),
                                      fontSize: ScreenUtil().setSp(35),
                                    ),
                                  ),
                                ),
                              ),
                              _addBtn(product: product),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _isEditStatus,
                        child: Container(
                          height: ScreenUtil().setWidth(120),
                          alignment: Alignment.center,
                          child: Text(
                            "× $productQuantity",
                            style: TextStyle(
                              color: Color(0xff666666),
                              fontSize: ScreenUtil().setSp(42),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  //减少按钮
  Widget _reduceBtn({CartListDataList product}) {
    var cartId;
    var productQuantity;

//  var minTotals = '10';
    var isSel = false;
    try {
      cartId = product.cartId;
      productQuantity = product.goodsNum;
    } catch (e) {}
    return Container(
      width: ScreenUtil().setWidth(75),
      height: ScreenUtil().setWidth(75),
      alignment: Alignment.center,
      margin: EdgeInsets.all(0),
      child: MaterialButton(
//              color: _colorRed,
//              textColor: Color(0xff707070),
        textColor: Color(0xff666666),
        color: Color(0xfff6f5f5),
        height: ScreenUtil().setWidth(75),
        padding: EdgeInsets.all(0),
        child: Center(
          child: Text(
            '-',
            style: TextStyle(
              fontSize: ScreenUtil().setWidth(48),
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              ScreenUtil().setWidth(10),
            ),
          ),
        ),
        onPressed: () async {
          int num = int.parse(productQuantity);
          if (num > 1) {
            num--;
            productQuantity = num.toString();
            product.goodsNum = productQuantity;
            var result =
                await HttpManage.cartEditGoods(cartId: cartId, goodsNum: num);
            if (result.status) {
              if (mounted) {
                setState(() {
                  _countTotalPrice(selProduct: product);
                });
              }
            }
          } else {}
        },
      ), //数量小于1 什么都不显示
    );
  }

  //加号
  Widget _addBtn({CartListDataList product}) {
    var cartId;
    var productQuantity;

//  var minTotals = '10';
    var isSel = false;
    try {
      cartId = product.cartId;
      productQuantity = product.goodsNum;
    } catch (e) {}
//          quantity=   widget.product.quantity
//          minTotals=   widget.product.minTotals
    return Container(
      width: ScreenUtil().setWidth(75),
      height: ScreenUtil().setWidth(75),
      alignment: Alignment.center,
      margin: EdgeInsets.all(0),
      child: MaterialButton(
//              color: _colorRed,
//              textColor: Color(0xff707070),
        textColor: Color(0xff666666),
        color: Color(0xfff6f5f5),
        height: ScreenUtil().setWidth(75),
        padding: EdgeInsets.all(0),
        child: Center(
          child: Text(
            '+',
            style: TextStyle(
              fontSize: ScreenUtil().setWidth(48),
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              ScreenUtil().setWidth(10),
            ),
          ),
        ),
        onPressed: () async {
          int num = int.parse(productQuantity);
          num++;
          productQuantity = num.toString();
          product.goodsNum = productQuantity;
          var result =
              await HttpManage.cartEditGoods(cartId: cartId, goodsNum: num);
          if (result.status) {
            setState(() {
              _countTotalPrice(selProduct: product);
            });
          } else {}
        },
      ),
    );
  }

  int _count = 1;

  @override
  bool get wantKeepAlive => true;
}
/*

class ShoppingCartRow extends StatefulWidget {
  CartListDataList product;
  Map<String, bool> checkedMap;

  ShoppingCartRow({this.product, this.checkedMap});

  @override
  _ShoppingCartRowState createState() => _ShoppingCartRowState();
}

class _ShoppingCartRowState extends State<ShoppingCartRow> {
  var _isEditStatus = false;
  var cartId;
  var productId;
  var productName;
  var productPrice;
  var productImg;
  var productSpec;
  var productCoin;
  var productQuantity;

//  var minTotals = '10';
  var isSel = false;

  @override
  void initState() {
    super.initState();
    bus.on("isEditStatus", (isEditStatus) {
      if (mounted) {
        setState(() {
          _isEditStatus = isEditStatus;
        });
      }
    });

    ///全选反选点击
    bus.on("isAllSelectTap", (isAllSelected) {
      if (mounted) {
        setState(() {
          isSel = isAllSelected;
        });
      }
    });
    try {
      cartId = widget.product.cartId;
      productId = widget.product.goodsId;
      productName = widget.product.goodsName;
      productPrice = widget.product.goodsPrice;
      productImg = widget.product.goodsImg;
      productSpec = widget.product.specItem;
      productCoin = widget.product.goodsCoin;
      if (productCoin != null) {
        productCoin = "分红金：$productCoin";
      }
      productQuantity = widget.product.goodsNum;
//      minTotals = '10';
      isSel = widget.checkedMap[widget.product.cartId];
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: ValueKey(cartId),
      onTap: () {
        if (widget.product != null) {
        }
      },
      child: Container(
//        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        */
/* decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color:
                      GlobalConfig.dark == true ? Colors.white12 : Colors.black12,
                  width: 1.0)),
        ),*/ /*

        child: Row(
//          key: ValueKey<String>(widget.product.productId),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                try {
                  widget.checkedMap[widget.product.cartId] =
                      !widget.checkedMap[widget.product.cartId];
                  isSel = widget.checkedMap[widget.product.cartId];
                } catch (e) {}
                var cartId = widget.product.cartId;
                bus.emit("allCheckedneedsChange", cartId);
                print("product.cartId=${widget.product.cartId}\n"
                    "widget.checkedMap=${widget.checkedMap[widget.product.cartId]}\n"
                    "product.goodsId=${widget.product.goodsId}\n"
                    "product.goodsName=${widget.product.goodsName}\n"
                    "product.goodsNum=${widget.product.goodsNum}\n"
                    "product.goodsPrice=${widget.product.goodsPrice}\n");
                if (mounted) {
                  setState(() {});
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      height: ScreenUtil().setWidth(345),
                      margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(30),
                        right: ScreenUtil().setWidth(30),
                      ),
                      child: KTKJMyOctoImage(
                        width: ScreenUtil().setWidth(60),
                        height: ScreenUtil().setWidth(60),
                        image:
                            "${isSel ? "https://alipic.lanhuapp.com/xde378dbfe-8b40-49d3-a858-3e70c8c4a71a" : "https://alipic.lanhuapp.com/xdd733d4bc-a5f5-4439-8c87-f454642467a5"}",
                      ),
                    ),
                  ),
                  */
/*Checkbox(
                    value: widget.checkedMap == null ||
                            widget.product == null ||
                            widget.checkedMap[widget.product] == null
                        ? false
                        : widget.checkedMap[widget.product],
                    onChanged: (isSelect) {
                      setState(() {
                        widget.checkedMap[widget.product] =
                            !widget.checkedMap[widget.product];
                        bus.emit("allCheckedneedsChange", true);
                      });
                    },
                  ),*/ /*

                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                ScreenUtil().setWidth(30),
              ),
              child: KTKJMyOctoImage(
                image: "$productImg",
                fit: BoxFit.fill,
                width: ScreenUtil().setWidth(345),
                height: ScreenUtil().setWidth(345),
                alignment: Alignment.center,
                errorBuilder: (
                  BuildContext context,
                  Object error,
                  StackTrace stackTrace,
                ) {
                  return Container(
                    width: ScreenUtil().setWidth(60),
                    height: ScreenUtil().setWidth(60),
                    color: Colors.red,
                  );
                },
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(30),
                right: ScreenUtil().setWidth(48),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
//                verticalDirection: ,
                children: <Widget>[
                  Text(
                    "$productName",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(42),
                      fontWeight: FontWeight.w600,
                      color: Color(0xff222222),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Visibility(
//                    visible: !KTKJCommonUtils.isEmpty(productSpec),
                    child: Container(
                      margin: EdgeInsets.only(
                        top: !KTKJCommonUtils.isEmpty(productSpec)
                            ? ScreenUtil().setWidth(20)
                            : 0,
                      ),
                      decoration: BoxDecoration(
                        color: !KTKJCommonUtils.isEmpty(productSpec)
                            ? Color(0xfff6f5f5)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(
                          ScreenUtil().setWidth(10),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(22),
                        vertical: ScreenUtil().setWidth(10),
                      ),
                      child: Text(
                        "$productSpec",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(36),
                          color: Color(0xffa0a0a0),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setWidth(20),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xfff32e43),
                      ),
                      borderRadius: BorderRadius.circular(
                        ScreenUtil().setWidth(10),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(22),
                      vertical: ScreenUtil().setWidth(10),
                    ),
                    child: Text(
                      "$productCoin",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        color: Color(0xfff32e43),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "$productPrice",
                          style: TextStyle(
                            color: Color(0xfff93736),
                            fontSize: ScreenUtil().setSp(48),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          _reduceBtn(),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 40,
                              alignment: Alignment.center,
                              child: Text(
                                "$productQuantity",
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: ScreenUtil().setSp(35),
                                ),
                              ),
                            ),
                          ),
                          _addBtn(),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  //减少按钮
  Widget _reduceBtn() {
//          quantity=   widget.product.quantity
    return Container(
      width: ScreenUtil().setWidth(75),
      alignment: Alignment.center,
      child: MaterialButton(
//              color: _colorRed,
//              textColor: Color(0xff707070),
        textColor: Color(0xff666666),
        color: Color(0xfff6f5f5),
        height: ScreenUtil().setWidth(75),
        padding: EdgeInsets.all(0),
        child: Center(
          child: Text(
            '-',
            style: TextStyle(
              fontSize: ScreenUtil().setWidth(48),
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              ScreenUtil().setWidth(10),
            ),
          ),
        ),
        onPressed: () async {
          int num = int.parse(productQuantity);
          if (num > 1) {
            num--;
            productQuantity = num.toString();
            widget.product.goodsNum = productQuantity;
            var result =
                await HttpManage.cartEditGoods(cartId: cartId, goodsNum: num);
            if (result.status) {
              if (mounted) {
                setState(() {
                  bus.emit("countPrice", widget.product);
                });
              }
            }
          } else {}
        },
      ), //数量小于1 什么都不显示
    );
  }

  //加号
  Widget _addBtn() {
//          quantity=   widget.product.quantity
//          minTotals=   widget.product.minTotals
    return Container(
      width: ScreenUtil().setWidth(75),
      alignment: Alignment.center,
      child: MaterialButton(
//              color: _colorRed,
//              textColor: Color(0xff707070),
        textColor: Color(0xff666666),
        color: Color(0xfff6f5f5),
        height: ScreenUtil().setWidth(75),
        padding: EdgeInsets.all(0),
        child: Center(
          child: Text(
            '+',
            style: TextStyle(
              fontSize: ScreenUtil().setWidth(48),
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              ScreenUtil().setWidth(10),
            ),
          ),
        ),
        onPressed: () async {
          int num = int.parse(productQuantity);
          num++;
          productQuantity = num.toString();
          widget.product.goodsNum = productQuantity;
          var result =
              await HttpManage.cartEditGoods(cartId: cartId, goodsNum: num);
          if (result.status) {
            setState(() {
              bus.emit("countPrice", widget.product);
            });
          } else {}
        },
      ),
    );
  }

  int _count = 1;
}
*/

class ActionButton extends StatefulWidget {
  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool isEditStatus = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: isEditStatus
          ? Text(
              '完成',
              style: TextStyle(
                color: Color(0xff666666),
                fontSize: ScreenUtil().setWidth(48),
              ),
            )
          : Text(
              '管理',
              style: TextStyle(
                color: Color(0xff666666),
                fontSize: ScreenUtil().setWidth(48),
              ),
            ),
      onPressed: () {
        setState(() {
          isEditStatus = !isEditStatus;
          bus.emit("isEditStatus", isEditStatus);
        });
      },
    );
  }
}

///购物车状态管理（废弃）
class ShoppingCartProvider with ChangeNotifier {
  ShoppingCartProvider() {
    _initCartGoodsList();
  }

  ///  购物车商品列表
  List<CartListDataList> _goodsList = List<CartListDataList>();

  List<CartListDataList> get goodsList => _goodsList;

  ///选中商品的购物车id集合
  String _selectedCartGoodsIds = '';

  ///选中商品的合计金额
  var totalPrice = 0.0;

  ///存储购物车选中状态
  Map<String, bool> checkedMap = Map();

  ///获取购物车商品列表
  Future<void> _initCartGoodsList() async {
    var entity = await HttpManage.cartGetGoodsList();

    if (entity.status) {
      _goodsList = List<CartListDataList>();
      _goodsList = entity.data.xList;

      ///初始化购物车商品选中状态
      for (var product in _goodsList) {
        if (KTKJCommonUtils.isEmpty(checkedMap[product.cartId])) {
          _setSelectedStatus(cartId: product.cartId);
        }
      }
      _countTotalPrice();
    }
    notifyListeners();
  }

  ///更新购物车商品列表数据
  ///
  /// [cartId] 购物车id
  ///
  /// [goodsNum] 购物车id对应商品数量
  ///
  Future<void> _updateCartGoodsList() async {
    ///初始化购物车商品选中状态
    for (var product in _goodsList) {
      if (checkedMap[product.cartId]) {
        _selectedCartGoodsIds += product.cartId + ",";
      }
    }
    _selectedCartGoodsIds =
        _selectedCartGoodsIds.substring(0, _selectedCartGoodsIds.length - 1);
    var result = await HttpManage.cartEditGoods(
      cartId: _selectedCartGoodsIds,
    );
    if (result.status) {
      _countTotalPrice();
    } else {}
    notifyListeners();
  }

  ///删除购物车商品列表数据
  ///
  /// [cartId] 购物车id
  ///
  /// [goodsNum] 购物车id对应商品数量
  ///
  Future<void> _deleteCartGoodsList({cartIds}) async {
    var result = await HttpManage.cartDeleteGoods(cartIds: cartIds);
    if (result.status) {
      _countTotalPrice();
    } else {}
  }

  ///计算购物车选中商品合计金额
  _countTotalPrice({rowCheckedMap}) {
    totalPrice = 0.0;
    for (var product in _goodsList) {
      /// 价格金额计算
      ///
      if (!KTKJCommonUtils.isEmpty(rowCheckedMap)) {
        if (rowCheckedMap[product.cartId]) {
          totalPrice +=
              double.parse(product.goodsNum) * double.parse(product.goodsPrice);
        }
      } else {
        if (checkedMap[product.cartId]) {
          totalPrice +=
              double.parse(product.goodsNum) * double.parse(product.goodsPrice);
        }
      }
    }
    totalPrice = KTKJUtils.formatNum(totalPrice, 2);
    notifyListeners();
  }

  ///获取某个购物车选中状态
  bool _getSelectedStatus({cartId}) {
    if (KTKJCommonUtils.isEmpty(checkedMap[cartId])) {
      checkedMap[cartId] = false;
      return false;
    } else {
      return checkedMap[cartId];
    }
  }

  ///设置某个购物车商品选中状态
  ///
  /// [cartId] 购物车id
  ///
  /// [status] 购物车id对应商品选中状态
  ///
  _setSelectedStatus({cartId, bool status = false}) {
    checkedMap[cartId] = status;
    notifyListeners();
  }
}

///below is the use of garbage code
///
///
class ShoppingCartBeanEntity with ChangeNotifier {
  bool status;
  @JSONField(name: "err_code")
  String errCode;
  @JSONField(name: "err_msg")
  String errMsg;
  ShoppingCartBeanData data;
}

class ShoppingCartBeanData with ChangeNotifier {
  List<ShoppingCartBeanDataProduct> products;
  @JSONField(name: "error_warning")
  String errorWarning;
  List<ShoppingCartBeanDataTotal> totals;
  ShoppingCartBeanDataTotal total;
}

class ShoppingCartBeanDataProduct with ChangeNotifier {
  @JSONField(name: "cart_id")
  String cartId;
  @JSONField(name: "product_id")
  String productId;
  String thumb;
  String name;
  String model;
  List<ShoppingCartBeanDataProductsOption> option;
  String minTotals;
  String recurring;
  String quantity;
  bool stock;
  String reward;
  String price;
  String total;

  updateCartGoodsNum(bool isAdd) {
    try {
      int num = int.parse(quantity);
      isAdd ? num++ : num--;
      quantity = num.toString();
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}

class ShoppingCartBeanDataProductsOption with ChangeNotifier {
  String quantity;
  String name;
  String value;
}

class ShoppingCartBeanDataTotal with ChangeNotifier {
  String title;
  String text;
}
