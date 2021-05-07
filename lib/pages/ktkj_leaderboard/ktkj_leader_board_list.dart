import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:star/http/ktkj_http_manage.dart';
import 'package:star/models/leader_board_entity.dart';
import 'package:star/pages/ktkj_leaderboard/ktkj_leader_board_mylist.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_octoimage.dart';
import 'package:star/pages/ktkj_widget/ktkj_no_data.dart';
import 'package:star/utils/ktkj_common_utils.dart';
import 'package:star/utils/ktkj_navigator_utils.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_webview_plugin.dart';

///活动排行榜页面
class KTKJLeaderBoard extends StatefulWidget {
  KTKJLeaderBoard({
    Key key,
    this.title = '排行榜',
    this.type = 0,
    this.cardType,
  }) : super(key: key);
  final String title;

  ///记录类型 0 抽奖记录 1 能量记录  2 卡片记录
  ///
  ///
  final int type;

  ///  卡片类型：1-万能卡，2-攻击卡，3-防护盾
  final int cardType;

  @override
  _KTKJLeaderBoardState createState() => _KTKJLeaderBoardState();
}

class _KTKJLeaderBoardState extends State<KTKJLeaderBoard> {
  var _mainColor = Color(0xffFEF3DE);
  int page = 1;
  EasyRefreshController _refreshController;
  bool isFirstLoading = true;
  List<LeaderBoardDataList> msgList = List<LeaderBoardDataList>();
  LeaderBoardDataMyRank myRank;

  ///我的奖励金额
  var _mAwardAmount = "";

  ///我的邀请人数
  var _mInvitationsNum = "";

  ///我的昵称
  var _mNickName = "";

  ///我的头像
  var _mAvatarUrl = "";

  ///我的排行
  var _mRanking;

  var rulesH5Url;

