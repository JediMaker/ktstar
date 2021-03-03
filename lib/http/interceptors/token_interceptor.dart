import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:star/bus/my_event_bus.dart';
import 'package:star/generated/json/result_bean_entity_helper.dart';
import 'package:star/global_config.dart';
import 'package:star/http/http.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/result_bean_entity.dart';
import 'package:star/pages/login/login.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';

/**
 * Token拦截器
 * Created by guoshuyu
 * on 2019/3/23.
 */
class TokenInterceptors extends InterceptorsWrapper {
  String _token;

  @override
  onRequest(RequestOptions options) async {
    try {
      /// 获取当前版本
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      if (Platform.isAndroid) {
        options.headers["version"] = packageInfo.version;
      }
      if (Platform.isIOS) {
        options.headers["version"] = packageInfo.buildNumber;
      }
      options.headers["token"] = GlobalConfig.getLoginInfo().token;
    } catch (e) {
      print(e);
    }
    //task_submission
    /*   //授权码
    if (_token == null) {
      var authorizationCode = await getAuthorization();
      if (authorizationCode != null) {
        _token = authorizationCode;
//        initClient(_token);
      }
    }
    options.headers["Authorization"] = _token;*/
//    HttpManage.dio.request(path);
    return options;
  }

  @override
  onResponse(Response response) async {
    try {
      var request = response.request;
      final extractData = json.decode(response.data) as Map<String, dynamic>;
      var entity = ResultBeanEntity();
      resultBeanEntityFromJson(entity, extractData);
      if (entity.errCode.toString() == "308") {
        response = await getAuthorization(request);
        if (!CommonUtils.isEmpty(response)) {
          return response;
        }
      }
      if (entity.errCode.toString() == "303" ||
          entity.errCode.toString() == "306") {
        CommonUtils.showToast("未获取到登录信息，，请登录！");
        Future.delayed(Duration(seconds: 1)).then((onValue) async {
          var context = GlobalConfig.navigatorKey.currentState.overlay.context;
          await NavigatorUtils.navigatorRouter(context, LoginPage());
          bus.emit("changBottomBar");
          return;
        });
      }
      if (entity.errCode.toString() == "304") {
        if (GlobalConfig.isLogin()) {
          GlobalConfig.prefs.remove("hasLogin");
          GlobalConfig.prefs.remove("token");
          GlobalConfig.prefs.remove("loginData");
          GlobalConfig.saveLoginStatus(false);
          CommonUtils.showToast("登陆状态已过期，请重新登录！");
          Future.delayed(Duration(seconds: 1)).then((onValue) async {
            var context =
                GlobalConfig.navigatorKey.currentState.overlay.context;
            await NavigatorUtils.navigatorRouter(context, LoginPage());
            bus.emit("changBottomBar");
            return;
          });
        } else {
          CommonUtils.showToast("未获取到登录信息，，请登录！");
          Future.delayed(Duration(seconds: 1)).then((onValue) async {
            var context =
                GlobalConfig.navigatorKey.currentState.overlay.context;
            await NavigatorUtils.navigatorRouter(context, LoginPage());
            bus.emit("changBottomBar");
            return;
          });
        }
        /*Future.delayed(Duration(seconds: 0)).then((onValue) {
          var context = GlobalConfig.navigatorKey.currentState.overlay.context;
          showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text('提示'),
                  content: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('您的账号已在其他设备上登录')),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text(
                        '关闭',
                        style: TextStyle(color: Color(0xff222222)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text(
                        '登录',
                        style: TextStyle(color: GlobalConfig.colorPrimary),
                      ),
                      onPressed: () {
                        GlobalConfig.prefs.remove("hasLogin");
                        GlobalConfig.saveLoginStatus(false);
                        NavigatorUtils.navigatorRouterAndRemoveUntil(
                            context, LoginPage());
                      },
                    ),
                  ],
                );
              });
        });*/
      }
    } catch (e) {}
    return response;
  }

  ///清除授权
  clearAuthorization() {
    this._token = null;

//    LocalStorage.remove(Config.TOKEN_KEY);
//    releaseClient();
  }

  ///获取授权token
  Future<Response> getAuthorization(request) async {
    Response response;
    if (GlobalConfig.prefs.getBool("canRefreshToken")) {
      var result = await HttpManage.referToken(request);
      if (!CommonUtils.isEmpty(result.data)) {
        if (result.status) {
          request.headers["token"] = GlobalConfig.getLoginInfo().token;
          try {
            if (request.data is FormData) {
              // https://github.com/flutterchina/dio/issues/482
              FormData formData = FormData();
              formData.fields.addAll(request.data.fields);
              for (MapEntry mapFile in request.data.files) {
                formData.files.add(MapEntry(
                    mapFile.key,
                    MultipartFile.fromFileSync(mapFile.value.FILE_PATH,
                        filename: mapFile.value.filename)));
              }
              request.data = formData;
            }
            response = await Dio().request(request.path,
                data: request.data,
                queryParameters: request.queryParameters,
                cancelToken: request.cancelToken,
                options: request,
                onReceiveProgress: request.onReceiveProgress);
            bus.emit("refreshHomeData");
          } catch (e) {}
        } else {
          getAuthorization(request);
        }
      }
    }
    return response;
  }
}
