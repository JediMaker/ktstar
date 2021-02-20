/**
 * 网络结果数据
 */
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedResultData {
  var data;
  bool status;
  String errCode;
  String errMsg;
  var headers;

  KeTaoFeaturedResultData(this.data, this.status, this.errCode, {this.errMsg, this.headers});
}
