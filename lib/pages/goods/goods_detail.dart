import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:ui' as ui show window;

import 'package:star/bus/my_event_bus.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/goods_info_entity.dart';
import 'package:star/pages/goods/ensure_order.dart';
import 'package:star/pages/login/login.dart';
import 'package:star/pages/task/task_index.dart';
import 'package:star/pages/widget/goods_select_choice.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';

import '../../global_config.dart';

class GoodsDetailPage extends StatefulWidget {
  var productId;

  GoodsDetailPage({@required this.productId});

  @override
  _GoodsDetailPageState createState() => _GoodsDetailPageState();
}

class _GoodsDetailPageState extends State<GoodsDetailPage>
    with TickerProviderStateMixin {
  AnimationController _controller;
  var _txtRedColor = const Color(0xffF93736);
  var _bgRedColor = const Color(0xffF32e43);

  GoodsInfoEntity detailData;
  var _salePrice = '';
  var _originalPrice = '';

  Future _initData() async {
    try {
      EasyLoading.show();
    } catch (e) {}
    try {
      GoodsInfoEntity resultData =
          await HttpManage.getProductDetails(widget.productId);
      if (resultData.status) {
        if (mounted) {
          setState(() {
            try {
              detailData = resultData;
              _detailImgs = detailData.data.detailImgs;
              _salePrice = detailData.data.salePrice;
              _originalPrice = detailData.data.originalPrice;
            } catch (e) {}
          });
        } else {}
      } else {
        Fluttertoast.showToast(
            msg: resultData.errMsg,
            textColor: Colors.white,
            backgroundColor: Colors.grey);
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

  var _detailImgs = [];

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return FlutterEasyLoading(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: ScreenUtil().setHeight(60),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: ScreenUtil().setHeight(1231),
                          child: Swiper(
                            itemHeight: ScreenUtil().setHeight(1231),
                            itemCount: detailData == null ||
                                    detailData.data == null ||
                                    detailData.data.bannerImgs == null
                                ? 1
                                : detailData.data.bannerImgs.length,
/*
                            itemCount: detailData == null ||
                                    detailData.data == null ||
                                    detailData.data.images == null
                                ? 1
                                : detailData.data.images.length,
*/
                            itemBuilder: (BuildContext context, int index) {
                              return detailData != null
                                  ? new CachedNetworkImage(
                                      imageUrl: detailData
                                                  .data.bannerImgs[index] ==
                                              null
                                          ? ""
                                          : detailData.data.bannerImgs[index],
                                      fit: BoxFit.fill,
                                    )
                                  : Image.asset("static/images/c_error.jpg");
                            },
                            autoplay: true,
                            controller: SwiperController(),
                            pagination: new SwiperPagination(
                                alignment: Alignment.bottomRight,
                                builder: FractionPaginationBuilder(
                                  activeColor: Colors.black,
                                  color: Colors.black,
                                  fontSize: ScreenUtil().setSp(20),
                                  activeFontSize: ScreenUtil().setSp(20),
                                )),
                          ),
                        ),
                        Divider(
                          height: 1,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          padding: EdgeInsets.symmetric(
                              vertical: 18, horizontal: 16),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(30)))),
                          child: Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    "￥$_salePrice",
                                    style: TextStyle(
                                        color: _txtRedColor,
                                        fontSize: ScreenUtil().setSp(56),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Visibility(
                                    visible: true,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          bottom: ScreenUtil().setHeight(8)),
                                      child: Text(
                                        "￥$_originalPrice",
//                                      "${_getPrice(false) == null ? "" : _getPrice(false)}",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: ScreenUtil().setSp(36),
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Wrap(
                                  spacing: 10,
                                  children: <Widget>[
                                    Text(
                                      "${detailData == null || detailData.data == null ? "" : detailData.data.goodsName}",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(42),
                                      ),
                                      textAlign: TextAlign.start,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(57),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        width: ScreenUtil().setWidth(9),
                                        height: ScreenUtil().setWidth(9),
                                        child: CircleAvatar(
                                            backgroundColor:
                                                Color(0xFFFF8800))),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: ScreenUtil().setWidth(12),
                                      height: ScreenUtil().setWidth(12),
                                      child: CircleAvatar(
                                          backgroundColor: Color(0xFFFF7270)),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: ScreenUtil().setWidth(16),
                                      height: ScreenUtil().setWidth(16),
                                      child: CircleAvatar(
                                          backgroundColor: Color(0xFFFBEE3A)),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("商品详情"),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: ScreenUtil().setWidth(16),
                                      height: ScreenUtil().setWidth(16),
                                      child: CircleAvatar(
                                          backgroundColor: Color(0xFFFBEE3A)),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: ScreenUtil().setWidth(12),
                                      height: ScreenUtil().setWidth(12),
                                      child: CircleAvatar(
                                          backgroundColor: Color(0xFFFF7270)),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: ScreenUtil().setWidth(9),
                                      height: ScreenUtil().setWidth(9),
                                      child: CircleAvatar(
                                          backgroundColor: Color(0xFFFF8800)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (content, index) {
                      return CachedNetworkImage(
                        imageUrl: _detailImgs[index],
/*
         todo               imageUrl: detailData.data.images[index].popup == null
                            ? ""
                            : detailData.data.images[index].popup,
*/
                        fit: BoxFit.fill,
                      );
                    },
                    childCount: _detailImgs.length,
/*
                    childCount: detailData == null ||
                            detailData.data == null ||
                            detailData.data.images == null
                        ? 0
                        : detailData.data.images.length,
*/
                  ),
                )
              ],
            ),
            SafeArea(
              child: Container(
                height: 50,
                alignment: Alignment.topLeft,
                child: ClipOval(
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: ScreenUtil().setHeight(245),
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin:
                            EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                        child: IconButton(
                            icon: CachedNetworkImage(
                              imageUrl:
                                  "https://alipic.lanhuapp.com/xd213bb1c5-b03e-4bcd-8573-9837e479d518",
                              width: ScreenUtil().setWidth(80),
                              height: ScreenUtil().setHeight(80),
                            ),
                            color: Colors.grey,
                            onPressed: () {
                              NavigatorUtils.navigatorRouterAndRemoveUntil(
                                  context, TaskIndexPage());
                            }),
                      ),
                      Expanded(
                        child: Container(
                          height: ScreenUtil().setHeight(155),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                        ScreenUtil().setWidth(30),
                                      ),
                                      topRight: Radius.circular(
                                        ScreenUtil().setWidth(30),
                                      ),
                                    ),
                                  ),
                                  builder: (BuildContext context) {
                                    return DetailWindow(
                                      detailData: detailData,
                                      type: 1,
                                    );
                                  });
                            },
                            child: Container(
                              height: ScreenUtil().setHeight(155),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 26),
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                " 立即购买 ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(42)),
                              ),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Color(0xFFF93736),
                                    Color(0xFFF93664)
                                  ]),
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//商品规格弹窗
class DetailWindow extends StatefulWidget {
//  GoodsDetailBeanEntity detailData; todo
  GoodsInfoEntity detailData;
  int type;

