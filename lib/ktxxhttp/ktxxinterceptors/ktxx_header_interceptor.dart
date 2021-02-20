import 'package:dio/dio.dart';

/**
 * header拦截器
 * Created by guoshuyu
 * on 2019/3/23.
 */
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedHeaderInterceptors extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) async {
    ///超时
//    options.connectTimeout = 30000;
//    options.receiveTimeout = 30000;

    return options;
  }
}
