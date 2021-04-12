import 'dart:convert';

import 'package:amap_map_fluttify/amap_map_fluttify.dart';

//import 'package:umeng/umeng.dart';
import 'package:amap_search_fluttify/amap_search_fluttify.dart';

//import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

//import 'package:lcfarm_flutter_umeng/lcfarm_flutter_umeng.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:star/generated/json/home_entity_helper.dart';
import 'package:star/generated/json/home_goods_list_entity_helper.dart';
import 'package:star/generated/json/shop_type_entity_helper.dart';
import 'package:star/generated/json/user_info_entity_helper.dart';
import 'package:star/http/ktkj_http_manage.dart';
import 'package:star/models/home_entity.dart';
import 'package:star/models/home_goods_list_entity.dart';
import 'package:star/models/login_entity.dart';
import 'package:star/models/shop_type_entity.dart';
import 'package:star/utils/ktkj_common_utils.dart';

//import 'package:umeng/umeng.dart';
import 'package:umeng_analytics_plugin/umeng_analytics_plugin.dart';

import 'generated/json/login_entity_helper.dart';
import 'models/user_info_entity.dart';

// 提供五套可选主题色
const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJGlobalConfig {
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

  static var LAYOUT_MARGIN = ScreenUtil().setWidth(30);

  ///全局context

  static final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  ///任务墙渠道别名
  static const String MISSION_WALL_CHANNEL = "ktxx001128";

  /// 任务墙入口秘钥
  static const String MISSION_WALL_KEY = "xJmIYddp";

  /// 极光推送appKey
  static const String JPUSH_APPKEY = "b8b53a639c646141e54bf4df";

  ///
  static const String JPUSH_REGISTRATIONID = "b8b53a639c646141e54bf4df";

  /// 渠道名称--华为（应用市场审核使用）
  static const String CHANEL_HUAWEI = "huawei";

  /// 渠道名称--微信公众号内下载
  static const String CHANEL_WECHAT = "wechat";

  static SharedPreferences get prefs => _prefs; // 可选的主题列表

  static List<MaterialColor> get themes => _themes;

  static const Color taskHeadColor = Color(0xffCE0100);
  static const Color taskNomalHeadColor = Color(0xFFFAFAFA);
  static Color taskHeadDisableColor = Color(0xFFFFBB97);
  static Color taskBtnBgColor = Color(0xFFFFECDE);
  static Color taskBtnBgGreyColor = Color(0xFFEFEFEF);
  static Color taskBtnTxtColor = Color(0xFFD95E00);
  static Color taskBtnTxtGreyColor = Color(0xFF999999);

  /// 是否为release版
  static bool isRelease = true;

  /// 是否为绑定微信
  static bool isBindWechat = false;

  /// ios是否展示第三方登录信息
  static bool displayThirdLoginInformation = false;

  /// ios是否审核上架中
  static bool get iosCheck => prefs.containsKey("isIosUnderReview")
      ? prefs.getBool("isIosUnderReview")
      : false;

  /// 渠道类型 发版两个包
  /// 0 应用市场审核
  ///
  /// 1 微信公众号内下载
  static String get chanelType => getChanelType(chanelType: 0);

  /// [chanelType] 渠道类型
  ///
  /// 0 应用市场审核
  ///
  /// 1 微信公众号内下载
  ///
  /// 其他 默认-1
  ///
  static String getChanelType({int chanelType = -1}) {
    switch (chanelType) {
      case 0:
        return CHANEL_HUAWEI;
      case 1:
        return CHANEL_WECHAT;
    }
    return '';
  }

  ///
  ///
  /// 支付类型
  ///
  /// 0 开通vip
  ///
  /// 1 话费充值
  ///
  /// 2 商品支付
  ///
  /// 3 微股东升级支付
  ///
  /// 4 商家付款支付
  ///
  /// 5 油卡充值支付
  ///
  static int payType = 0;

  /// 是否为首次进入app
  static bool get isFirst =>
      prefs.containsKey("isFirst") ? prefs.getBool("isFirst") : true;

  /// 是否为首次进入app
  static bool get isAgreePrivacy => prefs.containsKey("isAgreePrivacy")
      ? prefs.getBool("isAgreePrivacy")
      : true;

  /// 是否华为正在审核中
  static bool get isHuaweiUnderReview =>
      prefs.getBool("isHuaweiUnderReview") && chanelType == CHANEL_HUAWEI;

  /// taskWallAddress
  static const TASKWALL_ADDRESS = 'https://c.buuyee.com/api/external';

  /// 代理的 ip 地址
  static const localProxyIPAddress = '192.168.0.3';

  /// 微信appid
  static const String WECHAT_APPID = 'wx824cc9f48da9315c';

  /// 代理端口
  static const localProxyPort = 8888;

//  是否登录
  static bool hasLogin;

  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    _requestPermission();
    _prefs = await SharedPreferences.getInstance();
    _count = 1;
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
    prefs.setBool("canRefreshToken", true);
    if (!_prefs.containsKey("isAgreePrivacy")) {
      prefs.setBool("isAgreePrivacy", false);
    }
    if (!_prefs.containsKey("isHuaweiUnderReview")) {
      prefs.setBool("isHuaweiUnderReview", false);
    }
    if (!_prefs.containsKey("searchList")) {
      prefs.setStringList("searchList", List<String>());
    }

    if (!isRelease) {
//      KTKJGlobalConfig.prefs.setString("uid", "123");
    }

    ///    初始化高德定位key
    ///设置Android和iOS的apiKey<br>
    ///key的申请请参考高德开放平台官网说明<br>
    ///Android: https://lbs.amap.com/api/android-location-sdk/guide/create-project/get-key
    ///iOS: https://lbs.amap.com/api/ios-location-sdk/guide/create-project/get-key
    /* AMapFlutterLocation.setApiKey(
        "b9350473f6c0c17719fc9c3f824ad942", "ebb51ce06c26c7cc7fe0802694b8280f");*/
    await AmapCore.init('ced91b12f28d94bb81b09900777784b7');
    await enableFluttifyLog(!isRelease);
    await AmapService.instance.init(
      iosKey: 'ced91b12f28d94bb81b09900777784b7',
      androidKey: 'b9350473f6c0c17719fc9c3f824ad942',
//      webApiKey: 'e69c6fddf6ccf8de917f5990deaa9aa2',
    );
//    await _initUserLocationWithPermission();
    _initFluwx();
    _initUmengAnalytics();
    HttpManage.init();
    _initJPushPlatformState();
    configLoading();
    await HttpManage.getHomeInfo();
    await HttpManage.getGoodsList(
        type: "new", page: 1, pageSize: 2, isNewcomer: true);
//    await HttpManage.getUserInfo();
//    await HttpManage.getSiteShopAgreement();
//    await HttpManage.getShopTypeList();
    //initAndroidDeviceId();

    Future.delayed(Duration(seconds: 3));
    // 如果没有缓存策略，设置默认缓存策略
    //初始化网络请求相关配置
  }

  static int _count = 1;

  static Future _initUserLocation() async {
    var location = await AmapLocation.instance
        .fetchLocation(needAddress: true, mode: LocationAccuracy.High);
    print("经度:${location.latLng.longitude}");
    print("维度:${location.latLng.latitude}");

    if (KTKJCommonUtils.isEmpty(location.city) &&
        _count < 3 &&
        location.latLng.longitude == 0) {
      initUserLocationWithPermission();
      _count++;
      print("count=$_count");
    } else {
      _prefs.setString("longitude", location.latLng.longitude.toString());
      _prefs.setString("latitude", location.latLng.latitude.toString());

      ///根据经纬度信息获取位置；
      ReGeocode reGeocode =
          await AmapSearch.instance.searchReGeocode(location.latLng);
      _prefs.setString("cityName", await reGeocode.cityName);
      /*print("reGeocode.provinceName=${reGeocode.provinceName}");
      print("reGeocode.cityName=${reGeocode.cityName}");
      print("reGeocode.districtName=${reGeocode.districtName}");
      print("reGeocode.formatAddress=${reGeocode.formatAddress}");*/
    }
    print("城市cityName:${_prefs.getString("cityName")}");
  }

  static Future initUserLocationWithPermission({count}) async {
    if (!KTKJCommonUtils.isEmpty(count)) {
      _count = count;
    }
    KTKJCommonUtils.requestPermission(Permission.location, _initUserLocation());
  }

