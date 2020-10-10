import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:star/generated/json/alipay_payinfo_entity_helper.dart';
import 'package:star/generated/json/fans_list_entity_helper.dart';
import 'package:star/generated/json/fans_total_entity_helper.dart';
import 'package:star/generated/json/home_entity_helper.dart';
import 'package:star/generated/json/income_list_entity_helper.dart';
import 'package:star/generated/json/login_entity_helper.dart';
import 'package:star/generated/json/message_list_entity_helper.dart';
import 'package:star/generated/json/pay_coupon_entity_helper.dart';
import 'package:star/generated/json/phone_charge_list_entity_helper.dart';
import 'package:star/generated/json/poster_entity_helper.dart';
import 'package:star/generated/json/recharge_entity_helper.dart';
import 'package:star/generated/json/result_bean_entity_helper.dart';
import 'package:star/generated/json/task_detail_entity_helper.dart';
import 'package:star/generated/json/task_record_list_entity_helper.dart';
import 'package:star/generated/json/task_submit_info_entity_helper.dart';
import 'package:star/generated/json/user_info_entity_helper.dart';
import 'package:star/generated/json/version_info_entity_helper.dart';
import 'package:star/generated/json/vip_price_entity_helper.dart';
import 'package:star/generated/json/wechat_payinfo_entity_helper.dart';
import 'package:star/global_config.dart';
import 'package:star/http/api.dart';
import 'package:star/http/interceptors/error_interceptor.dart';
import 'package:star/http/interceptors/header_interceptor.dart';
import 'package:star/http/interceptors/log_interceptor.dart';
import 'package:star/http/interceptors/token_interceptor.dart';
import 'package:star/models/alipay_payinfo_entity.dart';
import 'package:star/models/fans_list_entity.dart';
import 'package:star/models/fans_total_entity.dart';
import 'package:star/models/home_entity.dart';
import 'package:star/models/income_list_entity.dart';
import 'package:star/models/message_list_entity.dart';
import 'package:star/models/pay_coupon_entity.dart';
import 'package:star/models/poster_entity.dart';
import 'package:star/models/recharge_entity.dart';
import 'package:star/models/task_detail_entity.dart';
import 'package:star/models/task_record_list_entity.dart';
import 'package:star/models/task_submit_info_entity.dart';
import 'package:star/models/user_info_entity.dart';
import 'package:star/models/wechat_payinfo_entity.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/utils.dart';
import 'interceptors/response_interceptor.dart';
import 'package:star/models/result_bean_entity.dart';
import 'package:star/models/login_entity.dart';
import 'package:star/models/vip_price_entity.dart';
import 'package:star/models/version_info_entity.dart';
import 'package:star/models/phone_charge_list_entity.dart';

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
      ..add(MapEntry(
          "sign", "${Utils.getSign(paramsMap)}")); //类型  1-注册 2-登录 3-绑定手机号码
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
  /// [review_code]邀请码
  ///
  /// 注册
  static Future<ResultBeanEntity> register(
      String phone, String smsCode, String password, String review_code) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["tel"] = "$phone";
    paramsMap["password"] = "$password";
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    paramsMap["code"] = "$smsCode";
    paramsMap["review_code"] = "$review_code";
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
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    paramsMap["code"] = "$smsCode";
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));

    print(HttpManage.dio.toString());
    var response = await HttpManage.dio.post(
      APi.RESET_PASSWORD,
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
    paramsMap["register_id"] = "${GlobalConfig.getJpushRegistrationId()}";
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();

    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.FAST_LOGIN,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = LoginEntity();
    loginEntityFromJson(entity, extractData);
    if (entity.status) {
      GlobalConfig.prefs.setString("loginData", response.data.toString());
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
  static Future<LoginEntity> login(String phone, String password) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["tel"] = "$phone";
    paramsMap["password"] = "$password";
    paramsMap["register_id"] = "${GlobalConfig.getJpushRegistrationId()}";
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();

    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.LOGIN,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = LoginEntity();
    loginEntityFromJson(entity, extractData);
    if (entity.status) {
      GlobalConfig.prefs.setString("loginData", response.data.toString());
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
  ///[code]微信授权获取到的code
  ///
  ///
  /// 第三方登录
  ///
  static Future<LoginEntity> wechatLogin(code) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["code"] = "$code";
    paramsMap["register_id"] = "${GlobalConfig.getJpushRegistrationId()}";
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();

    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.WECHAT_LOGIN,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = LoginEntity();
    loginEntityFromJson(entity, extractData);
    if (entity.status) {
      GlobalConfig.prefs.setString("loginData", response.data.toString());
    }
    GlobalConfig.saveLoginStatus(entity.status);
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
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();

    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.SITE_BIND_THIRD,
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
  static Future<UserInfoEntity> getUserInfo() async {
    Map paramsMap = Map<String, dynamic>();
//    paramsMap["uid"] = "${GlobalConfig.prefs.getString("uid")}";
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.get(
      APi.USER_INFO,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = UserInfoEntity();
    userInfoEntityFromJson(entity, extractData);
    if (entity.status) {
      GlobalConfig.prefs.setString("userInfo", response.data.toString());
      print("userInfo" + GlobalConfig.prefs.getString("userInfo"));
    }
    return entity;
  }


  ///
  /// 获取邀请海报
  ///
  static Future<PosterEntity> getInvitationPosters() async {
    var response = await HttpManage.dio.get(
      APi.USER_SHARE,
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
    var response = await HttpManage.dio.get(
      APi.SITE_HOME,
//      queryParameters: paramsMap,
    );
    //1. 读取json文件
//    String jsonString = await rootBundle.loadString("static/files/data.json");
    final extractData = json.decode(response.data) as Map<String, dynamic>;
//    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = HomeEntity();
    homeEntityFromJson(entity, extractData);
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
    var response = await HttpManage.dio.get(
      APi.SITE_RECHARGE,
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
    var response = await HttpManage.dio.get(
      APi.SITE_VIP_PRICE,
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
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.SITE_BIND_PHONE,
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
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.SITE_BIND_PHONE,
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
    var response = await HttpManage.dio.post(
      APi.SITE_VERSION,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = VersionInfoEntity();
    versionInfoEntityFromJson(entity, extractData);
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
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.SITE_EXPERIENCE_MEMBER_PHONE_ADD,
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
  ///[imgId]图片资源id
  ///
  /// 任务提交
  ///
  static Future<ResultBeanEntity> taskSubmit(taskId, imgId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["task_id"] = "$taskId";
    paramsMap["img_id"] = "$imgId";
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.TASK_SUBMIT_SAVE,
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
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.TASK_SUBMIT_INFO,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = TaskSubmitInfoEntity();
    taskSubmitInfoEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[page] 	页码
  ///[pageSize] 	单页数据量
  ///
  ///
  /// 获取粉丝列表
  ///
  static Future<FansListEntity> getFansList(page, pageSize, {type = ""}) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["page"] = "$page";
    paramsMap["page_size"] = "$pageSize";
    paramsMap["type"] = "$type";
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.USER_FANS_LIST,
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
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.USER_TOTAL_FANS,
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
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      !isWithdrawal ? APi.USER_PROFIT_LIST : APi.USER_WITHDRAWAL_LIST,
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
  /// 获取任务提交列表
  ///
  static Future<TaskRecordListEntity> getTaskRecordList(page, pageSize) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["page"] = "$page";
    paramsMap["page_size"] = "$pageSize";
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.USER_TASK_LIST,
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
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.USER_MSG_LIST,
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
  static Future<PhoneChargeListEntity> getPhoneChargesList(page, pageSize) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["page"] = "$page";
    paramsMap["page_size"] = "$pageSize";
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.USER_HF_LIST,
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
  ///
  ///
  /// 获取提现列表
  ///
  static Future<MessageListEntity> getWithdrawalList(page, pageSize) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["page"] = "$page";
    paramsMap["page_size"] = "$pageSize";
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.USER_MSG_LIST,
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
  /// 获取任务详情
  ///
  static Future<TaskDetailEntity> getTaskDetail(taskId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["task_id"] = "$taskId";
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.TASK_DETAIL,
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
  /// 任务领取
  ///
  static Future<TaskDetailEntity> taskReceive(taskId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["task_id"] = "$taskId";
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.TASK_RECEIVE,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = TaskDetailEntity();
    taskDetailEntityFromJson(entity, extractData);
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
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.PAY_CHECK_SUCCESS,
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
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.SITE_BIND_WECHAT_NO,
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
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.SITE_MODIFY_WECHAT_NO,
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
  /// 获取微信支付信息
  ///
  static Future<WechatPayinfoEntity> getWechatPayInfo() async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["payment"] = "2";
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.USER_UPGRADE_VIP,
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
  /// 获取支付宝支付信息
  ///
  static Future<AlipayPayinfoEntity> getAliPayInfo() async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["payment"] = "1";
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.USER_UPGRADE_VIP,
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
  /// 获取话费充值微信支付信息
  ///
  static Future<WechatPayinfoEntity> getRechargeWeChatPayInfo(
      tel, rechargeId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["payment"] = "2";
    paramsMap["tel"] = "$tel";
    paramsMap["recharge_id"] = "$rechargeId";
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.PAY_RECHARGE,
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
  /// 获取话费充值支付宝支付信息
  ///
  static Future<AlipayPayinfoEntity> getRechargeAliPayInfo(
      tel, rechargeId) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["payment"] = "1";
    paramsMap["tel"] = "$tel";
    paramsMap["recharge_id"] = "$rechargeId";
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.PAY_RECHARGE,
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
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.PAY_COUPON,
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
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.USER_WITHDRAWAL_APPLICATION,
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
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    var response = await HttpManage.dio.post(
      APi.SITE_UPLOAD_IMG,
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
    paramsMap["refertoken"] = "${GlobalConfig.getLoginInfo().refertoken}";
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields..add(MapEntry("sign", "${Utils.getSign(paramsMap)}"));
    var response = await HttpManage.dio.post(
      APi.REFRESH_TOKEN,
      data: formData,
    );
    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = LoginEntity();
    loginEntityFromJson(entity, extractData);
    if (entity.status) {
      GlobalConfig.prefs.setString("loginData", response.data.toString());
    }
    return entity;
  }
}
