import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:star/bus/ktkj_my_event_bus.dart';
import 'package:star/generated/json/base/json_convert_content.dart';
import 'package:star/generated/json/base/json_field.dart';
import 'package:star/pages/ktkj_widget/ktkj_PriceText.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_octoimage.dart';
import 'package:star/utils/ktkj_common_utils.dart';
import 'package:star/utils/ktkj_utils.dart';

class KTKJShoppingCartPage extends StatefulWidget {
  KTKJShoppingCartPage({Key key}) : super(key: key);
  final String title = "购物车";
  List<ShoppingCartBeanDataProduct> products;

  @override
  _KTKJShoppingCartPageState createState() => _KTKJShoppingCartPageState();
}

class _KTKJShoppingCartPageState extends State<KTKJShoppingCartPage> {
  var _colorRed = Color(0xffF32E43);

  _initData() async {
    /*ShoppingCartBeanEntity result = await HttpManage.getCartList();
    if (mounted) {
      setState(() {
        widget.products = result.data.products;
        totalPrice = 0.0;
        _isAllCheckedValue = false;
        if (widget.products != null) {
          int length = widget.products.length;
          print("购物车商品条目数量：" + length.toString());
          for (var product in widget.products) {
            checkedMap.putIfAbsent(product, () => false);
          }
        }
      });
    }*/
  }

  var _isEditStatus = false;
  double totalPrice = 0.0;
  bool _isAllCheckedValue = false;
  Map<ShoppingCartBeanDataProduct, bool> checkedMap = Map();

  _isAllSelected() {
    setState(() {
      _isAllCheckedValue = !_isAllCheckedValue;
      /*if (_isAllCheckedValue) {
        totalPrice = 0.0;
        for (var product in widget.products) {
          checkedMap[product] = true;
          _countTotalPrice();
          */ /*  if (product.price.contains("¥")) {
            print(product.price.substring(
                product.price.indexOf("¥") + 1, product.price.length));
          }
          totalPrice += int.parse(product.quantity) *
              double.parse(product.price.substring(
                  product.price.indexOf("¥") + 1, product.price.length));*/ /*
        }
      } else {
        for (var product in widget.products) {
          checkedMap[product] = false;
        }
        totalPrice = 0.0;
      }*/
    });
  }

  _isAllSelected2(bool _isAllCheck) {
    print("_isAllSelected2");
    if (!mounted) {
      return;
    }
    setState(() {
      _isAllCheckedValue = !_isAllCheckedValue;
      /*todo
      if (_isAllCheckedValue) {
        totalPrice = 0.0;
        for (var product in widget.products) {
          checkedMap[product] = true;
        }
        _countTotalPrice();
      } else {
        for (var product in widget.products) {
          checkedMap[product] = false;
        }
        totalPrice = 0.0;
      }*/
    });
  }

