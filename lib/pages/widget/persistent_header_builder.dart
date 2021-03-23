/*
作者：张风捷特烈
链接：https://juejin.cn/post/6887396184015208461
来源：掘金
*/

import 'package:flutter/cupertino.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedPersistentHeaderBuilder extends SliverPersistentHeaderDelegate {
  final double max;
  final double min;
  final Widget Function(BuildContext context, double offset) builder;

  KeTaoFeaturedPersistentHeaderBuilder(
      {this.max = 120, this.min = 80, @required this.builder})
      : assert(max >= min && builder != null);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return builder(context, shrinkOffset);
  }

  @override
  double get maxExtent => max;

  @override
  double get minExtent => min;

  @override
  bool shouldRebuild(covariant KeTaoFeaturedPersistentHeaderBuilder oldDelegate) =>
      max != oldDelegate.max ||
      min != oldDelegate.min ||
      builder != oldDelegate.builder;
}
