import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:star/global_config.dart';
import 'package:star/http/http.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/pages/task/task_detail.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:star/pages/task/task_open_diamond_dialog.dart';
import 'package:star/pages/task/task_submission.dart';
import 'package:star/pages/widget/my_webview.dart';
import 'package:star/utils/navigator_utils.dart';

class TaskListPage extends StatefulWidget {
  TaskListPage({Key key}) : super(key: key);
  final String title = "任务大厅";

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  int taskCompletedNum = 0;
  int taskTotalNum = 5;
  int taskStatus = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  var images = [
    "https://dss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1906469856,4113625838&fm=26&gp=0.jpg",
    "https://dss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1141259048,554497535&fm=26&gp=0.jpg",
    "https://dss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2396361575,51762536&fm=26&gp=0.jpg",
  ];

  var iconsUrls = [
    "static/images/task_icon_1.png",
    "static/images/task_icon_2.png",
    "static/images/task_icon_3.png",
    "static/images/task_icon_4.png",
    "static/images/task_icon_5.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          elevation: 0,
          backgroundColor: GlobalConfig.taskHeadColor,
        ),
        body: Builder(
          builder: (context) => CustomScrollView(
            slivers: <Widget>[
              buildBannerLayout(),
              taskCard(context),
              buildTaskWall(),
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget buildBannerLayout() {
    return SliverToBoxAdapter(
      child: Stack(
        children: <Widget>[
          Container(
            color: GlobalConfig.taskHeadColor,
            height: 108,
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            child: Container(
              height: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                child: Swiper(
                  itemCount: images.length,
                  autoplay: true,
                  indicatorLayout: PageIndicatorLayout.COLOR,
                  pagination: SwiperPagination(
                      builder: DotSwiperPaginationBuilder(
                          //自定义指示器颜色
                          color: Colors.white,
                          size: 8.0,
                          activeColor: GlobalConfig.taskHeadColor,
                          activeSize: 10.0)),
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: images[index],
                      width: 1920,
                      height: 170,
                      fit: BoxFit.fill,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTaskWall() {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () {
          NavigatorUtils.navigatorRouter(
              context,
              WebViewPage(
                initialUrl:
                    HttpManage.getTheMissionWallEntranceUrl("13122336666"),
                showActions: true,
                title: "任务墙",

              ));
//          HttpManage.getTheMissionWallEntrance("13122336666");
        },
        child: Container(
          height: 180,
          margin: EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: Image.asset(
            'static/images/task_wall.png',
          ),
        ),
      ),
    );
  }

  Widget buildTaskItemLayout(context, iconUri, index) {
    var statusTxt = '';
    var bgColor = GlobalConfig.taskBtnBgColor;
    var txtColor = GlobalConfig.taskBtnTxtColor;
    switch (taskStatus) {
      //todo 根据状态展示按钮状态
      case 0:
        statusTxt = '去审核';
        bgColor = GlobalConfig.taskBtnBgColor;
        txtColor = GlobalConfig.taskBtnTxtColor;
        break;
      case 1:
        statusTxt = '做任务';
        bgColor = GlobalConfig.taskBtnBgColor;
        txtColor = GlobalConfig.taskBtnTxtColor;
        break;
      case 2:
        statusTxt = '去领取';
        bgColor = GlobalConfig.taskBtnBgColor;
        txtColor = GlobalConfig.taskBtnTxtColor;
        break;
      case 3:
        statusTxt = '已完成';
        bgColor = GlobalConfig.taskBtnBgGreyColor;
        txtColor = GlobalConfig.taskBtnTxtGreyColor;
        break;
      case 4:
        statusTxt = '已完成';
        bgColor = GlobalConfig.taskBtnBgGreyColor;
        txtColor = GlobalConfig.taskBtnTxtGreyColor;
        break;
    }
    return ListTile(
      onTap: () async {
        /*switch (taskStatus) {
          //todo 根据状态展示按钮状态
          case 0: //待提交--去审核
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return TaskDetailPage();
            }));
            break;
          case 1: //审核中--仅展示？
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return TaskDetailPage();
            }));
            break;
          case 2: //todo 调用领取任务接口 跳转详情页下载完成后更改任务状态为待提交
            statusTxt = '去领取';
            bgColor = GlobalConfig.taskBtnBgColor;
            txtColor = GlobalConfig.taskBtnTxtColor;
            break;
          case 3: //审核失败--去重新提交审核
            statusTxt = '已完成';
            bgColor = GlobalConfig.taskBtnBgGreyColor;
            txtColor = GlobalConfig.taskBtnTxtGreyColor;
            break;
          case 4: //--已完成 仅作展示
            statusTxt = '已完成';
            bgColor = GlobalConfig.taskBtnBgGreyColor;
            txtColor = GlobalConfig.taskBtnTxtGreyColor;
            break;
        }*/
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
      },
      leading: ClipOval(
        child: Image.asset(
          iconUri,
          fit: BoxFit.fill,
          width: 55,
          height: 55,
        ),
      ),

      /* CachedNetworkImage(
        width: 40,
        height: 40,
        imageUrl:
        "https://img2020.cnblogs.com/blog/2016690/202009/2016690-20200901173254702-27754128.png",
      ),*/
      title: Text('转发朋友圈'),
      subtitle: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 24,
                height: 24,
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  "static/images/task_img_star.png",
                  width: 16,
                  height: 16,
                )),
            Text('+10元现金奖励'),
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
          "$statusTxt",
          style: TextStyle(color: txtColor),
        ),
      ),
    );
  }

  Widget taskCard(context) {
    return SliverToBoxAdapter(
      child: Card(
//      elevation: 2.0,
        margin: EdgeInsets.symmetric(horizontal: 16),
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
                        fontSize: 16),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "$taskCompletedNum/$taskTotalNum",
                    style: TextStyle(color: GlobalConfig.taskBtnTxtGreyColor),
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
                style: TextStyle(color: GlobalConfig.taskBtnTxtGreyColor),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                taskStatus = index;
                return buildTaskItemLayout(context, iconsUrls[index], index);
              },
              itemCount: iconsUrls.length,
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
      ),
    );
  }
}
