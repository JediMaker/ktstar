import 'package:star/pages/widget/my_octoimage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/fans_list_entity.dart';
import 'package:star/models/fans_total_entity.dart';
import 'package:star/pages/widget/no_data.dart';
import 'package:star/utils/common_utils.dart';

import '../../global_config.dart';

class FansListPage extends StatefulWidget {
  //是否代理商
  bool isAgent;

  FansListPage({Key key, this.isAgent = false}) : super(key: key);
  final String title = "我的粉丝";

  @override
  _FansListPageState createState() => _FansListPageState();
}

class _FansListPageState extends State<FansListPage>
    with TickerProviderStateMixin {
  ///粉丝类型  默认0全部  1vip会员 2普通会员 3体验会员
  int fansType;
  List<String> _tabValues;

  TabController _tabController;
  List<Widget> _tabViews;
  int _currentTabIndex = 0;

  ///会员总数量
  var _totalMembersNumber = "0";
  var _vipMembersNumber = "0";
  var _experienceMembersNumber = "0";
  var _ordinaryMembersNumber = "0";
  var _diamondMembersNumber = "0";
  FansTotalDataAgentInfo _agentInfo;

  _initFansTotalsData() async {
    var result = await HttpManage.getFansTotal();
    if (result.status) {
      if (mounted) {
        setState(() {
          try {
            _totalMembersNumber = result.data.countInfo.total.toString();
            _vipMembersNumber = result.data.countInfo.vip.toString();
            _experienceMembersNumber =
                result.data.countInfo.noviciate.toString();
            _ordinaryMembersNumber = result.data.countInfo.ordinary.toString();
            _diamondMembersNumber = result.data.countInfo.diamond.toString();
            if (widget.isAgent) {
            } else {
              _agentInfo = result.data.agentInfo;
            }
          } catch (e) {
            print(e);
          }

          _tabValues = [
            '全部($_totalMembersNumber)',
            '高级($_diamondMembersNumber)',
            '股东($_vipMembersNumber)',
            '见习($_experienceMembersNumber)',
            '普通($_ordinaryMembersNumber)',
          ];
          _tabViews = [
            FansTabView(
              fansType: "0",
              isAgent: widget.isAgent,
            ),
            FansTabView(
              fansType: "4",
              isAgent: widget.isAgent,
            ),
            FansTabView(
              fansType: "3",
              isAgent: widget.isAgent,
            ),
            FansTabView(
              fansType: "1",
              isAgent: widget.isAgent,
            ),
            FansTabView(
              fansType: "2",
              isAgent: widget.isAgent,
            ),
          ];

          _tabController = TabController(length: 5, vsync: this);
        });
      }
    } else {}
  }

  @override
  void initState() {
    _initFansTotalsData();
    /* _tabValues = [
      ' 全部 ',
      'vip会员',
      '普通会员',
      '体验会员',
    ];*/
//    if (widget.isAgent) {
    _tabValues = [
      '全部($_totalMembersNumber)',
      '高级($_diamondMembersNumber)',
      '股东($_vipMembersNumber)',
      '见习($_experienceMembersNumber)',
      '普通($_ordinaryMembersNumber)',
    ];
    _tabViews = [
      FansTabView(
        fansType: "0",
        isAgent: widget.isAgent,
      ),
      FansTabView(
        fansType: "4",
        isAgent: widget.isAgent,
      ),
      FansTabView(
        fansType: "3",
        isAgent: widget.isAgent,
      ),
      FansTabView(
        fansType: "1",
        isAgent: widget.isAgent,
      ),
      FansTabView(
        fansType: "2",
        isAgent: widget.isAgent,
      ),
    ];
//    }
    /*else {
      _tabValues = [
        '全部($_totalMembersNumber)',
        '高级股东($_diamondMembersNumber)',
        '股东($_vipMembersNumber)',
        '普通($_ordinaryMembersNumber)',
      ];
      _tabViews = [
        FansTabView(
          fansType: "",
          isAgent: widget.isAgent,
        ),
        FansTabView(
          fansType: "diamond",
          isAgent: widget.isAgent,
        ),
        FansTabView(
          fansType: "vip",
          isAgent: widget.isAgent,
        ),
        FansTabView(
          fansType: "ordinary",
          isAgent: widget.isAgent,
        ),
      ];
    }*/
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(
                color: Color(0xFF222222), fontSize: ScreenUtil().setSp(54)),
          ),
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
        body: Center(
          child: Column(
            children: <Widget>[
              Visibility(
                  visible: !widget.isAgent && !CommonUtils.isEmpty(_agentInfo),
                  child: buildHeadLayout()),
              Flexible(
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: GlobalConfig.LAYOUT_MARGIN,
                      vertical: ScreenUtil().setHeight(30)),
                  padding: EdgeInsets.all(ScreenUtil().setWidth(32)),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setWidth(30))),
                      border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                          color: Colors.white,
                          width: 0.5)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 48,
                        alignment: Alignment.center,
                        color: Colors.white,
                        child: Center(
                          child: TabBar(
                            tabs: _tabValues.map((f) {
                              return Text(
                                f,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    TextStyle(fontSize: ScreenUtil().setSp(38)),
                              );
                            }).toList(),
                            controller: _tabController,
                            indicatorColor: Color(0xffF93736),
                            indicatorSize: TabBarIndicatorSize.label,
                            isScrollable: _tabValues.length > 4 ? true : false,
                            labelColor: Color(0xffF93736),
                            unselectedLabelColor: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: _tabViews,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget buildHeadLayout() {
    String text = "";
    String headUrl;
    String nickName;
    String wechatNo;
    /*switch (userType) {
      case "0":
        text = "普通会员";
        break;
      case "1":
        text = "体验会员";
        break;
      case "2":
        text = "钻石vip";
        break;
      case "3":
        text = "代理";
        break;
    }*/
    try {
      headUrl = _agentInfo.avatar;
      nickName = _agentInfo.username;
      wechatNo = _agentInfo.wxNo;
    } catch (e) {}
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: GlobalConfig.LAYOUT_MARGIN,
                vertical: ScreenUtil().setHeight(30)),
            height: ScreenUtil().setHeight(295),
            padding: EdgeInsets.all(ScreenUtil().setWidth(32)),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().setWidth(30))),
                border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                    color: Colors.white,
                    width: 0.5)),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(30), vertical: 0),
              onTap: () async {},
              title: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(168),
                      height: ScreenUtil().setWidth(168),
                      child: headUrl == null
                          ? Visibility(
                              visible: false,
                              child: Image.asset(
                                "static/images/task_default_head.png",
                                width: ScreenUtil().setWidth(120),
                                height: ScreenUtil().setWidth(120),
                                fit: BoxFit.fill,
                              ),
                            )
                          : ClipOval(
                              child: MyOctoImage(
                                image: headUrl,
                                fit: BoxFit.fill,
                                width: ScreenUtil().setWidth(168),
                                height: ScreenUtil().setWidth(168),
                              ),
                            ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(30), vertical: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              child: Text(
                                "${nickName == null ? '' : nickName}",
                                overflow: TextOverflow.ellipsis,
                                /*style: TextStyle(
                                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil().setSp(42)),*/
                                style: TextStyle(
                                    color: Color(0xFF222222),
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil().setSp(42)),
                              ),
                            ),
                            SelectableText(
                              "${wechatNo == null ? '' : wechatNo}",
                              style: TextStyle(
                                  color: Color(0xFF222222),
                                  fontSize: ScreenUtil().setSp(42)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(26),
                    ),
//            Image.asset("", width:)
                  ],
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(
              right: ScreenUtil().setWidth(130),
            ),
            child: Container(
                width: ScreenUtil().setWidth(180),
                height: ScreenUtil().setHeight(61),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF393939),
                        Color(0xFF616161),
                      ],
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(10)))),
                child: Text(
                  "我的代理",
                  style: TextStyle(
                      color: Colors.white, fontSize: ScreenUtil().setSp(32)),
                )),
          ),
        ],
      ),
    );
  }
}

