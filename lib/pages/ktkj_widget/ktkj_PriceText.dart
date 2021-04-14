import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:star/utils/ktkj_common_utils.dart';

void main() {
  runApp(MaterialApp(
    home: Container(
      color: Colors.white,
      width: double.maxFinite,
      height: double.infinity,
      child: Center(
        child: PriceText(
          text: "123.22",
          textColor: Colors.red,
          fontSize: 12,
          fontBigSize: 16,
        ),
      ),
    ),
  ));
}

class PriceText extends StatefulWidget {
  final String text;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double fontBigSize;
  final bool showMoneySymbol; //展示金额符号

  const PriceText({
    @required this.text,
    this.fontSize,
    this.fontBigSize,
    this.fontWeight = FontWeight.bold,
    this.textColor,
    this.showMoneySymbol = true,
  });

  //免单
  @override
  _PriceTextState createState() => _PriceTextState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _PriceTextState extends State<PriceText> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose(); //队列
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 1125, height: 2436, allowFontScaling: false);
    var intText;
    var dotText = '';
    if (!KTKJCommonUtils.isEmpty(widget.text)) {
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
                text: '${widget.showMoneySymbol ? "￥" : ""}',
                style: TextStyle(fontSize: widget.fontSize - 3)),
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
