import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:star/generated/json/alipay_payinfo_entity_helper.dart';
import 'package:star/generated/json/home_entity_helper.dart';
import 'package:star/generated/json/login_entity_helper.dart';
import 'package:star/generated/json/result_bean_entity_helper.dart';
import 'package:star/generated/json/task_detail_entity_helper.dart';
import 'package:star/generated/json/task_submit_info_entity_helper.dart';
import 'package:star/generated/json/user_info_entity_helper.dart';
import 'package:star/generated/json/vip_price_entity_helper.dart';
import 'package:star/generated/json/wechat_payinfo_entity_helper.dart';
import 'package:star/global_config.dart';
import 'package:star/http/api.dart';
import 'package:star/http/interceptors/error_interceptor.dart';
import 'package:star/http/interceptors/header_interceptor.dart';
import 'package:star/http/interceptors/log_interceptor.dart';
import 'package:star/http/interceptors/token_interceptor.dart';
import 'package:star/models/alipay_payinfo_entity.dart';
import 'package:star/models/home_entity.dart';
import 'package:star/models/task_detail_entity.dart';
import 'package:star/models/task_submit_info_entity.dart';
import 'package:star/models/user_info_entity.dart';
import 'package:star/models/wechat_payinfo_entity.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/utils.dart';
import 'interceptors/response_interceptor.dart';
import 'package:star/models/result_bean_entity.dart';
import 'package:star/models/login_entity.dart';
import 'package:star/models/vip_price_entity.dart';

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
    // ??????????????????
    // ????????????token????????????null?????????????????????
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

    // ???????????????????????????????????????????????????????????????????????????HTTPS????????????
    if (!GlobalConfig.isRelease) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.findProxy = (uri) {
          return 'PROXY ${GlobalConfig.localProxyIPAddress}:${GlobalConfig.localProxyPort}';
        };
        //???????????????????????????????????????????????????????????????????????????????????????????????????????????????
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
    }
//    /api/index.php?route=oauth/oauth2/authorize
  }

  /// ?????????????????????
  static String getTheMissionWallEntranceUrl(String phone) {
    // ??????????????????????????????????????????
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
  /// [phone]     ?????????
  ///
  /// [type]    ?????? 2???????????? 1?????? 3 ??????
  ///
  /// ???????????????
  static Future<ResultBeanEntity> sendVerificationCode(
      String phone, String type) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["tel"] = "$phone";
    paramsMap["type"] = "$type";
    paramsMap['timestamp'] = CommonUtils.currentTimeMillis();
    FormData formData = FormData.fromMap(paramsMap);
    formData.fields
      ..add(MapEntry(
          "sign", "${Utils.getSign(paramsMap)}")); //??????  1-?????? 2-?????? 3-??????????????????
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
  ///[phone] ?????????
  ///
  ///[smsCode]?????????
  ///
  /// [password]??????
  ///
  /// [review_code]?????????
  ///
  /// ??????
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

  ///[phone] ?????????
  ///
  ///[smsCode]?????????
  ///
  /// ????????????
  ///
  /// ????????????????????????
  ///
  static Future<LoginEntity> quickLogin(String phone, String smsCode) async {
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
    var entity = LoginEntity();
    loginEntityFromJson(entity, extractData);
    if (entity.status) {
      GlobalConfig.prefs.setString("loginData", response.data.toString());
    }
    GlobalConfig.saveLoginStatus(entity.status);
    return entity;
  }

  ///[phone] ?????????
  ///
  ///[password]??????
  ///
  ///
  /// ??????????????????
  ///
  static Future<LoginEntity> login(String phone, String password) async {
    Map paramsMap = Map<String, dynamic>();
    paramsMap["tel"] = "$phone";
    paramsMap["password"] = "$password";
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
  ///[password]??????
  ///
  ///
  /// ????????????????????????
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
  ///[code]????????????????????????code
  ///
  ///
  /// ???????????????
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
  ///[code]????????????????????????code
  ///
  ///
  /// ???????????????
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
  /// ???????????????
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
  /// ??????????????????
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
  /// ??????????????????
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
    //1. ??????json??????
//    String jsonString = await rootBundle.loadString("static/files/data.json");
    final extractData = json.decode(response.data) as Map<String, dynamic>;
//    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = HomeEntity();
    homeEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  /// ??????vip????????????
  ///
  static Future<VipPriceEntity> getVipPrice() async {
    var response = await HttpManage.dio.get(
      APi.SITE_VIP_PRICE,
    );
    //1. ??????json??????
//    String jsonString = await rootBundle.loadString("static/files/data.json");
    final extractData = json.decode(response.data) as Map<String, dynamic>;
//    final extractData = json.decode(response.data) as Map<String, dynamic>;
    var entity = VipPriceEntity();
    vipPriceEntityFromJson(entity, extractData);
    return entity;
  }

  ///
  ///[tel] ?????????
  ///
  ///[code]?????????
  ///
  /// ??????????????????
  ///
  static Future<ResultBeanEntity> bindPhone({tel,code=12345}) async {
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
  ///[taskId] 	??????id
  ///
  ///[imgId]????????????id
  ///
  /// ????????????
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
  ///[taskId] 	??????id
  ///
  ///
  /// ????????????????????????
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
  ///[taskId] 	??????id
  ///
  ///
  /// ??????????????????
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
  ///[taskId] 	??????id
  ///
  ///
  /// ????????????
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
  ///[payNo] 	????????????
  ///
  ///
  /// ????????????????????????
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
  ///[payment] 	???????????? 1????????? 2??????
  ///
  ///
  /// ????????????????????????
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
  ///[payment] 	???????????? 1????????? 2??????
  ///
  ///
  /// ???????????????????????????
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
  ///[type] 	???????????? 1????????? 2??????
  ///
  ///[txPrice] 	????????????
  ///
  ///[zfbName] 	??????????????????type=1?????????
  ///
  ///[zfbAccount] 	??????????????????type=1?????????
  ///
  /// ????????????
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
  ///[image] 	????????????
  ///
  ///
  /// ????????????
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
    print("????????????=" + path);
    print("?????????=" + name);
    print("????????????=" + suffix);
    print("??????image=$imageFile");
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
  /// ??????token
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
