import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/message_list_entity.dart';
import 'package:star/models/phone_charge_list_entity.dart';
import 'package:star/pages/recharge/recharge_list.dart';
import 'package:star/pages/widget/no_data.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';

import '../../global_config.dart';

class RechargeOrderListPage extends StatefulWidget {
  RechargeOrderListPage({Key key}) : super(key: key);
  final String title = "我的订单";

  @override
  _RechargeOrderListPageState createState() => _RechargeOrderListPageState();
}

class _RechargeOrderListPageState extends State<RechargeOrderListPage> {
  int page = 1;
  EasyRefreshController _refreshController;
  bool isFirstLoading = true;
  List<PhoneChargeListDataList> _phoneChargeList;
  String contactPhone = ""; //
  _initData() async {
    PhoneChargeListEntity result =
        await HttpManage.getPhoneChargesList(page, 10);
    if (result.status) {
      if (mounted) {
        setState(() {
          contactPhone=result.data.phone;
          if (page == 1) {
            _phoneChargeList = result.data.xList;
          } else {
            if (result == null ||
                result.data == null ||
                result.data.xList == null ||
                result.data.xList.length == 0) {
              //              _refreshController.resetLoadState();
              _refreshController.finishLoad(noMore: true);
            } else {
              _phoneChargeList += result.data.xList;
            }
          }
          isFirstLoading = false;
        });
      }
    } else {
      CommonUtils.showToast(result.errMsg);
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
          centerTitle: true,
          backgroundColor: GlobalConfig.taskNomalHeadColor,
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
          },
          onLoad: () {
            if (!isFirstLoading) {
              page++;
              _initData();
            }
          },
          emptyWidget:
              _phoneChargeList == null || _phoneChargeList.length == 0
                  ? NoDataPage()
                  : null,
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
            PhoneChargeListDataList listItem = _phoneChargeList[index];
            return buildItemLayout(listItem: listItem);
          },
          itemCount: _phoneChargeList == null ? 0 : _phoneChargeList.length,
        ),
      ),
    );
  }

  buildItemLayout({PhoneChargeListDataList listItem}) {
    String id = "1";
    String title = "";
    String createTime = "";
    String phoneNumberType = "";
    String phoneNumber = "";
    String phoneMoney = "";
    String totalMoney = "";
    String saleMoney = ""; //
    String payMoney = ""; //

    String orderNo = ""; //
    String rechargeStatus = "1";
    String rechargeStatusText = "";
    String iconName = '';
    bool showContact = false;
    try {
      phoneNumberType = listItem.type.toString();
      title = listItem.title;
      createTime = listItem.czTime;

      phoneNumber = listItem.phone;
      phoneMoney = listItem.faceMoney;
      totalMoney = listItem.useMoney;
      saleMoney = listItem.useMoney;
      payMoney = listItem.payMoney;
      orderNo = listItem.orderNo;
      rechargeStatus = listItem.status;
    } catch (e) {}
    switch (rechargeStatus) {
      case "1":
        rechargeStatusText = "充值成功"; //chinaUnicom china_mobile china_telecom
        break;
      case "9":
        rechargeStatusText = "充值失败";
        showContact = true;
        break;
      case "0":
        rechargeStatusText = "充值中";
        break;
    }
    switch (phoneNumberType) {
      case "2":
        iconName = "china_mobile.png";
        break;
      case "3":
        iconName = "china_telecom.png";
        break;
      case "1":
        iconName = "china_unicom.png";
        break;
    }
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      "创建：$createTime",
                      style: TextStyle(
//                color:  Color(0xFF222222) ,
                          fontSize: ScreenUtil().setSp(32)),
                    ),
                  ],
                ),
              ),
              Container(
                child: Text(
                  rechargeStatusText,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(36),
                    color: Color(0xffFD8B4E),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                "static/images/$iconName",
                width: ScreenUtil().setWidth(243),
                height: ScreenUtil().setWidth(243),
                fit: BoxFit.fill,
              ),
              SizedBox(
                width: ScreenUtil().setWidth(29),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      child: Text(
                        //状态：
                        title,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(42),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(12),
                    ),
                    Container(
                      child: Text(
                        //状态：
                        "充值号码：$phoneNumber",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(30),
                          color: Color(0xFF999999),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(12),
                    ),
                    Container(
                      child: Text(
                        //状态：
                        "充值金额：$phoneMoney 元",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(30),
                          color: Color(0xFF999999),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(29),
              ),
              Container(
                width: ScreenUtil().setWidth(200),
                alignment: Alignment.centerRight,
                child: Text(
                  "￥$saleMoney",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(42),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                //状态：
                "总价",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(42),
                  color: Color(0xFF999999),
                ),
              ),
              Text(
                //状态：
                " ￥ ",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(30),
                  color: Color(0xFF999999),
                ),
              ),
              Text(
                //状态：
                "$totalMoney",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(42),
                  color: Color(0xFF999999),
                ),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(29),
              ),
              Text(
                //状态：
                "实付款",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(42),
                ),
              ),
              Text(
                //状态：
                " ￥ ",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(30),
                ),
              ),
              Text(
                //状态：
                "$payMoney",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(42),
                ),
              ),
            ],
          ),
          SizedBox(
            height: ScreenUtil().setHeight(37),
          ),
          Divider(
            height: ScreenUtil().setHeight(1),
            color: Color(0xFFdddddd),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(37),
          ),
          Visibility(
            visible: showContact,
            child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  "联系我们：$contactPhone",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(42),
                  ),
                )),
          ),
          Visibility(
            visible: !showContact,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      child: Text(
                    "订单编号：$orderNo",
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(32),
                        color: Color(0xff666666)),
                  )),
                ),
                GestureDetector(
                  onTap: () {
                    if (Platform.isIOS) {
                      CommonUtils.showIosPayDialog();
                      return;
                    }
                    NavigatorUtils.navigatorRouter(context, RechargeListPage());
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(235),
                    height: ScreenUtil().setHeight(77),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setWidth(39))),
                        border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                            color: Color(0xFF999999),
                            width: 0.5)),
                    child: Text(
                      //状态：
                      "再次充值",
                      style: TextStyle(
                        color: Color(0xFF222222),
                        fontSize: ScreenUtil().setSp(42),
                      ),
                    ),
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
