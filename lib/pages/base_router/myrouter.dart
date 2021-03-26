import 'package:flutter/material.dart';
import 'package:star/pages/goods/category/classify.dart';
import 'package:star/pages/goods/goods_detail.dart';
import 'package:star/pages/goods/goods_list.dart';
import 'package:star/pages/goods/pdd/pdd_goods_detail.dart';
import 'package:star/pages/goods/pdd/pdd_goods_list.dart';
import 'package:star/pages/goods/pdd/pdd_home.dart';
import 'package:star/pages/login/login.dart';
import 'package:star/pages/order/recharge_order_list.dart';
import 'package:star/pages/recharge/recharge_list.dart';
import 'package:star/pages/task/fans_list.dart';
import 'package:star/pages/task/income_list.dart';
import 'package:star/pages/task/invitation_poster.dart';
import 'package:star/pages/task/task_about.dart';
import 'package:star/pages/task/task_hall.dart';
import 'package:star/pages/task/task_index.dart';
import 'package:star/pages/task/task_list.dart';
import 'package:star/pages/task/task_message.dart';
import 'package:star/pages/task/task_mine.dart';
import 'package:star/pages/task/task_open_vip.dart';
import 'package:star/pages/task/task_record_list.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJRouteNames {
  static const String MAINPAGE = '';
  static const String KTKJGoodsListPage = 'goodsListPage';
  static const String LOGINPAGE = "login";
  static const String KTKJOrderListPage = "orderListPage";
  static const String KTKJRechargeListPage = "rechargeListPage";
  static const String KTKJClassifyListPage = "classifyListPage";
  static const String KTKJTaskListPage = "taskListPage";
  static const String KTKJTaskMinePage = "taskMinePage";
  static const String KTKJTaskOpenVipPage = "taskOpenVipPage";
  static const String KTKJTaskHallPage = "taskHallPage";
  static const String KTKJIncomeListPage = "incomeListPage";
  static const String KTKJInvitationPosterPage = "invitationPosterPage";
  static const String KTKJAboutPage = "aboutPage";
  static const String KTKJFansListPage = "fansListPage";
  static const String KTKJTaskMessagePage = "taskMessagePage";
  static const String KTKJTaskRecordListPage = "taskRecordListPage";
  static const String KTKJPddHomeIndexPage = "pddHome";
  static const String KTKJPddGoodsListPage = "pddList";
  static const String KTKJPddGoodsDetailPage = "pddGoodsDetailPage";
}

class MyRouters {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print("RouteSettings==:" + settings.toString());
    switch (settings.name) {
      case KTKJRouteNames.KTKJOrderListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KTKJRouteNames.KTKJOrderListPage),
          builder: (context) => KTKJRechargeOrderListPage(),
        );
      case KTKJRouteNames.KTKJGoodsListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KTKJRouteNames.KTKJGoodsListPage),
          builder: (context) => KTKJGoodsListPage(),
        );
      case KTKJRouteNames.LOGINPAGE:
        return MaterialPageRoute(
          settings: RouteSettings(name: KTKJRouteNames.LOGINPAGE),
          builder: (context) => KTKJLoginPage(),
        );
      case KTKJRouteNames.KTKJRechargeListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KTKJRouteNames.KTKJRechargeListPage),
          builder: (context) => KTKJRechargeListPage(),
        );
      case KTKJRouteNames.KTKJClassifyListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KTKJRouteNames.KTKJClassifyListPage),
          builder: (context) => KTKJClassifyListPage(),
        );
      case KTKJRouteNames.KTKJTaskListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KTKJRouteNames.KTKJTaskListPage),
          builder: (context) => KTKJTaskListPage(),
        );
      case KTKJRouteNames.KTKJTaskMinePage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KTKJRouteNames.KTKJTaskMinePage),
          builder: (context) => KTKJTaskMinePage(),
        );
      case KTKJRouteNames.KTKJTaskOpenVipPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KTKJRouteNames.KTKJTaskOpenVipPage),
          builder: (context) => KTKJTaskOpenVipPage(),
        );
      case KTKJRouteNames.KTKJTaskHallPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KTKJRouteNames.KTKJTaskHallPage),
          builder: (context) => KTKJTaskHallPage(),
        );
      case KTKJRouteNames.KTKJIncomeListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KTKJRouteNames.KTKJIncomeListPage),
          builder: (context) => KTKJIncomeListPage(),
        );
      case KTKJRouteNames.KTKJInvitationPosterPage:
        return MaterialPageRoute(
          settings:
              RouteSettings(name: KTKJRouteNames.KTKJInvitationPosterPage),
          builder: (context) => KTKJInvitationPosterPage(),
        );
      case KTKJRouteNames.KTKJAboutPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KTKJRouteNames.KTKJAboutPage),
          builder: (context) => KTKJAboutPage(),
        );
      case KTKJRouteNames.KTKJFansListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KTKJRouteNames.KTKJFansListPage),
          builder: (context) => KTKJFansListPage(),
        );
      case KTKJRouteNames.KTKJTaskMessagePage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KTKJRouteNames.KTKJTaskMessagePage),
          builder: (context) => KTKJTaskMessagePage(),
        );
      case KTKJRouteNames.KTKJTaskRecordListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KTKJRouteNames.KTKJTaskRecordListPage),
          builder: (context) => KTKJTaskRecordListPage(),
        );
      case KTKJRouteNames.KTKJPddHomeIndexPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KTKJRouteNames.KTKJPddHomeIndexPage),
          builder: (context) => KTKJPddHomeIndexPage(),
        );
      case KTKJRouteNames.KTKJPddGoodsListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KTKJRouteNames.KTKJPddGoodsListPage),
          builder: (context) => KTKJPddGoodsListPage(),
        );
      case KTKJRouteNames.KTKJPddGoodsDetailPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KTKJRouteNames.KTKJPddGoodsDetailPage),
          builder: (context) => KTKJPddGoodsDetailPage(),
        );
      default:
        return MaterialPageRoute(
          settings: RouteSettings(name: KTKJRouteNames.MAINPAGE),
          builder: (context) => KTKJTaskIndexPage(),
        );
    }
  }
}
