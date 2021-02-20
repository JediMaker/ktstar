import 'package:dio/dio.dart';
import 'dart:collection';

import 'ktxx_code.dart';
import 'ktxxinterceptors/ktxx_error_interceptor.dart';
import 'ktxxinterceptors/ktxx_header_interceptor.dart';
import 'ktxxinterceptors/ktxx_log_interceptor.dart';
import 'ktxxinterceptors/ktxx_response_interceptor.dart';
import 'ktxx_result_data.dart';
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
///http请求
class KeTaoFeaturedMyHttp {
  static const CONTENT_TYPE_JSON = "application/generated.json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";

  Dio _dio = new Dio(); // 使用默认配置

  KeTaoFeaturedMyHttp() {
    _dio.interceptors.add(new KeTaoFeaturedHeaderInterceptors());

    _dio.interceptors.add(new KeTaoFeaturedLogsInterceptors());

    _dio.interceptors.add(new KeTaoFeaturedErrorInterceptors(_dio));

    _dio.interceptors.add(new KeTaoFeaturedResponseInterceptors());
  }

  ///发起网络请求
  ///[ url] 请求url
  ///[ params] 请求参数
  ///[ header] 外加头
  ///[ option] 配置
  Future<KeTaoFeaturedResultData> netFetch(
      url, params, Map<String, dynamic> header, Options option,
      {noTip = false}) async {
    Map<String, dynamic> headers = new HashMap();
    if (header != null) {
      headers.addAll(header);
    }

    if (option != null) {
      option.headers = headers;
    } else {
      option = new Options(method: "get");
      option.headers = headers;
    }

    resultError(DioError e) {
      Response errorResponse;
      if (e.response != null) {
        errorResponse = e.response;
      } else {
        errorResponse = new Response(statusCode: 666);
      }
      if (e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RECEIVE_TIMEOUT) {
        errorResponse.statusCode = KeTaoFeaturedCode.NETWORK_TIMEOUT;
      }
      return new KeTaoFeaturedResultData(
          KeTaoFeaturedCode.errorHandleFunction(errorResponse.statusCode, e.message, noTip),
          false,
          errorResponse.statusCode.toString());
    }

    Response response;
    try {
      response = await _dio.request(url, data: params, options: option);
    } on DioError catch (e) {
      return resultError(e);
    }
    if (response.data is DioError) {
      return resultError(response.data);
    }
    return response.data;
  }

  ///发起网络请求
  ///[ url] 请求url
  ///[ params] 请求参数
  ///[ header] 外加头
  ///[ option] 配置
  netFetch2(url, params, Map<String, dynamic> header, Options option,
      {noTip = false}) async {
    Map<String, dynamic> headers = new HashMap();
    if (header != null) {
      headers.addAll(header);
    }

    if (option != null) {
      option.headers = headers;
    } else {
      option = new Options(method: "get");
      option.headers = headers;
    }

    Response response;
    try {
      response = await _dio.request(url, data: params, options: option);
    } on DioError catch (e) {
      return resultError(e);
    }
    if (response.data is DioError) {
      return resultError(response.data);
    }
    return response.data;
  }

  static resultError(DioError e, {noTip = false}) {
    Response errorResponse;
    if (e.response != null) {
      errorResponse = e.response;
    } else {
      errorResponse = new Response(statusCode: 666);
    }
    if (e.type == DioErrorType.CONNECT_TIMEOUT ||
        e.type == DioErrorType.RECEIVE_TIMEOUT) {
      errorResponse.statusCode = KeTaoFeaturedCode.NETWORK_TIMEOUT;
    }
    return new KeTaoFeaturedResultData(
        KeTaoFeaturedCode.errorHandleFunction(errorResponse.statusCode, e.message, noTip),
        false,
        errorResponse.statusCode.toString());
  }
}

final KeTaoFeaturedMyHttp httpManager = new KeTaoFeaturedMyHttp();
