import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class MyFractionPaginationBuilder extends SwiperPlugin {
  ///color ,if set null , will be Theme.of(context).scaffoldBackgroundColor
  final Color color;

  ///color when active,if set null , will be Theme.of(context).primaryColor
  final Color activeColor;

  ////font size
  final double fontSize;

  ///font size when active
  final double activeFontSize;

  final Key key;

  const MyFractionPaginationBuilder(
      {this.color,
      this.fontSize: 20.0,
      this.key,
      this.activeColor,
      this.activeFontSize: 35.0});

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    ThemeData themeData = Theme.of(context);
    Color activeColor = this.activeColor ?? themeData.primaryColor;
    Color color = this.color ?? themeData.scaffoldBackgroundColor;

    if (Axis.vertical == config.scrollDirection) {
      return Opacity(
        opacity: 0.5,
        child: Container(
          color: Color(0xff222222),
          child: new Column(
            key: key,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Text(
                "${config.activeIndex + 1}",
                style: TextStyle(color: activeColor, fontSize: activeFontSize),
              ),
              new Text(
                "/",
                style: TextStyle(color: color, fontSize: fontSize),
              ),
              new Text(
                "${config.itemCount}",
                style: TextStyle(color: color, fontSize: fontSize),
              )
            ],
          ),
        ),
      );
    } else {
      return Opacity(
        opacity: 0.5,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Color(0xff222222),
            borderRadius: BorderRadius.circular(
              ScreenUtil().setWidth(30),
            ),
          ),
          child: new Row(
            key: key,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Text(
                "${config.activeIndex + 1}",
                style: TextStyle(color: activeColor, fontSize: activeFontSize),
              ),
              new Text(
                " / ${config.itemCount}",
                style: TextStyle(color: color, fontSize: fontSize),
              )
            ],
          ),
        ),
      );
    }
  }
}
