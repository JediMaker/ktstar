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

class KeTaoFeaturedRouteNames {
  static const String MAINPAGE = '';
  static const String KeTaoFeaturedGoodsListPage = 'goodsListPage';
  static const String LOGINPAGE = "login";
  static const String KeTaoFeaturedOrderListPage = "orderListPage";
  static const String KeTaoFeaturedRechargeListPage = "rechargeListPage";
  static const String KeTaoFeaturedClassifyListPage = "classifyListPage";
  static const String KeTaoFeaturedTaskListPage = "taskListPage";
  static const String KeTaoFeaturedTaskMinePage = "taskMinePage";
  static const String KeTaoFeaturedTaskOpenVipPage = "taskOpenVipPage";
  static const String KeTaoFeaturedTaskHallPage = "taskHallPage";
  static const String KeTaoFeaturedIncomeListPage = "incomeListPage";
  static const String KeTaoFeaturedInvitationPosterPage = "invitationPosterPage";
  static const String KeTaoFeaturedAboutPage = "aboutPage";
  static const String KeTaoFeaturedFansListPage = "fansListPage";
  static const String KeTaoFeaturedTaskMessagePage = "taskMessagePage";
  static const String KeTaoFeaturedTaskRecordListPage = "taskRecordListPage";
  static const String KeTaoFeaturedPddHomeIndexPage = "pddHome";
  static const String KeTaoFeaturedPddGoodsListPage = "pddList";
  static const String KeTaoFeaturedPddGoodsDetailPage = "pddGoodsDetailPage";
}

class MyRouters {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print("RouteSettings==:" + settings.toString());
    switch (settings.name) {
      case KeTaoFeaturedRouteNames.KeTaoFeaturedOrderListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.KeTaoFeaturedOrderListPage),
          builder: (context) => KeTaoFeaturedRechargeOrderListPage(),
        );
      case KeTaoFeaturedRouteNames.KeTaoFeaturedGoodsListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.KeTaoFeaturedGoodsListPage),
          builder: (context) => KeTaoFeaturedGoodsListPage(),
        );
      case KeTaoFeaturedRouteNames.LOGINPAGE:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.LOGINPAGE),
          builder: (context) => KeTaoFeaturedLoginPage(),
        );
      case KeTaoFeaturedRouteNames.KeTaoFeaturedRechargeListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.KeTaoFeaturedRechargeListPage),
          builder: (context) => KeTaoFeaturedRechargeListPage(),
        );
      case KeTaoFeaturedRouteNames.KeTaoFeaturedClassifyListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.KeTaoFeaturedClassifyListPage),
          builder: (context) => KeTaoFeaturedClassifyListPage(),
        );
      case KeTaoFeaturedRouteNames.KeTaoFeaturedTaskListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.KeTaoFeaturedTaskListPage),
          builder: (context) => KeTaoFeaturedTaskListPage(),
        );
      case KeTaoFeaturedRouteNames.KeTaoFeaturedTaskMinePage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.KeTaoFeaturedTaskMinePage),
          builder: (context) => KeTaoFeaturedTaskMinePage(),
        );
      case KeTaoFeaturedRouteNames.KeTaoFeaturedTaskOpenVipPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.KeTaoFeaturedTaskOpenVipPage),
          builder: (context) => KeTaoFeaturedTaskOpenVipPage(),
        );
      case KeTaoFeaturedRouteNames.KeTaoFeaturedTaskHallPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.KeTaoFeaturedTaskHallPage),
          builder: (context) => KeTaoFeaturedTaskHallPage(),
        );
      case KeTaoFeaturedRouteNames.KeTaoFeaturedIncomeListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.KeTaoFeaturedIncomeListPage),
          builder: (context) => KeTaoFeaturedIncomeListPage(),
        );
      case KeTaoFeaturedRouteNames.KeTaoFeaturedInvitationPosterPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.KeTaoFeaturedInvitationPosterPage),
          builder: (context) => KeTaoFeaturedInvitationPosterPage(),
        );
      case KeTaoFeaturedRouteNames.KeTaoFeaturedAboutPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.KeTaoFeaturedAboutPage),
          builder: (context) => KeTaoFeaturedAboutPage(),
        );
      case KeTaoFeaturedRouteNames.KeTaoFeaturedFansListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.KeTaoFeaturedFansListPage),
          builder: (context) => KeTaoFeaturedFansListPage(),
        );
      case KeTaoFeaturedRouteNames.KeTaoFeaturedTaskMessagePage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.KeTaoFeaturedTaskMessagePage),
          builder: (context) => KeTaoFeaturedTaskMessagePage(),
        );
      case KeTaoFeaturedRouteNames.KeTaoFeaturedTaskRecordListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.KeTaoFeaturedTaskRecordListPage),
          builder: (context) => KeTaoFeaturedTaskRecordListPage(),
        );
      case KeTaoFeaturedRouteNames.KeTaoFeaturedPddHomeIndexPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.KeTaoFeaturedPddHomeIndexPage),
          builder: (context) => KeTaoFeaturedPddHomeIndexPage(),
        );
      case KeTaoFeaturedRouteNames.KeTaoFeaturedPddGoodsListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.KeTaoFeaturedPddGoodsListPage),
          builder: (context) => KeTaoFeaturedPddGoodsListPage(),
        );
      case KeTaoFeaturedRouteNames.KeTaoFeaturedPddGoodsDetailPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: KeTaoFeaturedRouteNames.KeTaoFeaturedPddGoodsDetailPage),
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