  _initData({showLoading = false}) async {
    try {
      if (showLoading) {
        EasyLoading.show();
      }
    } catch (e) {}
    var result = await HttpManage.activityGetLeaderBoard();
    try {
      if (showLoading) {
        EasyLoading.dismiss();
      }
    } catch (e) {}
    if (result.status) {
      if (mounted) {
        setState(() {
          msgList = result.data.lists;
          myRank = result.data.myRank;
          _mAvatarUrl = myRank.avatar;
          _mNickName = myRank.username;
          _mInvitationsNum = myRank.count;
          _mAwardAmount = myRank.reward;
          _mRanking = myRank.ranking;
          rulesH5Url = result.data.rulesH5;
          /*if (page == 1) {

            _refreshController.finishLoad(noMore: false);
          } else {
            if (result == null ||
                result.data == null ||
                result.data.lists == null ||
                result.data.lists.length == 0) {
              //              _refreshController.resetLoadState();
              _refreshController.finishLoad(noMore: true);
            } else {
              msgList += result.data.lists;
            }
          }*/
          isFirstLoading = false;
        });
      }
    } else {
      KTKJCommonUtils.showToast(result.errMsg);
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController();
//    _refreshController.finishLoad(noMore: true);
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
      child: Scaffold(
        appBar: GradientAppBar(
          title: Text(
            widget.title,
            style: TextStyle(
                color: Color(0xff222222), fontSize: ScreenUtil().setSp(54)),
          ),
          leading: Visibility(
            child: IconButton(
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
          ),
          centerTitle: true,
          elevation: 0,
          brightness: Brightness.light,
          gradient: LinearGradient(colors: [
            Colors.white,
            Colors.white,
//          Color(0xffFEDD3C),
//          Color(0xffFEDD3C),
          ]),
        ),
        body:
            buildContainer(), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Widget buildContainer() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
//            _mainColor,
//            _mainColor,
            Color(0xffEC2D50),
            Color(0xffEB5572),
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildTopLayout(),
            buildTableTitleRow(),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: double.maxFinite,
                  height: ScreenUtil().setWidth(427),
                  child: KTKJMyOctoImage(
                    image:
                        "https://alipic.lanhuapp.com/xddbbd3ced-b257-410b-8f51-af356488afb3",
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  height: ScreenUtil().setWidth(962),
                  margin: EdgeInsets.only(
                    bottom: ScreenUtil().setWidth(427),
                  ),
                  child: KTKJMyOctoImage(
                    image:
                        "https://alipic.lanhuapp.com/xd24f6c479-7a2e-44bf-8a5a-6b18c0f956ed",
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  height: ScreenUtil().setWidth(962),
                  margin: EdgeInsets.only(
                    bottom: ScreenUtil().setWidth(427),
                  ),
                  child: KTKJMyOctoImage(
                    image:
                        "https://alipic.lanhuapp.com/xdb29c384f-8172-4498-8c31-19c9abeb43bb",
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(92),
                    right: ScreenUtil().setWidth(92),
                    bottom: ScreenUtil().setWidth(30),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                        ScreenUtil().setWidth(60),
                      ),
                      bottomRight: Radius.circular(
                        ScreenUtil().setWidth(60),
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          minHeight: ScreenUtil().setWidth(1325),
                          maxHeight: ScreenUtil().setWidth(1325),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Column(
                                children: List.generate(
//                                  10,
                                  msgList.length,
                                  (index) => buildItemRow(
                                    ranking: int.parse(msgList[index].ranking),
                                    avatarUrl: msgList[index].avatar,
                                    nickName: msgList[index].username,
                                    invitationsNum: msgList[index].count,
                                    awardAmount: msgList[index].reward,
                                  ),
                                ),
                              ),
                              Visibility(
                                  visible: KTKJCommonUtils.isEmpty(msgList),
                                  child: Container(
                                      width: double.maxFinite,
                                      height: ScreenUtil().setWidth(1162),
                                      child: KTKJNoDataPage())),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          KTKJNavigatorUtils.navigatorRouter(
                              context, KTKJLeaderBoardMineList());
                        },
                        child: Container(
                          width: double.maxFinite,
                          height: ScreenUtil().setWidth(185),
                          decoration: BoxDecoration(
                            color: Color(0xffFFE2E2),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(
                                ScreenUtil().setWidth(60),
                              ),
                              bottomRight: Radius.circular(
                                ScreenUtil().setWidth(60),
                              ),
                            ),
                          ),
                          child: buildItemRow(
                            ranking: _mRanking,
                            avatarUrl: _mAvatarUrl,
                            nickName: _mNickName,
                            invitationsNum: _mInvitationsNum,
                            awardAmount: _mAwardAmount,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItemRow({
    ranking,
    avatarUrl,
    nickName,
    invitationsNum,
    awardAmount,
  }) {
    return Container(
      width: double.maxFinite,
      height: ScreenUtil().setWidth(185),
      child: Row(
        children: [
          ///序号
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Center(
              child: buildRanking(ranking),
            ),
          ),

          ///头像
          Flexible(
            flex: 5,
            fit: FlexFit.tight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: ScreenUtil().setWidth(104),
                  height: ScreenUtil().setWidth(104),
                  child: ClipOval(
                    child: KTKJMyOctoImage(
                      image: "$avatarUrl",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                    ),
                    child: Text(
                      "$nickName",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xff222222),
                        fontSize: ScreenUtil().setSp(32),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          ///昵称
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: Center(
              child: Text(
                "共邀$invitationsNum人",
                style: TextStyle(
                  color: Color(0xff222222),
                  fontSize: ScreenUtil().setSp(32),
                ),
              ),
            ),
          ),

          ///奖励金额
          Flexible(
            flex: 3,
            fit: FlexFit.tight,
            child: Center(
              child: Text(
                "$awardAmount元",
                style: TextStyle(
                  color: Color(0xff222222),
                  fontSize: ScreenUtil().setSp(32),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRanking(ranking) {
    return "$ranking" == "3"
        ? Container(
            width: ScreenUtil().setWidth(94),
            height: ScreenUtil().setWidth(94),
            child: ClipOval(
              child: KTKJMyOctoImage(
                image:
                    "https://alipic.lanhuapp.com/xd2f1d3ba2-d22e-449f-93ca-86d8214ef61d",
                fit: BoxFit.fill,
              ),
            ),
          )
        : "$ranking" == "1"
            ? Container(
                width: ScreenUtil().setWidth(94),
                height: ScreenUtil().setWidth(94),
                child: ClipOval(
                  child: KTKJMyOctoImage(
                    image:
                        "https://alipic.lanhuapp.com/xd390d8166-de76-4239-8306-32c58f13a430",
                    fit: BoxFit.fill,
                  ),
                ),
              )
            : "$ranking" == "2"
                ? Container(
                    width: ScreenUtil().setWidth(94),
                    height: ScreenUtil().setWidth(94),
                    child: ClipOval(
                      child: KTKJMyOctoImage(
                        image:
                            "https://alipic.lanhuapp.com/xd89de2890-7f62-44b6-9c99-d5fcc6de7082",
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                : Text(
                    ///我的排名
                    "$ranking",
                    style: TextStyle(
                      color: Color(0xff222222),
                      fontSize: ScreenUtil().setSp(48),
                    ),
                  );
  }

  ///表格标题
  Container buildTableTitleRow() {
    return Container(
      height: ScreenUtil().setWidth(117),
      width: double.infinity,
      margin: EdgeInsets.only(
        left: ScreenUtil().setWidth(30),
        right: ScreenUtil().setWidth(30),
      ),
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(60),
        right: ScreenUtil().setWidth(60),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          ScreenUtil().setWidth(59),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
//            _mainColor,
//            _mainColor,
            Color(0xffFBC388),
            Color(0xffF06586),
          ],
        ),
      ),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: Center(
              child: Container(
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(0),
                ),
                child: Text(
                  "排名",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(38),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: Center(
              child: Container(
                child: Text(
                  "昵称",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(38),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: Center(
              child: Container(
                child: Text(
                  "人数",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(38),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Center(
              child: Container(
                child: Text(
                  "奖励金额",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(38),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///顶部布局
  Widget buildTopLayout() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.maxFinite,
          height: ScreenUtil().setWidth(753),
          child: KTKJMyOctoImage(
            image:
                "https://alipic.lanhuapp.com/xdebc75c5d-5631-44de-a653-24b13ba2d4ea",
            fit: BoxFit.fill,
          ),
        ),
        Text(
          "话费充值PK赛",
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(69),
          ),
        ),
        buildRulesWidget(),
      ],
    );
  }

  ///活动规则
  Widget buildRulesWidget() {
    return GestureDetector(
      onTap: () {
        if (KTKJCommonUtils.isEmpty(rulesH5Url)) {
          return;
        }
        KTKJNavigatorUtils.navigatorRouter(
            this.context,
            KTKJWebViewPluginPage(
              initialUrl: "$rulesH5Url",
              showActions: false,
              title: "活动规则",
              appBarBackgroundColor: Colors.white,
            ));
      },
      child: Container(
        width: double.maxFinite,
        height: ScreenUtil().setWidth(753),
        margin: EdgeInsets.only(
          right: ScreenUtil().setWidth(55),
        ),
        padding: EdgeInsets.only(
          top: ScreenUtil().setWidth(55),
        ),
        alignment: Alignment.topRight,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: ScreenUtil().setWidth(123),
              width: ScreenUtil().setWidth(112),
              child: KTKJMyOctoImage(
                image:
                    "https://alipic.lanhuapp.com/xde0914498-fdda-4167-964e-cd2d1f817e6a",
                fit: BoxFit.fill,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: ScreenUtil().setWidth(123),
              ),
              child: Text(
                "活动规则",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  EasyRefresh buildEasyRefresh() {
    return EasyRefresh.custom(
      topBouncing: false,
      bottomBouncing: false,
      header: MaterialHeader(),
      footer: CustomFooter(
//          triggerDistance: ScreenUtil().setWidth(180),
          completeDuration: Duration(seconds: 1),
          footerBuilder: (context,
              loadState,
              pulledExtent,
              loadTriggerPullDistance,
              loadIndicatorExtent,
              axisDirection,
              float,
              completeDuration,
              enableInfiniteLoad,
              success,
              noMore) {
            return Stack(
              children: <Widget>[
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Visibility(
                    visible: noMore,
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: ScreenUtil().setWidth(30),
                          bottom: ScreenUtil().setWidth(30),
                        ),
                        child: Text(
                          "~我是有底线的~",
                          style: TextStyle(
                            color: Color(0xff666666),
                            fontSize: ScreenUtil().setSp(32),
                          ),
                        ),
                      ),
                    ),
                  ),
//                  child: Container(
//                    width: 30.0,
//                    height: 30.0,
//                    /* child: SpinKitCircle(
//                            color: KTKJGlobalConfig.colorPrimary,
//                            size: 30.0,
//                          ),*/
//                  ),
                ),
              ],
            );
          }),
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
      emptyWidget: msgList == null || msgList.length == 0
          ? Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _mainColor,
                    _mainColor,
                  ],
                ),
              ),
              child: KTKJNoDataPage(
                textColor: Color(0xff41555d),
              ))
          : null,
      slivers: <Widget>[buildCenter()],
    );
  }

  Widget buildCenter() {
    return SliverToBoxAdapter(
      child: buildContainer(),
    );
  }

  ///创建翻牌弹窗

  ///
}
