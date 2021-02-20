import 'package:dio/dio.dart';

/**
 * Token拦截器
 * Created by guoshuyu
 * on 2019/3/23.
 */
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedResponseInterceptors extends InterceptorsWrapper {
  @override
  onResponse(Response response) async {
    RequestOptions option = response.request;
    var value;
    try {
      var header = response.headers[Headers.contentTypeHeader];
      if ((header != null && header.toString().contains("text"))) {
      } else if (response.statusCode >= 200 && response.statusCode < 300) {}
    } catch (e) {
      print(e.toString() + option.path);
    }
    return value;
  }
}
