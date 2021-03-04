import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:star/ktxx_global_config.dart';
import 'package:star/ktxxhttp/ktxx_http_manage.dart';
import 'package:star/ktxxmodels/ktxx_logistics_info_entity.dart';
import 'package:star/ktxxutils/ktxx_common_utils.dart';
import 'package:timeline_tile/timeline_tile.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedOrderLogisticsTrackingPage extends StatefulWidget {
  KeTaoFeaturedOrderLogisticsTrackingPage({Key key, this.orderId})
      : super(key: key);
  final String title = "物流跟踪";
  var orderId;
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;
  @override
  _KeTaoFeaturedOrderLogisticsTrackingPageState createState() =>
      _KeTaoFeaturedOrderLogisticsTrackingPageState();
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
class _KeTaoFeaturedOrderLogisticsTrackingPageState
    extends State<KeTaoFeaturedOrderLogisticsTrackingPage> {
  ///运单号
  var _waybillNumber;

  ///快递公司
  var _carrier;

  ///物流当前状态
  var __deliveryStatus;

  ///物流当前状态对应图标
  var __deliveryStatusIconUrl;
  Color _activeColor = Color(0xff222222);
  Color _inactiveColor = Color(0xff999999);
  List<LogisticsInfoDataExpressList> _deliveryList;

  List<LogisticsInfoDataExpressList> _expressList =
      List<LogisticsInfoDataExpressList>();

  Future _initData({bool onlyChangeAddress = false}) async {
    EasyLoading.show();
    var result =
        await KeTaoFeaturedHttpManage.getOrderLogisticsInfo(widget.orderId);
    EasyLoading.dismiss();
    if (result.status) {
      try {
        if (mounted) {
          setState(() {
            if (!KeTaoFeaturedCommonUtils.isEmpty(result.data.expressInfo)) {
              _waybillNumber = result.data.expressInfo.number;
              if (!KeTaoFeaturedCommonUtils.isEmpty(
                  result.data.expressInfo.name)) {
                _carrier = result.data.expressInfo.name;
                if (!KeTaoFeaturedCommonUtils.isEmpty(
                    result.data.expressInfo.tel)) {
                  _carrier += "(${result.data.expressInfo.tel})";
                }
              }
            }
            _expressList = result.data.expressList;
            _deliveryList = List<LogisticsInfoDataExpressList>();
            for (LogisticsInfoDataExpressList item in _expressList) {
              if (!KeTaoFeaturedCommonUtils.isEmpty(item.xList)) {
                for (var it = 0; it < item.xList.length; it++) {
                  LogisticsInfoDataExpressList newItem =
                      LogisticsInfoDataExpressList();
                  newItem.time = item.xList[it].time;
                  newItem.desc = item.xList[it].subdesc;
                  newItem.type = item.type;
                  if (it == 0) {
                    newItem.title = item.title;
                  } else {
                    newItem.title = '';
                  }
                  _deliveryList.add(newItem);
                }
              } else {
                _deliveryList.add(item);
              }
            }
          });
        }
      } catch (e) {
        print("$e");
      }
    } else {
      KeTaoFeaturedCommonUtils.showToast("${result.errMsg}");
    }
  }

  @override
  void initState() {
    super.initState();
    if (KeTaoFeaturedCommonUtils.isEmpty(widget.orderId)) {
      return;
    }
    _initData();
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
        body: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: !KeTaoFeaturedCommonUtils.isEmpty(_waybillNumber),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible:
                              !KeTaoFeaturedCommonUtils.isEmpty(_waybillNumber),
                          child: SelectableText.rich(
                            TextSpan(text: '运单号码：', children: [
                              TextSpan(
                                text: '$_waybillNumber',
                                style: TextStyle(
                                  color: Color(0xff222222),
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(42),
                                ),
                              ),
                            ]),
                            style: TextStyle(
                              color: Color(0xff222222),
                              fontSize: ScreenUtil().setSp(42),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: !KeTaoFeaturedCommonUtils.isEmpty(_carrier),
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              '承运商：$_carrier',
                              style: TextStyle(
                                color: Color(0xff222222),
                                fontSize: ScreenUtil().setSp(42),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: KeTaoFeaturedGlobalConfig.taskNomalHeadColor,
                  height: 10,
                ),
                Visibility(
                  visible: KeTaoFeaturedCommonUtils.isEmpty(_deliveryList),
                  child: Container(
                    color: KeTaoFeaturedGlobalConfig.taskNomalHeadColor,
                    child: Center(
                      child: SelectableText.rich(
                        TextSpan(
                          text: '物流信息数据异常！',
                        ),
                        style: TextStyle(
                          color: Color(0xff222222),
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(42),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !KeTaoFeaturedCommonUtils.isEmpty(_deliveryList),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    width: double.maxFinite,
                    constraints:
                        BoxConstraints(minHeight: ScreenUtil().setHeight(2300)),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return buildTimelineTile(index);
                      },
                      itemCount:
                          _deliveryList == null ? 0 : _deliveryList.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Widget buildTimelineTile(int index) {
    int logisticsStatus = 0;
    var logisticsStatusIconUrl = '';
    var logisticsStatusActiveIconUrl = '';
    String title = '';
    String time = '';
    String desc = '';
    List<LogisticsInfoDataExpressListList> xList;
    try {
      LogisticsInfoDataExpressList item = _deliveryList[index];
      logisticsStatus = item.type;
      title = item.title;
      time = item.time;
      desc = item.desc;
    } catch (e) {}
    switch (logisticsStatus) {
      case 1:
      case 2:
        logisticsStatusIconUrl =
            'https://alipic.lanhuapp.com/xd0a8f2557-0488-4bb9-b3ae-bd4b060c224c';
        logisticsStatusActiveIconUrl =
            'https://alipic.lanhuapp.com/xdf0aaee0c-7082-4a8e-8089-bfffc8bf28cd';

        break;
      case 3:
        logisticsStatusIconUrl =
            'https://alipic.lanhuapp.com/xd12d16d14-1837-488f-841a-c67de472753d';
        logisticsStatusActiveIconUrl =
            'https://alipic.lanhuapp.com/xddf03c221-2a08-41f4-8422-88a6761db3c8';
        break;
      case 4:
      case 6:
        logisticsStatusIconUrl =
            'https://alipic.lanhuapp.com/xda25bb9ac-3343-4c48-a7d1-69e31c28a910';
        logisticsStatusActiveIconUrl =
            'https://alipic.lanhuapp.com/xd355200b3-443e-4e90-aa9d-68bc7ca5f38c';
        break;
      case 5:
        logisticsStatusIconUrl =
            'https://alipic.lanhuapp.com/xdc9ff7682-4ef0-442b-876e-e69fb83a4807';
        logisticsStatusActiveIconUrl =
            'https://alipic.lanhuapp.com/xd9ac8c35d-e96e-4907-b030-de67066abeb6';

        break;
      case 7:
        logisticsStatusIconUrl =
            'https://alipic.lanhuapp.com/xd05a2a677-ef52-489e-aea0-aad427addd4a';
        logisticsStatusActiveIconUrl =
            'https://alipic.lanhuapp.com/xd05a2a677-ef52-489e-aea0-aad427addd4a';
        break;
    }
    return TimelineTile(
      alignment: TimelineAlign.start,
      indicatorStyle: !KeTaoFeaturedCommonUtils.isEmpty(title)
          ? IndicatorStyle(
              color: Color(0xffD1D1D1),
              width: ScreenUtil().setWidth(60),
              height: ScreenUtil().setWidth(60),
              indicator: CachedNetworkImage(
                imageUrl:
                    '${index == 0 ? logisticsStatusActiveIconUrl : logisticsStatusIconUrl}',
                width: ScreenUtil().setWidth(60),
                height: ScreenUtil().setWidth(60),
                fit: BoxFit.fill,
              ),
            )
          : IndicatorStyle(
              color: Color(0xffD1D1D1),
              width: ScreenUtil().setWidth(60),
              height: ScreenUtil().setWidth(60),
              indicator: UnconstrainedBox(
                child: Container(
                  width: ScreenUtil().setWidth(24),
                  height: ScreenUtil().setWidth(24),
                  child: CircleAvatar(
                    backgroundColor: Color(0xffD1D1D1),
                  ),
                ),
              ),
            ),
      isFirst: index == 0,
      isLast: index == _deliveryList.length - 1,
      beforeLineStyle: xList == null
          ? LineStyle(
              color: Color(0xffD1D1D1),
              thickness: 1,
            )
          : LineStyle(
              color: Color(0xffD1D1D1),
              thickness: 0,
            ),
      endChild: Container(
        margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(32),
          top: ScreenUtil().setWidth(45),
          bottom: ScreenUtil().setWidth(45),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: !KeTaoFeaturedCommonUtils.isEmpty(title),
              child: Text(
                "$title",
                style: TextStyle(
                  color: index == 0 ? _activeColor : _inactiveColor,
                  fontSize: ScreenUtil().setSp(48),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Visibility(
              visible: !KeTaoFeaturedCommonUtils.isEmpty(desc),
              child: Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(20),
                ),
                child: Text(
                  "$desc",
                  style: TextStyle(
                    color: index == 0 ? _activeColor : _inactiveColor,
                    fontSize: ScreenUtil().setSp(38),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !KeTaoFeaturedCommonUtils.isEmpty(time),
              child: Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(20),
                ),
                child: Text(
                  "$time",
                  style: TextStyle(
                    color: index == 0 ? _activeColor : _inactiveColor,
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(38),
                  ),
                ),
              ),
            ),
            /* Flexible(
              flex: 1,
              child: Visibility(
                visible: !CommonUtils.isEmpty(xList) && xList.length > 1,
                child: Container(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return buildChildTimelineTile(xList, index);
                    },
                    itemCount: xList == null ? 0 : xList.length,
                  ),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  Widget buildChildTimelineTile(
      List<LogisticsInfoDataExpressListList> xList, int index) {
    String time = '';
    String desc = '';
    try {
      LogisticsInfoDataExpressListList item = xList[index];
      time = item.time;
      desc = item.subdesc;
    } catch (e) {}
    return Container(
      child: TimelineTile(
        alignment: TimelineAlign.start,
        lineXY: 0.7,
        isLast: index == xList.length - 1,
        indicatorStyle: IndicatorStyle(
          color: Color(0xffD1D1D1),
          width: ScreenUtil().setWidth(60),
          height: ScreenUtil().setWidth(60),
          indicator: UnconstrainedBox(
            child: Container(
              width: ScreenUtil().setWidth(24),
              height: ScreenUtil().setWidth(24),
              child: CircleAvatar(
                backgroundColor: Color(0xffD1D1D1),
              ),
            ),
          ),
        ),
        beforeLineStyle: LineStyle(
          color: Color(0xffD1D1D1),
          thickness: 1,
        ),
        endChild: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(20),
                ),
                child: Text(
                  "$desc",
                  style: TextStyle(
                    color: _inactiveColor,
                    fontSize: ScreenUtil().setSp(38),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(20),
                ),
                child: Text(
                  "$time",
                  style: TextStyle(
                    color: _inactiveColor,
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(38),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}