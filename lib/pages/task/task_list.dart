import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:star/bus/my_event_bus.dart';
import 'package:star/global_config.dart';
import 'package:star/http/http.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/home_entity.dart';
import 'package:star/models/user_info_entity.dart';
import 'package:star/pages/recharge/recharge_list.dart';
import 'package:star/pages/task/task_detail.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:star/pages/task/task_detail_other.dart';
import 'package:star/pages/task/task_open_diamond.dart';
import 'package:star/pages/task/task_open_diamond_dialog.dart';
import 'package:star/pages/task/task_open_vip.dart';
import 'package:star/pages/task/task_share.dart';
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

class _TaskListPageState extends State<TaskListPage>
    with TickerProviderStateMixin {
  String taskCompletedNum = "";
  String taskTotalNum = "";
  int bannerIndex = 0;
  HomeEntity entity;
  TabController _tabController;
  List<HomeDataBanner> bannerList;
  static List<HomeDataTaskListList> taskList;
  static List<HomeDataTaskListList> taskVipList;
  static List<HomeDataTaskListList> taskDiamondVipList;
  List<HomeDataTaskList> taskListAll;
  ScrollController _scrollController;
  SwiperController _swiperController;
  bool _isLoop = false;

  ///当前用户等级 0普通用户 1体验用户 2VIP用户 3代理 4钻石用户
  var userType;

  List<String> _tabValues = [
    "普通专区",
    "vip专区",
    "钻石专区",
  ];
  List<String> nomalItems = [
    "普通专区",
    "vip专区",
    "钻石专区",
  ];
  List<String> experienceItems = [
    "体验专区",
    "vip专区",
    "钻石专区",
  ];
  List<Widget> _tabViews = [
/*    buildTaskListTabView(
      taskType: 0,
    ),
    buildTaskListTabView(
      taskType: 1,
    ),
    buildTaskListTabView(
      taskType: 2,
    ),*/
    TaskListTabView(
      taskType: 0,
    ),
    TaskListTabView(
      taskType: 1,
    ),
    TaskListTabView(
      taskType: 2,
    ),
  ];

  @override
  initState() {
    _tabController = TabController(length: 3, vsync: this);
    _initData();
    _scrollController = ScrollController()..addListener(() {});
    _swiperController = new SwiperController();
    _swiperController.startAutoplay();

//    try {
//      userType = GlobalConfig.getUserInfo().type;
//    } catch (e) {
//      print(e);
//    }

    bus.on("taskListChanged", (listSize) {
      if (mounted) {
        setState(() {
          if (listSize == 0) {
            _tabBarViewHeight = ScreenUtil().setHeight(300);
            return;
          }
          _tabBarViewHeight = ScreenUtil()
              .setHeight(listSize * (388 - listSize * (12 - listSize * 0.5)));
        });
      }
    });
    bus.on("refreshData", (data) {
      _initData();
    });
    super.initState();
  }

  Future _initData() async {
    var result = await HttpManage.getHomeInfo();
    if (mounted) {
      setState(() {
        try {
          entity = result;
          bannerList = entity.data.banner;
          taskListAll = entity.data.taskList;
          userType = entity.data.userLevel;
        } catch (e) {}
//        _tabController = TabController(length: 3, vsync: this);
        switch (userType) {
          case "1": //体验
            _tabValues = experienceItems;
            break;
          case "2": //vip
            _tabController.animateTo(1);
            break;
          case "4": //钻石
            _tabController.animateTo(2);
            break;
        }
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
  static checkUserBind({bool isTaskWall = false}) {
    UserInfoData userInfoData = GlobalConfig.getUserInfo();
    if (!isTaskWall) {
      if (userInfoData.bindThird == 1) {
        CommonUtils.showToast("请先绑定微信后领取任务");
        return false;
      }
    }

    if (CommonUtils.isEmpty(userInfoData.tel)) {
      CommonUtils.showToast("请先绑定手机号后领取任务");
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _swiperController.stopAutoplay();
    _swiperController.dispose();
    _tabController.dispose();
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
    Color(0xFFB43733),
    Color(0xFFB43733),
    Color(0xFFB43733),
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
                    taskCard2(context),
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
              switch (bannerList[index].uri.toString().trim()) {
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
                case "upgrade_diamond":
                  _gradientCorlor = LinearGradient(colors: [
                    Color(0xFFB43733),
                    Color(0xFFB43733),
                    Color(0xFFB43733),
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
              if (Platform.isIOS) {
                CommonUtils.showIosPayDialog();
                return;
              }

              switch (bannerList[bannerIndex].uri.toString().trim()) {
                case "upgrade":
                  NavigatorUtils.navigatorRouter(context, TaskOpenVipPage());
/*
                  NavigatorUtils.navigatorRouter(
                      context, TaskOpenDiamondPage());
*/
                  break;
                case "recharge":
                  NavigatorUtils.navigatorRouter(context, RechargeListPage());
                  break;
                case "upgrade_diamond":
                  NavigatorUtils.navigatorRouter(
                      context,
                      TaskOpenVipPage(
                        taskType: 2,
                      ));
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
          /* if (checkUserBind(isTaskWall: true)) {
            */ /* NavigatorUtils.navigatorRouter(
                context,
                WebViewPage(
                  initialUrl: HttpManage.getTheMissionWallEntranceUrl(
                      "${GlobalConfig.getUserInfo().tel}"),
                  showActions: true,
                  title: "任务墙",
                  appBarBackgroundColor: Color(0xFFD72825),
                ));*/ /*

          }*/
          NavigatorUtils.navigatorRouter(
              context,
              TaskOpenVipPage(
                taskType: 2,
              ));
//          HttpManage.getTheMissionWallEntrance("13122336666");
        },
        child: Container(
          height: ScreenUtil().setHeight(550),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          alignment: Alignment.center,
          child: CachedNetworkImage(
            imageUrl:
                'https://alipic.lanhuapp.com/xddcdf45d1-4fd3-47e6-9326-88bb1cfd4edf',
            width: ScreenUtil().setWidth(1061),
            height: ScreenUtil().setHeight(550),
            fit: BoxFit.fill,
          ),
/*
          child: Image.asset(
            'static/images/task_wall.png',
            width: ScreenUtil().setWidth(1061),
            height: ScreenUtil().setHeight(550),
            fit: BoxFit.fill,
          ),
*/
        ),
      ),
    );
  }

  ///任务状态 -2不可领取 -1去开通 0领任务 1待提交 2待审核 3已完成 4被驳回
  Widget buildTaskItemLayout(context, HomeDataTaskListList taskItem, index) {
    var bgColor = GlobalConfig.taskBtnBgColor;
    var txtColor = GlobalConfig.taskBtnTxtColor;
    var category = '';
    category = taskItem.category;
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
            if (Platform.isIOS) {
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
              switch (category) {
                case "1":
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
                    CommonUtils.showToast(result.errMsg);
                  }
                  break;
                case "2":
                  var result = await HttpManage.taskReceiveOther(taskItem.id);
                  if (result.status) {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return TaskDetailOtherPage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  } else {
                    CommonUtils.showToast(result.errMsg);
                  }
                  break;
              }
            }

            break;
          case 1: //待提交
            if (category == "1") {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return TaskDetailPage(
                  taskId: taskItem.id,
                );
              }));
              _initData();
            } else {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return TaskDetailOtherPage(
                  taskId: taskItem.id,
                );
              }));
              _initData();
            }

            break;
          case 2: //2待审核
            break;
          case 3: //3已完成
            break;
          case 4: //--4被驳回
            if (category == "1") {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return TaskDetailPage(
                  taskId: taskItem.id,
                  pageType: 1,
                );
              }));
              _initData();
            } else {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return TaskDetailOtherPage(
                  taskId: taskItem.id,
                  pageType: 1,
                );
              }));
              _initData();
            }
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

  ///任务状态 -2不可领取 -1去开通 0领任务 1待提交 2待审核 3已完成 4被驳回
  Widget buildTaskItemLayout2(context, HomeDataTaskListList taskItem, index) {
    var bgColor = GlobalConfig.taskBtnBgColor;
    var txtColor = GlobalConfig.taskBtnTxtColor;
    var category = '';
    category = taskItem.category;
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
            if (Platform.isIOS) {
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
              switch (category) {
                case "1":
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
                    CommonUtils.showToast(result.errMsg);
                  }
                  break;
                case "2":
                  var result = await HttpManage.taskReceiveOther(taskItem.id);
                  if (result.status) {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return TaskDetailOtherPage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  } else {
                    CommonUtils.showToast(result.errMsg);
                  }
                  break;
              }
            }

            break;
          case 1: //待提交
            if (category == "1") {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return TaskDetailPage(
                  taskId: taskItem.id,
                );
              }));
              _initData();
            } else {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return TaskDetailOtherPage(
                  taskId: taskItem.id,
                );
              }));
              _initData();
            }

            break;
          case 2: //2待审核
            break;
          case 3: //3已完成
            break;
          case 4: //--4被驳回
            if (category == "1") {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return TaskDetailPage(
                  taskId: taskItem.id,
                  pageType: 1,
                );
              }));
              _initData();
            } else {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return TaskDetailOtherPage(
                  taskId: taskItem.id,
                  pageType: 1,
                );
              }));
              _initData();
            }
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
          left: 16, right: 16, top: ScreenUtil().setHeight(655)),
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

  ///2.0版本任务列表
  Widget taskCard2(context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(
          left: 16, right: 16, top: ScreenUtil().setHeight(655)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            child: Center(
              child: TabBar(
                tabs: _tabValues.map((f) {
                  return Text(
                    f,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: ScreenUtil().setSp(38)),
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
          Container(
            height: _tabBarViewHeight,
            child: TabBarView(
              controller: _tabController,
              children: _tabViews,
            ),
          ),
        ],
      ),
    );
  }

  var _tabBarViewHeight = ScreenUtil().setHeight(300);

  Widget buildTaskListTabView({int taskType}) {
    var taskList;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 16,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return buildTaskItemLayout2(context, taskList[index], index);
            },
            itemCount: taskList == null ? 0 : taskList.length,
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class TaskListTabView extends StatefulWidget {
  int taskType;
  List<HomeDataTaskListList> taskList;

  @override
  _TaskListTabViewState createState() => _TaskListTabViewState();

  TaskListTabView({Key key, @required this.taskList, this.taskType})
      : super(key: key);
}

class _TaskListTabViewState extends State<TaskListTabView>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  String taskCompletedNum = "";
  String taskTotalNum = "";
  int bannerIndex = 0;
  HomeEntity entity;
  List<HomeDataBanner> bannerList;
  List<HomeDataTaskListList> taskList = List<HomeDataTaskListList>();

  List<HomeDataTaskList> taskListAll;
  String userType;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _initData();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ///初始化任务列表数据
  Future _initData() async {
    var result = await HttpManage.getHomeInfo();
    if (mounted) {
      setState(() {
        try {
          bus.emit("taskListChanged", 0);
          entity = result;
          bannerList = entity.data.banner;
          taskListAll = entity.data.taskList;
          userType = entity.data.userLevel;
        } catch (e) {}
        var length = 0;
        switch (widget.taskType) {
          case 0: //普通/体验
            for (var taskListItem in taskListAll) {
              if (taskListItem.name == "普通专区" || taskListItem.name == "体验专区") {
                taskList = taskListItem.xList;
                bus.emit("taskListChanged", taskList.length);
                return;
              }
            }
            break;
          case 1: //vip
            for (var taskListItem in taskListAll) {
              if (taskListItem.name == "VIP专区") {
                taskList = taskListItem.xList;
                bus.emit("taskListChanged", taskList.length);
                return;
              }
            }
            break;
          case 2: //钻石
            for (var taskListItem in taskListAll) {
              if (taskListItem.name == "钻石专区") {
                taskList = taskListItem.xList;
                bus.emit("taskListChanged", taskList.length);
                return;
              }
            }
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildTaskListTabView();
  }

  Widget buildTaskListTabView() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 20,
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
        ],
      ),
    );
  }

  /// 确认账户信息是否绑定手机号以及微信授权
  checkUserBind({bool isTaskWall = false}) {
    UserInfoData userInfoData = GlobalConfig.getUserInfo();
    if (!isTaskWall) {
      if (userInfoData.bindThird == 1) {
        CommonUtils.showToast("请先绑定微信后领取任务");
        return false;
      }
    }

    if (CommonUtils.isEmpty(userInfoData.tel)) {
      CommonUtils.showToast("请先绑定手机号后领取任务");
      return false;
    }
    return true;
  }

  ///任务状态 -2不可领取 -1去开通 0领任务 1待提交 2待审核 3已完成 4被驳回
  Widget buildTaskItemLayout(context, HomeDataTaskListList taskItem, index) {
    var bgColor = GlobalConfig.taskBtnBgColor;
    var txtColor = GlobalConfig.taskBtnTxtColor;
    var category = '';
    category = taskItem.category;
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
    return GestureDetector(
      onTap: () async {
        /*      if (true) {
          NavigatorUtils.navigatorRouter(context, TaskSharePage());
          return;
        }*/
        switch (taskItem.taskStatus) {
          case -2:
            break;
          case -1: //-1去开通
            if (Platform.isIOS) {
              CommonUtils.showIosPayDialog();
              return;
            }
            var result = await showDialog(
                context: context,
                builder: (context) {
                  return TaskOpenDiamondDialogPage(
                    taskType: widget.taskType,
                  );
                });
            break;
          case 0: // 领任务
            if (checkUserBind(isTaskWall: !GlobalConfig.isBindWechat)) {
              switch (userType) {
                case "0": //普通
                  break;
                case "1": //体验
                  break;
                case "2": //vip
                  if (widget.taskType != 1) {
                    CommonUtils.showToast("请到vip专区领取任务");
                    return;
                  }
                  break;
                case "4": //钻石
                  if (widget.taskType != 2) {
                    CommonUtils.showToast("请到钻石专区领取任务");
                    return;
                  }
                  break;
              }
              switch (category) {
                case "1":
                  /*if (userType == "0") {
                    CommonUtils.showToast("您只能领取非朋友圈任务");
                    return;
                  }*/
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
                    CommonUtils.showToast(result.errMsg);
                  }
                  break;
                case "2":
                  var result = await HttpManage.taskReceiveOther(taskItem.id);
                  if (result.status) {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return TaskDetailOtherPage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  } else {
                    CommonUtils.showToast(result.errMsg);
                  }
                  break;
                case "3":
                  var result = await HttpManage.taskReceiveWechat(taskItem.id);
                  if (result.status) {
                    var result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return TaskSharePage(
                        taskId: taskItem.id,
                      );
                    }));
                    _initData();
                  } else {
                    CommonUtils.showToast(result.errMsg);
                  }
                  break;
              }
            }

            break;
          case 1: //待提交
            switch (userType) {
              case "0": //普通
                break;
              case "1": //体验
                break;
              case "2": //vip
                if (widget.taskType != 1) {
                  CommonUtils.showToast("请到vip专区提交任务");
                  return;
                }
                break;
              case "4": //钻石
                if (widget.taskType != 2) {
                  CommonUtils.showToast("请到钻石专区提交任务");
                  return;
                }
                break;
            }
            if (category == "1") {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return TaskDetailPage(
                  taskId: taskItem.id,
                );
              }));
              _initData();
            } else {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return TaskDetailOtherPage(
                  taskId: taskItem.id,
                );
              }));
              _initData();
            }

            break;
          case 2: //2待审核
            switch (category) {
              case "3":
                NavigatorUtils.navigatorRouter(
                    context,
                    TaskSharePage(
                      taskId: taskItem.id,
                    ));
                break;
            }
            break;
          case 3: //3已完成
            break;
          case 4: //--4被驳回
            switch (userType) {
              case "0": //普通
                break;
              case "1": //体验
                break;
              case "2": //vip
                if (widget.taskType != 1) {
                  CommonUtils.showToast("请到vip专区提交任务");
                  return;
                }
                break;
              case "4": //钻石
                if (widget.taskType != 2) {
                  CommonUtils.showToast("请到钻石专区提交任务");
                  return;
                }
                break;
            }
            if (category == "1") {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return TaskDetailPage(
                  taskId: taskItem.id,
                );
              }));
              _initData();
            } else {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return TaskDetailOtherPage(
                  taskId: taskItem.id,
                );
              }));
              _initData();
            }
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
      child: Container(
        height: ScreenUtil().setHeight(300),
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(184),
              height: ScreenUtil().setHeight(216),
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().setWidth(24))),
                border: Border.all(
                    color: Color(0xffF32E43), width: ScreenUtil().setWidth(2)),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: ScreenUtil().setHeight(141),
                    decoration: BoxDecoration(
                      color: Color(0xffF32E43),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(ScreenUtil().setHeight(24)),
                          topRight:
                              Radius.circular(ScreenUtil().setHeight(24))),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "${taskItem.sharePrice}",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(54),
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft:
                                Radius.circular(ScreenUtil().setHeight(24)),
                            bottomRight:
                                Radius.circular(ScreenUtil().setHeight(24))),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "奖励(元)",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(30),
                          color: Color(0xffF32E43),
                        ),
                      ),
                    ),
                  ),
                  /* ClipOval(
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          width: ScreenUtil().setWidth(110),
                          height: ScreenUtil().setWidth(110),
                          imageUrl: taskItem.icons,
                        ),
                      ),*/
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    child: Text(
                      '${taskItem.title}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: ScreenUtil().setSp(42)),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Text('${taskItem.subtitle}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(32),
                                  color: Color(0xff999999))),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(48),
                          height: ScreenUtil().setHeight(48),
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            CupertinoIcons.news_solid,
                            size: ScreenUtil().setWidth(36),
                            color: Color(0XFF666666),
                          ),
                        ),
/*
                            child: Image.asset(
                              "static/images/task_img_star.png",
                              width: ScreenUtil().setWidth(36),
                              height: ScreenUtil().setWidth(36),
                              fit: BoxFit.fill,
                            )),
*/
                        Text('剩余任务：${taskItem.num}条',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(32),
                                color: Color(0xff666666))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    color: bgColor,
                    border: Border.all(
                        width: 0.5, color: bgColor, style: BorderStyle.solid)),
                child: Text(
                  "${taskItem.statusDesc}",
                  style: TextStyle(
                      color: txtColor, fontSize: ScreenUtil().setSp(36)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