class FansTabView extends StatefulWidget {
  ///类型 默认全部  vip：VIP用户，experience：体验用户，ordinary：普通用户
  String fansType;
  bool isAgent;

  FansTabView({Key key, this.fansType = "", this.isAgent = false})
      : super(key: key);

  @override
  _FansTabViewState createState() => _FansTabViewState();
}

class _FansTabViewState extends State<FansTabView> {
  int page = 1;
  EasyRefreshController _refreshController;
  bool isFirstLoading = true;
  List<FansListDataList> _fansList;

  _initData() async {
    var result =
        await HttpManage.getFansList(page, 10, holderType: widget.fansType);
    if (result.status) {
      if (mounted) {
        setState(() {
          if (page == 1) {
            _fansList = result.data.xList;
          } else {
            if (result == null ||
                result.data == null ||
                result.data.xList == null ||
                result.data.xList.length == 0) {
              //              _refreshController.resetLoadState();
              _refreshController.finishLoad(noMore: true);
            } else {
              _fansList += result.data.xList;
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
    return EasyRefresh.custom(
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
          _fansList == null || _fansList.length == 0 ? NoDataPage() : null,
      slivers: <Widget>[buildCenter()],
    );
  }

  Widget buildCenter() {
    return SliverToBoxAdapter(
      child: Container(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            FansListDataList listItem = _fansList[index];
            return buildItemLayout(listItem: listItem);
          },
          itemCount: _fansList == null ? 0 : _fansList.length,
        ),
      ),
    );
  }

  Widget buildItemLayout({FansListDataList listItem}) {
    String text = "";
    String headUrl;
    String nickName;
    String bindTime;

    ///账户类型 0普通用户 1体验用户 2VIP用户 3 钻石用户
    String userType;
    //微股东类型
    String shareHolderType;
    String completeTaskNum = '';
    String totalTaskNum = '';
    bool taskComplete = false;
    /*switch (userType) {
      case "0":
        text = "普通会员";
        break;
      case "1":
        text = "体验会员";
        break;
      case "2":
        text = "钻石vip";
        break;
      case "3":
        text = "代理";
        break;
    }*/
    try {
      headUrl = listItem.avatar;
      nickName = listItem.username;
      bindTime = listItem.createdTime;
      userType = listItem.isVip;
      shareHolderType = listItem.isPartner;
      completeTaskNum = listItem.completeCount;
      totalTaskNum = listItem.totalCount;
      taskComplete = listItem.completeStatus == "2";
    } catch (e) {}
    return ListTile(
      onTap: () async {},
      leading: Container(
        width: ScreenUtil().setWidth(120),
        height: ScreenUtil().setWidth(120),
        child: headUrl == null
            ? Image.asset(
                "static/images/task_default_head.png",
                width: ScreenUtil().setWidth(120),
                height: ScreenUtil().setWidth(120),
                fit: BoxFit.fill,
              )
            : ClipOval(
                child: MyOctoImage(
                  image: headUrl,
                  width: ScreenUtil().setWidth(120),
                  height: ScreenUtil().setWidth(120),
                  fit: BoxFit.fill,
                ),
              ),
      ),
      title: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                "${nickName == null ? '' : nickName}",
                overflow: TextOverflow.ellipsis,
                /*style: TextStyle(
                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(42)),*/
                style: TextStyle(
                    color: Color(0xFF222222),
//                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(38)),
                maxLines: 1,
              ),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(26),
            ),
//            Image.asset("", width:)
          ],
        ),
      ),
      subtitle: Row(
        children: <Widget>[
          Text(
            "${bindTime == null ? '' : bindTime}",
            style: TextStyle(
                color: Color(0xFF999999), fontSize: ScreenUtil().setSp(42)),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(26),
          ),
          Visibility(
            visible: false,
            child: Container(
              width: ScreenUtil().setWidth(98),
              height: ScreenUtil().setWidth(49),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: !taskComplete ? Color(0xffFFE1E1) : Color(0xffE1EAFF),
                borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().setWidth(25))),
                border: Border.all(
                    color:
                        !taskComplete ? Color(0xffFFE1E1) : Color(0xffE1EAFF),
                    width: 0.5),
              ),
              child: Text(
                "${'$completeTaskNum/$totalTaskNum'}",
                style: TextStyle(
                    color:
                        !taskComplete ? Color(0xffF32E43) : Color(0xff2E5CF3),
                    fontSize: ScreenUtil().setSp(36)),
              ),
            ),
          ),
        ],
      ),
      trailing: GestureDetector(
        child: MyOctoImage(
          image: "${_getImgName(shareHolderType)}",
          width: ScreenUtil().setWidth(shareHolderType == '2' ? 119 : 137),
          height: ScreenUtil().setWidth(shareHolderType == '2' ? 59 : 77),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  String _getImgName(_type) {
//    账户类型 1见习股东 2普通用户 3vip股东 4高级股东
    switch (_type) {
      case "1":
        return "https://alipic.lanhuapp.com/xd5002e038-9179-4c95-9a49-09e0d0e53590";
      case "2":
        return "https://alipic.lanhuapp.com/xd5fafac9d-1d56-49a0-b658-04a43e50582a";
      case "3":
        return "https://alipic.lanhuapp.com/xdf964acde-df69-493b-8547-ce8bf626e734";
      case "4":
        return "https://alipic.lanhuapp.com/xd533cce7c-b6f4-47fc-9051-2c3d186e1df4";
    }
    return "";
  }
}
