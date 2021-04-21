import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:star/pages/ktkj_lottery/ktkj_lottery_record_list.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_octoimage.dart';
import 'package:star/utils/ktkj_common_utils.dart';
import 'package:star/utils/ktkj_navigator_utils.dart';

typedef void OnTapClickBlock();

///抽奖转盘
class KTKJLotteryView extends StatefulWidget {
  KTKJLotteryView({Key key, this.tapClickBlock}) : super(key: key);
  final String title = "";
  final OnTapClickBlock tapClickBlock;

  @override
  _KTKJLotteryViewState createState() => _KTKJLotteryViewState();
}

class _KTKJLotteryViewState extends State<KTKJLotteryView>
    with SingleTickerProviderStateMixin {
  final List<LotteryItemModel> _lotteryList = <LotteryItemModel>[
    LotteryItemModel(
      titleName: '能量值',
      iconName: '',
      value: '8',
    ),
    LotteryItemModel(
      titleName: '万能卡',
      iconName:
          'https://alipic.lanhuapp.com/xdc812a2cc-384c-4f24-b3a8-def8ad79b7a0',
      width: ScreenUtil().setWidth(110),
      height: ScreenUtil().setWidth(70),
    ),
    LotteryItemModel(
      titleName: '攻击卡',
      iconName:
          'https://alipic.lanhuapp.com/xd19de56e9-427d-4ea0-9a83-b47866996868',
      width: ScreenUtil().setWidth(88),
      height: ScreenUtil().setWidth(87),
    ),
    LotteryItemModel(
      titleName: '保护盾',
      iconName:
          'https://alipic.lanhuapp.com/xda9349a78-ac96-481e-91bd-98f95bd4448f',
      width: ScreenUtil().setWidth(74),
      height: ScreenUtil().setWidth(100),
    ),
    LotteryItemModel(
      titleName: '能量值',
      iconName: '',
      value: '10',
    ),
    LotteryItemModel(
      titleName: '攻击卡',
      iconName:
          'https://alipic.lanhuapp.com/xd19de56e9-427d-4ea0-9a83-b47866996868',
      width: ScreenUtil().setWidth(88),
      height: ScreenUtil().setWidth(87),
    ),
    LotteryItemModel(
      titleName: '能量值',
      iconName: '',
      value: '12',
    ),
    LotteryItemModel(
      titleName: '保护盾',
      iconName:
          'https://alipic.lanhuapp.com/xda9349a78-ac96-481e-91bd-98f95bd4448f',
      width: ScreenUtil().setWidth(74),
      height: ScreenUtil().setWidth(100),
    ),
  ];

  ///总能量值
  var _totalEnergy = "99999";

  ///单次抽奖消耗能量值
  var _consumeEnergy = '10';

  List<Widget> getItemWidgets() {
    List<Widget> _itemWidgets = <Widget>[];
    for (int i = 0; i < _lotteryList.length; i++) {
      LotteryItemModel itemModel = _lotteryList[i];
      Widget item = myTransitionItem(i, itemModel);
      _itemWidgets.add(item);
    }
    return _itemWidgets;
  }

  Widget myTransitionItem(int i, LotteryItemModel itemModel) {
    return Container(
//      color: i % 2 == 0 ? Color(0xffFAC07F) : Color(0xffFDD594),
      child: MyTransitionItem(
        angle: pi / 180.0 * (i * 1.0 / _lotteryList.length) * 360.0,
        child: Transform.rotate(
          angle: pi / 180.0 * (i * 1.0 / _lotteryList.length) * 360.0 +
              90 * pi / 180.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(20),
                ),
                child: Text(
                  itemModel.titleName,
                  style: TextStyle(
                    color: Color(0xFFD31D16),
                    fontSize: ScreenUtil().setSp(44),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
//              HeroGiftView(
//                isAlertStyle: false,
//                giftImg: 'assets/images/' + itemModel.iconName + '.png',
//              ),
              Visibility(
                visible: !KTKJCommonUtils.isEmpty(itemModel.iconName),
                child: Container(
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setWidth(10),
                  ),
                  width: itemModel.width,
                  height: itemModel.height,
                  child: KTKJMyOctoImage(
                    image: itemModel.iconName,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Visibility(
                visible: !KTKJCommonUtils.isEmpty(itemModel.value),
                child: Container(
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setWidth(20),
                  ),
                  child: Text(
                    "${itemModel.value}",
                    style: TextStyle(
                      color: Color(0xFFD31D16),
                      fontSize: ScreenUtil().setSp(44),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Animation<double> tween;
  AnimationController controller;
  bool _isAnimating = false;
  var _statusListener;

  void _gestureTap({int rewardIndex = 0}) {
    _statusListener = (AnimationStatus status) {
      print('$status');
      if (status == AnimationStatus.completed) {
        _isAnimating = false;

        ///todo 提示中奖信息
//        showAwardAlert(context: context, itemModel: _lotteryList[rewardIndex]);
        tween.removeStatusListener(_statusListener);
      }
    };

    double rewardAngle =
        pi / 180.0 * (270 - (rewardIndex * 1.0 / _lotteryList.length) * 360.0);
    //补间动画
    tween = Tween<double>(
      begin: 0.0,
      end: pi * 2 * 3 + rewardAngle,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.easeInOutQuad,
        ),
      ),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener(_statusListener);
    controller.reset();
    controller.forward();
    _isAnimating = true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //控制类对象
    controller = new AnimationController(
        duration: const Duration(milliseconds: 5000), vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
//      transform: Matrix4.identity()..rotateZ(tween.value),
          width: ScreenUtil().setWidth(900),
          height: ScreenUtil().setWidth(900),
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.loose,
            children: <Widget>[
              //转盘背景
              Container(
                width: ScreenUtil().setWidth(900),
                height: ScreenUtil().setWidth(900),
                margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(20),
                ),
                child: Image.asset(
                  "static/images/bg_lottery.png",
                  fit: BoxFit.fill,
                ),
              ),
              Transform.rotate(
                angle: tween != null ? tween.value : pi / 180.0 * 270,
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.loose,
                  children: <Widget>[
                    Transform.rotate(
                      angle: _lotteryList.length % 2 == 0
                          ? pi * 90 / _lotteryList.length +
                              pi / _lotteryList.length
                          : 0,
                      child: PieChart(
                        PieChartData(
                            pieTouchData:
                                PieTouchData(touchCallback: (pieTouchResponse) {
                              /* setState(() {
                                final desiredTouch = pieTouchResponse.touchInput
                                        is! PointerExitEvent &&
                                    pieTouchResponse.touchInput is! PointerUpEvent;
                                if (desiredTouch &&
                                    pieTouchResponse.touchedSection != null) {
                                  touchedIndex =
                                      pieTouchResponse.touchedSectionIndex;
                                } else {
                                  touchedIndex = -1;
                                }
                              });*/
                            }),
                            startDegreeOffset: 180,
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 0,
                            centerSpaceRadius: 0,
                            sections: showingSections()),
                      ),
                    ),
                    //转盘奖励内容
                    Stack(
                      alignment: Alignment.center,
                      fit: StackFit.loose,
                      children: getItemWidgets(),
                    ),
                  ],
                ),
              ),

              //转盘中间开启按钮
              GestureDetector(
                onTap: _isAnimating ? null : _gestureTap,
                child: Container(
                  width: ScreenUtil().setWidth(270),
                  height: ScreenUtil().setWidth(323),
                  child: KTKJMyOctoImage(
                    image:
                        'https://alipic.lanhuapp.com/xdebe9a4b2-97ff-4cf4-b2e9-55ec7e756eec',
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: ScreenUtil().setWidth(248),
          margin: EdgeInsets.only(
            top: ScreenUtil().setWidth(106),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  /// 跳转记录列表页
                  KTKJNavigatorUtils.navigatorRouter(
                    context,
                    KTKJLotteryRecordListPage(
                      title: "能量记录",
                      type: 0,
                    ),
                  );

                  ///
                },
                child: Container(
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(30),
                  ),
                  child: Stack(
                    children: [
                      KTKJMyOctoImage(
                        image:
                            "https://alipic.lanhuapp.com/xdd234d3a3-7e0e-4f10-b3c7-eeb0867b79d8",
                        width: ScreenUtil().setWidth(206),
                        height: ScreenUtil().setWidth(206),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(150),
                          ),
                          child: Text(
                            "总能量$_totalEnergy",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(38),
                              color: Color(0xff8D0002),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  ///todo 调用接口获取中奖id
                  _gestureTap();

                  ///bus
                },
                child: Container(
                  width: ScreenUtil().setWidth(515),
                  height: ScreenUtil().setWidth(248),
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(80),
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Image.network(
                        "https://alipic.lanhuapp.com/xd723158b3-402b-481f-985c-fcb60c9473a0",
                        width: ScreenUtil().setWidth(515),
                        height: ScreenUtil().setWidth(248),
                        fit: BoxFit.fill,
                      ).image,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "消耗$_consumeEnergy能量",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(48),
                        fontWeight: FontWeight.bold,
                        color: Color(0xff780200),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  int touchedIndex;

  List<PieChartSectionData> showingSections() {
    return List.generate(
      _lotteryList.length,
      (i) {
        final isTouched = i == touchedIndex;
//        final double opacity = isTouched ? 1 : 0.6;
        switch (i % 2) {
          case 0:
            return PieChartSectionData(
              color: const Color(0xffFDD594), //.withOpacity(opacity),
              value: 100 / _lotteryList.length,
              title: '',
              radius: ScreenUtil().setWidth(350),
              /*titleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff044d7c)),
              titlePositionPercentageOffset: 0.55,*/
            );
          /* case 1:
            return PieChartSectionData(
              color: const Color(0xfff8b250).withOpacity(opacity),
              value: 12.5,
              title: '',
              radius: 80,
              titleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff90672d)),
              titlePositionPercentageOffset: 0.55,
            );
         case 2:
            return PieChartSectionData(
              color: const Color(0xff845bef).withOpacity(opacity),
              value: 12.5,
              title: '',
              radius: 80,
              titleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff4c3788)),
              titlePositionPercentageOffset: 0.6,
            );
          case 3:
            return PieChartSectionData(
              color: const Color(0xff13d38e).withOpacity(opacity),
              value: 25,
              title: '',
              radius: 80,
              titleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff0c7f55)),
              titlePositionPercentageOffset: 0.55,
            );*/
          default:
            return PieChartSectionData(
              color: const Color(0xffFAC07F), //.withOpacity(opacity),
              value: 100 / _lotteryList.length,
              title: '',
              radius: ScreenUtil().setWidth(350),
              /*titleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff044d7c)),
              titlePositionPercentageOffset: 0.55,*/
            );
        }
      },
    );
  }
}

class LotteryItemModel {
  const LotteryItemModel(
      {this.value, this.titleName, this.iconName, this.width, this.height});

  final String titleName;
  final String iconName;
  final String value;
  final double width;
  final double height;
}

class MyTransitionItem extends StatelessWidget {
  MyTransitionItem({this.angle, this.child});

  final double angle;
  final Widget child;

  final double radius = 90.0;

  @override
  Widget build(BuildContext context) {
    final x = radius * cos(angle);
    final y = radius * sin(angle);
    return Transform(
      transform: Matrix4.translationValues(x, y, 0.0),
      child: child,
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key key,
    this.color,
    this.text,
    this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}