  _countTotalPrice() {
    totalPrice = 0.0;
    for (var product in widget.products) {
      ///todo 价格金额计算
      /*if (product.price.contains("¥")) {
        product.price = product.price.replaceAll(",", "");
        print(product.price);
      }
      if (checkedMap[product]) {
        totalPrice += double.parse(product.quantity) *
            double.parse(product.price.substring(
                product.price.indexOf("¥") + 1, product.price.length));
      }*/
    }
    print("totalPrice：=" + totalPrice.toString());
    totalPrice = KTKJUtils.formatNum(totalPrice, 2);
    print("totalPrice2：=" + totalPrice.toString());
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
                    onPressed: () {
//                todo 跳转确认订单页面
                      List<String> cartIdList = List<String>();
                      for (var product in widget.products) {
                        if (checkedMap[product]) {
//                    cartIdList.add(product.cartId);
                        }
                      }
                      if (cartIdList.length == 0) {
                        KTKJCommonUtils.showToast("请选择要结算的商品 ！");
                      } else {
                        /// todo 跳转确认订单页面
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<ShoppingCartBeanDataProduct> selectedProducts;

  //调用接口删除所有选中的购物车商品
  Future<void> _delCartGoods() async {
    selectedProducts = List<ShoppingCartBeanDataProduct>();
    for (var product in widget.products) {
      if (checkedMap[product]) {
        /*var isDelSuccess = await HttpManage.cartdel(
            product.cartId.trim(), product.quantity.trim());
        selectedProducts.add(product);*/
        /* Future.delayed(Duration(seconds: 1))
              .then((value) => );*/
      }
    }
    bus.emit("delCartAllSelected", true);
  }

  @override
  void initState() {
    super.initState();
    bus
      ..on("allCheckedneedsChange", (arg) {
        if (arg && mounted) {
          setState(() {
            if (_isAllCheckedValue) {
              _isAllCheckedValue = !_isAllCheckedValue;
            } else {
              var isAllChecked = true;
              for (var product in widget.products) {
                if (!checkedMap[product]) {
                  isAllChecked = false;
                }
              }
              if (isAllChecked) {
                _isAllCheckedValue = true;
              }
            }
            _countTotalPrice();
          });
        }
      });
    bus
      ..on("countPrice", (arg) {
        if (mounted) {
          setState(() {
            if (arg) {
              _countTotalPrice();
            }
          });
        }
      });
    bus
      ..on("delCart", (product) {
        if (mounted) {
          setState(() {
//              _initData();

            widget.products.remove(product);
            _countTotalPrice();
          });
        }
      });
    bus
      ..on("delCartAllSelected", (args) {
        if (mounted) {
          setState(() {
            for (var product in selectedProducts) {
              widget.products.remove(product);
            }
            _countTotalPrice();
          });
        }
      });
    bus.on("isEditStatus", (isEditStatus) {
      if (mounted) {
        setState(() {
          _isEditStatus = isEditStatus;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
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
      body: new Stack(
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
                    child: widget.products != null
                        ? Center(
//                            child: CircularProgressIndicator(),
                            )
                        : NotificationListener(
                            onNotification: (ScrollNotification notification) {
                              bus.emit(
                                  "isEditStatus", _isEditStatus); //解决item布局错乱问题
                            },
                            child: ListView.separated(
                              itemBuilder: (BuildContext context, int index) {
                                return ShoppingCartRow(
//                                  product: widget.products[index],
//                                  checkedMap: checkedMap,
                                    );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Visibility(child: Text(""));
                              },
                              itemCount: 10,
//                            itemCount: widget.products.length,
                              /*children: widget.products
                              .map((product) => ShoppingCartRow(
                                  product: product, checkedMap: checkedMap))
                              .toList(),*/
                            ),
                          ))),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomLayout(),
          )
        ],
      ),
    );
  }
}

class ShoppingCartRow extends StatefulWidget {
  ShoppingCartBeanDataProduct product;
  Map<ShoppingCartBeanDataProduct, bool> checkedMap;

  ShoppingCartRow({this.product, this.checkedMap});

  @override
  _ShoppingCartRowState createState() => _ShoppingCartRowState();
}

class _ShoppingCartRowState extends State<ShoppingCartRow> {
  var _isEditStatus = false;
  var productId;
  var productName = '单鞋女2019春款网红浅口粗跟奶鞋豆豆百搭中跟晚晚仙';
  var productPrice = '￥32.80';
  var productImg =
      'https://alipic.lanhuapp.com/xd2f520b38-025c-48bb-9062-fce866a7f67b';
  var productSpec = '37码；豆绿色；蝴蝶结仙女款；';
  var productCoin = '分红金：¥1.2';
  var productQuantity = '3';
  var minTotals = '10';
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
    try {
      isSel = widget.checkedMap[widget.product];
    } catch (e) {
      isSel = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.product != null) {
          /// todo 跳转商品详情
        }
      },
      child: Container(
//        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                  widget.checkedMap[widget.product] =
                      !widget.checkedMap[widget.product];
                } catch (e) {}
                isSel = !isSel;
//                bus.emit("allCheckedneedsChange", true);
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
                            "${!isSel ? "https://alipic.lanhuapp.com/xde378dbfe-8b40-49d3-a858-3e70c8c4a71a" : "https://alipic.lanhuapp.com/xdd733d4bc-a5f5-4439-8c87-f454642467a5"}",
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
              child: Image.network(
//          todo    widget.product.thumb,

                "$productImg",
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
//            todo        "${widget.product.name}",
                    "$productName",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: ScreenUtil().setWidth(42),
                      fontWeight: FontWeight.w600,
                      color: Color(0xff222222),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setWidth(20),
                      bottom: ScreenUtil().setWidth(20),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xfff6f5f5),
                      borderRadius: BorderRadius.circular(
                        ScreenUtil().setWidth(10),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(22),
                      vertical: ScreenUtil().setWidth(10),
                    ),
                    child: Text(
//            todo        "${widget.product.name}",
                      "$productSpec",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: ScreenUtil().setWidth(36),
                        color: Color(0xffa0a0a0),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
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
//            todo        "${widget.product.name}",
                      "$productCoin",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: ScreenUtil().setWidth(30),
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
//                     todo       "${widget.product.price}",
                          "$productPrice",
                          style: TextStyle(
                            color: Color(0xfff93736),
                            fontSize: ScreenUtil().setWidth(48),
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
                                  fontSize: ScreenUtil().setWidth(35),
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
        onPressed: () {
          setState(() {
            int num = int.parse(productQuantity);
            if (num > 1) {
              num--;
              productQuantity = num.toString();
            } else {}
//            bus.emit("countPrice", true);
//          todo 调用接口修改购物车数量
            /* HttpManage.cartModify(
            widget.product.cartId.trim(), widget.product.quantity.trim());*/
          });
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
        onPressed: () {
          setState(() {
            int num = int.parse(productQuantity);
            if (num < int.parse(minTotals)) {
              num++;
              productQuantity = num.toString();
//              bus.emit("countPrice", true);
//            todo 调用接口修改购物车数量
              /*HttpManage.cartModify(
                widget.product.cartId.trim(), quantity.trim());*/
            } else {
              /*Fluttertoast.showToast(
                msg: "只能买这么多了！",
                gravity: ToastGravity.BOTTOM,
                textColor: Colors.white,
                backgroundColor: Colors.grey);*/
            }
          });
        },
      ),
    );
  }

  int _count = 1;
}

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

class ShoppingCartBeanEntity
    with JsonConvert<ShoppingCartBeanEntity>, ChangeNotifier {
  bool status;
  @JSONField(name: "err_code")
  String errCode;
  @JSONField(name: "err_msg")
  String errMsg;
  ShoppingCartBeanData data;
}

class ShoppingCartBeanData
    with JsonConvert<ShoppingCartBeanData>, ChangeNotifier {
  List<ShoppingCartBeanDataProduct> products;
  @JSONField(name: "error_warning")
  String errorWarning;
  List<ShoppingCartBeanDataTotal> totals;
  ShoppingCartBeanDataTotal total;
}

class ShoppingCartBeanDataProduct
    with JsonConvert<ShoppingCartBeanDataProduct>, ChangeNotifier {
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

class ShoppingCartBeanDataProductsOption
    with JsonConvert<ShoppingCartBeanDataProductsOption>, ChangeNotifier {
  String quantity;
  String name;
  String value;
}

class ShoppingCartBeanDataTotal
    with JsonConvert<ShoppingCartBeanDataTotal>, ChangeNotifier {
  String title;
  String text;
}
