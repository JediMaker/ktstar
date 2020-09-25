import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

/// @desp:
/// @time 2019/10/30 14:44
/// @author lizubing
class SelectChoiceChip extends StatefulWidget {
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

  const SelectChoiceChip(
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
      this.textSelectColor = const Color(0xFF1C74D0),
      this.boxSelectColor = const Color(0xFF0A7FFF)});

  @override
  State<StatefulWidget> createState() {
    return _SelectChoiceChipState();
  }
}

class _SelectChoiceChipState extends State<SelectChoiceChip> {
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
            borderRadius: widget.borderRadius,
//              border: _select ? widget.selectBorder : widget.border
          )),
    );
  }
}
