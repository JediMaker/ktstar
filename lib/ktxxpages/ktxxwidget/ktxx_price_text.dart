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
