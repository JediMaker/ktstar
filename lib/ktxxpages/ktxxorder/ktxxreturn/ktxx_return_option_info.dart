import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:star/ktxxmodels/ktxx_order_detail_entity.dart';
import 'package:star/ktxxpages/ktxxadress/ktxx_my_adress.dart';
import 'package:star/ktxxpages/ktxxorder/ktxxreturn/ktxx_return_info.dart';
import 'package:star/ktxxutils/ktxx_common_utils.dart';
import 'package:star/ktxxutils/ktxx_navigator_utils.dart';

import '../../../ktxx_global_config.dart';
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
class KeTaoFeaturedReturnOptionInfoPage extends StatefulWidget {
  ///
  ///[pageType]页面类型
  ///
  /// 0 退款（无需退货）
  ///
  ///  1 退货退款
  ///
  ///  2 退货换货
  ///
  KeTaoFeaturedReturnOptionInfoPage({Key key, this.product, this.pageType = 0})
      : super(key: key);
  String title = "申请退款";int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;
  KeTaoFeaturedOrderDetailDataGoodsList product;

  ///
  ///[pageType]页面类型
  ///
  /// 0 退款（无需退货）
  ///
  ///  1 退货退款
  ///
  ///  2 退货换货
  ///
  int pageType;

  @override
  _KeTaoFeaturedReturnOptionInfoPageState createState() => _KeTaoFeaturedReturnOptionInfoPageState();
}
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _KeTaoFeaturedReturnOptionInfoPageState extends State<KeTaoFeaturedReturnOptionInfoPage> {
  /// 未收到货退货原因集合
  ///
  var _noReceivingReturnReasonList = [
    '不喜欢不想要',
    '空包裹',
    '快递/物流一致未送到',
    '快递/物流无跟踪记录',
    '货物破损已拒签',
  ];

  /// 收到货退货原因集合
  ///
  var _receivedReturnReasonList = [
    '材质与商品描述不符',
    '功能/效果与描述不符',
    '产地/类型/规格与描述不符',
    '做工问题',
    '商品质量问题',
    '少件/漏发',
    '收到商品破损/有污渍',
    '卖家发错货',
  ];
  var _cargoStatusList = [
    "未收到货",
    '已收到货',
  ];

  ///货物状态
  ///
  ///0 未收到货
  ///
  ///1 已收到货
  int _cargoStatus = -1;

  /// 未收到货退货原因索引
  ///
  var _noReceivingReasonSelectedIndex = -1;

  /// 收到货退货原因索引
  ///
  var _receivedReasonSelectedIndex = -1;

  var _returnMoney = '16.3';

  @override
  void initState() {
    super.initState();
    product = widget.product;
    if (widget.pageType == 2) {
      setState(() {
        widget.title = "申请退货";
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
      child: KeyboardDismissOnTap(
        child: Scaffold(
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
            backgroundColor: KeTaoFeaturedGlobalConfig.taskNomalHeadColor,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    child: buildtopGoodsContainer(),
                  ),
                  Visibility(
                    visible: widget.pageType != 2,
                    child: buildOptionsContainer(),
                  ),
                  Visibility(
                    visible: widget.pageType == 2,
                    child: _buildReturnReasonContainer(),
                  ),
                  Visibility(
                    visible: widget.pageType == 2,
                    child: _buildAddressContainer(),
                  ),
                  buildBtnLayout(),
                ],
              ),
            ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }

  KeTaoFeaturedOrderDetailDataGoodsList product;

  Container buildtopGoodsContainer() {
    return Container(
      padding: EdgeInsets.only(
        top: 16,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(28))),
          border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
              color: Colors.white,
              width: 0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8),
            child: Text(
              '退款商品',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(42),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
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
                  imageUrl: product.goodsImg == null ? "" : product.goodsImg,
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
          Visibility(
            child: Container(
              margin: EdgeInsets.only(bottom: 8, top: 8),
              child: Text(
                '请与商家协商，确定达成一致后填写协商好的退款金额',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(36),
                  color: Color(0xffF32E43),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildOptionsContainer() {
    return Container(
      padding: EdgeInsets.only(
        top: 16,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      margin: EdgeInsets.only(left: 16, right: 16, top: 10),
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(28))),
          border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
              color: Colors.white,
              width: 0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8),
            child: Text(
              '退款信息',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(42),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Visibility(visible: widget.pageType == 0, child: _buildListTile(0)),
          _buildListTile(1),
          _buildMoneyListTile(2),
        ],
      ),
    );
  }

  var cargoStatus;
  var _selectStatusTxt = '';
  var _selectReasonTxt = '';

  Widget _buildListTile(int type) {
    var title = '';
    var iconUrl = '';
    try {
      switch (type) {
        case 0:
          title = '货物状态';
          iconUrl =
              'https://alipic.lanhuapp.com/xdc05c048e-39ae-442b-b7df-83a8d279efce';
          break;
        case 1:
          title = '退款原因';
          iconUrl =
              'https://alipic.lanhuapp.com/xd27d999e2-a5f9-4a4b-84ce-f545b85f3a1d';
          break;
      }
    } catch (e) {
      print(e);
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        switch (type) {
          case 0: //货物状态
            showChooseStatusSheet();
            break;
          case 1: //退款原因
            showReturnReasonSheet();
            break;
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          top: 16,
          bottom: 16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '$title',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(42),
                color: Color(0xff222222),
              ),
            ),
            Text(
              ' *',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(42),
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                '',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(42),
                  color: Color(0xff999999),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Visibility(
              visible: type == 0,
              child: Text(
                '${KeTaoFeaturedCommonUtils.isEmpty(_selectStatusTxt) ? '请选择' : _selectStatusTxt}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(42),
                  color: KeTaoFeaturedCommonUtils.isEmpty(_selectStatusTxt)
                      ? Color(0xff999999)
                      : Color(0xff222222),
                ),
              ),
            ),
            Visibility(
              visible: type == 1,
              child: Text(
                '${KeTaoFeaturedCommonUtils.isEmpty(_selectReasonTxt) ? '请选择' : _selectReasonTxt}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(42),
                  color: KeTaoFeaturedCommonUtils.isEmpty(_selectReasonTxt)
                      ? Color(0xff999999)
                      : Color(0xff222222),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              width: ScreenUtil().setWidth(46),
              child: CachedNetworkImage(
                width: ScreenUtil().setWidth(20),
                height: ScreenUtil().setWidth(36),
                imageUrl:
                    'https://alipic.lanhuapp.com/xd6b0fc912-422b-4a25-8cf0-fab0ca862249',
              ),
            ),
          ],
        ),
      ),
    );
  }

  showChooseStatusSheet() {
    showBarModalBottomSheet(
      expand: false,
      context: this.context,
      backgroundColor: Colors.white,
      builder: (context) => StatefulBuilder(
        builder: (context, state) {
          return Stack(
            children: [
              Row(
                children: [
                  IconButton(
                      icon: Icon(CupertinoIcons.clear_thick),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ],
              ),
              Container(
                height: 400,
                color: Colors.white,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () async {
                        state(() {
                          _cargoStatus = index;
                          Navigator.of(context).pop();
                        });
                        setState(() {
                          _selectStatusTxt = _cargoStatusList[index];
                          _noReceivingReasonSelectedIndex = -1;
                          _receivedReasonSelectedIndex = -1;
                          _selectReasonTxt = '';
                        });
                      },
                      selected: _cargoStatus == index,
                      title: Text(
                        '${_cargoStatusList[index]}',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(48),
                          color: Color(0xff222222),
                        ),
                      ),
                      trailing: CachedNetworkImage(
                        imageUrl:
                            "${_cargoStatus == index ? "https://alipic.lanhuapp.com/xda760ae72-7c57-4c57-b898-6b6a00d16c9c" : "https://alipic.lanhuapp.com/xd9cbbe519-1886-421d-a02e-27d8c33cfc90"}",
                        width: ScreenUtil().setWidth(60),
                        height: ScreenUtil().setWidth(60),
                        fit: BoxFit.fill,
                      ),
                    );
                  },
                  itemCount: _cargoStatusList.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  showReturnReasonSheet() {
    showBarModalBottomSheet(
      expand: false,
      context: this.context,
      backgroundColor: Colors.white,
      builder: (context) => listView(),
    );
  }

  Widget listView() {
    return StatefulBuilder(
      builder: (context, state) {
        return Container(
          height: 400,
          color: Colors.white,
          child: ListView.builder(
            itemBuilder: (context, index) {
              var item = '';
              if (_cargoStatus == 0) {
                item = _noReceivingReturnReasonList[index];
              } else {
                item = _receivedReturnReasonList[index];
              }

              return ListTile(
                onTap: () async {
                  state(() {
                    if (_cargoStatus == 0) {
                      _noReceivingReasonSelectedIndex = index;
                    } else {
                      _receivedReasonSelectedIndex = index;
                    }
                    Navigator.of(context).pop();
                  });
                  setState(() {
                    if (_cargoStatus == 0) {
                      _selectReasonTxt = _noReceivingReturnReasonList[index];
                    } else {
                      _selectReasonTxt = _receivedReturnReasonList[index];
                    }
                  });
                },
                selected: _cargoStatus == 0
                    ? _noReceivingReasonSelectedIndex == index
                    : _receivedReasonSelectedIndex == index,
                title: Text(
                  '$item',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(48),
                    color: Color(0xff222222),
                  ),
                ),
                trailing: CachedNetworkImage(
                  imageUrl:
                      "${_cargoStatus == 0 && _noReceivingReasonSelectedIndex == index || _cargoStatus == 1 && _receivedReasonSelectedIndex == index ? "https://alipic.lanhuapp.com/xda760ae72-7c57-4c57-b898-6b6a00d16c9c" : "https://alipic.lanhuapp.com/xd9cbbe519-1886-421d-a02e-27d8c33cfc90"}",
                  width: ScreenUtil().setWidth(60),
                  height: ScreenUtil().setWidth(60),
                  fit: BoxFit.fill,
                ),
              );
            },
            itemCount: _cargoStatus == 0
                ? _noReceivingReturnReasonList.length
                : _receivedReturnReasonList.length,
          ),
        );
      },
    );
  }

  Widget _buildMoneyListTile(int type) {
    var title = '';
    var subTitle = '';
    var iconUrl = '';
    try {
      switch (type) {
        case 0: //退款
          title = '货物状态';
          iconUrl =
              'https://alipic.lanhuapp.com/xdc05c048e-39ae-442b-b7df-83a8d279efce';
          break;
        case 1: //退货退款
          title = '退款原因';
          iconUrl =
              'https://alipic.lanhuapp.com/xd27d999e2-a5f9-4a4b-84ce-f545b85f3a1d';
          break;
        case 2: //退换货
          title = '退款金额';
          subTitle = '不可修改，最多$_returnMoney';
          iconUrl =
              'https://alipic.lanhuapp.com/xd0201789e-6702-4f31-8f40-48280f71d536';
          break;
      }
    } catch (e) {
      print(e);
    }
    return MergeSemantics(
      child: MediaQuery(
        data: MediaQueryData(padding: EdgeInsets.zero),
        child: ListTile(
          isThreeLine: true,
          contentPadding: EdgeInsets.all(0),
          dense: false,
          onTap: () {},
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                '$title',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(42),
                  color: Color(0xff222222),
                ),
              ),
              Text(
                ' *',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(42),
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: '$subTitle',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(42),
                        color: Color(0xff999999),
                      ),
                    ),
                  ]),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          trailing: Container(
            child: Text(
              '￥$_returnMoney',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(42),
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReturnReasonContainer() {
    return Container(
      padding: EdgeInsets.only(
        top: 16,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      margin: EdgeInsets.only(left: 16, right: 16, top: 10),
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(28))),
          border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
              color: Colors.white,
              width: 0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8),
            child: Text(
              '退换原因',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(42),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            height: ScreenUtil().setHeight(300),
            decoration: BoxDecoration(
              color: Color(0x30cccccc),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  ScreenUtil().setWidth(30),
                ),
              ),
            ),
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.left,
              maxLines: 3,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(42),
              ),
              maxLength: 200,
              buildCounter: (
                BuildContext context, {
                int currentLength,
                int maxLength,
                bool isFocused,
              }) {
                return MediaQuery(
                  data: MediaQueryData(
                    padding: EdgeInsets.zero,
                  ),
                  child: Container(
                    margin: EdgeInsets.all(0),
                    child: Visibility(
                      visible: currentLength != 0,
                      child: Text(
                        '$currentLength/$maxLength',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(42),
                            color: Colors.black87),
                      ),
                    ),
                  ),
                );
              },
              decoration: InputDecoration(
                hintText: '\n补充描述，有助于商家更好的处理售后问题 0/200 ',
                hintStyle: TextStyle(wordSpacing: 20),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          )
        ],
      ),
    );
  }

  var addressDetail = "";
  var iphone = "";
  var name = "";

  Widget _buildAddressContainer() {
    return Container(
      padding: EdgeInsets.only(
        top: 16,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      margin: EdgeInsets.only(left: 16, right: 16, top: 10),
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(28))),
          border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
              color: Colors.white,
              width: 0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8),
            child: Text(
              '收货地址',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(42),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            color: Colors.white,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              onTap: () async {
//                      CommonUtils.isEmpty(iphone)
//                  ? Text(
//                '暂无收货地址信息，点击添加',
//                style: TextStyle(
//                  color: Colors.black12,
//                  fontSize: ScreenUtil().setSp(48),
//                ),
//              )
//                  :           _initData();
                KeTaoFeaturedNavigatorUtils.navigatorRouter(
                    context,
                    KeTaoFeaturedAddressListPage(
                      type: 2,
                    ));
              },
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
                          fontSize: ScreenUtil().setSp(48),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        iphone,
                        style: TextStyle(
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
                        '$addressDetail',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(32),
                            color: const Color(0xff999999)),
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
        ],
      ),
    );
  }

  /// 提交按钮操作
  Widget buildBtnLayout() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        top: ScreenUtil().setHeight(257),
        bottom: ScreenUtil().setHeight(257),
      ),
      child: Ink(
        child: InkWell(
            onTap: () async {
              if (widget.pageType == 0 && _cargoStatus == -1) {
                KeTaoFeaturedCommonUtils.showToast("请选择货物状态");
                return;
              }
              if (widget.pageType != 2 &&
                  _receivedReasonSelectedIndex == -1 &&
                  _noReceivingReasonSelectedIndex == -1) {
                KeTaoFeaturedCommonUtils.showToast("请选择退货原因");
                return;
              }
              KeTaoFeaturedNavigatorUtils.navigatorRouter(
                context,
                KeTaoFeaturedReturnInfoPage(
                  product: widget.product,
                ),
              );
            },
            child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 30),
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: ScreenUtil().setHeight(152),
                width: ScreenUtil().setWidth(810),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(100)),
                    color: Color(0xffF32E43)),
                child: Text(
                  "提交",
                  style: TextStyle(
                      color: Colors.white, fontSize: ScreenUtil().setSp(48)),
                ))),
      ),
    );
  }
}