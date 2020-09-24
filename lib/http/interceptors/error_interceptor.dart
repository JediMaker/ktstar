import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

///是否需要弹提示
const NOT_TIP_KEY = "noTip";

/**
 * 错误拦截
 * Created by guoshuyu
 * on 2019/3/23.
 */
class ErrorInterceptors extends InterceptorsWrapper {
  final Dio _dio;

  ErrorInterceptors(this._dio);

  @override
  Future onError(DioError err) {
    getFinalException(err);
    return super.onError(err);
  }

  @override
  onRequest(RequestOptions options) async {
    //没有网络
  }

  getFinalException(DioError dioError) {
    print("HandleError DioError:  $dioError");
    switch (dioError.type) {
      case DioErrorType.CANCEL:
        return "Request Cancel";
      case DioErrorType.CONNECT_TIMEOUT:
        Fluttertoast.showToast(
            msg: "网络连接超时！",
            textColor: Colors.white,
            backgroundColor: Colors.grey);
        break;
//        return "CONNECT TIMEOUT";
      case DioErrorType.SEND_TIMEOUT:
        Fluttertoast.showToast(
            msg: "网络连接超时！",
            textColor: Colors.white,
            backgroundColor: Colors.grey);
        break;
//        return 'Send Time Out';
      case DioErrorType.RESPONSE:
        return "Server Incorrect Status";
      case DioErrorType.RECEIVE_TIMEOUT:
//        return "Receive Time Out";
        Fluttertoast.showToast(
            msg: "网络连接超时！",
            textColor: Colors.white,
            backgroundColor: Colors.grey);
        break;
      case DioErrorType.DEFAULT:
        String msg = 'UnKnown';
//        Log.v("Handle Error DEFAULT", dioError.error);
        if (dioError.error != null) {
          if (dioError.error is SocketException) {
            msg = "网络连接异常";
            Fluttertoast.showToast(
                msg: "网络连接异常！",
                textColor: Colors.white,
                backgroundColor: Colors.grey);
          } else {
            msg = dioError.message;
          }
        }
        break;
    }
//    return "UnKnown";
  }
}

