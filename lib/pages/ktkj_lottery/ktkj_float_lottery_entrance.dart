import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:star/pages/ktkj_lottery/ktkj_lottery_main.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_octoimage.dart';
import 'package:star/utils/ktkj_navigator_utils.dart';

///能量大作战悬浮入口
class KTKJFloatLotteryEntrancePage extends StatefulWidget {
  KTKJFloatLotteryEntrancePage({Key key}) : super(key: key);
  final String title = "";

  @override
  _KTKJFloatLotteryEntrancePageState createState() =>
      _KTKJFloatLotteryEntrancePageState();
}

class _KTKJFloatLotteryEntrancePageState
    extends State<KTKJFloatLotteryEntrancePage> {
  var _initOffsetDx;

  var _initOffsetDy;

  Offset offset;

  var _showFloatBtn = true;

  ///https://juejin.cn/post/6844904071778795528
  Offset _calOffset(Size size, Offset offset, Offset nextOffset) {
    print("offset.dx=${offset.dx}\n"
        "offset.dy=${offset.dy}\n"
        "nextOffset.dx=${nextOffset.dx}\n"
        "nextOffset.dy=${nextOffset.dy}\n"
        "_initOffsetDx=${_initOffsetDx}\n"
        "_initOffsetDy=${_initOffsetDy}\n"
        "screenWidth=${ScreenUtil.screenWidth}\n"
        "screenHeight=${ScreenUtil.screenHeight}\n");
    double dx = 0;
    //水平方向偏移量不能小于0不能大于屏幕最大宽度
    if (offset.dx + nextOffset.dx <= 0) {
      dx = 0;
    } else if (offset.dx + nextOffset.dx >= _initOffsetDx) {
      dx = _initOffsetDx;
    } else {
      dx = offset.dx + nextOffset.dx;
    }

    double dy = 0;
    //垂直方向偏移量不能小于0不能大于屏幕最大高度
    if (offset.dy + nextOffset.dy >= (_initOffsetDy)) {
      dy = _initOffsetDy;
    } else if (offset.dy + nextOffset.dy <= 0) {
      dy = 0;
    } else {
      dy = offset.dy + nextOffset.dy;
    }
    return Offset(
      dx,
      dy,
    );
  }

  @override
  void initState() {
    super.initState();
    _initOffsetDx = ScreenUtil.screenWidth - ScreenUtil().setWidth(185);
    _initOffsetDy = ScreenUtil.screenHeight -
        ScreenUtil.statusBarHeight -
        kToolbarHeight -
        kBottomNavigationBarHeight -
        ScreenUtil().setWidth(200);
    offset = Offset(_initOffsetDx, ScreenUtil.screenHeight / 2);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: offset.dx,
      top: offset.dy,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: Visibility(
        visible: _showFloatBtn,
        child: GestureDetector(
          onTap: () {
            KTKJNavigatorUtils.navigatorRouter(context, KTKJLotteryMainPage());
          },
          onPanStart: (DragStartDetails details) {
            print("onPanStart");
//          print("localPosition=${details.localPosition}");
//          print("globalPosition=${details.globalPosition}");
          },
          onPanDown: (DragDownDetails details) {
            print("onPanDown");
//          print("localPosition=${details.localPosition}");
//          print("globalPosition=${details.globalPosition}");
          },
          onPanEnd: (DragEndDetails details) {
            print("onPanEnd");
            setState(() {
              if (offset.dx >= _initOffsetDx / 2) {
                offset = Offset(_initOffsetDx, offset.dy);
              } else {
                offset = Offset(0, offset.dy);
              }
            });
//          print("primaryVelocity=${details.primaryVelocity}");
//          print("velocity=${details.velocity.pixelsPerSecond}");
          },
          onPanUpdate: (DragUpdateDetails details) {
            print("onPanUpdate");
//          print("localPosition=${details.localPosition}");
//          print("globalPosition=${details.globalPosition}");
//          print("delta=${details.delta}");
//          print("primaryDelta=${details.primaryDelta}");

            setState(() {
              offset = _calOffset(
                  MediaQuery.of(context).size, offset, details.delta);
            });
          },
          child: Center(
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  width: ScreenUtil().setWidth(185),
                  height: ScreenUtil().setWidth(200),
                  child: KTKJMyOctoImage(
                    image:
                        "https://alipic.lanhuapp.com/xdb83b263d-0433-44b4-a33c-ee70210c8437",
                    fit: BoxFit.fill,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        _showFloatBtn = false;
                      });
                    }
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(54),
                    height: ScreenUtil().setWidth(63),
                    child: KTKJMyOctoImage(
                      image:
                          "https://alipic.lanhuapp.com/xd408d44f0-73d0-40ac-918c-e5136765f0fc",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
