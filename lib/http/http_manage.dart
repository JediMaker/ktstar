import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:star/generated/json/result_bean_entity_helper.dart';
import 'package:star/global_config.dart';
import 'package:star/http/api.dart';
import 'package:star/http/interceptors/error_interceptor.dart';
import 'package:star/http/interceptors/header_interceptor.dart';
import 'package:star/http/interceptors/log_interceptor.dart';
import 'package:star/http/interceptors/token_interceptor.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/utils.dart';
import 'interceptors/response_interceptor.dart';
import 'package:star/models/result_bean_entity.dart';

void getHttp() async {
  try {
    Response response = await HttpManage.dio.get("");
    print(response);
  } catch (e) {
    print(e);
  }
}

class HttpManage {
//  prefs.setString("token", tokenBean.data.accessToken);
  static Dio dio = new Dio(BaseOptions(
    baseUrl: APi.BASE_URL,
    connectTimeout: APi.CONNECT_TIMEOUT, //5s
    receiveTimeout: APi.RECEIVE_TIMEOUT, //3s
    headers: {
//      HttpHeaders.acceptHeader: "application/vnd.github.squirrel-girl-preview,"
//          "application/vnd.github.symmetra-preview+generated.json",
    },
  ));

  static void init() {
    // 添加缓存插件
    // 设置用户token（可能为null，代表未登录）
    if (GlobalConfig.prefs != null &&
        GlobalConfig.prefs.containsKey("tokenBean")) {
      final extractData = json.decode(GlobalConfig.prefs.getString("tokenBean"))
          as Map<String, dynamic>;
    }

//    dio.options.headers[HttpHeaders.authorizationHeader] = tokenBean.data;
    dio.interceptors.add(new HeaderInterceptors());

    dio.interceptors.add(new LogsInterceptors());

    dio.interceptors.add(new ErrorInterceptors(dio));

    dio.interceptors.add(new ResponseInterceptors());

    dio.interceptors.add(new TokenInterceptors());

    // 在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
    if (!GlobalConfig.isRelease) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.findProxy = (uri) {
          return 'PROXY ${GlobalConfig.localProxyIPAddress}:${GlobalConfig.localProxyPort}';
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
    var signature = Utils.generateMd5(phone.toString() +
        GlobalConfig.MISSION_WALL_CHANNEL +
        GlobalConfig.MISSION_WALL_KEY);
    var paramStr = "?phone=$phone&" +
        "channel=${GlobalConfig.MISSION_WALL_CHANNEL}&" +
        "time=${CommonUtils.currentTimeMillis()}&" +
        "signature=$signature";
    return GlobalConfig.TASKWALL_ADDRESS + paramStr;
  }

  ///
  /// [phone]     手机号
  ///
  /// [type]    类型 2快速登录 1注册 3 其他
  ///
  /// 发送验证码
  static Future<ResultBeanEntity> sendVerificationCode(
      String phone, String type) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["tel"] = "$phone";
    paramsMap["type"] = "$type";
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry("sign", "${Utils.getSign(paramsMap)}")); //类型 1注册、2修改密码 3登录
    var response = await HttpManage.dio.post(
      APi.SMS_SEND,
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
  /// 注册
  static Future<ResultBeanEntity> register(
      String phone, String smsCode, String password) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["tel"] = "$phone";
    paramsMap["password"] = "$password";
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    paramsMap["code"] = "$smsCode";
    paramsMap["username"] = "$phone";
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));

    print(HttpManage.dio.toString());
    var response = await HttpManage.dio.post(
      APi.REGISTER,
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
  static Future<ResultBeanEntity> quickLogin(
      String phone, String smsCode) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["tel"] = "$phone";
    paramsMap["code"] = "$smsCode";
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();

    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.FAST_LOGIN,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    if (entity.status) {
      GlobalConfig.prefs.setString("uid", entity.data["uid"].toString());
    }
    GlobalConfig.saveLoginStatus(entity.status);
    return entity;
  }

  ///[phone] 手机号
  ///
  ///[password]密码
  ///
  ///
  /// 账号密码登录
  ///
  static Future<ResultBeanEntity> login(String phone, String password) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["tel"] = "$phone";
    paramsMap["password"] = "$password";
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();

    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.FAST_LOGIN,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    if (entity.status) {
      GlobalConfig.prefs.setString("uid", entity.data["uid"].toString());
    }
    GlobalConfig.saveLoginStatus(entity.status);
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
    paramsMap["uid"] = "${GlobalConfig.prefs.getString("uid")}";
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();

    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.RESET_PASSWORD,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    if (entity.status) {
      GlobalConfig.prefs.setString("uid", entity.data["uid"].toString());
    }
    GlobalConfig.saveLoginStatus(entity.status);
    return entity;
  }

  ///
  ///
  ///
  /// 产生二维码
  ///
  static Future<ResultBeanEntity> generateQRCode(String password) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["id"] = "${GlobalConfig.prefs.getString("uid")}";
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();

    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.CREATE_QRCODE,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    if (entity.status) {
      GlobalConfig.prefs.setString("uid", entity.data["uid"].toString());
    }
    GlobalConfig.saveLoginStatus(entity.status);
    return entity;
  }

  ///
  /// 获取用户信息
  ///
  static Future<ResultBeanEntity> getUserInfo() async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["uid"] = "${GlobalConfig.prefs.getString("uid")}";
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.FAST_LOGIN,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = ResultBeanEntity();
    resultBeanEntityFromJson(entity, extractData);
    if (entity.status) {
      GlobalConfig.prefs.setString("uid", entity.data["uid"].toString());
    }
    GlobalConfig.saveLoginStatus(entity.status);
    return entity;
  }
}
