import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/ktxx_global_config.dart';
import 'package:star/ktxxhttp/ktxx_http_manage.dart';
import 'package:star/ktxxmodels/ktxx_income_list_entity.dart';
import 'package:star/ktxxmodels/ktxx_task_record_list_entity.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_other_submission.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_submission.dart';
import 'package:star/ktxxpages/ktxxwidget/ktxx_no_data.dart';
import 'package:star/ktxxutils/ktxx_common_utils.dart';
import 'package:star/ktxxutils/ktxx_navigator_utils.dart';
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedTaskRecordListPage extends StatefulWidget {
  KeTaoFeaturedTaskRecordListPage({Key key}) : super(key: key);
  final String title = "任务提交记录";
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
  _KeTaoFeaturedTaskRecordListPageState createState() => _KeTaoFeaturedTaskRecordListPageState();
}
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _KeTaoFeaturedTaskRecordListPageState extends State<KeTaoFeaturedTaskRecordListPage> {
  ///  任务状态 -2不可领取 -1去开通 0领任务 1待提交 2待审核 3已完成 4被驳回
  int page = 1;
  EasyRefreshController _refreshController;
  bool isFirstLoading = true;
  List<TaskRecordListDataList> _recordList;
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;
  _initData() async {
    TaskRecordListEntity result = await KeTaoFeaturedHttpManage.getTaskRecordList(page, 10);
    if (result.status) {
      if (mounted) {
        setState(() {
          if (page == 1) {
            _recordList = result.data.xList;
          } else {
            if (result == null ||
                result.data == null ||
                result.data.xList == null ||
                result.data.xList.length == 0) {
              //              _refreshController.resetLoadState();
              _refreshController.finishLoad(noMore: true);
            } else {
              _recordList += result.data.xList;
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
          backgroundColor: KeTaoFeaturedGlobalConfig.taskNomalHeadColor,
          centerTitle: true,
//          backgroundColor: Color(0xfff5f5f5),
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
          emptyWidget: _recordList == null || _recordList.length == 0
              ? KeTaoFeaturedNoDataPage()
              : null,
          slivers: <Widget>[buildCenter()],
        )

        /// This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget buildCenter() {
    return SliverToBoxAdapter(
      child: Container(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            TaskRecordListDataList listItem = _recordList[index];
            return buildItemLayout(listItem: listItem);
          },
          itemCount: _recordList == null ? 0 : _recordList.length,
        ),
      ),
    );
  }

  buildItemLayout({TaskRecordListDataList listItem}) {
    String title = "";
    String price = "";
    String status;
    String rejectReason = "";
    String submitTime = "";
    String checkTime = "";
    String taskId;
    String comId;
    String category = '1';
    String reSubmit = "0";
    bool showSubmitButton = false;
    try {
      taskId = listItem.taskId;
      comId = listItem.comId;
      title = listItem.title;
      price = listItem.price;
      status = listItem.status;
      rejectReason = listItem.rejectReason;
      submitTime = listItem.submitTime;
      checkTime = listItem.checkTime;
      reSubmit = listItem.reSubmit;
      category = listItem.category;
    } catch (e) {}
    var statusDesc = "";
    Color bgColor = Colors.white;
    Color txtColor = Colors.white;
    switch (status) {
      case "1":
        statusDesc = "待提交";
        bgColor = Color(0xffFFC4C4);
        txtColor = Color(0xffF93736);
        break;
      case "2":
        statusDesc = "审核中";
        bgColor = Color(0xffFFEAD2);
        txtColor = Color(0xffFF9100);
        break;
      case "3":
        statusDesc = "已通过";
        bgColor = Color(0xffE0F8E7);
        txtColor = Color(0xff3BBC6E);
        break;
      case "4":
        statusDesc = "已驳回";
        bgColor = Color(0xffFFC4C4);
        txtColor = Color(0xffF93736);
        break;
    }
    showSubmitButton = reSubmit == "2";
    print(reSubmit);

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 16, vertical: ScreenUtil().setHeight(16)),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    /* Image.asset(
                      "static/images/icon_fans.png",
                      width: ScreenUtil().setWidth(44),
                      height: ScreenUtil().setWidth(71),
                    ),*/
                    Text(
                      "$title",
                      style: TextStyle(
//                color:  Color(0xFF222222) ,
                          fontSize: ScreenUtil().setSp(42)),
                    ),
                  ],
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(150),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    Text(
                      "$price元",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(42),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "奖励金额",
                      style: TextStyle(
                        color: Color(0xff999999),
                        fontSize: ScreenUtil().setSp(32),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: ScreenUtil().setHeight(0),
          ),
          Wrap(
            runSpacing: 4,
            spacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Image.asset(
                "static/images/icon_check.png",
                width: ScreenUtil().setWidth(35),
                height: ScreenUtil().setHeight(39),
                fit: BoxFit.fill,
              ),
              Text(
                //状态：
                "状态：",
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(36),
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(144),
                height: ScreenUtil().setHeight(59),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(10))),
                    border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                        color: bgColor,
                        width: 0.5)),
                child: Text(
                  //状态：
                  statusDesc,
                  style: TextStyle(
                    color: txtColor,
                    fontSize: ScreenUtil().setSp(32),
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            // todo
            visible: category == "3"
                ? !KeTaoFeaturedCommonUtils.isEmpty(rejectReason) ? true : false
                : status == "4" ? true : false,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: ScreenUtil().setHeight(16),
                ),
                Wrap(
                  runSpacing: 4,
                  spacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "static/images/icon_reason.png",
                          width: ScreenUtil().setWidth(33),
                          height: ScreenUtil().setWidth(33),
                          fit: BoxFit.fill,
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(8),
                        ),
                        Expanded(
                          child: Wrap(
                            children: <Widget>[
                              Text(
                                //状态：
                                "原因：$rejectReason",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(36),
                                    color: Color(0xff666666)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    /*Text(
                      //状态：
                      "原因：$rejectReason",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(36),
                          color: Color(0xff666666)),
                    ),*/
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(55),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      runSpacing: 4,
                      spacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "static/images/icon_submit_time.png",
                          width: ScreenUtil().setWidth(32),
                          height: ScreenUtil().setWidth(32),
                          fit: BoxFit.fill,
                        ),
                        Text(
                          //状态：
                          "提交时间：",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(32),
                            color: Color(0xffb9b9b9),
                          ),
                        ),
                        Text(
                          //
                          //                                2019-07-02 19:01:32
                          //                            ：
                          submitTime,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(32),
                            color: Color(0xff222222),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(16),
                    ),
                    Wrap(
                      runSpacing: 4,
                      spacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "static/images/icon_check_time.png",
                          width: ScreenUtil().setWidth(32),
                          height: ScreenUtil().setWidth(32),
                          fit: BoxFit.fill,
                        ),
                        Text(
                          //状态：
                          "审核时间：",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(32),
                            color: Color(0xffb9b9b9),
                          ),
                        ),
                        Text(
                          checkTime,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(32),
                            color: Color(0xff222222),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: showSubmitButton, //showSubmitButton,
                child: GestureDetector(
                  onTap: () {
                    if (category == '1') {
                      KeTaoFeaturedNavigatorUtils.navigatorRouter(
                          context,
                          KeTaoFeaturedTaskSubmissionPage(
                            taskId: taskId,
                            comId: comId,
                            pageType: 1,
                          ));
                    } else {
                      KeTaoFeaturedNavigatorUtils.navigatorRouter(
                          context,
                          KeTaoFeaturedTaskOtherSubmissionPage(
                            taskId: taskId,
                            comId: comId,
                            pageType: 1,
                          ));
                    }
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(176),
                    height: ScreenUtil().setHeight(68),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setWidth(47))),
                        border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                            color: Color(0xFFCE0100),
                            width: 0.5)),
                    child: Text(
                      //状态：
                      "${status == "4" ? "重新提交" : "去提交"}",
                      style: TextStyle(
                        color: Color(0xFFCE0100),
                        fontSize: ScreenUtil().setSp(34),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
