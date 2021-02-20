import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedNavigatorUtils {
  static navigatorRouter(BuildContext context, Widget widget) {
    return Navigator.push(
        context, new MaterialPageRoute(builder: (context) => widget));
  }
  static navigatorRouterReplaceMent(BuildContext context, Widget widget) {
    return Navigator.pushReplacement(
        context, new MaterialPageRoute(builder: (context) => widget));
  }
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;
  static navigatorRouterAndRemoveUntil(BuildContext context, Widget widget) {
    //跳转并关闭当前页面
    return Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => widget),
      (route) => route == null,
    );
  }
/*

  Container buildLampsWithSlider() {
    return Container(
      //color: Colors.yellow,
      height: 350,
      child: Stack(
        children: <Widget>[
          buildLamps,
          Positioned(
            bottom: 40.0,
            right: 50.0,
            child: ItemNavigation(),
          )
        ],
      ),
    );
  }
*/

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
/*final buildFurnitureCategories = Container(
  height: 100.0,
  //color: Colors.red,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: furnitureCategoriesList.length,
    itemBuilder: (context, int index) => FurnitureCategory(
      item: furnitureCategoriesList[index],
    ),
  ),
);*/
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