//  存储是否登陆的状态
  static saveLoginStatus(hasLogin) {
    prefs.setBool("hasLogin", hasLogin);
  }

  /// 获取登陆成功后的数据
  static LoginData getLoginInfo() {
    final extractData =
        json.decode(prefs.getString("loginData")) as Map<String, dynamic>;
    var entity = LoginEntity();
    loginEntityFromJson(entity, extractData);
    return entity.data;
  }

  /// 获取店铺行业类型的数据
  static List<ShopTypeDataList> getShopTypeListData() {
    final extractData =
        json.decode(prefs.getString("shopTypeList")) as Map<String, dynamic>;
    var entity = ShopTypeEntity();
    shopTypeEntityFromJson(entity, extractData);
    return entity.data.xList;
  }

  /// 获取首页的数据
  static HomeData getHomeInfo() {
    final extractData =
        json.decode(prefs.getString("homeData")) as Map<String, dynamic>;
    var entity = HomeEntity();
    homeEntityFromJson(entity, extractData);
    return entity.data;
  }

  /// 获取首页新人专享的商品数据
  static List<HomeGoodsListGoodsList> getHomeNewcomersInfo() {
    final extractData = json.decode(prefs.getString("homeNewcomersData"))
        as Map<String, dynamic>;
    HomeGoodsListEntity entity = HomeGoodsListEntity();
    homeGoodsListEntityFromJson(entity, extractData);
    return entity.goodsList;
  }

  /// 获取关键词历史搜索列表
  static List<String> getSearchList() {
    var list = KTKJGlobalConfig.prefs.getStringList("searchList");
    return list == null ? List<String>() : list;
  }

  /// 保存关键词历史搜索列表
  static setSearchList({List<String> searchList}) {
    KTKJGlobalConfig.prefs.setStringList("searchList", searchList);
  }

  /// 获取用户信息
  static UserInfoData getUserInfo() {
    var entity = UserInfoEntity();
    try {
      userInfoEntityFromJson(entity,
          json.decode(prefs.getString("userInfo")) as Map<String, dynamic>);
    } catch (e) {
      print(e);
    }
    return entity.data;
  }

  /// 获取商家入驻协议地址
  static String getAgreementShopEntryRulesUrl() {
    return prefs.containsKey("agreementShopEntryRulesUrl")
        ? prefs.getString("agreementShopEntryRulesUrl")
        : ""; //prefs.getString("agreementShopEntryRulesUrl");
  }

  /// 存储极光推送设备id
  static setJpushRegistrationId(registrationId) {
    prefs.setString("register_id", registrationId.toString());
  }

  ///   获取极光推送设备id
  static String getJpushRegistrationId() {
    return prefs.getString("register_id");
  }

