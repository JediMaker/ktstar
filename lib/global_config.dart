import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:star/http/http_manage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 提供五套可选主题色
const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

class GlobalConfig {
  static bool dark = false;
  static ThemeData themeData = new ThemeData(
    primarySwatch: Colors.red,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
  static ThemeData taskThemeData = new ThemeData(
    primarySwatch: MaterialColor(
      0xFFFF5E00,
      <int, Color>{},
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
  static Color searchBackgroundColor = Colors.white10;
  static Color cardBackgroundColor = new Color(0xFF222222);
  static Color checkedColor = Colors.red;
  static Color colorPrimary = taskHeadColor;
  static Color fontColor = Colors.white30;
  static Gradient primaryGradient =
      const LinearGradient(colors: [Color(0xFFF93736), Color(0xFFFE725C)]);
  static var token;

  static SharedPreferences _prefs;

  ///任务墙渠道别名
  static const String MISSION_WALL_CHANNEL = "ktxx001128";

  /// 任务墙入口秘钥
  static const String MISSION_WALL_KEY = "xJmIYddp";

  static SharedPreferences get prefs => _prefs; // 可选的主题列表

  static List<MaterialColor> get themes => _themes;

  static Color taskHeadColor = Color(0xFFFD8B4E);
  static Color taskHeadDisableColor = Color(0xFFFFBB97);
  static Color taskBtnBgColor = Color(0xFFFFECDE);
  static Color taskBtnBgGreyColor = Color(0xFFEFEFEF);
  static Color taskBtnTxtColor = Color(0xFFD95E00);
  static Color taskBtnTxtGreyColor = Color(0xFF999999);

  // 是否为release版
  static bool isRelease = true;

  /// 是否为首次进入app
  static bool get isFirst =>
      prefs.containsKey("isFirst") ? prefs.getBool("isFirst") : true;

  /// taskWallAddress
  static const TASKWALL_ADDRESS =
      'https://c.buuyee.com/api/external';

  /// 代理的 ip 地址
  static const localProxyIPAddress = '192.168.0.6';
  /// 微信appid
  static const String WECHAT_APPID = 'wx824cc9f48da9315c';
  /// 代理端口
  static const localProxyPort = 8888;

//  是否登录
  static bool hasLogin;

  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    if (_profile != null) {
      try {} catch (e) {
        print(e);
      }
    }
    if (!_prefs.containsKey("hasLogin")) {
      saveLoginStatus(false);
    }
    if (!_prefs.containsKey("isFirst")) {
      saveIsFirst(true);
    }
    if (!isRelease) {
//      GlobalConfig.prefs.setString("uid", "123");
    }
    _initFluwx();
    HttpManage.init();
    // 如果没有缓存策略，设置默认缓存策略
    //初始化网络请求相关配置
  }

//  存储是否登陆的状态
  static saveLoginStatus(hasLogin) {
    prefs.setBool("hasLogin", hasLogin);
  }

//  存储是否首次进入app的状态
  static saveIsFirst(isFirst) {
    prefs.setBool("isFirst", isFirst);
  }

  static bool isLogin() {
    /* bool hasLogin =
        prefs.containsKey("hasLogin") ? prefs.getBool("hasLogin") : false;
    print("hasLogin===" +
        hasLogin.toString() +
        "  " +
        prefs.containsKey("hasLogin").toString());*/
    return prefs.containsKey("hasLogin") ? prefs.getBool("hasLogin") : false;
//    return prefs.containsKey("uid") ? prefs.getString("uid") : false;
  }

  static _initFluwx() async {
    await registerWxApi(
        appId: WECHAT_APPID,
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: "https://your.univerallink.com/link/");
    var result = await isWeChatInstalled;
    print("is installed $result");
  }
}
