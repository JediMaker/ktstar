// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
///错误编码
class KeTaoFeaturedCode {
  ///网络错误
  static const NETWORK_ERROR = -1;

  ///网络超时
  static const NETWORK_TIMEOUT = -2;

  ///网络返回数据格式化一次
  static const NETWORK_JSON_EXCEPTION = -3;

  static const SUCCESS = 200;

  static errorHandleFunction(code, message, noTip) {
    if(noTip) {
      return message;
    }
//    eventBus.fire(new HttpErrorEvent(code, message));
    return message;
  }
}