  DetailWindow({@required this.detailData, @required this.type});

  @override
  _DetailWindowState createState() => _DetailWindowState();
}

class _DetailWindowState extends State<DetailWindow>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  var minStockNum = 999999999;
  var _txtRedColor = const Color(0xffF93736);
  var _bgRedColor = const Color(0xffF32e43);

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    //_initSelectedMap();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

//商品价格

  var selectedMap = HashMap();

  //减少按钮
  Widget _reduceBtn(context) {
    return InkWell(
      onTap: () {
        if (_count > 1) {
          setState(() {
            _count--;
          });
        }
      },
      child: Container(
        width: ScreenUtil().setWidth(115),
        //是正方形的所以宽和高都是45
        height: ScreenUtil().setWidth(115),
        alignment: Alignment.center,
        //上下左右都居中
        decoration: BoxDecoration(
            color: _count > 1 ? Colors.white : Colors.black12,
            //按钮颜色大于1是白色，小于1是灰色
            border: Border(
                //外层已经有边框了所以这里只设置右边的边框
                right: BorderSide(width: 1.0, color: Colors.black12))),
        child: Text('-'), //数量小于1 什么都不显示
      ),
    );
  }

  //加号
  Widget _addBtn(context) {
    return InkWell(
      onTap: () {
        if (_count < minStockNum) {
          setState(() {
            _count++;
          });
        }
      },
      child: Container(
        width: ScreenUtil().setWidth(115),
        //是正方形的所以宽和高都是45
        height: ScreenUtil().setWidth(115),
        alignment: Alignment.center,
        //上下左右都居中
        decoration: BoxDecoration(
            color: _count < minStockNum ? Colors.white : Colors.black12,
            //按钮颜色大于1是白色，小于1是灰色
            border: Border(
                //外层已经有边框了所以这里只设置右边的边框
                left: BorderSide(width: 1.0, color: Colors.black12))),
        child: Text('+'),
      ),
    );
  }

  int _count = 1;

  //中间数量显示区域
  Widget _countArea() {
    return Container(
      width: ScreenUtil().setWidth(135),
      //爬两个数字的这里显示不下就宽一点70
      height: ScreenUtil().setWidth(115),
      //高度和加减号保持一样的高度
      alignment: Alignment.center,
      //上下左右居中
      color: Colors.white,
      // 设置为白色
      child: Text(
        '$_count',
        style: TextStyle(
            fontSize: ScreenUtil().setSp(54), color: const Color(0xff666666)),
      ), //先默认设置为1 因为后续是动态的获取数字
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.maxFinite,
        height: ScreenUtil().setHeight(700),
        constraints: BoxConstraints(
          minHeight: ScreenUtil().setHeight(500), //设置最小高度（必要）
          maxHeight: MediaQuery.of(context).size.height / 1.5, //设置最大高度（必要）
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              ScreenUtil().setWidth(30),
            ),
            topRight: Radius.circular(
              ScreenUtil().setWidth(30),
            ),
          ),
        ),
