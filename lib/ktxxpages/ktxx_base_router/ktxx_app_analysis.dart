import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//import 'package:umeng/umeng.dart';
//import 'package:lcfarm_flutter_umeng/lcfarm_flutter_umeng.dart';
import 'package:umeng_analytics_plugin/umeng_analytics_plugin.dart';
//  return Column(
//  mainAxisSize: MainAxisSize.min,
//  children: <Widget>[
//  Stack(
//  overflow: Overflow.visible,
//  children: <Widget>[
//  GestureDetector(
//  onTap: () {
//  if (catg.name == listProfileCategories[0].name)
//  Navigator.pushNamed(context, '/furniture');
//  },
//  child: Container(
//  padding: EdgeInsets.all(10.0),
//  decoration: BoxDecoration(
//  shape: BoxShape.circle,
//  color: profile_info_categories_background,
//  ),
//  child: Icon(
//  catg.icon,
//  // size: 20.0,
//  ),
//  ),
//  ),
//  catg.number > 0
//  ? Positioned(
//  right: -5.0,
//  child: Container(
//  padding: EdgeInsets.all(5.0),
//  decoration: BoxDecoration(
//  color: profile_info_background,
//  shape: BoxShape.circle,
//  ),
//  child: Text(
//  catg.number.toString(),
//  style: TextStyle(
//  color: Colors.white,
//  fontSize: 10.0,
//  ),
//  ),
//  ),
//  )
//      : SizedBox(),
//  ],
//  ),
//  SizedBox(
//  height: 10.0,
//  ),
//  Text(
//  catg.name,
//  style: TextStyle(
//  fontSize: 13.0,
//  ),
//  )
//  ],
//  );
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedAppAnalysis extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    try {
      /*if (previousRoute.settings.name != null) {
//        LcfarmFlutterUmeng.pageEnd(previousRoute.settings.name);
        Umeng.pageEnd(previousRoute.settings.name);
      }*/
      if (previousRoute.settings.name != null) {
        UmengAnalyticsPlugin.pageEnd(previousRoute.settings.name);
      }

      if (route.settings.name != null) {
        UmengAnalyticsPlugin.pageStart(route.settings.name);
      }
    } catch (e) {}

    try {
      /*  if (route.settings.name != null) {
        Umeng.pageStart(route.settings.name);
      }*/
    } catch (e) {}
  }int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    /*try {
      if (route.settings.name != null) {
        Umeng.pageEnd(route.settings.name);
      }
    } catch (e) {}

    try {
      if (previousRoute.settings.name != null) {
        Umeng.pageStart(previousRoute.settings.name);
      }
    } catch (e) {}*/
    if (previousRoute.settings.name != null) {
      UmengAnalyticsPlugin.pageEnd(previousRoute.settings.name);
    }

    if (route.settings.name != null) {
      UmengAnalyticsPlugin.pageStart(route.settings.name);
    }
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    /*try {
      if (oldRoute.settings.name != null) {
        Umeng.pageEnd(oldRoute.settings.name);
      }
    } catch (e) {}

    try {
      if (newRoute.settings.name != null) {
        Umeng.pageStart(newRoute.settings.name);
      }
    } catch (e) {}*/
    if (oldRoute.settings.name != null) {
      UmengAnalyticsPlugin.pageEnd(oldRoute.settings.name);
    }

    if (newRoute.settings.name != null) {
      UmengAnalyticsPlugin.pageStart(newRoute.settings.name);
    }
  }
}
