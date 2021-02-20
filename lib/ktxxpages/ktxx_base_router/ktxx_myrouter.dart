import 'package:flutter/material.dart';
import 'package:star/ktxxpages/ktxxgoods/ktxxcategory/ktxx_classify.dart';
import 'package:star/ktxxpages/ktxxgoods/ktxx_goods_detail.dart';
import 'package:star/ktxxpages/ktxxgoods/ktxx_goods_list.dart';
import 'package:star/ktxxpages/ktxxgoods/ktxxpdd/ktxx_pdd_goods_detail.dart';
import 'package:star/ktxxpages/ktxxgoods/ktxxpdd/ktxx_pdd_goods_list.dart';
import 'package:star/ktxxpages/ktxxgoods/ktxxpdd/ktxx_pdd_home.dart';
import 'package:star/ktxxpages/ktxxlogin/ktxx_login.dart';
import 'package:star/ktxxpages/ktxxorder/ktxx_recharge_order_list.dart';
import 'package:star/ktxxpages/ktxxrecharge/ktxx_recharge_list.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_fans_list.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_income_list.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_invitation_poster.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_about.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_hall.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_index.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_list.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_message.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_mine.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_open_vip.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_record_list.dart';

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
class KeTaoFeaturedRouteNames {
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;
  static const String MAINPAGE = '';
  static const String GoodsListPage = 'goodsListPage';
  static const String LOGINPAGE = "login";
  static const String OrderListPage = "orderListPage";
  static const String RechargeListPage = "rechargeListPage";
  static const String ClassifyListPage = "classifyListPage";
  static const String TaskListPage = "taskListPage";
  static const String TaskMinePage = "taskMinePage";
  static const String TaskOpenVipPage = "taskOpenVipPage";
  static const String TaskHallPage = "taskHallPage";
  static const String IncomeListPage = "incomeListPage";
  static const String InvitationPosterPage = "invitationPosterPage";
  static const String AboutPage = "aboutPage";
  static const String FansListPage = "fansListPage";
  static const String TaskMessagePage = "taskMessagePage";
  static const String TaskRecordListPage = "taskRecordListPage";
  static const String PddHomeIndexPage = "pddHome";
  static const String PddGoodsListPage = "pddList";
  static const String PddGoodsDetailPage = "pddGoodsDetailPage";
}

class MyRouters {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print("RouteSettings==:" + settings.toString());
    switch (settings.name) {
      case KeTaoFeaturedRouteNames.OrderListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.OrderListPage),
          builder: (context) => KeTaoFeaturedRechargeOrderListPage(),
        );
      case KeTaoFeaturedRouteNames.GoodsListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.GoodsListPage),
          builder: (context) => KeTaoFeaturedGoodsListPage(),
        );
      case KeTaoFeaturedRouteNames.LOGINPAGE:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.LOGINPAGE),
          builder: (context) => KeTaoFeaturedLoginPage(),
        );
      case KeTaoFeaturedRouteNames.RechargeListPage:
        return MaterialPageRoute(
          settings:
              RouteSettings(name: KeTaoFeaturedRouteNames.RechargeListPage),
          builder: (context) => KeTaoFeaturedRechargeListPage(),
        );
      case KeTaoFeaturedRouteNames.ClassifyListPage:
        return MaterialPageRoute(
          settings:
              RouteSettings(name: KeTaoFeaturedRouteNames.ClassifyListPage),
          builder: (context) => KeTaoFeaturedClassifyListPage(),
        );
      case KeTaoFeaturedRouteNames.TaskListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.TaskListPage),
          builder: (context) => KeTaoFeaturedTaskListPage(),
        );
      case KeTaoFeaturedRouteNames.TaskMinePage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.TaskMinePage),
          builder: (context) => KeTaoFeaturedTaskMinePage(),
        );
      case KeTaoFeaturedRouteNames.TaskOpenVipPage:
        return MaterialPageRoute(
          settings:
              RouteSettings(name: KeTaoFeaturedRouteNames.TaskOpenVipPage),
          builder: (context) => KeTaoFeaturedTaskOpenVipPage(),
        );
      case KeTaoFeaturedRouteNames.TaskHallPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.TaskHallPage),
          builder: (context) => KeTaoFeaturedTaskHallPage(),
        );
      case KeTaoFeaturedRouteNames.IncomeListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.IncomeListPage),
          builder: (context) => KeTaoFeaturedIncomeListPage(),
        );
      case KeTaoFeaturedRouteNames.InvitationPosterPage:
        return MaterialPageRoute(
          settings:
              RouteSettings(name: KeTaoFeaturedRouteNames.InvitationPosterPage),
          builder: (context) => KeTaoFeaturedInvitationPosterPage(),
        );
      case KeTaoFeaturedRouteNames.AboutPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.AboutPage),
          builder: (context) => KeTaoFeaturedAboutPage(),
        );
      case KeTaoFeaturedRouteNames.FansListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.FansListPage),
          builder: (context) => KeTaoFeaturedFansListPage(),
        );
      case KeTaoFeaturedRouteNames.TaskMessagePage:
        return MaterialPageRoute(
          settings:
              RouteSettings(name: KeTaoFeaturedRouteNames.TaskMessagePage),
          builder: (context) => KeTaoFeaturedTaskMessagePage(),
        );
      case KeTaoFeaturedRouteNames.TaskRecordListPage:
        return MaterialPageRoute(
          settings:
              RouteSettings(name: KeTaoFeaturedRouteNames.TaskRecordListPage),
          builder: (context) => KeTaoFeaturedTaskRecordListPage(),
        );
      case KeTaoFeaturedRouteNames.PddHomeIndexPage:
        return MaterialPageRoute(
          settings:
              RouteSettings(name: KeTaoFeaturedRouteNames.PddHomeIndexPage),
          builder: (context) => KeTaoFeaturedPddHomeIndexPage(),
        );
      case KeTaoFeaturedRouteNames.PddGoodsListPage:
        return MaterialPageRoute(
          settings:
              RouteSettings(name: KeTaoFeaturedRouteNames.PddGoodsListPage),
          builder: (context) => KeTaoFeaturedPddGoodsListPage(),
        );
      case KeTaoFeaturedRouteNames.PddGoodsDetailPage:
        return MaterialPageRoute(
          settings:
              RouteSettings(name: KeTaoFeaturedRouteNames.PddGoodsDetailPage),
          builder: (context) => KeTaoFeaturedPddGoodsDetailPage(),
        );
      default:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.MAINPAGE),
          builder: (context) => KeTaoFeaturedTaskIndexPage(),
        );
    }
  }
}
