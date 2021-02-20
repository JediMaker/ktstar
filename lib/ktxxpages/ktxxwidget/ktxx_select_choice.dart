import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
/// @desp:
/// @time 2019/10/30 14:44
/// @author lizubing
class KeTaoFeaturedSelectChoiceChip extends StatefulWidget {
  final double height;
  final num width;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double fontSize;
  final Color textColor;
  final Color boxColor;
  final Color textSelectColor;
  final Color boxSelectColor;
  final BorderRadiusGeometry borderRadius;

//  final BoxBorder border;
//  final BoxBorder selectBorder;
  final ValueChanged<bool> onSelected;
  final bool selected;
  final Widget child;
  final Border selectBorder;
  final Border border;
  final LinearGradient selectGradient;
  final LinearGradient gradient;

  const KeTaoFeaturedSelectChoiceChip(
      {@required this.child,
      this.height,
      this.padding =
          const EdgeInsets.only(left: 16, top: 3, right: 16, bottom: 3),
      this.margin,
      this.width,
      this.fontSize,
      this.textColor = const Color(0xFF535353),
      this.boxColor = const Color(0xFFEEF5FE),
      this.borderRadius = const BorderRadius.all(Radius.circular(12)),
      /*this.border = const Border.fromBorderSide(BorderSide(
          color: Color(0xFFf0f0f0), width: 1, style: BorderStyle.solid)),*/
      /*this.selectBorder = const Border.fromBorderSide(
          BorderSide(color: Colors.red, width: 1, style: BorderStyle.solid)),*/
      this.onSelected,
      this.selected,
      this.selectBorder,
      this.border,
      this.selectGradient,
      this.gradient,
      this.textSelectColor = const Color(0xFF1C74D0),
      this.boxSelectColor = const Color(0xFF0A7FFF)});

  @override
  State<StatefulWidget> createState() {
    return _KeTaoFeaturedSelectChoiceChipState();
  }
 /* Align(
  alignment: Alignment.center,
  child: Container(
  margin: EdgeInsets.symmetric(horizontal: 25.0),
  child: Transform.rotate(
  angle: pi / 4,
  child: Container(
  padding: EdgeInsets.all(10.0),
  decoration: BoxDecoration(
  boxShadow: [
  if (item.elivation)
  BoxShadow(
  color: Color(0xFFD1DCFF),
  blurRadius: 5.0, // has the effect of softening the shadow
  spreadRadius:
  -1.0, // has the effect of extending the shadow
  offset: Offset(10.0, 10.0),
  )
  ],
  color: item.elivation
  ? profile_info_background
      : profile_info_categories_background,
  borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  child: Transform.rotate(
  angle: -pi / 4,
  child: Icon(
  item.icon,
  size: 30.0,
  color:
  item.elivation ? Colors.white : furnitureCateDisableColor,
  ),
  ),
  ),
  ),
  ),
  );*/
}

class _KeTaoFeaturedSelectChoiceChipState extends State<KeTaoFeaturedSelectChoiceChip> {
  @override
  Widget build(BuildContext context) {
    bool _select = widget.selected;

    return GestureDetector(
      onTap: () {
        widget.onSelected(!_select);
      },
      child: Container(
          height: widget.height,
          width: widget.width,
//          padding: widget.padding,
          margin: widget.margin,
          alignment: Alignment.center,
          child: widget.child

          /* new Text(
            widget.text,
            style: new TextStyle(
                fontSize: widget.fontSize,
                color: _select ? widget.textSelectColor : widget.textColor),
          )*/
          ,
          decoration: new BoxDecoration(
              color: _select ? widget.boxSelectColor : widget.boxColor,
              gradient: _select ? widget.selectGradient : widget.gradient,
              borderRadius: widget.borderRadius,
              border: _select ? widget.selectBorder : widget.border)),
    );
  }
}
