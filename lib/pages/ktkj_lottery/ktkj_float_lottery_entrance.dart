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
  ///水平偏移量范围
  var _initOffsetDx;

  ///垂直偏移量范围
  var _initOffsetDy;

  Offset offset;

  var _showFloatBtn = true;

  ///https://juejin.cn/post/6844904071778795528
  ///偏移量处理返回新的位置
  Offset _calOffset(Size size, Offset offset, Offset nextOffset) {
    /*print("offset.dx=${offset.dx}\n"
        "offset.dy=${offset.dy}\n"
        "nextOffset.dx=${nextOffset.dx}\n"
        "nextOffset.dy=${nextOffset.dy}\n"
        "_initOffsetDx=${_initOffsetDx}\n"
        "_initOffsetDy=${_initOffsetDy}\n"
        "screenWidth=${ScreenUtil.screenWidth}\n"
        "screenHeight=${ScreenUtil.screenHeight}\n");*/
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: offset.dx,
      top: offset.dy,
      duration: Duration(milliseconds: 1000),
      curve: Curves.fastLinearToSlowEaseIn,
      child: Visibility(
        visible: _showFloatBtn,
        child: GestureDetector(
          onTap: () {
            KTKJNavigatorUtils.navigatorRouter(context, KTKJLotteryMainPage());
          },
          onPanStart: (DragStartDetails details) {
//            print("onPanStart");
//          print("localPosition=${details.localPosition}");
//          print("globalPosition=${details.globalPosition}");
          },
          onPanDown: (DragDownDetails details) {
//            print("onPanDown");
//          print("localPosition=${details.localPosition}");
//          print("globalPosition=${details.globalPosition}");
          },
          onPanEnd: (DragEndDetails details) {
//            print("onPanEnd");
            setState(() {
              ///移动结束设置图标靠左或者靠右悬浮
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
//            print("onPanUpdate");
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
                ///悬浮图标
                Container(
                  width: ScreenUtil().setWidth(185),
                  height: ScreenUtil().setWidth(200),
                  child: KTKJMyOctoImage(
                    image:
                        "https://alipic.lanhuapp.com/xd6ae1f9f4-a636-409b-a852-8484fe638390",
                    fit: BoxFit.fill,
                  ),
                ),

                ///删除图标
                GestureDetector(
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        _showFloatBtn = false;
                      });
                    }
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(63),
                    height: ScreenUtil().setWidth(63),
                    child: KTKJMyOctoImage(
                      image:
                          "https://alipic.lanhuapp.com/xd8a35fac7-95b5-46c7-9297-5962e4996331",
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
