import 'package:flutter/material.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedNavigationIconView {
  KeTaoFeaturedNavigationIconView(
      {Widget icon, Widget activeIcon, Widget title, TickerProvider vsync})
      : item = new BottomNavigationBarItem(
            icon: icon, title: title, activeIcon: activeIcon),
        controller = new AnimationController(
            vsync: vsync, duration: kThemeAnimationDuration);

  final BottomNavigationBarItem item;
  final AnimationController controller;
}
