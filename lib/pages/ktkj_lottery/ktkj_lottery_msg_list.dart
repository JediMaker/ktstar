import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:star/http/ktkj_http_manage.dart';
import 'package:star/models/lottery_msg_list_entity.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_octoimage.dart';
import 'package:star/utils/ktkj_common_utils.dart';

///能量大作战消息页面
class KTKJLotteryMsgListPage extends StatefulWidget {
  KTKJLotteryMsgListPage({Key key}) : super(key: key);
  final String title = "能量大作战";

  @override
  _KTKJLotteryMsgListPageState createState() => _KTKJLotteryMsgListPageState();
}

class _KTKJLotteryMsgListPageState extends State<KTKJLotteryMsgListPage> {
  var _mainColor = Color(0xffEF4C3C);
  int page = 1;
  EasyRefreshController _refreshController;
  bool isFirstLoading = true;
  List<LotteryMsgListDataList> msgList = List<LotteryMsgListDataList>();

  _initData() async {
    var result = await HttpManage.lotteryGetMsgList(
      page: page,
      pageSize: 20,
    );
    if (result.status) {
      if (mounted) {
        setState(() {
          if (page == 1) {
            msgList = result.data.xList;
            _refreshController.finishLoad(noMore: false);
          } else {
            if (result == null ||
                result.data == null ||
                result.data.xList == null ||
                result.data.xList.length == 0) {
              //              _refreshController.resetLoadState();
              _refreshController.finishLoad(noMore: true);
            } else {
              msgList += result.data.xList;
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
    return Scaffold(
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
          Color(0xffFEDD3C),
          Color(0xffFEDD3C),
        ]),
      ),
      body:
          buildEasyRefresh(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildContainer() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xffFFB20E),
            Color(0xffF9993D),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            height: ScreenUtil().setWidth(496),
            /* margin: EdgeInsets.only(
                top: ScreenUtil().setWidth(100),
              ),*/
            child: KTKJMyOctoImage(
              width: double.maxFinite,
              height: ScreenUtil().setWidth(496),
              image:
                  "https://alipic.lanhuapp.com/xda83691ec-8bfb-4c55-a569-5daaa859c393",
              fit: BoxFit.fill,
            ),
          ),
          Container(
            constraints: BoxConstraints(
              minHeight: ScreenUtil().setWidth(1825),
            ),
            child: Column(
              children: List.generate(
                msgList.length,
                (index) => buildItemContainer(index: index),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setWidth(160),
            ),
            height: ScreenUtil().setWidth(16),
          ),
        ],
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
//      emptyWidget:
//          msgList == null || msgList.length == 0 ? KTKJNoDataPage() : null,
      slivers: <Widget>[buildCenter()],
    );
  }

  Widget buildCenter() {
    return SliverToBoxAdapter(
      child: buildContainer(),
    );
  }

  Widget buildItemContainer({index}) {
    var msg = '';
    var _timeDesc = "";
    var _avatarUrl = '';
    bool isProtected = false;
    try {
      var item = msgList[index];
      msg = item.aDesc;
      _avatarUrl = item.avatar;
      _timeDesc = item.createTime;
      _timeDesc = KTKJCommonUtils.getNewsTimeStr(DateTime.parse(_timeDesc));
//      _avatarUrl = item.aDesc;
      if (item.aStatus == "2") {
        isProtected = true;
      }
    } catch (e) {}
    return Container(
      height: ScreenUtil().setWidth(351),
      margin: EdgeInsets.only(
        left: ScreenUtil().setWidth(30),
        right: ScreenUtil().setWidth(30),
        bottom: ScreenUtil().setWidth(30),
      ),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: Offset(
              0,
              ScreenUtil().setWidth(6),
            ),
            color: _mainColor.withOpacity(0.32),
            blurRadius: ScreenUtil().setWidth(20),
          ),
        ],
        borderRadius: BorderRadius.circular(
          ScreenUtil().setWidth(30),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.maxFinite,
            height: ScreenUtil().setWidth(351),
            child: KTKJMyOctoImage(
              fit: BoxFit.fill,
              image:
                  "https://alipic.lanhuapp.com/xd55303641-38a3-441e-9de4-3a73cd1bc640",
            ),
          ),
          Column(
            children: [
              Container(
                height: ScreenUtil().setWidth(76),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      ScreenUtil().setWidth(30),
                    ),
                    topRight: Radius.circular(
                      ScreenUtil().setWidth(30),
                    ),
                  ),
                ),
              ),
              Container(
                height: ScreenUtil().setWidth(275),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                      ScreenUtil().setWidth(30),
                    ),
                    bottomRight: Radius.circular(
                      ScreenUtil().setWidth(30),
                    ),
                  ),
                ),
                padding: EdgeInsets.all(
                  ScreenUtil().setWidth(46),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: ScreenUtil().setWidth(180),
                      height: ScreenUtil().setHeight(180),
                      child: CircleAvatar(
                        backgroundColor: Color(0xffF9993D),
                        child: Center(
                          child: ClipOval(
                            child: KTKJMyOctoImage(
                              image: "$_avatarUrl",
                              width: ScreenUtil().setWidth(150),
                              height: ScreenUtil().setWidth(150),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(30),
                        ),
                        child: Text(
                          "$msg",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(42),
                            color: _mainColor,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible: !isProtected,
                          child: KTKJMyOctoImage(
                            width: ScreenUtil().setWidth(88),
                            height: ScreenUtil().setWidth(88),
                            image:
                                "https://alipic.lanhuapp.com/xdbc05c151-e64b-4ced-93b5-3730c8bbfb91",
                          ),
                        ),
                        Visibility(
                          visible: isProtected,
                          child: KTKJMyOctoImage(
                            width: ScreenUtil().setWidth(74),
                            height: ScreenUtil().setWidth(100),
                            image:
                                "https://alipic.lanhuapp.com/xd365c451b-519e-4be0-bed6-315013e9466e",
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: ScreenUtil().setWidth(188),
                          ),
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(10),
                          ),
                          child: Text(
                            "$_timeDesc",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(32),
                              color: Color(0xff666666),
                            ),
                          ),
                        ),

                        ///
                      ],
                    ),

                    ///https://alipic.lanhuapp.com/xdbc05c151-e64b-4ced-93b5-3730c8bbfb91
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///创建翻牌弹窗

  ///
}
