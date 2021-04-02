import 'package:star/pages/ktkj_widget/ktkj_my_octoimage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/global_config.dart';
import 'package:star/http/ktkj_http_manage.dart';
import 'package:star/models/income_list_entity.dart';
import 'package:star/pages/ktkj_widget/ktkj_no_data.dart';
import 'package:star/utils/ktkj_common_utils.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJIncomeListPage extends StatefulWidget {
  ///页面类型 0、1收益列表 2提现列表
  int pageType;

  KTKJIncomeListPage(
      {Key key,
      @required this.pageType,
      this.showAppBar = false,
      this.showType})
      : super(key: key);
  String title = "";
  bool showAppBar;
  var showType;

  @override
  _IncomeListPageState createState() => _IncomeListPageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _IncomeListPageState extends State<KTKJIncomeListPage>
    with AutomaticKeepAliveClientMixin {
  ///收益类型 0邀请 1任务
  String incomeType = "0";

  ///提现类型 0微信 1支付宝
  String withdrawalType = "0";
  bool isWithdrawal = false;
  int page = 1;
  EasyRefreshController _refreshController;
  bool isFirstLoading = true;
  List<IncomeListDataList> _profitList;

  _initData() async {
    lastTimeDesc = '';
    IncomeListEntity result = await HttpManage.getProfitList(page, 10,
        isWithdrawal: isWithdrawal, showType: widget.showType);
    if (result.status) {
      if (mounted) {
        setState(() {
          if (page == 1) {
            _profitList = result.data.xList;
          } else {
            if (result == null ||
                result.data == null ||
                result.data.xList == null ||
                result.data.xList.length == 0) {
              //              _refreshController.resetLoadState();
              _refreshController.finishLoad(noMore: true);
            } else {
              _profitList += result.data.xList;
            }
          }
          isFirstLoading = false;
        });
      }
    } else {
      KTKJCommonUtils.showToast(result.errMsg);
    }
  }

  @override
  void initState() {
    switch (widget.pageType) {
      case 0:
      case 1:
        widget.title = "收益明细";
        isWithdrawal = false;
        break;
      case 2:
        widget.title = "已提现记录";
        isWithdrawal = true;
        break;
    }
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Visibility(
          visible: widget.showAppBar,
          child: AppBar(
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
            backgroundColor: KTKJGlobalConfig.taskNomalHeadColor,
            elevation: 0,
          ),
        ),
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
        emptyWidget: _profitList == null || _profitList.length == 0
            ? KTKJNoDataPage()
            : null,
        slivers: <Widget>[buildCenter()],
      ),
    );
  }

  Widget buildCenter() {
    return SliverToBoxAdapter(
      child: Container(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            IncomeListDataList listItem = _profitList[index];
            return buildItemLayout(listItem: listItem);
          },
          itemCount: _profitList == null ? 0 : _profitList.length,
        ),
      ),
    );
  }

  String lastTimeDesc = '';

  buildItemLayout({IncomeListDataList listItem}) {
    String price = '';
    String type = '';
    String profitType = '';
    String rejectReason = '';
    String createTime = '';
    String status = '';
    String statusText = '';
    String prefixText = '+';
    String timeDesc = '';
    String desc = '';
    String iconName = '';
    bool _showTimeDesc = true;
    String titleTxt = '';
    String titleIcon = '';
    try {
      price = listItem.price;
      status = listItem.status;
      rejectReason = listItem.rejectReason;
      createTime = listItem.createTime;
      timeDesc = listItem.timeDesc;
      _showTimeDesc = lastTimeDesc != timeDesc;
      lastTimeDesc = timeDesc;
      desc = listItem.desc;
      profitType = listItem.profitType;
      type = listItem.type;
      titleTxt = listItem.typeDesc;
      titleIcon = listItem.typeIcon;
    } catch (e) {}
    if (isWithdrawal) {
      prefixText = '-';
      //type1支付宝提现 2 微信提现
      switch (type) {
        case "1":
          iconName = "icon_profit_zfb.png";
          statusText = "支付宝提现-";
          break;
        case "2":
          iconName = "icon_profit_wx.png";
          statusText = "微信提现-";
          break;
      }
      switch (status) {
        case "0": //未打款
//          desc = "审核中，请耐心等候~";
          statusText += "已提交";
          break;
        case "1": //已打款
//          desc = "恭喜！收益已打款成功！";
          statusText += "成功";
          break;
        case "3": //被驳回
          desc = rejectReason;
          statusText += "失败";
          break;
      }
    } else {
      switch (profitType) {
        case "9":
          iconName = "icon_profit_invite.png";
          statusText = "邀请奖励-成功";
          break;
        case "8":
          iconName = "icon_profit_invite.png";
          statusText = "微股东好友分红-成功";
          break;
        case "7":
          iconName = "icon_profit_invite.png";
          statusText = "微股东个人分红-成功";
          break;
        case "6":
          iconName = "icon_profit_invite.png";
          statusText = "微股东分红奖励-成功";
          break;
        case "5":
          iconName = "icon_profit_invite.png";
          statusText = "会员退款-成功";
          if (double.parse(price) < 0) {
            prefixText = '';
          }
          break;
        case "4":
          iconName = "icon_profit_task.png";
          statusText = "商品消费-成功";
          prefixText = '';
          break;
        case "3":
          iconName = "icon_profit_invite.png";
          statusText = "消费补贴-成功";
          break;
        case "2":
          iconName = "icon_profit_task.png";
          statusText = "任务奖励-成功";
          break;
        case "0":
          iconName = "icon_profit_task.png";
          statusText = "活动奖励-成功";
          break;
        case "1":
          iconName = "icon_profit_invite.png";
          statusText = "邀请奖励-成功";
          break;
      }
      if (price.contains("-")) {
        prefixText = '';
      }
      /*if (KTKJGlobalConfig.getUserInfo().type == 3) {

        switch (type) {
          case "1":
          case "2":
            iconName = "icon_profit_task.png";
            statusText = "任务奖励-成功";
            break;
          case "3":
            iconName = "icon_profit_invite.png";
            statusText = "邀请奖励-成功";
            break;
        }
      } else {

      }*/
    }

    return Column(
      children: [
        Visibility(
          visible: _showTimeDesc,
          child: Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                  child: Container(
                height: ScreenUtil().setWidth(53),
                width: ScreenUtil().setWidth(201),
                decoration: BoxDecoration(
                  color: Color(0xffdedede),
                  borderRadius: BorderRadius.circular(
                    ScreenUtil().setSp(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    '$timeDesc',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(32),
                    ),
                  ),
                ),
              ))),
        ),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: KTKJGlobalConfig.LAYOUT_MARGIN,
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
                        /* Image.asset(
                          "static/images/$iconName",
                          width: ScreenUtil().setWidth(60),
                          height: ScreenUtil().setWidth(60),
                        ),*/
                        KTKJMyOctoImage(
                          image: "$titleIcon",
                          width: ScreenUtil().setWidth(60),
                          height: ScreenUtil().setWidth(60),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(20),
                        ),
                        Text(
                          "$titleTxt",
                          style: TextStyle(
//                color:  Color(0xFF222222) ,
                              fontSize: ScreenUtil().setSp(42)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: <Widget>[
                        Text(
                          "$createTime",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(42),
                            color: Color(0xff999999),
                          ),
                        ),
                      ],
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
              Row(
                children: <Widget>[
                  Expanded(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      alignment: WrapAlignment.start,
                      runSpacing: 4,
                      children: <Widget>[
                        Text(
                          //状态：
                          "$desc",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(42),
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    alignment: WrapAlignment.start,
                    runSpacing: 4,
                    children: <Widget>[
                      Text(
                        //您于2020-23-12 14:32:10提交的任务截图被驳回，驳回原因为截图不符合
                        //要求。请当天及时重新提交~：
                        "$prefixText$price",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(42),
                          color: Color(0xFF222222),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}