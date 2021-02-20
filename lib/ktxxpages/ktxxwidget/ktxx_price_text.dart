import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:star/ktxxutils/ktxx_common_utils.dart';

void main() {
  runApp(MaterialApp(
    home: Container(
      color: Colors.white,
      width: double.maxFinite,
      height: double.infinity,
      child: Center(
        child: KeTaoFeaturedPriceText(
          text: "123.22",
          textColor: Colors.red,
          fontSize: 12,
          fontBigSize: 16,
        ),
      ),
    ),
  ));
}
//Container(
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
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedPriceText extends StatefulWidget {
  final String text;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double fontBigSize;

  const KeTaoFeaturedPriceText({
    @required this.text,
    this.fontSize,
    this.fontBigSize,
    this.fontWeight = FontWeight.bold,
    this.textColor ,
  });
  //免单
  @override
  _KeTaoFeaturedPriceTextState createState() => _KeTaoFeaturedPriceTextState();
}

class _KeTaoFeaturedPriceTextState extends State<KeTaoFeaturedPriceText> {
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();//队列
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 1125, height: 2436, allowFontScaling: false);
    var intText;
    var dotText = '';
    if (!KeTaoFeaturedCommonUtils.isEmpty(widget.text)) {
      List<String> s = widget.text.split(".");
      try {
        intText = s[0];
        dotText = ".${s[1]}";
      } catch (e) {}
    }
    return Container(
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
                text: '￥', style: TextStyle(fontSize: widget.fontSize-3)),
            TextSpan(
                text: intText, style: TextStyle(fontSize: widget.fontBigSize)),
            TextSpan(text: dotText),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: widget.textColor,
            fontSize: widget.fontSize,
            decoration: TextDecoration.none,
            fontWeight: widget.fontWeight),
      ),
    );
  }
}
