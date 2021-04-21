import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:star/http/ktkj_http_manage.dart';
import 'package:star/utils/ktkj_common_utils.dart';

///能量大作战消息页面
class KTKJLotteryRecordListPage extends StatefulWidget {
  KTKJLotteryRecordListPage({
    Key key,
    this.title = '抽奖记录',
    this.type = 0,
  }) : super(key: key);
  final String title;

  ///记录类型 0 抽奖记录 1 能量记录  2 卡片记录
  final int type;

  @override
  _KTKJLotteryRecordListPageState createState() =>
      _KTKJLotteryRecordListPageState();
}

class _KTKJLotteryRecordListPageState extends State<KTKJLotteryRecordListPage> {
  var _mainColor = Color(0xffFEF3DE);
  int page = 1;
  EasyRefreshController _refreshController;
  bool isFirstLoading = true;
  var msgList = [];

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
//    _initData();
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
          _mainColor,
          _mainColor,
//          Color(0xffFEDD3C),
//          Color(0xffFEDD3C),
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
            _mainColor,
            _mainColor,
//            Color(0xffFFB20E),
//            Color(0xffF9993D),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(
              minHeight: ScreenUtil().setWidth(1925),
            ),
            child: Column(
              children: List.generate(
                8,
                (index) => buildItemContainer(index: index),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setWidth(260),
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
    var msg = 'ID455678偷走了你0.01个分红金ID455678偷走了你0ID455678偷走了你0';
    var _timeDesc = "10分钟前";
    var _avatarUrl =
        'https://alipic.lanhuapp.com/xdac86e5c2-6da4-4369-ad9d-4f2d9922e343';
    bool isProtected = index % 2 == 0;

    return Container(
      height: ScreenUtil().setWidth(230),
      margin: EdgeInsets.only(
        left: ScreenUtil().setWidth(30),
        right: ScreenUtil().setWidth(30),
      ),
      child: Column(
        children: [
          Visibility(
            visible: index != 0,
            child: Container(
              height: ScreenUtil().setWidth(2),
              width: double.maxFinite,
              color: Colors.white,
            ),
          ),
          Container(
            height: ScreenUtil().setWidth(228),
            /*decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(
                  ScreenUtil().setWidth(30),
                ),
                bottomRight: Radius.circular(
                  ScreenUtil().setWidth(30),
                ),
              ),
            ),*/
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    /*margin: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(30),
                    ),*/
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                "$msg",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(48),
                                  color: Color(0xff222222),
                                ),
                              ),
                            ),
                            Container(
                              constraints: BoxConstraints(
                                maxWidth: ScreenUtil().setWidth(388),
                              ),
                              margin: EdgeInsets.only(
//                                top: ScreenUtil().setWidth(10),
                                  ),
                              child: Text(
                                "$_timeDesc",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(48),
                                  color: Color(0xff222222),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(25),
                          ),
                          child: Text(
                            "$msg",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(38),
                              color: Color(0xff666666),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                ///https://alipic.lanhuapp.com/xdbc05c151-e64b-4ced-93b5-3730c8bbfb91
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///创建翻牌弹窗

  ///
}
