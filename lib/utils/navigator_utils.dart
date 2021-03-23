import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KeTaoFeaturedNavigatorUtils {
  static navigatorRouter(BuildContext context, Widget widget) {
    return Navigator.push(
        context, new MaterialPageRoute(builder: (context) => widget));
  }
  static navigatorRouterReplaceMent(BuildContext context, Widget widget) {
    return Navigator.pushReplacement(
        context, new MaterialPageRoute(builder: (context) => widget));
  }

  static navigatorRouterAndRemoveUntil(BuildContext context, Widget widget) {
    //跳转并关闭当前页面
    return Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => widget),
      (route) => route == null,
    );
  }

  ///弹出 dialog
  static Future<T> showGSYDialog<T>({
    @required BuildContext context,
    bool barrierDismissible = true,
    WidgetBuilder builder,
  }) {
    return showDialog<T>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) {
          return MediaQuery(

              ///不受系统字体缩放影响
              data: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                  .copyWith(textScaleFactor: 1),
              child: new SafeArea(child: builder(context)));
        });
  }
}

class MyCupertinoPageRoute extends CupertinoPageRoute {
  Widget widget;

  MyCupertinoPageRoute(this.widget)
      : super(builder: (BuildContext context) => widget);

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: widget);
  }

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => Duration(seconds: 0);
}
