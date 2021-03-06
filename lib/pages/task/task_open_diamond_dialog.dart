import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:star/global_config.dart';
import 'package:star/pages/task/task_open_diamond.dart';

class TaskOpenDiamondDialogPage extends StatefulWidget {
  TaskOpenDiamondDialogPage({Key key}) : super(key: key);
  final String title = "";

  @override
  _TaskOpenDiamondDialogPageState createState() =>
      _TaskOpenDiamondDialogPageState();
}

class _TaskOpenDiamondDialogPageState extends State<TaskOpenDiamondDialogPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        margin: EdgeInsets.only(
          top: ScreenUtil().setHeight(570),
        ),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return TaskOpenDiamondPage();
                }));
              },
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Container(
                    height: ScreenUtil().setHeight(850),
                    width: ScreenUtil().setHeight(645),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: Image.asset(
                                    "static/images/task_dialog_diamond.png")
                                .image)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(280)),
                    child: Text(
                      "钻石会员福利",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          fontSize: ScreenUtil().setSp(72)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(496)),
                    child: Text(
                      "VIP会员仅可领取2条任务",
                      style: TextStyle(
                          color: Color(0xFF6B6B6B),
                          fontSize: ScreenUtil().setSp(33)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(566)),
                    child: Text(
                      "开通为钻石会员可全部领取",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(32),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: ScreenUtil().setHeight(680), left: 47, right: 47),
                    alignment: Alignment.center,
                    height: ScreenUtil().setHeight(90),
                    width: ScreenUtil().setWidth(360),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color(0xFFFBA951),
                          Color(0xFFFFDCAC),
                        ]),
                        borderRadius: BorderRadius.all(Radius.circular(34))),
                    child: Text(
                      "立即开通>",
                      style: TextStyle(
                        color: Color(0xFFC61800),
                        fontSize: ScreenUtil().setSp(49),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: ScreenUtil().setHeight(120),
                alignment: Alignment.center,
                child: Image.asset(
                  "static/images/task_dialog_close_btn.png",
                  width: ScreenUtil().setWidth(120),
                  height: ScreenUtil().setWidth(120),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