//        height:  MediaQueryData.fromWindow(ui.window).size.height * 9.0 / 16.0,
        child: Stack(
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                buildTopBox(),
//                buildSpecList(),
              ],
            ),
            Positioned.fill(
              bottom: ScreenUtil().setHeight(0),
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: ScreenUtil().setHeight(340),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "数量",
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(42),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(""),
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color:
                                            Colors.black12) //设置所有的边框宽度为1 颜色为浅灰
                                    ),
                                child: Row(
                                  children: <Widget>[
                                    _reduceBtn(context),
                                    _countArea(),
                                    _addBtn(context)
                                  ],
                                ))
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () async {
                            createBuyOrder(context);
                            Navigator.maybePop(context);
                          },
                          child: Container(
                            height: ScreenUtil().setHeight(155),
                            color: minStockNum > 0 ? _bgRedColor : Colors.grey,
                            alignment: Alignment.center,
                            child: Text(
                              "确定",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(48),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      child: Icon(Icons.close, size: 22)),
                )),
          ],
        ),
      ),
    );
  }

  Future createBuyOrder(context) async {
    var goodsId = '';
    var goodsNum;
    var orderId = '';
    try {
      goodsId = widget.detailData.data.id;
      goodsNum = _count;
    } catch (e) {}
    var result = await HttpManage.createOrder(goodsId, goodsNum);
    if (result.status) {
      try {
        orderId = result.data['order_id'].toString();
      } catch (e) {}
      if (!CommonUtils.isEmpty(context)) {
        NavigatorUtils.navigatorRouter(
            context,
            EnsureOrderPage(
              orderId: "$orderId",
            ));
      }
    }
  }

  Widget buildTopBox() {
    var _defaultImgUrl = '';
    var goodsName = '';
    var goodsPrice = '';
    try {
      _defaultImgUrl = widget.detailData.data.bannerImgs[0];
      goodsName = widget.detailData.data.goodsName;
      goodsPrice = widget.detailData.data.salePrice;
    } catch (e) {}
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: "$_defaultImgUrl",
/*
                  widget.detailData == null || widget.detailData.data == null
                      ? ""
                      : widget.detailData.data.thumb,
*/
              width: ScreenUtil().setWidth(180),
              height: ScreenUtil().setWidth(180),
              fit: BoxFit.fill,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: "￥",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(42),
                        ),
                      ),
                      TextSpan(
                        text: "$goodsPrice",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(42),
                        ),
                      ),
                    ]),
                    style: TextStyle(
                      color: _txtRedColor,
                      fontSize: ScreenUtil().setSp(56),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(16)),
                    child: Text(
                      "$goodsName",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(42),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
