import 'package:flutter/material.dart';
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedNavigationIconView {
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;
  KeTaoFeaturedNavigationIconView(
      {Widget icon, Widget activeIcon, Widget title, TickerProvider vsync})
      : item = new BottomNavigationBarItem(
            icon: icon, title: title, activeIcon: activeIcon),
        controller = new AnimationController(
            vsync: vsync, duration: kThemeAnimationDuration);
//    Container(
//height: 6.0,
//width: 6.0,
//decoration: BoxDecoration(
//color: furnitureCateDisableColor,
//shape: BoxShape.circle,
//),
//),
//SizedBox(
//width: 5.0,
//),
//Container(
//height: 5.0,
//width: 20.0,
//decoration: BoxDecoration(
//color: Colors.blue[700],
//borderRadius: BorderRadius.circular(10.0)),
//),
  final BottomNavigationBarItem item;
  final AnimationController controller;
}
