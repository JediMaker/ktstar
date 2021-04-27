import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:star/http/ktkj_http_manage.dart';
import 'package:star/models/lottery_attacked_user_entity.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_octoimage.dart';
import 'package:star/utils/ktkj_common_utils.dart';

///翻牌页面
class KTKJLotteryFlopPage extends StatefulWidget {
  KTKJLotteryFlopPage({Key key}) : super(key: key);
  final String title = "能量大作战";

  @override
  _KTKJLotteryFlopPageState createState() => _KTKJLotteryFlopPageState();
}

class _KTKJLotteryFlopPageState extends State<KTKJLotteryFlopPage>
    with SingleTickerProviderStateMixin {
  var _mainColor = Color(0xffEF4C3C);

  ///攻击姿势合集
  List<PostureModel> _postureList = <PostureModel>[
    PostureModel(
        name: "NO.1放飞式",
        iconUrl:
            "https://alipic.lanhuapp.com/xd97e1402e-1659-48f2-b311-6f01fe697d15"),
    PostureModel(
        name: "NO.2超人式",
        iconUrl:
            "https://alipic.lanhuapp.com/xdb32dc98e-8978-4e39-bd17-b15d50f2a860"),
    PostureModel(
        name: "NO.1考拉式",
        iconUrl:
            "https://alipic.lanhuapp.com/xde35cee18-74fa-4527-8f0c-8bc4f368bd39"),
    PostureModel(
        name: "NO.4趴倒式",
        iconUrl:
            "https://alipic.lanhuapp.com/xd03b9ff6c-544a-4e62-b1f6-da3e5b91485b"),
    PostureModel(
        name: "NO.5翘臀式",
        iconUrl:
            "https://alipic.lanhuapp.com/xd7e00519b-5392-47a0-a159-df37e6889db1"),
    PostureModel(
        name: "NO.6都不式",
        iconUrl:
            "https://alipic.lanhuapp.com/xdb3c3b9ae-dcb7-43b4-ba5c-2a725ef78feb"),
  ];

  ///选中攻击姿势下标
  var _selectIndex = 0;

  ///剩余攻击次数
  var _availableAttackCount = "";

  ///动画控制器
  AnimationController _animationController;
  Animation<double> tween;
  bool _isAnimating = false;
  var _statusListener;

  ///被攻击对象id
  var _attackedUid = '';

  ///被攻击对象集合
  List<LotteryAttackedUserDataUser> _attackedUidList;

  ///攻击结果描述
  var _attackResultDesc = '';

  ///被攻击者状态描述
  var _attackedUserAssetsDesc = '';

  ///攻击结果头像
  var _avatarUrl =
      'https://alipic.lanhuapp.com/xdac86e5c2-6da4-4369-ad9d-4f2d9922e343';

  ///攻击结果标题
  var _attackedResultTitle = "";

  ///获取被攻击对象集合
  _initData({showLoading = true}) async {
    /// 调用接口兑换卡片
    try {
      if (showLoading) {
        EasyLoading.show();
      }
    } catch (e) {}
    var result = await HttpManage.lotteryUseCardAttack();
    try {
      if (showLoading) {
        EasyLoading.dismiss();
      }
    } catch (e) {}
    if (result.status) {
      if (mounted) {
        setState(() {
          _attackedUidList = result.data.users;
          _availableAttackCount = result.data.times;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _availableAttackCount = "0";
        });
      }
      if (showLoading) {
        KTKJCommonUtils.showToast(result.errMsg);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    _statusListener = (AnimationStatus status) {
      print('$status');
      if (status == AnimationStatus.completed) {
        _isAnimating = false;

        /// 提示中奖信息
//        showAwardAlert(context: context, itemModel: _lotteryList[rewardIndex]);
        tween.removeStatusListener(_statusListener);
      }
    };

    double rewardAngle = 360;
    //补间动画
    tween = Tween<double>(
      begin: 0.0,
      end: rewardAngle,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.easeInOut,
        ),
      ),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener(_statusListener);
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  Widget buildPostureItem({int index}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (mounted) {
          setState(() {
            _selectIndex = index;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: _selectIndex == index ? Colors.white : Color(0xffFC7272),
          borderRadius: BorderRadius.circular(
            ScreenUtil().setWidth(20),
          ),
        ),
        width: ScreenUtil().setWidth(330),
        height: ScreenUtil().setWidth(415),
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            color: _mainColor,
            borderRadius: BorderRadius.circular(
              ScreenUtil().setWidth(12),
            ),
          ),
          width: ScreenUtil().setWidth(302),
          height: ScreenUtil().setWidth(381),
          alignment: Alignment.center,
          child: Container(
            width: ScreenUtil().setWidth(274),
            height: ScreenUtil().setWidth(345),
            child: Stack(
              alignment: Alignment.center,
              children: [
                KTKJMyOctoImage(
                  image:
                      "https://alipic.lanhuapp.com/xd5f24fec6-794d-46d9-bfd4-a3b967332824",
                  fit: BoxFit.fill,
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setWidth(20),
                    bottom: ScreenUtil().setWidth(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: ScreenUtil().setWidth(150),
                        height: ScreenUtil().setWidth(218),
                        child: KTKJMyOctoImage(
                          image: "${_postureList[index].iconUrl}",
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(223),
                        height: ScreenUtil().setWidth(61),
                        margin: EdgeInsets.only(
                          top: ScreenUtil().setWidth(20),
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            ScreenUtil().setWidth(31),
                          ),
                        ),
                        child: Text(
                          "${_postureList[index].name}",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(34),
                            color: Color(0xff222222),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
      child: Scaffold(
          appBar: GradientAppBar(
            title: Text(
              widget.title,
              style: TextStyle(
                  color: Colors.white, fontSize: ScreenUtil().setSp(54)),
            ),
            leading: Visibility(
              child: IconButton(
                icon: Container(
                  width: ScreenUtil().setWidth(63),
                  height: ScreenUtil().setHeight(63),
                  child: Center(
                    child: Image.asset(
                      "static/images/icon_ios_back_white.png",
                      width: ScreenUtil().setWidth(36),
                      height: ScreenUtil().setHeight(63),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            centerTitle: true,
            elevation: 0,
            brightness: Brightness.dark,
            gradient: LinearGradient(colors: [
              _mainColor,
              _mainColor,
            ]),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                color: _mainColor,
                child: Column(
                  children: [
                    Container(
                      width: ScreenUtil().setWidth(1043),
                      height: ScreenUtil().setWidth(314),
                      margin: EdgeInsets.only(
                        top: ScreenUtil().setWidth(100),
                      ),
                      child: KTKJMyOctoImage(
                        image:
                            "https://alipic.lanhuapp.com/xd28617740-00c1-4269-b28b-4edaf1d9cb43",
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: ScreenUtil().setWidth(160),
                      ),
                      child: Wrap(
                        spacing: ScreenUtil().setWidth(20),
                        runSpacing: ScreenUtil().setWidth(40),
                        children: List.generate(
                          _postureList.length,
                          (index) {
                            return buildPostureItem(index: index);
                          },
                        ),
                      ),
                    ),
                    buildAttackButton(),
                    Container(
                      margin: EdgeInsets.only(
                        top: ScreenUtil().setWidth(30),
                      ),
                      child: Text(
                        "剩余$_availableAttackCount次攻击机会",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(32),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(1125),
                      height: ScreenUtil().setWidth(334),
                      margin: EdgeInsets.only(
                        top: ScreenUtil().setWidth(100),
                      ),
                      child: KTKJMyOctoImage(
                        image:
                            "https://alipic.lanhuapp.com/xdac86e5c2-6da4-4369-ad9d-4f2d9922e343",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ) // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }

  ///攻击
  Widget buildAttackButton() {
    return GestureDetector(
      onTap: () async {
        if (_selectIndex == -1) {
          KTKJCommonUtils.showToast("选择你的攻击姿势！");
          return;
        }
        if (_availableAttackCount == "0") {
          KTKJCommonUtils.showToast("暂无可用攻击卡！");
          return;
        }
        _attackedUid = _attackedUidList[_selectIndex].uid;
        print("_attackedUid=$_attackedUid");

        /// 调用接口获取攻击结果
        try {
          EasyLoading.show();
        } catch (e) {}
        var attackResult = await HttpManage.lotteryAttack(uid: _attackedUid);
        try {
          EasyLoading.dismiss();
        } catch (e) {}
        if (attackResult.status) {
          if (mounted) {
            setState(() {
              _avatarUrl = attackResult.data.aAvatar;
              _attackedResultTitle = attackResult.data.aTitle;
              _attackedUserAssetsDesc = attackResult.data.aDesc;
              _attackResultDesc = attackResult.data.aResult;
            });
          }
          _initData(showLoading: false);
          await showResultDialog(context: this.context);
        } else {
          if (mounted) {
            setState(() {
              _availableAttackCount = "0";
            });
          }
          KTKJCommonUtils.showToast(attackResult.errMsg);
        }
        if (_availableAttackCount == "0") {
          Future.delayed(Duration(seconds: 2))
              .then((value) => {Navigator.of(context).pop()});
        }

        ///

        /* await KTKJCommonUtils.showNoticeDialog(
          context: this.context,
          noticeTitle:
          "汽车票暂不支持网上退票和改签汽车票暂不支持网上退票和改签汽车票暂不支持网上退票和改签汽车票暂不支持网上退票和改签",
          mNoticeContent:
          "预订后如需退票，请在发车前到汽车站取质车票，并在窗口办理退票。退票费由各大汽车站和地方物价部门自行规定，具体请咨询汽车站。预订后如需退票，请在发车前到汽车站取质车票，退票费由各大汽车站和地方物价部门自行规定，具体请咨询汽车站。",
        );*/
        if (mounted) {
          setState(() {
            _selectIndex = 0;
          });
        }

        ///
      },
      child: Container(
        width: ScreenUtil().setWidth(429),
        height: ScreenUtil().setWidth(129),
        margin: EdgeInsets.only(
          top: ScreenUtil().setWidth(160),
        ),
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffFC7272),
              Color(0xffF32E43),
              Color(0xffFF8A7E),
            ],
          ),
          borderRadius: BorderRadius.circular(
            ScreenUtil().setWidth(121),
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(
                0,
                0,
              ), //x,y轴
              color: Color(0xff440000).withOpacity(0.27), //投影颜色
              blurRadius: ScreenUtil().setWidth(20), //投影距离
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: ScreenUtil().setWidth(364),
              height: ScreenUtil().setWidth(66),
              decoration: BoxDecoration(
                color: Color(0xffF5E0C6).withOpacity(0.3),
                borderRadius: BorderRadius.circular(
                  ScreenUtil().setWidth(62),
                ),
              ),
              child: Row(
                children: [
                  Transform.rotate(
                    angle: -20,
                    child: Container(
                      width: ScreenUtil().setWidth(22),
                      height: ScreenUtil().setWidth(18),
                      margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(37),
                        top: ScreenUtil().setWidth(20),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          ScreenUtil().setWidth(9),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(7),
                    height: ScreenUtil().setWidth(7),
                    margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(10),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        ScreenUtil().setWidth(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: ScreenUtil().setWidth(429),
              height: ScreenUtil().setWidth(129),
              child: Center(
                child: Text(
                  "攻击",
                  style: TextStyle(
                    fontSize: ScreenUtil().setWidth(42),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //换个姿势
  Widget changePostureButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(true);

        ///
      },
      child: Container(
        width: ScreenUtil().setWidth(429),
        height: ScreenUtil().setWidth(129),
        margin: EdgeInsets.only(
          top: ScreenUtil().setWidth(160),
        ),
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffFC7272),
              Color(0xffF32E43),
              Color(0xffFF8A7E),
            ],
          ),
          borderRadius: BorderRadius.circular(
            ScreenUtil().setWidth(121),
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(
                0,
                0,
              ), //x,y轴
              color: Color(0xff440000).withOpacity(0.27), //投影颜色
              blurRadius: ScreenUtil().setWidth(20), //投影距离
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: ScreenUtil().setWidth(364),
              height: ScreenUtil().setWidth(66),
              decoration: BoxDecoration(
                color: Color(0xffF5E0C6).withOpacity(0.3),
                borderRadius: BorderRadius.circular(
                  ScreenUtil().setWidth(62),
                ),
              ),
              child: Row(
                children: [
                  Transform.rotate(
                    angle: -20,
                    child: Container(
                      width: ScreenUtil().setWidth(22),
                      height: ScreenUtil().setWidth(18),
                      margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(37),
                        top: ScreenUtil().setWidth(20),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          ScreenUtil().setWidth(9),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(7),
                    height: ScreenUtil().setWidth(7),
                    margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(10),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        ScreenUtil().setWidth(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: ScreenUtil().setWidth(429),
              height: ScreenUtil().setWidth(129),
              child: Center(
                child: Text(
                  "换个姿势",
                  style: TextStyle(
                    fontSize: ScreenUtil().setWidth(42),
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> showResultDialog(
      {BuildContext context, String mUpdateContent, bool mIsForce}) async {
    double degrees2Radians = pi / 180;
    return await showGeneralDialog(
        context: context,
        pageBuilder: (context, anim1, anim2) {},
//        barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 2000),
        transitionBuilder: (context, anim1, anim2, child) {
          /* return SlideTransition(
            position: AlignmentTween(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            )..animate(animation),
            child: SlideTransition(
              position: TweenOffset(
                begin: Offset.zero,
                end: const Offset(0.0, 1.0),
              ).animate(secondaryAnimation),
              child: child,
            ),
          );*/
          return TweenAnimationBuilder(
            duration: Duration(seconds: 2),
            curve: Curves.easeInOut,
            tween: Tween<double>(begin: 360, end: 0),
            builder: (context, value, child) {
              return Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(value * degrees2Radians),
                child: Transform.scale(
                    scale: anim1.value,
                    child: WillPopScope(
                        child: createDialog(context), onWillPop: _onWillPop)),
              );
            },
          );
        });
/*
    return await showDialog(
        barrierDismissible: false, //屏蔽物理返回键（因为强更的时候点击返回键，弹窗会消失）
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              child: createDialog(context), onWillPop: _onWillPop);
        });
*/
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  ///创建翻牌弹窗
  Widget createDialog(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: ScreenUtil().setWidth(95),
                height: ScreenUtil().setWidth(95),
                margin: EdgeInsets.only(
                  bottom: ScreenUtil().setWidth(89),
                ),
                child: KTKJMyOctoImage(
                  image:
                      "https://alipic.lanhuapp.com/xdba03542e-5276-4412-967b-ea8d02dcca7c",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              width: ScreenUtil().setWidth(557),
              height: ScreenUtil().setWidth(716),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: ScreenUtil().setWidth(557),
                    height: ScreenUtil().setWidth(716),
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setWidth(0),
                    ),
                    child: KTKJMyOctoImage(
                      image:
                          "https://alipic.lanhuapp.com/xdcdb14edd-b700-4575-9914-74e415d59b26",
                      fit: BoxFit.fill,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(80),
                          ),
                          child: Text(
                            "$_attackedResultTitle",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(61),
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(10),
                          ),
                          child: Text(
                            "$_attackedUserAssetsDesc",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(42),
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        Container(
                          width: ScreenUtil().setWidth(301),
                          height: ScreenUtil().setWidth(301),
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(10),
                          ),
                          child: ClipOval(
                            child: KTKJMyOctoImage(
                              image: "$_avatarUrl",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(20),
                          ),
                          child: Text(
                            "$_attackResultDesc", //
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(42),
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: changePostureButton(context),
            ),
          ],
        ),
      ),
    );
  }

  ///
}

//姿势
class PostureModel {
  final String name;
  final String iconUrl;

  PostureModel({this.name, this.iconUrl});
}