//  存储是否首次进入app的状态
  static saveIsFirst(isFirst) {
    prefs.setBool("isFirst", isFirst);
  }

  static bool isLogin() {
    /* bool hasLogin =任务大厅
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
        universalLink: "https://www.ktkj.shop/");
  }

  static _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
      Permission.storage,
      Permission.camera,
      Permission.location,
    ].request();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  static Future<void> _initJPushPlatformState() async {
    String platformVersion;
    String debugLable = 'Unknown';
    final JPush jpush = new JPush();
    try {
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotification: $message");
        debugLable = "flutter onReceiveNotification: $message";
      }, onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
        debugLable = "flutter onOpenNotification: $message";
      }, onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");
        debugLable = "flutter onReceiveMessage: $message";
      }, onReceiveNotificationAuthorization:
              (Map<String, dynamic> message) async {
        print("flutter onReceiveNotificationAuthorization: $message");
        debugLable = "flutter onReceiveNotificationAuthorization: $message";
      });
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    jpush.setup(
      appKey: KTKJGlobalConfig.JPUSH_APPKEY, //你自己应用的 AppKey
      channel: "theChannel",
      production: false,
      debug: true,
    );
    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: false));
    jpush.setBadge(0);
    // Platform messages may fail, so we use a try/catch PlatformException.
    jpush.getRegistrationID().then((rid) {
      print("flutter get registration id : $rid");
      debugLable = "flutter getRegistrationID: $rid";
      setJpushRegistrationId(rid);
      print(debugLable.toString());
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    debugLable = platformVersion;
    print(debugLable.toString());
  }

  static configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = false;
  }

//初始化友盟统计
  static _initUmengAnalytics() async {
    await UmengAnalyticsPlugin.init(
      androidKey: '5ff4055644bb94418a737f1b',
      iosKey: '5ff405ea44bb94418a737fa3',
      logEnabled: true,
      channel: chanelType,
//      encryptEnabled: true,
    );
    print("UmengAnalyticsPlugin.init");
    /*print("初始化友盟开始");
    await Umeng.init(
      androidKey: '5ff4055644bb94418a737f1b',//5ff4055644bb94418a737f1b
      iosKey: '5ff405ea44bb94418a737fa3',
      onlineParamEnabled: true,
      logEnabled: true,
      channel: "ktxx",
    );

    if (!Platform.isAndroid) {
      print("初始化友盟结束");
      return;
    }
    //安卓系统特殊处理
    String deviceId = await initAndroidDeviceId();
    //上次是否是登录操作
    bool lastSignIn = _prefs.getBool("last_is_sign_in");
    if (lastSignIn) {
      print("上次为登录操作，本次为注销操作");
      Umeng.onProfileSignOff();
      _prefs.setBool("last_is_sign_in", false);
    } else {
      print("上次为注销操作，本次为登录操作");
      Umeng.onProfileSignIn(deviceId);
      _prefs.setBool("last_is_sign_in", true);
    }
    print("初始化友盟结束");
    var platformVersion = await Umeng.platformVersion;
    print("platformVersion=$platformVersion");*/
    /* print("初始化友盟开始");
    try {
      LcfarmFlutterUmeng.init(
          iOSAppKey: "5ff405ea44bb94418a737fa3",
          androidAppKey: "5ff4055644bb94418a737f1b",
          channel: chanelType,
          logEnable: true);
    } catch (e) {
      print("初始化友盟失败");
    }
    print("初始化友盟结束");*/
  }

