import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/utils/common_utils.dart';

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
    try {
      print("HandleError DioError:  $dioError");
      switch (dioError.type) {
            case DioErrorType.CANCEL:
              return "Request Cancel";
            case DioErrorType.CONNECT_TIMEOUT:
//              CommonUtils.showToast("网络异常，网络连接超时！");

              break;
      //        return "CONNECT TIMEOUT";
            case DioErrorType.SEND_TIMEOUT:
//              CommonUtils.showToast("网络异常，数据发送超时！");
              break;
      //        return 'Send Time Out';
            case DioErrorType.RESPONSE:
//              CommonUtils.showToast("服务器异常，请稍后再试！");
              return "Server Incorrect Status";
            case DioErrorType.RECEIVE_TIMEOUT:
      //        return "Receive Time Out";
//              CommonUtils.showToast("网络异常，数据接收超时！");
              break;
            case DioErrorType.DEFAULT:
              String msg = 'UnKnown';
      //        Log.v("Handle Error DEFAULT", dioError.error);
              if (dioError.error != null) {
                if (dioError.error is SocketException) {
                  msg = "网络连接异常";
                  CommonUtils.showToast("网络连接异常！");
                } else {
                  msg = dioError.message;
                }
              }
              break;
          }
    } catch (e) {
      print(e);
    }
//    return "UnKnown";
  }
}
