import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_screenutil/screenutil.dart';

/// @desp:
/// @time 2019/10/30 14:44
/// @author lizubing
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJGoodsSelectChoiceChip extends StatefulWidget {
  final String text;
  final double height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double fontSize;
  final Color textColor;
  final Color boxColor;
  final Color textSelectColor;
  final Color boxSelectColor;
  final BorderRadiusGeometry borderRadius;
  final BoxBorder border;
  final BoxBorder selectBorder;
  final ValueChanged<bool> onSelected;
  final bool selected;

  const KTKJGoodsSelectChoiceChip(
      {@required this.text,
      this.height = 25,
      this.padding = const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      this.margin = const EdgeInsets.symmetric(vertical: 5),
      this.fontSize,
      this.textColor = const Color(0xFF222222),
      this.boxColor = const Color(0xFFFFFFFF),
      this.borderRadius = const BorderRadius.all(Radius.circular(12)),
      this.border = const Border.fromBorderSide(BorderSide(
          color: Color(0xFFf0f0f0), width: 0.5, style: BorderStyle.solid)),
      this.selectBorder = const Border.fromBorderSide(BorderSide(
          color: const Color(0xffF93736),
          width: 0.5,
          style: BorderStyle.solid)),
      this.onSelected,
      this.selected,
      this.textSelectColor = const Color(0xFF1C74D0),
      this.boxSelectColor = const Color(0xFFFFFFFF)});

  @override
  State<StatefulWidget> createState() {
    return _GoodsSelectChoiceChipState();
  }
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _GoodsSelectChoiceChipState extends State<KTKJGoodsSelectChoiceChip> {
  @override
  Widget build(BuildContext context) {
    bool _select = widget.selected;

    return GestureDetector(
      onTap: () {
        widget.onSelected(!_select);
      },
      child: Container(
          height: widget.height,
          padding: widget.padding,
          margin: widget.margin,
          child: new Text(
            widget.text,
            style: new TextStyle(
                fontSize: widget.fontSize,
                color: _select ? widget.textSelectColor : widget.textColor),
          ),
          decoration: new BoxDecoration(
              color: _select ? widget.boxSelectColor : widget.boxColor,
              borderRadius: widget.borderRadius,
              border: _select ? widget.selectBorder : widget.border)),
    );
  }
}
