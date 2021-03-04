import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:star/generated/json/ktxx_address_info_entity_helper.dart';
import 'package:star/generated/json/ktxx_address_list_entity_helper.dart';
import 'package:star/generated/json/ktxx_alipay_payinfo_entity_helper.dart';
import 'package:star/generated/json/ktxx_category_bean_entity_helper.dart';
import 'package:star/generated/json/ktxx_fans_list_entity_helper.dart';
import 'package:star/generated/json/ktxx_fans_total_entity_helper.dart';
import 'package:star/generated/json/ktxx_goods_info_entity_helper.dart';
import 'package:star/generated/json/ktxx_goods_queue_entity_helper.dart';
import 'package:star/generated/json/ktxx_goods_queue_persional_entity_helper.dart';
import 'package:star/generated/json/ktxx_home_entity_helper.dart';
import 'package:star/generated/json/ktxx_home_pdd_category_entity_helper.dart';
import 'package:star/generated/json/ktxx_income_list_entity_helper.dart';
import 'package:star/generated/json/ktxx_login_entity_helper.dart';
import 'package:star/generated/json/ktxx_logistics_info_entity_helper.dart';
import 'package:star/generated/json/ktxx_message_list_entity_helper.dart';
import 'package:star/generated/json/ktxx_micro_shareholder_entity_helper.dart';
import 'package:star/generated/json/ktxx_order_detail_entity_helper.dart';
import 'package:star/generated/json/ktxx_order_list_entity_helper.dart';
import 'package:star/generated/json/ktxx_pay_coupon_entity_helper.dart';
import 'package:star/generated/json/ktxx_pdd_goods_info_entity_helper.dart';
import 'package:star/generated/json/ktxx_pdd_goods_list_entity_helper.dart';
import 'package:star/generated/json/ktxx_pdd_home_entity_helper.dart';
import 'package:star/generated/json/ktxx_phone_charge_list_entity_helper.dart';
import 'package:star/generated/json/ktxx_poster_entity_helper.dart';
import 'package:star/generated/json/ktxx_recharge_entity_helper.dart';
import 'package:star/generated/json/ktxx_region_data_entity_helper.dart';
import 'package:star/generated/json/ktxx_result_bean_entity_helper.dart';
import 'package:star/generated/json/ktxx_search_goods_list_entity_helper.dart';
import 'package:star/generated/json/ktxx_search_pdd_goods_list_entity_helper.dart';
import 'package:star/generated/json/ktxx_shareholder_income_list_entity_helper.dart';
import 'package:star/generated/json/ktxx_task_detail_entity_helper.dart';
import 'package:star/generated/json/ktxx_task_detail_other_entity_helper.dart';
import 'package:star/generated/json/ktxx_task_other_submit_info_entity_helper.dart';
import 'package:star/generated/json/ktxx_task_record_list_entity_helper.dart';
import 'package:star/generated/json/ktxx_task_share_entity_helper.dart';
import 'package:star/generated/json/ktxx_task_submit_info_entity_helper.dart';
import 'package:star/generated/json/ktxx_user_info_entity_helper.dart';
import 'package:star/generated/json/ktxx_version_info_entity_helper.dart';
import 'package:star/generated/json/ktxx_vip_price_entity_helper.dart';
import 'package:star/generated/json/ktxx_wechat_payinfo_entity_helper.dart';
import 'package:star/generated/json/ktxx_withdrawal_info_entity_helper.dart';
import 'package:star/generated/json/ktxx_withdrawal_user_info_entity_helper.dart';
import 'package:star/ktxx_global_config.dart';
import 'package:star/ktxxhttp/ktxx_api.dart';
import 'package:star/ktxxhttp/ktxxinterceptors/ktxx_error_interceptor.dart';
import 'package:star/ktxxhttp/ktxxinterceptors/ktxx_header_interceptor.dart';
import 'package:star/ktxxhttp/ktxxinterceptors/ktxx_log_interceptor.dart';
import 'package:star/ktxxhttp/ktxxinterceptors/ktxx_token_interceptor.dart';
import 'package:star/ktxxmodels/ktxx_address_info_entity.dart';
import 'package:star/ktxxmodels/ktxx_alipay_payinfo_entity.dart';
import 'package:star/ktxxmodels/ktxx_category_bean_entity.dart';
import 'package:star/ktxxmodels/ktxx_fans_list_entity.dart';
import 'package:star/ktxxmodels/ktxx_fans_total_entity.dart';
import 'package:star/ktxxmodels/ktxx_goods_info_entity.dart';
import 'package:star/ktxxmodels/ktxx_goods_queue_entity.dart';
import 'package:star/ktxxmodels/ktxx_goods_queue_persional_entity.dart';
import 'package:star/ktxxmodels/ktxx_home_entity.dart';
import 'package:star/ktxxmodels/ktxx_home_pdd_category_entity.dart';
import 'package:star/ktxxmodels/ktxx_income_list_entity.dart';
import 'package:star/ktxxmodels/ktxx_logistics_info_entity.dart';
import 'package:star/ktxxmodels/ktxx_message_list_entity.dart';
import 'package:star/ktxxmodels/ktxx_micro_shareholder_entity.dart';
import 'package:star/ktxxmodels/ktxx_order_detail_entity.dart';
import 'package:star/ktxxmodels/ktxx_order_list_entity.dart';
import 'package:star/ktxxmodels/ktxx_pay_coupon_entity.dart';
import 'package:star/ktxxmodels/ktxx_pdd_goods_info_entity.dart';
import 'package:star/ktxxmodels/ktxx_pdd_goods_list_entity.dart';
import 'package:star/ktxxmodels/ktxx_pdd_home_entity.dart';
import 'package:star/ktxxmodels/ktxx_poster_entity.dart';
import 'package:star/ktxxmodels/ktxx_recharge_entity.dart';
import 'package:star/ktxxmodels/ktxx_region_data_entity.dart';
import 'package:star/ktxxmodels/ktxx_search_goods_list_entity.dart';
import 'package:star/ktxxmodels/ktxx_search_pdd_goods_list_entity.dart';
import 'package:star/ktxxmodels/ktxx_shareholder_income_list_entity.dart';
import 'package:star/ktxxmodels/ktxx_task_detail_entity.dart';
import 'package:star/ktxxmodels/ktxx_task_detail_other_entity.dart';
import 'package:star/ktxxmodels/ktxx_task_other_submit_info_entity.dart';
import 'package:star/ktxxmodels/ktxx_task_record_list_entity.dart';
import 'package:star/ktxxmodels/ktxx_task_share_entity.dart';
import 'package:star/ktxxmodels/ktxx_task_submit_info_entity.dart';
import 'package:star/ktxxmodels/ktxx_user_info_entity.dart';
import 'package:star/ktxxmodels/ktxx_wechat_payinfo_entity.dart';
import 'package:star/ktxxmodels/ktxx_withdrawal_info_entity.dart';
import 'package:star/ktxxutils/ktxx_common_utils.dart';
import 'package:star/ktxxutils/ktxx_utils.dart';
import 'ktxxinterceptors/ktxx_response_interceptor.dart';
import 'package:star/ktxxmodels/ktxx_result_bean_entity.dart';
import 'package:star/ktxxmodels/ktxx_login_entity.dart';
import 'package:star/ktxxmodels/ktxx_vip_price_entity.dart';
import 'package:star/ktxxmodels/ktxx_version_info_entity.dart';
import 'package:star/ktxxmodels/ktxx_phone_charge_list_entity.dart';
import 'package:star/ktxxmodels/ktxx_address_list_entity.dart';
import 'package:star/ktxxmodels/ktxx_withdrawal_user_info_entity.dart';
import 'package:http_parser/http_parser.dart';

