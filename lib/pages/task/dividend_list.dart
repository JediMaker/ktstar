import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/global_config.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/income_list_entity.dart';
import 'package:star/pages/widget/no_data.dart';
import 'package:star/utils/common_utils.dart';

class DividendListPage extends StatefulWidget {
  ///页面类型 0、1收益列表 2提现列表
  int pageType;

  var profitType;
  bool showAppBar;

  DividendListPage(
      {Key key, this.pageType = 0, this.showAppBar = true, this.profitType})
      : super(key: key);
  String title = "分红金明细";

  @override
  _DividendListPageState createState() => _DividendListPageState();
}

class _DividendListPageState extends State<DividendListPage>
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
    var result = await HttpManage.getMicroShareHolderCoinList(
      page,
      10,
    );
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
      CommonUtils.showToast(result.errMsg);
    }
  }

  @override
  void initState() {
    /* switch (widget.pageType) {
      case 0:
      case 1:
        widget.title = "收益明细";
        isWithdrawal = false;
        break;
      case 2:
        widget.title = "已提现记录";
        isWithdrawal = true;
        break;
    }*/
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
            backgroundColor: GlobalConfig.taskNomalHeadColor,
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
            ? NoDataPage()
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
    String title = '';
    bool _showTimeDesc = true;
    try {
      price = listItem.bonus;
      status = listItem.status;
      rejectReason = listItem.rejectReason;
      createTime = listItem.createTime;
      timeDesc = listItem.timeDesc;
      _showTimeDesc = lastTimeDesc != timeDesc;
      lastTimeDesc = timeDesc;
      desc = listItem.desc;
      profitType = listItem.profitType;
      type = listItem.type;
      statusText = listItem.title;
    } catch (e) {
      print(e);
    }
    switch (status) {
      case "1": //已打款
        prefixText = '+';
        iconName = "icon_profit_invite.png";
        break;
      case "2": //已打款
        prefixText = '-';
        iconName = "icon_profit_task.png";
        break;
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
              horizontal: GlobalConfig.LAYOUT_MARGIN, vertical: ScreenUtil().setHeight(16)),
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
                        Image.asset(
                          "static/images/$iconName",
                          width: ScreenUtil().setWidth(60),
                          height: ScreenUtil().setWidth(60),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(20),
                        ),
                        Text(
                          statusText,
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
