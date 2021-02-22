import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:star/ktxx_global_config.dart';
import 'package:star/ktxxmodels/ktxx_order_detail_entity.dart';
import 'package:star/ktxxpages/ktxxorder/ktxxreturn/ktxx_return_option_info.dart';
import 'package:star/ktxxutils/ktxx_navigator_utils.dart';
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
class KeTaoFeaturedReturnGoodsOptionPage extends StatefulWidget {
  KeTaoFeaturedReturnGoodsOptionPage({Key key, this.product}) : super(key: key);
  final String title = "选择服务";
  KeTaoFeaturedOrderDetailDataGoodsList product;
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;
  @override
  _KeTaoFeaturedReturnGoodsOptionPageState createState() => _KeTaoFeaturedReturnGoodsOptionPageState();
}
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _KeTaoFeaturedReturnGoodsOptionPageState extends State<KeTaoFeaturedReturnGoodsOptionPage> {
  @override
  void initState() {
    super.initState();
    product = widget.product;
  }

  @override
  void dispose() {
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
                buildtopGoodsContainer(),
                buildOptionsContainer(),
              ],
            ),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
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
        ],
      ),
    );
  }

  Container buildOptionsContainer() {
    return Container(
      padding: EdgeInsets.only(
        top: 16,
        bottom: 16,
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
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            margin: EdgeInsets.only(bottom: 8),
            child: Text(
              '选择服务类型',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(42),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildListTile(0),
          _buildListTile(1),
          _buildListTile(2),
        ],
      ),
    );
  }

  Widget _buildListTile(int type) {
    var title = '';
    var subTitle = '';
    var iconUrl = '';
    try {
      switch (type) {
        case 0: //退款
          title = '我要退款(无需退货)';
          subTitle = '没收到货，或与卖家协商同意不用退货只退款';
          iconUrl =
              'https://alipic.lanhuapp.com/xdc05c048e-39ae-442b-b7df-83a8d279efce';
          break;
        case 1: //退货退款
          title = '我要退货退款';
          subTitle = '已收到货，需要退还收到的货物';
          iconUrl =
              'https://alipic.lanhuapp.com/xd27d999e2-a5f9-4a4b-84ce-f545b85f3a1d';
          break;
        case 2: //退换货
          title = '我要退货换货';
          subTitle = '已收到货，需要更换收到的货物';
          iconUrl =
              'https://alipic.lanhuapp.com/xd0201789e-6702-4f31-8f40-48280f71d536';
          break;
      }
    } catch (e) {
      print(e);
    }
    return MergeSemantics(
      child: ListTile(
        isThreeLine: true,
        dense: false,
        onTap: () {
          KeTaoFeaturedNavigatorUtils.navigatorRouter(
              context,
              KeTaoFeaturedReturnOptionInfoPage(
                product: product,
                pageType: type,
              ));
        },
        leading: Container(
          height: double.infinity,
          alignment: Alignment.center,
          width: ScreenUtil().setWidth(60),
          child: ExcludeSemantics(
            child: CachedNetworkImage(
              width: ScreenUtil().setWidth(60),
              height: ScreenUtil().setWidth(60),
              imageUrl: '$iconUrl',
            ),
          ),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              '$title',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(42),
                color: Color(0xff222222),
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
                      color: Color(0xff222222),
                    ),
                  ),
                ]),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        trailing: Container(
          alignment: Alignment.center,
          width: ScreenUtil().setWidth(36),
          child: CachedNetworkImage(
            width: ScreenUtil().setWidth(20),
            height: ScreenUtil().setWidth(36),
            imageUrl:
                'https://alipic.lanhuapp.com/xd6b0fc912-422b-4a25-8cf0-fab0ca862249',
          ),
        ),
      ),
    );
  }
}