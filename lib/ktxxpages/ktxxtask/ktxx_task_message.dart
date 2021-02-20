import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/ktxxhttp/ktxx_http_manage.dart';
import 'package:star/ktxxmodels/ktxx_message_list_entity.dart';
import 'package:star/ktxxpages/ktxxwidget/ktxx_no_data.dart';
import 'package:star/ktxxutils/ktxx_common_utils.dart';

import '../../ktxx_global_config.dart';
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedTaskMessagePage extends StatefulWidget {
  KeTaoFeaturedTaskMessagePage({Key key}) : super(key: key);
  final String title = "我的消息";
//    Container(
//height: 6.0,
//width: 6.0,
//decoration: BoxDecoration(
//color: furnitureCateDisableColor,
//shape: BoxShape.circle,
//),
//),
//SizedBox(
//width: 5.0,
//),
//Container(
//height: 5.0,
//width: 20.0,
//decoration: BoxDecoration(
//color: Colors.blue[700],
//borderRadius: BorderRadius.circular(10.0)),
//),
  @override
  _KeTaoFeaturedTaskMessagePageState createState() => _KeTaoFeaturedTaskMessagePageState();
}
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _KeTaoFeaturedTaskMessagePageState extends State<KeTaoFeaturedTaskMessagePage> {
  ///消息类型 0官方提醒 1 系统通知
  String noticeType = "0";
  int page = 1;
  EasyRefreshController _refreshController;
  bool isFirstLoading = true;
  List<KeTaoFeaturedMessageListDataList> _msgList;
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;
  _initData() async {
    KeTaoFeaturedMessageListEntity result = await KeTaoFeaturedHttpManage.getMsgList(page, 10);
    if (result.status) {
      if (mounted) {
        setState(() {
          if (page == 1) {
            _msgList = result.data.xList;
          } else {
            if (result == null ||
                result.data == null ||
                result.data.xList == null ||
                result.data.xList.length == 0) {
              //              _refreshController.resetLoadState();
              _refreshController.finishLoad(noMore: true);
            } else {
              _msgList += result.data.xList;
            }
          }
          isFirstLoading = false;
        });
      }
    } else {
      KeTaoFeaturedCommonUtils.showToast(result.errMsg);
    }
  }

  @override
  void initState() {
    _refreshController = EasyRefreshController();
    _initData();
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: EasyRefresh.custom(
          topBouncing: false,
          bottomBouncing: false,
          header: MaterialHeader(),
          footer: MaterialFooter(),
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
              _msgList == null || _msgList.length == 0 ? KeTaoFeaturedNoDataPage() : null,
          slivers: <Widget>[buildCenter()],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget buildCenter() {
    return SliverToBoxAdapter(
      child: Container(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            KeTaoFeaturedMessageListDataList listItem = _msgList[index];
            return buildItemLayout(listItem: listItem);
          },
          itemCount: _msgList == null ? 0 : _msgList.length,
        ),
      ),
    );
  }

  buildItemLayout({KeTaoFeaturedMessageListDataList listItem}) {
    String id = "";
    String title = "";
    String desc = "";
    String noticeTime = "";
    String type;
    String readStatus;
    try {
      type = listItem.type;
      title = listItem.title;
      desc = listItem.desc;
      noticeTime = listItem.noticeTime;
      readStatus = listItem.readStatus;
    } catch (e) {}

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
          vertical: ScreenUtil().setHeight(16)),
      padding: EdgeInsets.all(ScreenUtil().setWidth(32)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(30))),
          border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
              color: Colors.white,
              width: 0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Image.asset(
                          type == "2"
                              ? "static/images/notice_offcial.png"
                              : "static/images/notice_system.png",
                          width: ScreenUtil().setWidth(60),
                          height: ScreenUtil().setWidth(60),
                        ),
                        Visibility(
                          visible: readStatus == "1",
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Container(
                              child: Image.asset(
                                "static/images/dot.png",
                                width: ScreenUtil().setWidth(21),
                                height: ScreenUtil().setWidth(21),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(20),
                    ),
                    Text(
                      type == "2" ? "官方提醒" : "系统通知  ",
                      style: TextStyle(
//                color:  Color(0xFF222222) ,
                          fontSize: ScreenUtil().setSp(42)),
                    ),
                  ],
                ),
              ),
              Container(
                child: Text(
                  noticeTime,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                    color: Color(0xff999999),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          Divider(
            height: ScreenUtil().setHeight(1),
            color: Color(0xFFefefef),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(47),
          ),
          ListTile(
            title: Text(
              //状态：
              title,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(42),
              ),
            ),
            subtitle: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.start,
              runSpacing: 4,
              children: <Widget>[
                Text(
                  //您于2020-23-12 14:32:10提交的任务截图被驳回，驳回原因为截图不符合
                  //要求。请当天及时重新提交~：
                  desc,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
