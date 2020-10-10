import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/generated/json/result_bean_entity_helper.dart';
import 'package:star/global_config.dart';
import 'package:star/http/http.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/result_bean_entity.dart';
import 'package:star/pages/login/login.dart';
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
      }
      if (entity.errCode.toString() == "303") {
        Fluttertoast.showToast(
            msg: "登陆过期，请重新登录！",
            textColor: Colors.white,
            backgroundColor: Colors.grey);
      }
      if (entity.errCode.toString() == "304") {
        /*Fluttertoast.showToast(
            msg: "您的账号已在其他设备上登录！",
            textColor: Colors.white,
            backgroundColor: Colors.grey);*/

        Future.delayed(Duration(seconds: 0)).then((onValue) {
          var context = GlobalConfig.navigatorKey.currentState.overlay.context;
          showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text('提示'),
                  content: Text('您的账号已在其他设备上登录'),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text('关闭'),
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
        });
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
    var result = await HttpManage.referToken(request);
    print("getAuthorization" + result.data.toString());
    if (result.status) {
      request.headers["token"] = GlobalConfig.getLoginInfo().token;
      response = await Dio().request(request.path,
          data: request.data,
          queryParameters: request.queryParameters,
          cancelToken: request.cancelToken,
          options: request,
          onReceiveProgress: request.onReceiveProgress);
      print("getAuthorizationBeforeresponse" + response.data.toString());
    } else {
      getAuthorization(request);
    }
    return response;
  }
}
