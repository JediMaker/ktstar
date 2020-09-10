import 'package:dio/dio.dart';
import 'package:star/http/http.dart';
import 'package:star/http/http_manage.dart';

/**
 * Token拦截器
 * Created by guoshuyu
 * on 2019/3/23.
 */
class TokenInterceptors extends InterceptorsWrapper {
  String _token;

  @override
  onRequest(RequestOptions options) async {
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
      if (response.statusCode == 203 || response.statusCode == 203.0) {}
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
  getAuthorization() async {
//    String token = await LocalStorage.get(Config.TOKEN_KEY);
    /* if (token == null) {
      String basic = await LocalStorage.get(Config.USER_BASIC_CODE);
      if (basic == null) {
        //提示输入账号密码
      } else {
        //通过 basic 去获取token，获取到设置，返回token
        return "Basic $basic";
      }
    } else {
      this._token = token;
      return token;
    }*/
  }
}