void getHttp() async {
  try {
    Response response = await KeTaoFeaturedHttpManage.dio.get("");
    print(response);
  } catch (e) {
    print(e);
  }
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedHttpManage {
//  prefs.setString("token", tokenBean.data.accessToken);
  static Dio dio = new Dio(BaseOptions(
    baseUrl: KeTaoFeaturedAPi.BASE_URL,
    connectTimeout: KeTaoFeaturedAPi.CONNECT_TIMEOUT, //5s
    receiveTimeout: KeTaoFeaturedAPi.RECEIVE_TIMEOUT, //3s
    headers: {
//      HttpHeaders.acceptHeader: "application/vnd.github.squirrel-girl-preview,"
//          "application/vnd.github.symmetra-preview+generated.json",
    },
  ));

  static void init() {
    // 添加缓存插件
    // 设置用户token（可能为null，代表未登录）
    if (KeTaoFeaturedGlobalConfig.prefs != null &&
        KeTaoFeaturedGlobalConfig.prefs.containsKey("tokenBean")) {
      final extractData =
          json.decode(KeTaoFeaturedGlobalConfig.prefs.getString("tokenBean"))
              as Map<String, dynamic>;
    }

//    dio.options.headers[HttpHeaders.authorizationHeader] = tokenBean.data;
    dio.interceptors.add(new KeTaoFeaturedHeaderInterceptors());

    dio.interceptors.add(new KeTaoFeaturedLogsInterceptors());

    dio.interceptors.add(new KeTaoFeaturedErrorInterceptors(dio));

    dio.interceptors.add(new KeTaoFeaturedResponseInterceptors());

    dio.interceptors.add(new KeTaoFeaturedTokenInterceptors());

    // 在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
    if (!KeTaoFeaturedGlobalConfig.isRelease) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.findProxy = (uri) {
          return 'PROXY ${KeTaoFeaturedGlobalConfig.localProxyIPAddress}:${KeTaoFeaturedGlobalConfig.localProxyPort}';
        };
        //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
    }
//    /api/index.php?route=oauth/oauth2/authorize
  }

  /// 获取任务墙入口
  static String getTheMissionWallEntranceUrl(String phone) {
    // 请求参数也可以通过对象传递：
    var signature = KeTaoFeaturedUtils.generateMd5(phone.toString() +
        KeTaoFeaturedGlobalConfig.MISSION_WALL_CHANNEL +
        KeTaoFeaturedGlobalConfig.MISSION_WALL_KEY);
    var paramStr = "?phone=$phone&" +
        "channel=${KeTaoFeaturedGlobalConfig.MISSION_WALL_CHANNEL}&" +
        "time=${KeTaoFeaturedCommonUtils.currentTimeMillis()}&" +
        "signature=$signature";
    return KeTaoFeaturedGlobalConfig.TASKWALL_ADDRESS + paramStr;
  }

  ///
  /// [phone]     手机号
  ///
  /// [type]    类型 1注册 2快速登录 3 其他，4设置密码
  ///
  /// 发送验证码
  static Future<ResultBeanEntity> sendVerificationCode(
      String phone, String type) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["tel"] = "$phone";
    paramsMap["type"] = "$type";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign",
          "${KeTaoFeaturedUtils.getSign(paramsMap)}")); //类型  1-注册 2-登录 3-绑定手机号码
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.SMS_SEND,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var httpResult = ResultBeanEntity();
    resultBeanEntityFromJson(httpResult, extractData);
    return httpResult;
  }

  ///
  /// [phone]     手机号
  ///
  ///
  ///
  /// 发送修改支付密码验证码
  static Future<ResultBeanEntity> sendPayPasswordModifyVerificationCode(
      String phone, String type) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["tel"] = "$phone";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign",
          "${KeTaoFeaturedUtils.getSign(paramsMap)}")); //类型  1-注册 2-登录 3-绑定手机号码
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.USER_SEND_SMS,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var httpResult = ResultBeanEntity();
    resultBeanEntityFromJson(httpResult, extractData);
    return httpResult;
  }

  ///
  ///[phone] 手机号
  ///
  ///[smsCode]验证码
  ///
  /// [password]密码
  ///
  /// [review_code]邀请码
  ///
  /// 注册
  static Future<ResultBeanEntity> register(
      String phone, String smsCode, String password, String review_code) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["tel"] = "$phone";
    paramsMap["password"] = "$password";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    paramsMap["code"] = "$smsCode";
    paramsMap["review_code"] = "$review_code";
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));

    print(KeTaoFeaturedHttpManage.dio.toString());
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.REGISTER,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[phone] 手机号
  ///
  ///[smsCode]验证码
  ///
  /// [password]密码
  ///
  ///
  /// 修改密码
  static Future<ResultBeanEntity> modifyPassword(
      String phone, String smsCode, String password) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["tel"] = "$phone";
    paramsMap["password"] = "$password";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    paramsMap["code"] = "$smsCode";
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));

    print(KeTaoFeaturedHttpManage.dio.toString());
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.RESET_PASSWORD,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[phone] 手机号
  ///
  ///[smsCode]验证码
  ///
  /// [password]密码
  ///
  ///
  /// 修改支付密码
  static Future<ResultBeanEntity> modifyPayPassword(
      String phone, String smsCode, String password) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["tel"] = "$phone";
    paramsMap["password"] = "$password";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    paramsMap["code"] = "$smsCode";
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));

    print(KeTaoFeaturedHttpManage.dio.toString());
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.USER_RESET_PAY_PASSWORD,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///[phone] 手机号
  ///
  ///[smsCode]验证码
  ///
  /// 快速登录
  ///
  /// 手机号验证码登录
  ///
  static Future<LoginEntity> quickLogin(String phone, String smsCode) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["tel"] = "$phone";
    paramsMap["code"] = "$smsCode";
    paramsMap["register_id"] =
        "${KeTaoFeaturedGlobalConfig.getJpushRegistrationId()}";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();

    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.FAST_LOGIN,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = LoginEntity();
    loginEntityFromJson(entity, extractData);
    if (entity.status) {
      KeTaoFeaturedGlobalConfig.prefs
          .setString("loginData", response.data.toString());
      KeTaoFeaturedGlobalConfig.saveLoginStatus(entity.status);
    }

    return entity;
  }

  ///[phone] 手机号
  ///
  ///[password]密码
  ///
  ///
  /// 账号密码登录
  ///
  static Future<LoginEntity> login(String phone, String password) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["tel"] = "$phone";
    paramsMap["password"] = "$password";
    paramsMap["register_id"] =
        "${KeTaoFeaturedGlobalConfig.getJpushRegistrationId()}";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();

    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.LOGIN,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = LoginEntity();
    loginEntityFromJson(entity, extractData);
    if (entity.status) {
      KeTaoFeaturedGlobalConfig.prefs
          .setString("loginData", response.data.toString());
      KeTaoFeaturedGlobalConfig.saveLoginStatus(entity.status);
    }

    return entity;
  }

  ///
  ///[password]密码
  ///
  ///
  /// 快速登陆密码修改
  ///
  static Future<ResultBeanEntity> changePassword(String password) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["password"] = "$password";
    paramsMap["uid"] = "${KeTaoFeaturedGlobalConfig.prefs.getString("uid")}";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();

    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.RESET_PASSWORD,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    if (entity.status) {
      KeTaoFeaturedGlobalConfig.prefs
          .setString("uid", entity.data["uid"].toString());
      KeTaoFeaturedGlobalConfig.saveLoginStatus(entity.status);
    }
    return entity;
  }

  ///
  ///[code]微信授权获取到的code
  ///
  ///
  /// 第三方登录
  ///
  static Future<LoginEntity> wechatLogin(code) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["code"] = "$code";
    paramsMap["register_id"] =
        "${KeTaoFeaturedGlobalConfig.getJpushRegistrationId()}";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();

    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.WECHAT_LOGIN,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = LoginEntity();
    loginEntityFromJson(entity, extractData);
    if (entity.status) {
      KeTaoFeaturedGlobalConfig.prefs
          .setString("loginData", response.data.toString());
      KeTaoFeaturedGlobalConfig.saveLoginStatus(entity.status);
    }
    return entity;
  }

  ///
  ///[code]微信授权获取到的code
  ///
  ///
  /// 绑定第三方
  ///
  static Future<ResultBeanEntity> bindWechat(code) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["code"] = "$code";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();

    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.SITE_BIND_THIRD,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///
  ///
  /// 产生二维码
  ///
  static Future<ResultBeanEntity> generateQRCode(String password) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["id"] = "${KeTaoFeaturedGlobalConfig.prefs.getString("uid")}";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();

    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.CREATE_QRCODE,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    if (entity.status) {
      KeTaoFeaturedGlobalConfig.prefs
          .setString("uid", entity.data["uid"].toString());
    }
    KeTaoFeaturedGlobalConfig.saveLoginStatus(entity.status);
    return entity;
  }

  ///
  /// 获取用户信息
  ///
  static Future<UserInfoEntity> getUserInfo() async {
    Map paramsMap = Map<String, dynamic>();
//    paramsMap["uid"] = "${GlobalConfig.prefs.getString("uid")}";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.get(
      KeTaoFeaturedAPi.USER_INFO,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = UserInfoEntity();
    userInfoEntityFromJson(entity, extractData);
    if (entity.status) {
      KeTaoFeaturedGlobalConfig.prefs
          .setString("userInfo", response.data.toString());
      print("userInfo" + KeTaoFeaturedGlobalConfig.prefs.getString("userInfo"));
    }
    return entity;
  }

  ///
  /// 获取邀请海报
  ///
  static Future<PosterEntity> getInvitationPosters() async {
    var response = await KeTaoFeaturedHttpManage.dio.get(
      KeTaoFeaturedAPi.USER_SHARE,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = PosterEntity();
    posterEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  /// 获取首页信息
  ///
  static Future<HomeEntity> getHomeInfo() async {
    Map paramsMap = Map<String, dynamic>();
//    paramsMap["token"] = "${GlobalConfig.getLoginInfo().token}";
//    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
//    FormData formData = FormData.fromMap(paramsMap);
//    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.get(
      KeTaoFeaturedAPi.SITE_HOME,
//      queryParameters: paramsMap,
    );
    //1. 读取json文件
//    String jsonString = await rootBundle.loadString("static/files/data.json");
    final extractData = json.decode(response.data) as Map<String, dynamic>;
//    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = HomeEntity();
    homeEntityFromJson(entity, extractData);
    if (entity.status) {
      KeTaoFeaturedGlobalConfig.prefs
          .setString("homeData", response.data.toString());
    }
    return entity;
  }

  ///
  /// 获取充值列表
  ///
  static Future<RechargeEntity> getRechargeList() async {
    Map paramsMap = Map<String, dynamic>();
//    paramsMap["token"] = "${GlobalConfig.getLoginInfo().token}";
//    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
//    FormData formData = FormData.fromMap(paramsMap);
//    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.get(
      KeTaoFeaturedAPi.SITE_RECHARGE,
//      queryParameters: paramsMap,
    );
    //1. 读取json文件
//    String jsonString = await rootBundle.loadString("static/files/data.json");
    final extractData = json.decode(response.data) as Map<String, dynamic>;
//    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = RechargeEntity();
    rechargeEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  /// 获取vip价格信息
  ///
  static Future<VipPriceEntity> getVipPrice() async {
    var response = await KeTaoFeaturedHttpManage.dio.get(
      KeTaoFeaturedAPi.SITE_VIP_PRICE,
    );
    //1. 读取json文件
//    String jsonString = await rootBundle.loadString("static/files/data.json");
    final extractData = json.decode(response.data) as Map<String, dynamic>;
//    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = VipPriceEntity();
    vipPriceEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[tel] 手机号
  ///
  ///[code]验证码
  ///
  /// 绑定手机号码
  ///
  static Future<ResultBeanEntity> bindPhone({tel, code = 12345}) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["tel"] = "$tel";
    paramsMap["code"] = "$code";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.SITE_BIND_PHONE,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[tel] 手机号
  ///
  ///[code]验证码
  ///
  /// 修改手机号码
  ///
  static Future<ResultBeanEntity> modifyPhone({tel, code = 12345}) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["tel"] = "$tel";
    paramsMap["code"] = "$code";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.SITE_BIND_PHONE,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  /// 获取应用版本信息
  ///
  static Future<VersionInfoEntity> getVersionInfo() async {
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.SITE_VERSION,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = VersionInfoEntity();
    versionInfoEntityFromJson(entity, extractData);
    if (entity.status) {
      switch (entity.data.wxLogin) {
        case "1": //不显示
          KeTaoFeaturedGlobalConfig.displayThirdLoginInformation = false;

          /* if (mounted) {
            setState(() {});
          }*/
          break;

        case "2": //显示
          KeTaoFeaturedGlobalConfig.displayThirdLoginInformation = true;
          /*  if (mounted) {
            setState(() {});
          }*/
          break;
      }
      if (entity.data.whCheck) {
        //华为应用市场上架审核中
        KeTaoFeaturedGlobalConfig.prefs.setBool("isHuaweiUnderReview", true);
      } else {
        KeTaoFeaturedGlobalConfig.prefs.setBool("isHuaweiUnderReview", false);
      }
      if (entity.data.iosCheck) {
        //appStore上架审核中
        KeTaoFeaturedGlobalConfig.prefs.setBool("isIosUnderReview", true);
      } else {
        KeTaoFeaturedGlobalConfig.prefs.setBool("isIosUnderReview", false);
      }
      /*if (!GlobalConfig.isAgreePrivacy && GlobalConfig.isHuaweiUnderReview) {
        Future.delayed(Duration(milliseconds: 300), () {
          showPrivacyDialog(context);
        });
      }*/
    }
    return entity;
  }

  ///
  ///[tel] 手机号
  ///
  ///[code]验证码
  ///
  /// 添加体验会员手机号码
  ///
  static Future<ResultBeanEntity> addExperienceMemberPhone(
      {tel, code = 12345}) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["tel"] = "$tel";
    paramsMap["code"] = "$code";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.SITE_EXPERIENCE_MEMBER_PHONE_ADD,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[taskId] 	任务id
  ///
  ///[imgId]图片资源id集合（多个之间逗号隔开）
  ///
  /// 任务提交
  ///
  static Future<ResultBeanEntity> taskSubmit(taskId, imgId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["task_id"] = "$taskId";
    paramsMap["img_id"] = "$imgId";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.TASK_SUBMIT_SAVE,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[comId] 	任务提交记录id
  ///
  ///[imgId]图片资源id集合（多个之间逗号隔开）
  ///
  /// 任务重新提交
  ///
  static Future<ResultBeanEntity> taskReSubmit(comId, imgId, {remark}) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["com_id"] = "$comId";
    paramsMap["img_id"] = "$imgId";
    paramsMap["remark"] = "$remark";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.TASK_SUBMIT_SAVE,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[taskId] 	任务id
  ///
  ///
  /// 获取任务提交信息
  ///
  static Future<TaskSubmitInfoEntity> getTaskSubmitInfo(taskId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["task_id"] = "$taskId";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.TASK_SUBMIT_INFO,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = TaskSubmitInfoEntity();
    taskSubmitInfoEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[taskId] 	任务id
  ///
  /// [comId] 	任务提交记录id
  ///
  /// 获取任务提交信息--其他任务类型
  ///
  static Future<TaskOtherSubmitInfoEntity> getTaskOtherSubmitInfo(
      taskId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["task_id"] = "$taskId";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.TASK_SUBMIT_INFO,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = TaskOtherSubmitInfoEntity();
    taskOtherSubmitInfoEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[taskId] 	任务id
  ///
  ///[comId] 	任务提交记录id
  ///
  /// 获取任务重新提交信息
  ///
  static Future<TaskSubmitInfoEntity> getTaskReSubmitInfo(taskId, comId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["task_id"] = "$taskId";
    paramsMap["com_id"] = "$comId";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.TASK_RESUBMIT_INFO,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = TaskSubmitInfoEntity();
    taskSubmitInfoEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[taskId] 	任务id
  ///
  ///
  /// [comId] 	任务提交记录id
  ///
  /// 获取任务重新提交信息--其他任务类型
  ///
  static Future<TaskOtherSubmitInfoEntity> getTaskOtherReSubmitInfo(
      taskId, comId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["task_id"] = "$taskId";
    paramsMap["com_id"] = "$comId";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.TASK_RESUBMIT_INFO,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = TaskOtherSubmitInfoEntity();
    taskOtherSubmitInfoEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[page] 	页码
  ///[pageSize] 	单页数据量
  ///
  ///holderType 微股东类型
  /// 获取粉丝列表
  ///
  static Future<FansListEntity> getFansList(page, pageSize,
      {type = "", holderType}) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["page"] = "$page";
    paramsMap["page_size"] = "$pageSize";
    paramsMap["type"] = "$type";
    paramsMap["holder_type"] = "$holderType";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.USER_FANS_LIST,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = FansListEntity();
    fansListEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///
  /// 获取粉丝数据汇总
  ///
  static Future<FansTotalEntity> getFansTotal() async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.USER_TOTAL_FANS,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = FansTotalEntity();
    fansTotalEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[page] 	页码
  ///
  ///[pageSize] 	单页数据量
  ///
  ///[isWithdrawal] 获取数据类型是否是提现列表
  ///
  /// fasle 获取收益列表 true 获取提现列表
  ///
  static Future<IncomeListEntity> getProfitList(page, pageSize,
      {isWithdrawal = false}) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["page"] = "$page";
    paramsMap["page_size"] = "$pageSize";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      !isWithdrawal
          ? KeTaoFeaturedAPi.USER_PROFIT_LIST
          : KeTaoFeaturedAPi.USER_WITHDRAWAL_LIST,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = IncomeListEntity();
    incomeListEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[page] 	页码
  ///
  ///[pageSize] 	单页数据量
  ///
  ///[profiType] 	7个人分红 8好友分红 9邀请好友收益
  ///
  ///
  /// fasle 获取微股东收益列表
  ///
  static Future<IncomeListEntity> getHolderProfitList(page, pageSize,
      {profiType = 7}) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["page"] = "$page";
    paramsMap["page_size"] = "$pageSize";
    paramsMap["profit_type"] = "$profiType";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.USER_PROFIT_LIST,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = IncomeListEntity();
    incomeListEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[page] 	页码
  ///[pageSize] 	单页数据量
  ///
  ///
  ///
  ///
  ///
  ///
  /// 获取任务提交列表
  ///
  static Future<TaskRecordListEntity> getTaskRecordList(page, pageSize) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["page"] = "$page";
    paramsMap["page_size"] = "$pageSize";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.USER_TASK_LIST,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = TaskRecordListEntity();
    taskRecordListEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[page] 	页码
  ///[pageSize] 	单页数据量
  ///
  ///
  /// 获取消息列表
  ///
  static Future<MessageListEntity> getMsgList(page, pageSize) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["page"] = "$page";
    paramsMap["page_size"] = "$pageSize";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.USER_MSG_LIST,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = MessageListEntity();
    messageListEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[page] 	页码
  ///[pageSize] 	单页数据量
  ///
  ///
  /// 获取话费充值列表
  ///
  static Future<PhoneChargeListEntity> getPhoneChargesList(
      page, pageSize) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["page"] = "$page";
    paramsMap["page_size"] = "$pageSize";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.USER_HF_LIST,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = PhoneChargeListEntity();

    phoneChargeListEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[page] 	页码
  ///[pageSize] 	单页数据量
  ///[orderSource] 	订单来源 1自营 ,2 拼多多
  ///
  ///
  /// 获取订单列表
  ///
  static Future<OrderListEntity> getOrderList(
      page, pageSize, orderSource) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["page"] = "$page";
    paramsMap["page_size"] = "$pageSize";
    paramsMap["order_source"] = "$orderSource";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.ORDER_LIST,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = OrderListEntity();

    orderListEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[page] 	页码
  ///[pageSize] 	单页数据量
  ///
  ///
  /// 获取提现列表
  ///
  static Future<MessageListEntity> getWithdrawalList(page, pageSize) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["page"] = "$page";
    paramsMap["page_size"] = "$pageSize";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.USER_MSG_LIST,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = MessageListEntity();
    messageListEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[taskId] 	任务id
  ///
  ///
  /// 获取任务详情--朋友圈任务
  ///
  static Future<TaskDetailEntity> getTaskDetail(taskId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["task_id"] = "$taskId";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.TASK_DETAIL,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = TaskDetailEntity();
    taskDetailEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[taskId] 	任务id
  ///
  ///
  /// 获取任务详情--非朋友圈任务
  ///
  static Future<TaskDetailOtherEntity> getTaskDetailOther(taskId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["task_id"] = "$taskId";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.TASK_DETAIL,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = TaskDetailOtherEntity();
    taskDetailOtherEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[taskId] 	任务id
  ///
  ///
  /// 获取任务详情--微信链接分享
  ///
  static Future<TaskShareEntity> getTaskDetailWechat(taskId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["task_id"] = "$taskId";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.TASK_DETAIL,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = TaskShareEntity();
    taskShareEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[taskId] 	任务id
  ///
  ///
  /// 任务领取--朋友圈任务
  ///
  static Future<TaskDetailEntity> taskReceive(taskId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["task_id"] = "$taskId";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.TASK_RECEIVE,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = TaskDetailEntity();
    taskDetailEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[taskId] 	任务id
  ///
  ///
  /// 任务领取--非朋友圈任务
  ///
  static Future<TaskDetailOtherEntity> taskReceiveOther(taskId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["task_id"] = "$taskId";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.TASK_RECEIVE,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = TaskDetailOtherEntity();
    taskDetailOtherEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[taskId] 	任务id
  ///
  ///
  /// 任务领取--微信链接分享
  ///
  static Future<TaskShareEntity> taskReceiveWechat(taskId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["task_id"] = "$taskId";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.TASK_RECEIVE,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = TaskShareEntity();
    taskShareEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[payNo] 	支付单号
  ///
  ///
  /// 检测支付是否成功
  ///
  static Future<ResultBeanEntity> checkPayResult(payNo) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["pay_no"] = "$payNo";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.PAY_CHECK_SUCCESS,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[weChatNo] 	微信号
  ///
  ///
  /// 绑定微信号
  ///
  static Future<ResultBeanEntity> bindWeChatNo(weChatNo) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["wx_no"] = "$weChatNo";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.SITE_BIND_WECHAT_NO,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[weChatNo] 	微信号
  ///
  ///
  /// 修改微信号
  ///
  static Future<ResultBeanEntity> modifyWeChatNo(weChatNo) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["wx_no"] = "$weChatNo";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.SITE_MODIFY_WECHAT_NO,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[payment] 	支付类型 1支付宝 2微信
  ///
  ///
  ///[pay_type] 	升级类型 1VIP，3钻石
  ///
  ///[term] 期限（对应获取VIP价格接口返回值money_list->type）
  ///
  /// 获取微信支付信息
  ///
  static Future<WechatPayinfoEntity> getWechatPayInfo({pay_type, term}) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["payment"] = "2";
    paramsMap["pay_type"] = "$pay_type";
    paramsMap["term"] = "$term";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.USER_UPGRADE_VIP,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = WechatPayinfoEntity();
    wechatPayinfoEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[payment] 	支付类型 1支付宝 2微信
  ///
  ///
  ///[pay_type] 	升级类型 1VIP，3钻石
  ///
  ///[term] 期限（对应获取VIP价格接口返回值money_list->type）
  ///
  /// 获取支付宝支付信息
  ///
  static Future<AlipayPayinfoEntity> getAliPayInfo({pay_type, term}) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["payment"] = "1";
    paramsMap["pay_type"] = "$pay_type";
    paramsMap["term"] = "$term";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.USER_UPGRADE_VIP,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = AlipayPayinfoEntity();
    alipayPayinfoEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[payment] 	支付类型 1支付宝 2微信
  ///
  ///
  ///[pay_type] 	升级类型 1VIP，3钻石
  ///
  ///[term] 期限（对应获取VIP价格接口返回值money_list->type）
  ///
  /// 获取微股东微信支付信息
  ///
  static Future<WechatPayinfoEntity> getMicroShareholdersWechatPayInfo(
      {pay_type, term}) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["payment"] = "2";
    paramsMap["pay_type"] = "$pay_type";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.PAY_UPGRADE_HOLDER,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = WechatPayinfoEntity();
    wechatPayinfoEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[payment] 	支付类型 1支付宝 2微信
  ///
  ///
  ///[pay_type] 	升级类型 1VIP，3钻石
  ///
  ///[term] 期限（对应获取VIP价格接口返回值money_list->type）
  ///
  /// 获取微股东支付宝支付信息
  ///
  static Future<AlipayPayinfoEntity> getMicroShareholdersAliPayInfo(
      {pay_type, term}) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["payment"] = "1";
    paramsMap["pay_type"] = "$pay_type";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.PAY_UPGRADE_HOLDER,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = AlipayPayinfoEntity();
    alipayPayinfoEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[tel] 	充值手机号码
  ///
  ///[rechargeId] 充值id
  ///
  ///[rechargeType] 0 快充 1 慢充
  ///
  /// 获取话费充值微信支付信息
  ///
  static Future<WechatPayinfoEntity> getRechargeWeChatPayInfo(
    tel,
    rechargeId,
    rechargeType,
  ) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["payment"] = "2";
    paramsMap["tel"] = "$tel";
    paramsMap["recharge_id"] = "$rechargeId";
    paramsMap["recharge_type"] = "${rechargeType == 0 ? "fast" : "slow"}";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.PAY_RECHARGE,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = WechatPayinfoEntity();
    wechatPayinfoEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[tel] 	充值手机号码
  ///
  ///[rechargeId] 充值id
  ///
  ///[rechargeType] 0 快充 1 慢充
  ///
  /// 获取话费充值支付宝支付信息
  ///
  static Future<AlipayPayinfoEntity> getRechargeAliPayInfo(
    tel,
    rechargeId,
    rechargeType,
  ) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["payment"] = "1";
    paramsMap["tel"] = "$tel";
    paramsMap["recharge_id"] = "$rechargeId";
    paramsMap["recharge_type"] = "${rechargeType == 0 ? "fast" : "slow"}";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.PAY_RECHARGE,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = AlipayPayinfoEntity();
    alipayPayinfoEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///
  ///[orderId] 订单id
  ///
  /// 获取商品购买微信支付信息
  ///
  static Future<WechatPayinfoEntity> getGoodsPayWeChatPayInfo({orderId}) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["payment"] = "2";
    paramsMap["order_id"] = "$orderId";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.PAY_GOODS,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = WechatPayinfoEntity();
    wechatPayinfoEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[orderId] 订单id
  ///
  /// 获取商品购买支付宝支付信息
  ///
  static Future<AlipayPayinfoEntity> getGoodsPayAliPayInfo({orderId}) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["payment"] = "1";
    paramsMap["order_id"] = "$orderId";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.PAY_GOODS,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = AlipayPayinfoEntity();
    alipayPayinfoEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[orderId] 订单id
  ///
  /// 获取商品购买余额支付信息
  ///
  static Future<AlipayPayinfoEntity> getGoodsPayBalanceInfo(
      {orderId, payPassword}) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["payment"] = "3";
    paramsMap["order_id"] = "$orderId";
    paramsMap["pay_pwd"] = "$payPassword";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.PAY_GOODS,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = AlipayPayinfoEntity();
    alipayPayinfoEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///  [payNo] 	支付单号
  ///
  ///
  /// 获取话费充值优惠券信息
  ///
  static Future<PayCouponEntity> getRechargeCoupon(payNo) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["pay_no"] = "$payNo";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.PAY_COUPON,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = PayCouponEntity();
    payCouponEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[type] 	提现类型 1支付宝 2微信
  ///
  ///[txPrice] 	提现金额
  ///
  ///[zfbName] 	支付宝姓名（type=1必填）
  ///
  ///[zfbAccount] 	支付宝账户（type=1必填）
  ///
  /// 提现申请
  ///
  static Future<ResultBeanEntity> withdrawalApplication(
    type,
    txPrice,
    zfbName,
    zfbAccount,
  ) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["type"] = "$type";
    paramsMap["tx_price"] = "$txPrice";
    paramsMap["zfb_name"] = "$zfbName";
    paramsMap["zfb_account"] = "$zfbAccount";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.USER_WITHDRAWAL_APPLICATION,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[image] 	图片文件
  ///
  ///
  /// 上传图片
  ///
  static Future<ResultBeanEntity> uploadImage(File image) async {
    String imageId;
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
    Map paramsMap = Map<String, dynamic>();
    var imageFile = await MultipartFile.fromFile(
      path,
      filename: name,
    );
    print("文件路径=" + path);
    print("文件名=" + name);
    print("文件类型=" + suffix);
    print("文件image=$imageFile");
    paramsMap["file"] = imageFile;
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.SITE_UPLOAD_IMG,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[image] 	图片文件
  ///
  ///
  /// 以字节数据上传图片
  ///
  static Future<ResultBeanEntity> uploadImageWithBytes(
      ByteData byteData) async {
    List<int> imageData = byteData.buffer.asUint8List();
    var name = 'ktxx_${KeTaoFeaturedCommonUtils.currentTimeMillis()}.jpg';
    MultipartFile imageFile = MultipartFile.fromBytes(
      imageData,
      // 文件名
      filename: name,
      contentType: MediaType("image", "jpg"),
    );
    Map paramsMap = Map<String, dynamic>();
//    print("文件路径=" + path);
//    print("文件名=" + name);
    print("文件image=$imageFile");
    paramsMap["file"] = imageFile;
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.SITE_UPLOAD_IMG,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  /// 刷新token
  ///
  static Future<LoginEntity> referToken(RequestOptions request) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["refertoken"] =
        "${KeTaoFeaturedGlobalConfig.getLoginInfo().refertoken}";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    KeTaoFeaturedGlobalConfig.prefs.setBool("canRefreshToken", false);
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.REFRESH_TOKEN,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = LoginEntity();
    loginEntityFromJson(entity, extractData);
    if (entity.status) {
      KeTaoFeaturedGlobalConfig.prefs.setString("token", entity.data.token);
      KeTaoFeaturedGlobalConfig.prefs
          .setString("loginData", response.data.toString());
      KeTaoFeaturedGlobalConfig.prefs.setBool("canRefreshToken", true);
    }
    return entity;
  }

  ///获取省市区区域数据
  static Future<RegionDataEntity> getAddressAreaList() async {
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.REGIONAL_ADDRESS_LIST,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;

    var entity = RegionDataEntity();
    regionDataEntityFromJson(entity, extractData);
    return entity;
  }

  ///获取收货地址列表
  static Future<AddressListEntity> getListOfAddresses() async {
    var response = await KeTaoFeaturedHttpManage.dio.get(
      KeTaoFeaturedAPi.USER_ADDRESS,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;

    var entity = AddressListEntity();
    addressListEntityFromJson(entity, extractData);
    return entity;
  }

  ///修改收货地址
  static Future<ResultBeanEntity> modifyShippingAddress(
      {String consignee,
      String mobile,
      province,
      provinceId,
      city,
      cityId,
      county,
      countyId,
      String address,
      String isDefault,
      addressId}) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["consignee"] = "$consignee";
    paramsMap["mobile"] = "$mobile";
    paramsMap["province_id"] = "$provinceId";
    paramsMap["city_id"] = "$cityId";
    paramsMap["county_id"] = "$countyId";
    paramsMap["address"] = "$address";
    paramsMap["is_default"] = "$isDefault";
    paramsMap["addr_id"] = "$addressId";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.USER_ADDRESS_EDIT,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///添加收货地址
  static Future<ResultBeanEntity> addShippingAddress(
      {String consignee,
      String mobile,
      province,
      provinceId,
      city,
      cityId,
      county,
      countyId,
      String address,
      String isDefault}) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["consignee"] = "$consignee";
    paramsMap["mobile"] = "$mobile";
    paramsMap["province_id"] = "$provinceId";
    paramsMap["city_id"] = "$cityId";
    paramsMap["county_id"] = "$countyId";
    paramsMap["address"] = "$address";
    paramsMap["is_default"] = "$isDefault";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.USER_ADDRESS_ADD,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///删除收货地址
  static Future<ResultBeanEntity> deleteShippingAddress(addressId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["addr_id"] = "$addressId";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.USER_ADDRESS_DELETE,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///收货地址详情
  static Future<AddressInfoEntity> getShippingAddressDetail(addressId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["addr_id"] = "$addressId";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.USER_ADDRESS_INFO,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = AddressInfoEntity();
    addressInfoEntityFromJson(entity, extractData);
    return entity;
  }

  ///订单提交
  static orderSubmission(String addressId, List<String> cartIdList) {}

  static orderCheckoutX(String orderId) {}

  ///获取订单详情
  static Future<OrderDetailEntity> orderDetail(orderId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["order_id"] = "$orderId";
    paramsMap["type"] = "all";
    paramsMap["user_flag"] = "1";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.ORDER_DETAIL,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = OrderDetailEntity();
    orderDetailEntityFromJson(entity, extractData);
    return entity;
  }

  ///订单确认收货
  static Future<ResultBeanEntity> orderConfirm(orderId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["order_id"] = "$orderId";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.ORDER_ENSURE_RECEIVE,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///提交订单
  static Future<ResultBeanEntity> orderSubmit(orderId, needDeduct) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["order_id"] = "$orderId";
    paramsMap["need_deduct"] = "$needDeduct";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.ORDER_SUBMIT,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///订单物流信息
  static Future<LogisticsInfoEntity> getOrderLogisticsInfo(orderId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["order_id"] = "$orderId";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.ORDER_LOGISTICS,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    LogisticsInfoEntity entity = LogisticsInfoEntity();
    logisticsInfoEntityFromJson(entity, extractData);
    return entity;
  }

  ///获取商品详情
  static Future<GoodsInfoEntity> getProductDetails(productId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["goods_id"] = "$productId";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.GOODS_INFO,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = GoodsInfoEntity();
    goodsInfoEntityFromJson(entity, extractData);
    return entity;
  }

  ///创建订单
  static Future<ResultBeanEntity> createOrder(String goodsId, goodsNum,
      {specId}) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["goods_id"] = "$goodsId";
    paramsMap["goods_num"] = "$goodsNum";
    paramsMap["spec_id"] = "$specId";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.ORDER_CREATE,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///订单切换收货地址
  static Future<ResultBeanEntity> orderChangeBindAddress(
      String orderId, addressId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["order_id"] = "$orderId";
    paramsMap["addr_id"] = "$addressId";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.ORDER_CHANGE_ADDR,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///商品排队列表
  static Future<GoodsQueueEntity> getGoodsQueueList(String goodsId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["goods_id"] = "$goodsId";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.QUEUE_GOODS,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = GoodsQueueEntity();
    goodsQueueEntityFromJson(entity, extractData);
    return entity;
  }

  ///个人所有商品排队列表
  static Future<GoodsQueuePersionalEntity> getGoodsQueuePersonalList() async {
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.QUEUE_MY,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = GoodsQueuePersionalEntity();
    goodsQueuePersionalEntityFromJson(entity, extractData);
    return entity;
  }

  ///订单参与排队
  ///
  ///[joinStatus]  是否参与排队 1参与 2不参与
  ///
  ///
  ///
  ///
  static Future<ResultBeanEntity> orderIsJoinQueue(
      String orderId, String joinStatus) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["order_id"] = "$orderId";
    paramsMap["bx_status"] = "$joinStatus";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.ORDER_QUEUE,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///获取提现用户信息
  ///
  static Future<WithdrawalUserInfoEntity> getWithdrawalUserInfo() async {
    var response = await KeTaoFeaturedHttpManage.dio.get(
      KeTaoFeaturedAPi.USER_TX_USER,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = WithdrawalUserInfoEntity();
    withdrawalUserInfoEntityFromJson(entity, extractData);
    return entity;
  }

  ///获取用户提现信息
  ///
  static Future<WithdrawalInfoEntity> getWithdrawalInfo() async {
    var response = await KeTaoFeaturedHttpManage.dio.get(
      KeTaoFeaturedAPi.USER_TX_SUCCESS,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = WithdrawalInfoEntity();
    withdrawalInfoEntityFromJson(entity, extractData);
    return entity;
  }

  static Future<ResultBeanEntity> setPayPassword(String currentPassword) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["password"] = "$currentPassword";
    paramsMap["re_password"] = "$currentPassword";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.USER_SET_PAY_PASSWORD,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///修改余额支付密码
  static Future<ResultBeanEntity> checkPayPassword(
      String currentPassword) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["password"] = "$currentPassword";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.USER_CHECK_PASSWORD,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

//
  ///获取商品列表
  static Future<ResultBeanEntity> getGoodsList({cId = '', type}) async {
    Map paramsMap = Map<String, dynamic>();
//    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    paramsMap['cid'] = "$cId";
    paramsMap['type'] = "$type";
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.get(
      KeTaoFeaturedAPi.GOODS_LIST,
      queryParameters: paramsMap,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///  商品分类列表
  static Future<List<CategoryBeanData>> getCategoryList(category_id) async {
    var formData = FormData();
    formData.fields..add(MapEntry("parent_category_id", "$category_id "));

    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.CATEGORY,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    print(response.data.toString());
    CategoryBeanEntity dataBean = CategoryBeanEntity();
    categoryBeanEntityFromJson(dataBean, extractData);
    return dataBean.data;
  }

  //
  ///申请成为微股东
  static Future<ResultBeanEntity> applyToBecomeAMicroShareholder() async {
    Map paramsMap = Map<String, dynamic>();
//    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    paramsMap['cid'] = "";
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.get(
      KeTaoFeaturedAPi.USER_PARTNER,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  /// 获取拼多多首页数据
  ///
  static Future<PddHomeEntity> getPddHomeData() async {
    var response = await KeTaoFeaturedHttpManage.dio.get(
      KeTaoFeaturedAPi.GOODS_PDD_HOME,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = PddHomeEntity();
    pddHomeEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  /// 获取搜索热词
  ///
  static Future<ResultBeanEntity> getHotSearchWords() async {
    var response = await KeTaoFeaturedHttpManage.dio.get(
      KeTaoFeaturedAPi.GOODS_HOT_WORDS,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  /// 获取拼多多授权
  ///
  static Future<ResultBeanEntity> getPddAuthorization() async {
    var response = await KeTaoFeaturedHttpManage.dio.get(
      KeTaoFeaturedAPi.GOODS_PIN_AUTH,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  /// 获取首页拼多多商品分类
  ///
  ///
  static Future<HomePddCategoryEntity> getHomePagePddProductCategory() async {
    var response = await KeTaoFeaturedHttpManage.dio.get(
      KeTaoFeaturedAPi.SIT_CATS,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = HomePddCategoryEntity();
    homePddCategoryEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[page] 	页码
  ///[pageSize] 	单页数据量
  ///[searchType] 	搜索类型 1自营平台 2拼多多
  ///[categoryId] 	分类Id
  ///[type] 	分类Id
  ///
  ///
  /// 获取商品搜索自营商品列表
  ///
  static Future<SearchGoodsListEntity> getSearchedGoodsList(
    page, {
    pageSize = 20,
    keyword,
  }) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["page"] = "$page";
    paramsMap["page_size"] = "$pageSize";
    paramsMap["search_type"] = "1";
    paramsMap["keyword"] = "$keyword";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.get(
      KeTaoFeaturedAPi.GOODS_SEARCH,
      queryParameters: paramsMap,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = SearchGoodsListEntity();
    searchGoodsListEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[page] 	页码
  ///[pageSize] 	单页数据量
  ///[searchType] 	搜索类型 1自营平台 2拼多多
  ///[categoryId] 	分类Id
  ///[type] 	分类Id
  ///
  ///
  /// 获取商品搜索拼多多商品列表
  ///
  static Future<SearchPddGoodsListEntity> getSearchedPddGoodsList(
    page, {
    pageSize = 20,
    keyword,
  }) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["page"] = "$page";
    paramsMap["page_size"] = "$pageSize";
    paramsMap["search_type"] = "2";
    paramsMap["keyword"] = "$keyword";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.get(
      KeTaoFeaturedAPi.GOODS_SEARCH,
      queryParameters: paramsMap,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = SearchPddGoodsListEntity();
    searchPddGoodsListEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[page] 	页码
  ///[pageSize] 	单页数据量
  ///[listId] 	翻页时填写前页返回的list_id值
  ///[categoryId] 	分类Id
  ///[type] 	分类Id
  ///
  ///
  /// 获取拼多多商品列表
  ///
  static Future<PddGoodsListEntity> getPddGoodsList(page,
      {pageSize, listId = "", categoryId, type}) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["page"] = "$page";
//    paramsMap["page_size"] = "$pageSize";
    paramsMap["list_id"] = "$listId";
    paramsMap["cat_id"] = "$categoryId";
    paramsMap["type"] = "$type";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.GOODS_PDD_GOODS_LIST,
      queryParameters: paramsMap,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = PddGoodsListEntity();
    pddGoodsListEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[gId] 	页码
  ///[goodsSign] 	单页数据量
  ///[searchId] 	翻页时填写前页返回的list_id值
  ///
  ///
  /// 获取拼多多商品详情
  ///
  static Future<PddGoodsInfoEntity> getPddGoodsInfo(
      {gId, goodsSign, searchId = ""}) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["g_id"] = "$gId";
    paramsMap["goods_sign"] = "$goodsSign";
    paramsMap["search_id"] = "$searchId";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.get(
      KeTaoFeaturedAPi.GOODS_PDD_GOODS_Detail,
      queryParameters: paramsMap,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = PddGoodsInfoEntity();
    pddGoodsInfoEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///
  /// 获取微股东权益详情
  ///
  static Future<MicroShareholderEntity> getMicroShareHolderInfo() async {
    Map paramsMap = Map<String, dynamic>();
    var response = await KeTaoFeaturedHttpManage.dio.get(
      KeTaoFeaturedAPi.USER_HOLDER_EXPLAIN,
      queryParameters: paramsMap,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = MicroShareholderEntity();
    microShareholderEntityFromJson(entity, extractData);
    return entity;
  }

  ///[page] 	页码
  ///
  ///[pageSize] 	单页数据量
  ///
  /// 获取微股东分红金明细
  ///
  static Future<IncomeListEntity> getMicroShareHolderCoinList(
    page,
    pageSize,
  ) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["page"] = "$page";
    paramsMap["page_size"] = "$pageSize";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${KeTaoFeaturedUtils.getSign(paramsMap)}"));
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.USER_HOLDER_COIN,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = IncomeListEntity();
    incomeListEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  /// 获取拼多多是否授权
  ///
  static Future<ResultBeanEntity> getPddAuth() async {
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.GOODS_IS_PIN_AUTH,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///
  ///话费充值---申请退款
  static Future<ResultBeanEntity> chargeRefund(orderId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["order_id"] = "$orderId";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.ORDER_HF_REFUND,
      data: paramsMap,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///
  ///话费充值---重新充值
  static Future<ResultBeanEntity> chargeRetry(orderId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["order_id"] = "$orderId";
    paramsMap['timestamp'] = KeTaoFeaturedCommonUtils.currentTimeMillis();
    var response = await KeTaoFeaturedHttpManage.dio.post(
      KeTaoFeaturedAPi.ORDER_HF_REPAY,
      data: paramsMap,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    return entity;
  }
}
