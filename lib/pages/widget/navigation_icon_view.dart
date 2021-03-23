import 'package:flutter/material.dart';

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
