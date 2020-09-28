import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/fans_list_entity.dart';
import 'package:star/models/fans_total_entity.dart';

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
  FansTotalDataAgentInfo _agentInfo;

  _initFansTotalsData() async {
    var result = await HttpManage.getFansTotal();
    if (result.status) {
      if (mounted) {
        setState(() {
          if (widget.isAgent) {
            _totalMembersNumber = result.data.countInfo.total.toString();
            _vipMembersNumber = result.data.countInfo.vip.toString();
            _experienceMembersNumber =
                result.data.countInfo.experience.toString();
            _ordinaryMembersNumber = result.data.countInfo.ordinary.toString();
          } else {
            _agentInfo = result.data.agentInfo;
          }
        });
      }
    } else {}
  }

  @override
  void initState() {
    /* _tabValues = [
      ' 全部 ',
      'vip会员',
      '普通会员',
      '体验会员',
    ];*/
    _initFansTotalsData();
    if (widget.isAgent) {
      _tabValues = [
        ' 全部 （$_totalMembersNumber）',
        'vip会员（$_vipMembersNumber）',
        '普通会员（$_ordinaryMembersNumber）',
        '体验会员（$_experienceMembersNumber）',
      ];
      _tabViews = [
        FansTabView(
          fansType: "",
        ),
        FansTabView(
          fansType: "vip",
        ),
        FansTabView(
          fansType: "ordinary",
        ),
        FansTabView(
          fansType: "experience",
        ),
      ];
    } else {
      _tabValues = [
        ' 全部 （$_totalMembersNumber）',
        'vip会员（$_vipMembersNumber）',
        '普通会员（$_ordinaryMembersNumber）',
      ];
      _tabViews = [
        FansTabView(
          fansType: "",
        ),
        FansTabView(
          fansType: "vip",
        ),
        FansTabView(
          fansType: "ordinary",
        ),
      ];
    }

    _tabController = TabController(length: widget.isAgent ? 4 : 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
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
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xFF222222),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Visibility(visible: !widget.isAgent, child: buildHeadLayout()),
              Flexible(
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 16, vertical: ScreenUtil().setHeight(30)),
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
                                style:
                                    TextStyle(fontSize: ScreenUtil().setSp(38)),
                              );
                            }).toList(),
                            controller: _tabController,
                            indicatorColor: Color(0xffF93736),
                            indicatorSize: TabBarIndicatorSize.label,
                            isScrollable: false,
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
      margin: EdgeInsets.symmetric(
          horizontal: 16, vertical: ScreenUtil().setHeight(30)),
      height: ScreenUtil().setHeight(295),
      padding: EdgeInsets.all(ScreenUtil().setWidth(32)),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(30))),
          border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
              color: Colors.white,
              width: 0.5)),
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(
              right: ScreenUtil().setWidth(117),
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
          ListTile(
            onTap: () async {},
            leading: Container(
              child: headUrl == null
                  ? ClipOval(
                      child: Image.asset(
                        "static/images/task_default_head.png",
                        width: ScreenUtil().setWidth(120),
                        height: ScreenUtil().setWidth(120),
                        fit: BoxFit.fill,
                      ),
                    )
                  : ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: headUrl,
                        width: ScreenUtil().setWidth(197),
                        height: ScreenUtil().setWidth(197),
                        fit: BoxFit.fill,
                      ),
                    ),
            ),
            title: Container(
              child: Row(
                children: <Widget>[
                  Text(
                    "${nickName == null ? '' : nickName}",
                    /*style: TextStyle(
                        color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(42)),*/
                    style: TextStyle(
                        color: Color(0xFF222222),
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(42)),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(26),
                  ),
//            Image.asset("", width:)
                ],
              ),
            ),
            subtitle: Text(
              "${wechatNo == null ? '' : wechatNo}",
              style: TextStyle(
                  color: Color(0xFF222222), fontSize: ScreenUtil().setSp(42)),
            ),
          ),
        ],
      ),
    );
  }
}

class FansTabView extends StatefulWidget {
  ///类型 默认全部  vip：VIP用户，experience：体验用户，ordinary：普通用户
  String fansType;

  FansTabView({Key key, this.fansType = ""}) : super(key: key);

  @override
  _FansTabViewState createState() => _FansTabViewState();
}

class _FansTabViewState extends State<FansTabView> {
  int page = 1;
  EasyRefreshController _refreshController;
  bool isFirstLoading = true;
  List<FansListDataList> _fansList;

  _initData() async {
    var result = await HttpManage.getFansList(page, 10, type: widget.fansType);
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
      Fluttertoast.showToast(
          msg: "${result.errMsg}",
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM);
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
      },
      onLoad: () {
        if (!isFirstLoading) {
          page++;
          _initData();
        }
      },
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

    ///账户类型 0普通用户 1体验用户 2VIP用户
    String userType;
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
                child: CachedNetworkImage(
                  imageUrl: headUrl,
                  width: ScreenUtil().setWidth(120),
                  height: ScreenUtil().setWidth(120),
                  fit: BoxFit.fill,
                ),
              ),
      ),
      title: Container(
        child: Row(
          children: <Widget>[
            Text(
              "${nickName == null ? '' : nickName}",
              /*style: TextStyle(
                  color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(42)),*/
              style: TextStyle(
                  color: Color(0xFF222222),
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(42)),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(26),
            ),
//            Image.asset("", width:)
          ],
        ),
      ),
      subtitle: Text(
        "${bindTime == null ? '' : bindTime}",
        style: TextStyle(
            color: Color(0xFF999999), fontSize: ScreenUtil().setSp(42)),
      ),
      trailing: GestureDetector(
        child: Image.asset(
          "static/images/${_getImgName(userType)}",
          width: ScreenUtil().setWidth(185),
          height: ScreenUtil().setHeight(53),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  String _getImgName(_type) {
    switch (_type) {
      case "0":
        return "icon_nomal.png";
      case "1":
        return "icon_experience.png";
      case "2":
        return "icon_vip.png";
    }
    return "icon_vip.png";
  }
}
