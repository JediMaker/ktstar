import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:star/global_config.dart';
import 'package:star/http/http.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/home_entity.dart';
import 'package:star/models/user_info_entity.dart';
import 'package:star/pages/recharge/recharge_list.dart';
import 'package:star/pages/task/task_detail.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:star/pages/task/task_open_diamond.dart';
import 'package:star/pages/task/task_open_diamond_dialog.dart';
import 'package:star/pages/task/task_submission.dart';
import 'package:star/pages/widget/my_webview.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';
import 'package:flutter_screenutil/screenutil.dart';

class TaskListPage extends StatefulWidget {
  TaskListPage({Key key}) : super(key: key);
  final String title = "任务大厅";

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  String taskCompletedNum = "";
  String taskTotalNum = "";
  int bannerIndex = 0;
  HomeEntity entity;
  List<HomeDataBanner> bannerList;
  List<HomeDataTaskListList> taskList;
  ScrollController _scrollController;
  SwiperController _swiperController;
  bool _isLoop = false;

  @override
  initState() {
    _initData();
    _scrollController = ScrollController()..addListener(() {});
    _swiperController = new SwiperController();
    _swiperController.startAutoplay();
    super.initState();
  }

  Future _initData() async {
    var result = await HttpManage.getHomeInfo();
    if (mounted) {
      setState(() {
        entity = result;
        bannerList = entity.data.banner;
        taskList = entity.data.taskList.xList;
        taskCompletedNum = entity.data.taskList.useTaskTotal;
        taskTotalNum = entity.data.taskList.taskTotal;
        _isLoop = true;
        switch (bannerList[0].uri.toString().trim()) {
          case "upgrade":
            _gradientCorlor = LinearGradient(colors: [
              Color(0xFF7E090F),
              Color(0xFF810A0C),
              Color(0xFF7D0A0F),
            ]);

            break;
          case "recharge":
            _gradientCorlor = LinearGradient(colors: [
              Color(0xFF4A07C6),
              Color(0xFF4A07C6),
            ]);
            break;
        }
      });
    }
  }

