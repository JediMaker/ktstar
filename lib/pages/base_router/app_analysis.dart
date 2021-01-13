import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//import 'package:umeng/umeng.dart';
//import 'package:lcfarm_flutter_umeng/lcfarm_flutter_umeng.dart';
import 'package:umeng_analytics_plugin/umeng_analytics_plugin.dart';

class AppAnalysis extends NavigatorObserver {
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
  }

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
