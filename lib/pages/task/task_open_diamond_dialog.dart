import 'package:flutter/material.dart';
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
        height: 336,
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
                    height: 286,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: Image.asset(
                                    "static/images/task_dialog_diamond.png")
                                .image)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 98),
                    child: Text(
                      "钻石会员福利",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          fontSize: 24),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 165),
                    child: Text(
                      "VIP会员仅可领取2条任务",
                      style: TextStyle(color: Color(0xFF6B6B6B), fontSize: 12),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 188),
                    child: Text(
                      "开通为钻石会员可全部领取",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 229, left: 47, right: 47),
                    alignment: Alignment.center,
                    height: 34,
                    width: 124,
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
                        fontSize: 16,
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
                height: 24,
                alignment: Alignment.center,
                child: Image.asset(
                  "static/images/task_dialog_close_btn.png",
                  width: 24,
                  height: 24,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