/* static Future<String> initAndroidDeviceId() async {
    print("初始化设备id");
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    print("初始化自定义设备结束，id 为：" + androidDeviceInfo.androidId);
    print("初始化自定义设备结束，board 为：" + androidDeviceInfo.board);
    print("初始化自定义设备结束，bootloader 为：" + androidDeviceInfo.bootloader);
    print("初始化自定义设备结束，brand 为：" + androidDeviceInfo.brand);
    print("初始化自定义设备结束，device 为：" + androidDeviceInfo.device);
    print("初始化自定义设备结束，fingerprint 为：" + androidDeviceInfo.fingerprint);
    print("初始化自定义设备结束，hardware 为：" + androidDeviceInfo.hardware);
    print("初始化自定义设备结束，id 为：" + androidDeviceInfo.id);
    print("初始化自定义设备结束，manufacturer 为：" + androidDeviceInfo.manufacturer);
    print("初始化自定义设备结束，model 为：" + androidDeviceInfo.model);
    print("初始化自定义设备结束，product 为：" + androidDeviceInfo.product);
    print("初始化自定义设备结束，tags 为：" + androidDeviceInfo.tags);
    print("初始化自定义设备结束，type 为：" + androidDeviceInfo.type);
    return androidDeviceInfo.androidId;
  }*/
}