  ///
  /// 确认账户信息是否绑定手机号以及微信授权
  checkUserBind({bool isTaskWall = false}) {
    UserInfoData userInfoData = GlobalConfig.getUserInfo();
    if (!isTaskWall) {
      if (userInfoData.bindThird == 1) {
        Fluttertoast.showToast(
            msg: "请先绑定微信后领取任务",
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            gravity: ToastGravity.BOTTOM);
        return false;
      }
    }

    if (CommonUtils.isEmpty(userInfoData.tel)) {
      Fluttertoast.showToast(
          msg: "请先绑定手机号后领取任务",
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM);
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _swiperController.stopAutoplay();
    _swiperController.dispose();
    _isLoop = false;
    super.dispose();
  }

  var images = [
    /* "https://dss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1906469856,4113625838&fm=26&gp=0.jpg",
    "https://dss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1141259048,554497535&fm=26&gp=0.jpg",
    "https://dss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2396361575,51762536&fm=26&gp=0.jpg",*/
  ];

  var iconsUrls = [
    /*"static/images/task_icon_1.png",
    "static/images/task_icon_2.png",
    "static/images/task_icon_3.png",
    "static/images/task_icon_4.png",
    "static/images/task_icon_5.png",*/
  ];
  LinearGradient _gradientCorlor = LinearGradient(colors: [
    Color(0xFF4A07C6),
    Color(0xFF4A07C6),
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(
          title: Text(
            widget.title,
            style: TextStyle(fontSize: ScreenUtil().setSp(54)),
          ),
          centerTitle: true,
          elevation: 0,
          gradient: _gradientCorlor,
        ),
        body: Builder(
          builder: (context) => CustomScrollView(
            slivers: <Widget>[
//              buildBannerLayout(),
//              buildBannerLayout2(),
              SliverToBoxAdapter(
                child: Stack(
                  children: <Widget>[
                    buildBannerLayout(),
                    taskCard(context),
                  ],
                ),
              ),
              buildTaskWall(),
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget buildBannerLayout2() {
    return GestureDetector(
      onTap: () {
        NavigatorUtils.navigatorRouter(context, TaskOpenDiamondPage());
      },
      child: Image.asset(
        "static/images/home_banner.png",
        height: ScreenUtil().setHeight(623),
        width: ScreenUtil().setWidth(1125),
        fit: BoxFit.fill,
      ),
    );
  }

  Widget buildBannerLayout() {
    return Container(
      height: ScreenUtil().setHeight(741),
      width: double.maxFinite,
//      width: ScreenUtil().setWidth(1125),
      /*  decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),*/
      child: Swiper(
        itemCount: bannerList == null ? 0 : bannerList.length,
//        key: GlobalKey(),
        /*itemWidth: ScreenUtil().setWidth(1125),
        itemHeight: ScreenUtil().setHeight(623),
        transformer: ScaleAndFadeTransformer(scale: 0, fade: 0),*/
        //bannerList == null ? 0 : bannerList.length,
        loop: _isLoop,
        autoplay: false,
        controller: _swiperController,
//          indicatorLayout: PageIndicatorLayout.COLOR,
        onIndexChanged: (index) {
          if (mounted) {
            setState(() {
              bannerIndex = index;
              switch (bannerList[bannerIndex].uri.toString().trim()) {
                case "upgrade":
                  _gradientCorlor = LinearGradient(colors: [
                    Color(0xFF7E090F),
                    Color(0xFF810A0C),
                    Color(0xFF7D0A0F),
                  ]);

                  break;
                case "recharge":
                  _gradientCorlor = LinearGradient(colors: [
                    Color(0xFF4A07C6),
                    Color(0xFF4A07C6),
                  ]);
                  break;
              }
            });
          }
        },
        /*pagination: SwiperPagination(
            builder: DotSwiperPaginationBuilder(
                //自定义指示器颜色
                color: Colors.white,
                size: 8.0,
                activeColor: GlobalConfig.taskHeadColor,
                activeSize: 10.0)),*/
        itemBuilder: (context, index) {
          var bannerData = bannerList[index];
          return GestureDetector(
            onTap: () {
              if(Platform.isIOS){
                CommonUtils.showIosPayDialog();
                return;
              }
              switch (bannerList[bannerIndex].uri.toString().trim()) {
                case "upgrade":
                  NavigatorUtils.navigatorRouter(
                      context, TaskOpenDiamondPage());
                  break;
                case "recharge":
                  NavigatorUtils.navigatorRouter(context, RechargeListPage());
                  break;
              }
            },
            child: CachedNetworkImage(
              imageUrl: bannerData.imgPath,
              height: ScreenUtil().setHeight(623),
//              width: ScreenUtil().setWidth(1125),
              fit: BoxFit.fill,
            ),
          );
        },
      ),
    );
  }

  Widget buildTaskWall() {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () {
          if (checkUserBind(isTaskWall: true)) {
            NavigatorUtils.navigatorRouter(
                context,
                WebViewPage(
                  initialUrl: HttpManage.getTheMissionWallEntranceUrl(
                      "${GlobalConfig.getUserInfo().tel}"),
                  showActions: true,
                  title: "任务墙",
                  appBarBackgroundColor: Color(0xFFD72825),
                ));
          }
//          HttpManage.getTheMissionWallEntrance("13122336666");
        },
        child: Container(
          height: ScreenUtil().setHeight(550),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          alignment: Alignment.center,
          child: Image.asset(
            'static/images/task_wall.png',
            width: ScreenUtil().setWidth(1061),
            height: ScreenUtil().setHeight(550),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

//任务状态 -2不可领取 -1去开通 0领任务 1待提交 2待审核 3已完成 4被驳回
  Widget buildTaskItemLayout(context, HomeDataTaskListList taskItem, index) {
    var bgColor = GlobalConfig.taskBtnBgColor;
    var txtColor = GlobalConfig.taskBtnTxtColor;
    switch (taskItem.taskStatus) {
      case -2:
        bgColor = GlobalConfig.taskBtnBgGreyColor;
        txtColor = GlobalConfig.taskBtnTxtGreyColor;
        break;
      case -1:
        break;
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        bgColor = GlobalConfig.taskBtnBgGreyColor;
        txtColor = GlobalConfig.taskBtnTxtGreyColor;
        break;
      case 4:
        break;
    }
    return ListTile(
      onTap: () async {
        switch (taskItem.taskStatus) {
          case -2:
            break;
          case -1: //-1去开通
            if(Platform.isIOS){
              CommonUtils.showIosPayDialog();
              return;
            }
            var result = await showDialog(
                context: context,
                builder: (context) {
                  return TaskOpenDiamondDialogPage();
                });
            break;
          case 0: // 领任务
            if (checkUserBind(isTaskWall: !GlobalConfig.isBindWechat)) {
              var result = await HttpManage.taskReceive(taskItem.id);
              if (result.status) {
                var result = await Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return TaskDetailPage(
                    taskId: taskItem.id,
                  );
                }));
                _initData();
              } else {
                Fluttertoast.showToast(
                    msg: "${result.errMsg}",
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    gravity: ToastGravity.BOTTOM);
              }
            }

            break;
          case 1: //待提交
            var result = await Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) {
              return TaskDetailPage(
                taskId: taskItem.id,
              );
            }));
            _initData();
            break;
          case 2: //2待审核
            break;
          case 3: //3已完成
            break;
          case 4: //--4被驳回
            var result = await Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) {
              return TaskDetailPage(
                taskId: taskItem.id,
              );
            }));
            _initData();
            break;
        }

        /*if (checkUserBind()) {
          if (index == taskStatus) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return TaskDetailPage();
            }));
          } else if (index == 2) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return TaskSubmissionPage();
            }));
          } else {
            var result = await showDialog(
                context: context,
                builder: (context) {
                  return TaskOpenDiamondDialogPage();
                });
            print('$result');
          }
        }*/
      },
      leading: ClipOval(
        child: CachedNetworkImage(
          fit: BoxFit.fill,
          width: ScreenUtil().setWidth(110),
          height: ScreenUtil().setWidth(110),
          imageUrl: taskItem.icons,
        ),
/*
        child: Image.asset(
          taskItem,
          fit: BoxFit.fill,
          width: ScreenUtil().setWidth(110),
          height: ScreenUtil().setWidth(110),
        ),
*/
      ),

      /* CachedNetworkImage(
        width: 40,
        height: 40,
        imageUrl:
        "https://img2020.cnblogs.com/blog/2016690/202009/2016690-20200901173254702-27754128.png",
      ),*/
      title: Text(
        '${taskItem.title}',
        style: TextStyle(fontSize: ScreenUtil().setSp(42)),
      ),
      subtitle: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                width: ScreenUtil().setWidth(48),
                height: ScreenUtil().setHeight(48),
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  "static/images/task_img_star.png",
                  width: ScreenUtil().setWidth(36),
                  height: ScreenUtil().setWidth(36),
                  fit: BoxFit.fill,
                )),
            Text('+${taskItem.sharePrice}元现金奖励',
                style: TextStyle(fontSize: ScreenUtil().setSp(36))),
          ],
        ),
      ),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: bgColor,
            border: Border.all(
                width: 0.5, color: bgColor, style: BorderStyle.solid)),
        child: Text(
          "${taskItem.statusDesc}",
          style: TextStyle(color: txtColor, fontSize: ScreenUtil().setSp(36)),
        ),
      ),
    );
  }

  Widget taskCard(context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(
          left: 16, right: 16, top: ScreenUtil().setHeight(556)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  "每日任务",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(48)),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "$taskCompletedNum/$taskTotalNum",
                  style: TextStyle(
                      color: GlobalConfig.taskBtnTxtGreyColor,
                      fontSize: ScreenUtil().setSp(36)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "完成每日任务可领取更多奖励",
              style: TextStyle(
                  color: GlobalConfig.taskBtnTxtGreyColor,
                  fontSize: ScreenUtil().setSp(36)),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return buildTaskItemLayout(context, taskList[index], index);
            },
            itemCount: taskList == null ? 0 : taskList.length,
          ),
          SizedBox(
            height: 20,
          ),
//        Container(height: 400,width: 400,color: Colors.red, child: _buildPhotosWidget(post),),

//          post.messageImage != null
//              ? Image.network(
//                  post.messageImage,
//                  fit: BoxFit.cover,
//                )
//              : Container(),
//          post.messageImage != null
//              ? Container()
//              : Divider(
//                  color: Colors.grey.shade300,
//                  height: 8.0,
//                ),
        ],
      ),
    );
  }
}
