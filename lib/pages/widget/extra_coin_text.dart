import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:star/utils/common_utils.dart';

///限时额外赠送分红体验金 展示文本
class KeTaoFeaturedExtraCoinTextPage extends StatefulWidget {
  KeTaoFeaturedExtraCoinTextPage({
    Key key,
    this.coin,
    this.borderColor = const Color(0xffF32E43),
    this.bgDescColor = const Color(0xffF32E43),
    this.coinTextColor = const Color(0xffF32E43),
    this.coinDesc = '限时额外赠送分红体验金',
    this.coinFontSize,
    this.coinDescFontSize,
    this.borderRadius,
    this.width,
    this.height,
    this.leftMargin = 20,
    this.rightMargin = 20,
    this.topMargin = 10,
    this.bottomMargin = 10,
  }) : super(key: key);

  ///分红体验金
  final String coin;

  ///  描述
  final String coinDesc;

  final double coinFontSize;
  final double coinDescFontSize;
  final Color borderColor;
  final Color bgDescColor;
  final Color coinTextColor;
  final num borderRadius;
  final num leftMargin;
  final num rightMargin;
  final num topMargin;
  final num bottomMargin;
  final double width;
  final double height;

  @override
  _ExtraCoinTextPageState createState() => _ExtraCoinTextPageState();
}

class _ExtraCoinTextPageState extends State<KeTaoFeaturedExtraCoinTextPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !KeTaoFeaturedCommonUtils.isEmpty(widget.coin),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setWidth(10),
              bottom: ScreenUtil().setWidth(10),
              left: ScreenUtil().setWidth(widget.leftMargin),
              right: ScreenUtil().setWidth(widget.rightMargin),
            ),
            height: widget.height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  ScreenUtil().setWidth(widget.borderRadius),
                ),
                border: Border.all(
                  color: widget.borderColor,
                  width: ScreenUtil().setWidth(1),
                )),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: widget.height,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: widget.bgDescColor,
                    borderRadius: BorderRadius.circular(
                      ScreenUtil().setWidth(widget.borderRadius),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(widget.borderRadius),
                  ),
                  child: Text(
                    "${widget.coinDesc}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.coinDescFontSize,
                    ),
                  ),
                ),
                Container(
                  height: widget.height,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(widget.borderRadius),
                  ),
                  child: Text(
                    "${widget.coin}",
                    style: TextStyle(
                      color: widget.coinTextColor,
                      fontSize: widget.coinFontSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
