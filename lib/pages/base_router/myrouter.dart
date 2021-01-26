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

class RouteNames {
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
      case RouteNames.OrderListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: RouteNames.OrderListPage),
          builder: (context) => RechargeOrderListPage(),
        );
      case RouteNames.GoodsListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: RouteNames.GoodsListPage),
          builder: (context) => GoodsListPage(),
        );
      case RouteNames.LOGINPAGE:
        return MaterialPageRoute(
          settings: RouteSettings(name: RouteNames.LOGINPAGE),
          builder: (context) => LoginPage(),
        );
      case RouteNames.RechargeListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: RouteNames.RechargeListPage),
          builder: (context) => RechargeListPage(),
        );
      case RouteNames.ClassifyListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: RouteNames.ClassifyListPage),
          builder: (context) => ClassifyListPage(),
        );
      case RouteNames.TaskListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: RouteNames.TaskListPage),
          builder: (context) => TaskListPage(),
        );
      case RouteNames.TaskMinePage:
        return MaterialPageRoute(
          settings: RouteSettings(name: RouteNames.TaskMinePage),
          builder: (context) => TaskMinePage(),
        );
      case RouteNames.TaskOpenVipPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: RouteNames.TaskOpenVipPage),
          builder: (context) => TaskOpenVipPage(),
        );
      case RouteNames.TaskHallPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: RouteNames.TaskHallPage),
          builder: (context) => TaskHallPage(),
        );
      case RouteNames.IncomeListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: RouteNames.IncomeListPage),
          builder: (context) => IncomeListPage(),
        );
      case RouteNames.InvitationPosterPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: RouteNames.InvitationPosterPage),
          builder: (context) => InvitationPosterPage(),
        );
      case RouteNames.AboutPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: RouteNames.AboutPage),
          builder: (context) => AboutPage(),
        );
      case RouteNames.FansListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: RouteNames.FansListPage),
          builder: (context) => FansListPage(),
        );
      case RouteNames.TaskMessagePage:
        return MaterialPageRoute(
          settings: RouteSettings(name: RouteNames.TaskMessagePage),
          builder: (context) => TaskMessagePage(),
        );
      case RouteNames.TaskRecordListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: RouteNames.TaskRecordListPage),
          builder: (context) => TaskRecordListPage(),
        );
      case RouteNames.PddHomeIndexPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: RouteNames.PddHomeIndexPage),
          builder: (context) => PddHomeIndexPage(),
        );
      case RouteNames.PddGoodsListPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: RouteNames.PddGoodsListPage),
          builder: (context) => PddGoodsListPage(),
        );
      case RouteNames.PddGoodsDetailPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: RouteNames.PddGoodsDetailPage),
          builder: (context) => PddGoodsDetailPage(),
        );
      default:
        return MaterialPageRoute(
          settings: RouteSettings(name: RouteNames.MAINPAGE),
          builder: (context) => TaskIndexPage(),
        );
    }
  }
}
