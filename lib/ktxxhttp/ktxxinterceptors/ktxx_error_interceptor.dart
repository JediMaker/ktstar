import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/ktxxutils/ktxx_common_utils.dart';

///是否需要弹提示
const NOT_TIP_KEY = "noTip";

/**
 * 错误拦截
 * Created by guoshuyu
 * on 2019/3/23.
 */
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedErrorInterceptors extends InterceptorsWrapper {
  final Dio _dio;

  KeTaoFeaturedErrorInterceptors(this._dio);

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
              KeTaoFeaturedCommonUtils.showToast("网络异常，网络连接超时！");

              break;
      //        return "CONNECT TIMEOUT";
            case DioErrorType.SEND_TIMEOUT:
              KeTaoFeaturedCommonUtils.showToast("网络异常，数据发送超时！");
              break;
      //        return 'Send Time Out';
            case DioErrorType.RESPONSE:
              KeTaoFeaturedCommonUtils.showToast("服务器异常，请稍后再试！");
              return "Server Incorrect Status";
            case DioErrorType.RECEIVE_TIMEOUT:
      //        return "Receive Time Out";
              KeTaoFeaturedCommonUtils.showToast("网络异常，数据接收超时！");
              break;
            case DioErrorType.DEFAULT:
              String msg = 'UnKnown';
      //        Log.v("Handle Error DEFAULT", dioError.error);
              if (dioError.error != null) {
                if (dioError.error is SocketException) {
                  msg = "网络连接异常";
                  KeTaoFeaturedCommonUtils.showToast("网络连接异常！");
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

