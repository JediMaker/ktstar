import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:star/http/ktkj_http_manage.dart';
import 'package:star/models/lottery_info_entity.dart';
import 'package:star/pages/ktkj_lottery/ktkj_lottery_flop.dart';
import 'package:star/pages/ktkj_lottery/ktkj_lottery_msg_list.dart';
import 'package:star/pages/ktkj_lottery/ktkj_lottery_record_list.dart';
import 'package:star/pages/ktkj_lottery/ktkj_lottery_view.dart';
import 'package:star/pages/ktkj_task/ktkj_task_index.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_octoimage.dart';
import 'package:star/utils/ktkj_common_utils.dart';
import 'package:star/utils/ktkj_navigator_utils.dart';

class KTKJLotteryMainPage extends StatefulWidget {
  KTKJLotteryMainPage({Key key}) : super(key: key);
  final String title = "能量大作战";

  @override
  _KTKJLotteryMainPageState createState() => _KTKJLotteryMainPageState();
}

class _KTKJLotteryMainPageState extends State<KTKJLotteryMainPage> {
  ///已拥有保护盾数量
  var _cardProtectedCount = "0";

  ///已拥有攻击卡数量
  var _cardAttackCount = "0";

  ///已拥有万能卡数量
  var _cardUniversalCount = "0";
  LotteryInfoData _lotteryInfoData;

  ///保护卡存储上限
  var _protectLimitNum = "0";
  var isProtecting = false;

  _initData({bool showLoading = true}) async {
    try {
      if (showLoading) {
        EasyLoading.show();
      }
    } catch (e) {}
    var result = await HttpManage.lotteryGetInfo();
    try {
      if (showLoading) {
        EasyLoading.dismiss();
      }
    } catch (e) {}
    if (result.status) {
      if (mounted) {
        setState(() {
          _cardProtectedCount = result.data.userCardNum.protectNum;
          _cardAttackCount = result.data.userCardNum.attackNum;
          _cardUniversalCount = result.data.userCardNum.magicNum;
          _lotteryInfoData = result.data;
          _protectLimitNum = _lotteryInfoData.cardConfig.protectNum;
          isProtecting = _lotteryInfoData.isProtecting;
        });
      }
    } else {
      KTKJCommonUtils.showToast(result.errMsg);
    }
  }

  @override
  void initState() {
    _initData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
              Color(0xffF9993D),
              Color(0xffF9993D),
            ]),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                    child: Stack(
                      fit: StackFit.loose,
                      children: [
                        Container(
                          width: ScreenUtil().setWidth(1125),
                          height: ScreenUtil().setWidth(1522),
                          child: Image.asset(
                            "static/images/bg_fight_page.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          width: ScreenUtil().setWidth(1125),
                          height: ScreenUtil().setWidth(1522),
                          child: KTKJMyOctoImage(
                            image:
                                "https://alipic.lanhuapp.com/xd3dce6cee-2d43-4cf8-972f-06a40c0b780a",
                            fit: BoxFit.fill,
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(
                              top: ScreenUtil().setWidth(60),
                            ),
                            child: KTKJMyOctoImage(
                              image:
                                  "https://alipic.lanhuapp.com/xdf61316e7-1937-47e2-9138-edfdff60a168",
                              width: ScreenUtil().setWidth(794),
                              height: ScreenUtil().setWidth(182),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            /// 跳转消息列表页
                            KTKJNavigatorUtils.navigatorRouter(
                                context, KTKJLotteryMsgListPage());

                            ///
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              top: ScreenUtil().setWidth(93),
                              left: ScreenUtil().setWidth(968),
                              right: ScreenUtil().setWidth(60),
                            ),
                            child: Column(
                              children: [
                                KTKJMyOctoImage(
                                  image:
                                      "https://alipic.lanhuapp.com/xd6d197e09-f5b4-417d-b16a-a8edf03898d9",
                                  width: ScreenUtil().setWidth(76),
                                  height: ScreenUtil().setWidth(71),
                                ),
                                Center(
                                  child: Container(
                                    child: Text(
                                      "消息",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(42),
                                        color: CupertinoColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        /*  GestureDetector(
                          onTap: () {
                            /// 跳转记录列表页
                            KTKJNavigatorUtils.navigatorRouter(
                                context,
                                KTKJLotteryRecordListPage(
                                  title: "抽奖记录",
                                  type: 0,
                                ));

                            ///
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              top: ScreenUtil().setWidth(293),
                              left: ScreenUtil().setWidth(968),
                              right: ScreenUtil().setWidth(60),
                            ),
                            child: Column(
                              children: [
                                KTKJMyOctoImage(
                                  image:
                                      "https://alipic.lanhuapp.com/xd6d197e09-f5b4-417d-b16a-a8edf03898d9",
                                  width: ScreenUtil().setWidth(76),
                                  height: ScreenUtil().setWidth(71),
                                ),
                                Center(
                                  child: Container(
                                    child: Text(
                                      "抽奖记录",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(42),
                                        color: CupertinoColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),*/
                        Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(1068),
                            left: ScreenUtil().setWidth(30),
                            right: ScreenUtil().setWidth(30),
//                        left: ScreenUtil().setWidth(30),
//                        right: ScreenUtil().setWidth(30),
                          ),
                          child: Image.asset(
                            "static/images/img_platform.png",
                            width: ScreenUtil().setWidth(1179),
                            height: ScreenUtil().setWidth(313),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Stack(
                            children: [
                              KTKJMyOctoImage(
                                image:
                                    "https://alipic.lanhuapp.com/xdf2f588a2-5940-4b68-8cf8-e7098073ebac",
                                width: ScreenUtil().setWidth(1125),
                                height: ScreenUtil().setWidth(177),
                                fit: BoxFit.fill,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(279),
//                        left: ScreenUtil().setWidth(30),
//                        right: ScreenUtil().setWidth(30),
                          ),
                          child: Center(
                            child: KTKJLotteryView(
                              lotteryInfoData: _lotteryInfoData,
                              lotteryRequest: () {
                                try {
                                  EasyLoading.show();
                                } catch (e) {}
                              },
                              lotteryResult: () {
                                try {
                                  EasyLoading.dismiss();
                                } catch (e) {}
                              },
                              tapClickBlock: (LotteryInfoData data) {
                                if (mounted) {
                                  setState(() {
                                    _cardProtectedCount =
                                        data.userCardNum.protectNum;
                                    _cardAttackCount =
                                        data.userCardNum.attackNum;
                                    _cardUniversalCount =
                                        data.userCardNum.magicNum;
                                    print(
                                        "_cardProtectedCount=$_cardProtectedCount");
                                    print("_cardAttackCount=$_cardAttackCount");
                                    print(
                                        "_cardUniversalCount=$_cardUniversalCount");
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(249),
                            left: ScreenUtil().setWidth(386),
                          ),
                          child: KTKJMyOctoImage(
                            image:
                                "https://alipic.lanhuapp.com/xdc812a2cc-384c-4f24-b3a8-def8ad79b7a0",
                            width: ScreenUtil().setWidth(110),
                            height: ScreenUtil().setWidth(70),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(232),
                            left: ScreenUtil().setWidth(543),
                          ),
                          child: KTKJMyOctoImage(
                            image:
                                "https://alipic.lanhuapp.com/xd19de56e9-427d-4ea0-9a83-b47866996868",
                            width: ScreenUtil().setWidth(88),
                            height: ScreenUtil().setWidth(87),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(219),
                            left: ScreenUtil().setWidth(724),
                          ),
                          child: KTKJMyOctoImage(
                            image:
                                "https://alipic.lanhuapp.com/xda9349a78-ac96-481e-91bd-98f95bd4448f",
                            width: ScreenUtil().setWidth(74),
                            height: ScreenUtil().setWidth(100),
                          ),
                        ),

                        ///左牛图
                        Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(908),
                            left: ScreenUtil().setWidth(124),
                          ),
                          child: KTKJMyOctoImage(
                            image:
                                "https://alipic.lanhuapp.com/xd25e742b3-15d3-4ece-b072-002e2a929c2d",
                            width: ScreenUtil().setWidth(401),
                            height: ScreenUtil().setWidth(437),
                          ),
                        ),

                        ///右牛图
                        Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(908),
                            left: ScreenUtil().setWidth(719),
                          ),
                          child: KTKJMyOctoImage(
                            image:
                                "https://alipic.lanhuapp.com/xd5ff3ebed-ca34-4dfc-9f99-a252fe27c214",
                            width: ScreenUtil().setWidth(392),
                            height: ScreenUtil().setWidth(437),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: ScreenUtil().setWidth(656),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xffFFC561),
                          Colors.white,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Container(
                                width: ScreenUtil.screenWidth / 3,
                                child: Stack(
                                  children: [
                                    Center(
                                      child: KTKJMyOctoImage(
                                        image:
                                            "https://alipic.lanhuapp.com/xde7bc09b1-bc3e-4f3c-a912-fff1a705d22b",
                                        width: ScreenUtil().setWidth(326),
                                        height: ScreenUtil().setWidth(416),
                                        fit: BoxFit.fill,
                                      ),
                                    ),

                                    ///卡片名称
                                    Visibility(
                                      visible: true,
                                      child: Center(
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(
                                            top: ScreenUtil().setWidth(10),
                                          ),
                                          /*decoration: BoxDecoration(
                                            color: Color(0xffFC4044),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    ScreenUtil().setWidth(25))),
                                          ),*/
                                          child: Text(
                                            "攻击卡",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
//                                        "${'$completeTaskNum/$totalTaskNum'}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    ScreenUtil().setSp(42)),
                                          ),
                                        ),
                                      ),
                                    ),

                                    ///卡片数量
                                    Visibility(
                                      visible: true,
                                      child: Container(
                                        padding: EdgeInsets.all(
                                            ScreenUtil().setWidth(8)),
                                        constraints: BoxConstraints(
                                          maxWidth: ScreenUtil().setWidth(78),
                                        ),
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                          top: ScreenUtil().setWidth(75),
                                          left: ScreenUtil().setWidth(55),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xffFC4044),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  ScreenUtil().setWidth(25))),
                                        ),
                                        child: Text(
                                          'x $_cardAttackCount',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
//                                        "${'$completeTaskNum/$totalTaskNum'}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil().setSp(21)),
                                        ),
                                      ),
                                    ),

//                                  https://alipic.lanhuapp.com/xdf95cba4d-e67f-4653-a7a3-880bc095c31a
                                    ///卡片消耗记录入口
                                    GestureDetector(
                                      onTap: () {
                                        KTKJNavigatorUtils.navigatorRouter(
                                            context,
                                            KTKJLotteryRecordListPage(
                                              title: "攻击卡记录",
                                              type: 2,
                                              cardType: 2,
                                            ));
                                      },
                                      child: Container(
                                        width: ScreenUtil().setWidth(67),
                                        height: ScreenUtil().setWidth(67),
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                          top: ScreenUtil().setWidth(60),
                                          left: ScreenUtil().setWidth(260),
                                        ),
                                        child: Container(
                                          width: ScreenUtil().setWidth(38),
                                          height: ScreenUtil().setWidth(38),
                                          child: KTKJMyOctoImage(
                                            image:
                                                "https://alipic.lanhuapp.com/xd9ca0cc8f-9b74-41c0-ab24-bdb05e963c69",
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),

                                    ///使用攻击卡
                                    Visibility(
                                      visible: true,
                                      child: GestureDetector(
                                        onTap: () {
                                          ///使用攻击卡
                                          useAttackCards();
                                        },
                                        child: Center(
                                          child: Container(
                                            width: ScreenUtil().setWidth(192),
                                            height: ScreenUtil().setWidth(67),
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(
                                              top: ScreenUtil().setWidth(296),
                                            ),
                                            decoration: BoxDecoration(
//                                        color: Color(0xffFC4044),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xffFFFFFF),
                                                  Color(0xffFFC5C6),
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                  ScreenUtil().setWidth(34),
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              "使用道具",
//                                        "${'$completeTaskNum/$totalTaskNum'}",
                                              style: TextStyle(
                                                  color: Color(0xffE53539),
                                                  fontSize:
                                                      ScreenUtil().setSp(34)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: ScreenUtil.screenWidth / 3,
                                child: Stack(
                                  children: [
                                    Center(
                                      child: KTKJMyOctoImage(
                                        image:
                                            "https://alipic.lanhuapp.com/xd4abe7981-957d-4601-b361-de1d742d77eb",
                                        width: ScreenUtil().setWidth(326),
                                        height: ScreenUtil().setWidth(416),
                                        fit: BoxFit.fill,
                                      ),
                                    ),

                                    ///卡片名称
                                    Visibility(
                                      visible: true,
                                      child: Center(
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(
                                            top: ScreenUtil().setWidth(10),
                                          ),
                                          /*decoration: BoxDecoration(
                                            color: Color(0xffFC4044),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    ScreenUtil().setWidth(25))),
                                          ),*/
                                          child: Text(
                                            "万能卡",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
//                                        "${'$completeTaskNum/$totalTaskNum'}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    ScreenUtil().setSp(42)),
                                          ),
                                        ),
                                      ),
                                    ),

                                    ///卡片数量
                                    Visibility(
                                      visible: true,
                                      child: Container(
                                        padding: EdgeInsets.all(
                                            ScreenUtil().setWidth(8)),
                                        constraints: BoxConstraints(
                                          maxWidth: ScreenUtil().setWidth(78),
                                        ),
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                          top: ScreenUtil().setWidth(75),
                                          left: ScreenUtil().setWidth(55),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xffFE9B2F),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  ScreenUtil().setWidth(25))),
                                        ),
                                        child: Text(
                                          'x $_cardUniversalCount',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
//                                        "${'$completeTaskNum/$totalTaskNum'}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil().setSp(21)),
                                        ),
                                      ),
                                    ),

                                    ///卡片消耗记录入口
                                    GestureDetector(
                                      onTap: () {
                                        KTKJNavigatorUtils.navigatorRouter(
                                            context,
                                            KTKJLotteryRecordListPage(
                                              title: "万能卡记录",
                                              type: 2,
                                              cardType: 1,
                                            ));
                                      },
                                      child: Container(
                                        width: ScreenUtil().setWidth(67),
                                        height: ScreenUtil().setWidth(67),
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                          top: ScreenUtil().setWidth(60),
                                          left: ScreenUtil().setWidth(260),
                                        ),
                                        child: Container(
                                          width: ScreenUtil().setWidth(38),
                                          height: ScreenUtil().setWidth(38),
                                          child: KTKJMyOctoImage(
                                            image:
                                                "https://alipic.lanhuapp.com/xd9ca0cc8f-9b74-41c0-ab24-bdb05e963c69",
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),

                                    ///使用万能卡
                                    Visibility(
                                      visible: true,
                                      child: GestureDetector(
                                        onTap: () {
                                          ///使用万能卡
                                          useUniversalCards();
                                        },
                                        child: Center(
                                          child: Container(
                                            width: ScreenUtil().setWidth(192),
                                            height: ScreenUtil().setWidth(67),
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(
                                              top: ScreenUtil().setWidth(296),
                                            ),
                                            decoration: BoxDecoration(
//                                        color: Color(0xffFC4044),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xffFFFFFF),
                                                  Color(0xffFFE4C5),
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                  ScreenUtil().setWidth(34),
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              "兑换道具",
//                                        "${'$completeTaskNum/$totalTaskNum'}",
                                              style: TextStyle(
                                                  color: Color(0xffFE9B2F),
                                                  fontSize:
                                                      ScreenUtil().setSp(34)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: ScreenUtil.screenWidth / 3,
                                child: Stack(
                                  children: [
                                    Center(
                                      child: KTKJMyOctoImage(
                                        image:
                                            "https://alipic.lanhuapp.com/xdf5e808bc-fec6-4036-a8bc-a14603ffe0f1",
                                        width: ScreenUtil().setWidth(326),
                                        height: ScreenUtil().setWidth(416),
                                        fit: BoxFit.fill,
                                      ),
                                    ),

                                    ///卡片名称
                                    Visibility(
                                      visible: true,
                                      child: Center(
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(
                                            top: ScreenUtil().setWidth(10),
                                          ),
                                          /*decoration: BoxDecoration(
                                            color: Color(0xffFC4044),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    ScreenUtil().setWidth(25))),
                                          ),*/
                                          child: Text(
                                            "保护盾",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
//                                        "${'$completeTaskNum/$totalTaskNum'}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    ScreenUtil().setSp(42)),
                                          ),
                                        ),
                                      ),
                                    ),

                                    ///卡片数量
                                    Visibility(
                                      visible: true,
                                      child: Container(
                                        padding: EdgeInsets.all(
                                            ScreenUtil().setWidth(8)),
                                        constraints: BoxConstraints(
                                          maxWidth: ScreenUtil().setWidth(78),
                                        ),
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                          top: ScreenUtil().setWidth(75),
                                          left: ScreenUtil().setWidth(55),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xff8CC041),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  ScreenUtil().setWidth(25))),
                                        ),
                                        child: Text(
                                          '$_cardProtectedCount/$_protectLimitNum',
                                          //
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
//                                        "${'$completeTaskNum/$totalTaskNum'}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil().setSp(21)),
                                        ),
                                      ),
                                    ),

                                    ///卡片消耗记录入口
                                    GestureDetector(
                                      onTap: () {
                                        KTKJNavigatorUtils.navigatorRouter(
                                            context,
                                            KTKJLotteryRecordListPage(
                                              title: "保护盾记录",
                                              type: 2,
                                              cardType: 3,
                                            ));
                                      },
                                      child: Container(
                                        width: ScreenUtil().setWidth(67),
                                        height: ScreenUtil().setWidth(67),
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                          top: ScreenUtil().setWidth(60),
                                          left: ScreenUtil().setWidth(260),
                                        ),
                                        child: Container(
                                          width: ScreenUtil().setWidth(38),
                                          height: ScreenUtil().setWidth(38),
                                          child: KTKJMyOctoImage(
                                            image:
                                                "https://alipic.lanhuapp.com/xd9ca0cc8f-9b74-41c0-ab24-bdb05e963c69",
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
//                                    visible: _cardProtectedCount != '0',
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Center(
                                          child: Container(
                                            width: ScreenUtil().setWidth(192),
                                            height: ScreenUtil().setWidth(67),
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(
                                              top: ScreenUtil().setWidth(296),
                                            ),
                                            decoration: BoxDecoration(
//                                        color: Color(0xffFC4044),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xffFFFFFF),
                                                  Color(0xffD2FFC5),
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                  ScreenUtil().setWidth(34),
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              "${isProtecting ? "保护中" : "未保护"}",
//                                        "${'$completeTaskNum/$totalTaskNum'}",
                                              style: TextStyle(
                                                  color: Color(0xff8CC041),
                                                  fontSize:
                                                      ScreenUtil().setSp(34)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: ScreenUtil.screenWidth / 3,
                                child: Center(
                                  child: KTKJMyOctoImage(
                                    image:
                                        "https://alipic.lanhuapp.com/xdf5e808bc-fec6-4036-a8bc-a14603ffe0f1",
                                    width: ScreenUtil().setWidth(326),
                                    height: ScreenUtil().setWidth(416),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            KTKJNavigatorUtils.navigatorRouterAndRemoveUntil(
                                context, KTKJTaskIndexPage());
                          },
                          child: Center(
                            child: Container(
                              margin: EdgeInsets.only(
                                top: ScreenUtil().setWidth(50),
                              ),
                              child: Text(
                                "购买商品获得更多能量>",
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(32),
                                  color: Color(0xff222222),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ) // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }

  ///使用攻击卡
  useAttackCards() async {
//    stopLotteryAnimation
    if (_cardAttackCount == "0" || KTKJCommonUtils.isEmpty(_cardAttackCount)) {
      KTKJCommonUtils.showToast("您还没有该卡片，去抽一个吧！");
      return;
    }

    /// 跳转翻牌页面
    await KTKJNavigatorUtils.navigatorRouter(context, KTKJLotteryFlopPage());
    _initData(showLoading: false);

    ///
  }

  ///使用万能卡
  useUniversalCards() async {
    if (_cardUniversalCount == "0" ||
        KTKJCommonUtils.isEmpty(_cardUniversalCount)) {
      KTKJCommonUtils.showToast("您还没有该卡片，去抽一个吧！");
      return;
    }

    ///
    await showConvertDialog(context: context);
    _initData(showLoading: false);
  }

  Future<bool> showConvertDialog(
      {BuildContext context, String mUpdateContent, bool mIsForce}) async {
    return await showDialog(
        barrierDismissible: false, //屏蔽物理返回键（因为强更的时候点击返回键，弹窗会消失）
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              child: CardConvertDialog(), onWillPop: _onWillPop);
        });
  }

  Future<bool> _onWillPop() async {
    return false;
  }
}

///卡片转换弹窗
class CardConvertDialog extends StatefulWidget {
  @override
  _CardConvertDialogState createState() => _CardConvertDialogState();
}

class _CardConvertDialogState extends State<CardConvertDialog> {
  ///兑换卡片类型 0 攻击卡 1 防御卡
  var _convertCardType = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: ScreenUtil().setWidth(95),
              height: ScreenUtil().setWidth(95),
              margin: EdgeInsets.only(
                top: ScreenUtil().setWidth(389),
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
            width: ScreenUtil().setWidth(795),
            height: ScreenUtil().setWidth(827),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: ScreenUtil().setWidth(795),
                  height: ScreenUtil().setWidth(827),
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setWidth(0),
                  ),
                  child: KTKJMyOctoImage(
                    image:
                        "https://alipic.lanhuapp.com/xdf4108b31-6769-4ee1-8004-b18ff9ff890d",
                    fit: BoxFit.fill,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: ScreenUtil().setWidth(44),
                        ),
                        child: Container(
                          width: ScreenUtil().setWidth(422),
                          height: ScreenUtil().setWidth(107),
                          child: KTKJMyOctoImage(
                            image:
                                "https://alipic.lanhuapp.com/xd72777907-3f56-4983-8e3a-b8cf52a4edc7",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      buildCardContainer(),
                      buildConvertBtn(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///兑换按钮
  Widget buildConvertBtn() {
    return GestureDetector(
      onTap: () async {
        if (_convertCardType == -1) {
          KTKJCommonUtils.showToast("请选择需要兑换的卡片类型！");
          return;
        }

        /// 调用接口兑换卡片
        try {
          EasyLoading.show();
        } catch (e) {}
        var result = await HttpManage.lotteryUseCardUniversal(
            toType: _convertCardType + 2);
        try {
          EasyLoading.dismiss();
        } catch (e) {}
        if (result.status) {
          KTKJCommonUtils.showToast(
              _convertCardType == 0 ? "恭喜您获得一张攻击卡！" : "恭喜您获得一张保护盾！",
              gravity: ToastGravity.CENTER);
          Navigator.of(context).pop();
        } else {
          KTKJCommonUtils.showToast(result.errMsg);
        }

        ///
      },
      child: Container(
        margin: EdgeInsets.only(
          top: ScreenUtil().setWidth(64),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: ScreenUtil().setWidth(386),
              height: ScreenUtil().setWidth(129),
              child: KTKJMyOctoImage(
                image:
                    "https://alipic.lanhuapp.com/xd2092ecf5-e6b9-4818-b786-66f0c541c39c",
                fit: BoxFit.fill,
              ),
            ),
            Container(
              width: ScreenUtil().setWidth(231),
              height: ScreenUtil().setWidth(62),
              child: KTKJMyOctoImage(
                image:
                    "https://alipic.lanhuapp.com/xd11a53cf7-7cd3-4cdb-98bf-9eafc4663ab0",
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double degrees2Radians = pi / 180;

  ///创建兑换卡片
  Container buildCardContainer() {
    return Container(
      margin: EdgeInsets.only(
        top: ScreenUtil().setWidth(104),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ///两个子Widget相互切换的动画
          /*AnimatedCrossFade(
            crossFadeState: _convertCardType == 0
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(seconds: 2),
            firstCurve: Curves.easeIn,
            secondCurve: Curves.easeIn,
            firstChild: buildCardAttack(),
            secondChild: buildCardAttackBack(),
          ),
          AnimatedCrossFade(
            crossFadeState: _convertCardType == 1
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(seconds: 2),
            firstCurve: Curves.easeIn,
            secondCurve: Curves.easeIn,
            firstChild: buildCardProtected(),
            secondChild: buildCardProtectedBack(),
          ),*/
          TweenAnimationBuilder(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            tween:
                Tween<double>(begin: 0, end: _convertCardType == 0 ? 180 : 0),
            builder: (context, value, child) {
              return Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(value * degrees2Radians),
                  child:
                      value <= 90 ? buildCardAttack() : buildCardAttackBack());
            },
          ),
          TweenAnimationBuilder(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            tween:
                Tween<double>(begin: 0, end: _convertCardType == 1 ? 180 : 0),
            builder: (context, value, child) {
              return Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(value * degrees2Radians),
                  child: value <= 90
                      ? buildCardProtected()
                      : buildCardProtectedBack());
            },
          ),
        ],
      ),
    );
  }

  ///保护盾背面
  Widget buildCardProtectedBack() {
    return Visibility(
//      visible: _convertCardType == 1,
      child: Container(
        width: ScreenUtil().setWidth(221),
        height: ScreenUtil().setWidth(283),
        margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(26),
        ),
        child: KTKJMyOctoImage(
          image:
              "https://alipic.lanhuapp.com/xdad265fcd-ead0-4300-a5ef-62e17b600a85",
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  ///保护盾正面
  Widget buildCardProtected() {
    return GestureDetector(
      onTap: () {
        if (mounted) {
          setState(() {
            _convertCardType = 1;
          });
        }
      },
      child: Visibility(
//        visible: _convertCardType != 1,
        child: Container(
          width: ScreenUtil().setWidth(221),
          height: ScreenUtil().setWidth(283),
          margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(26),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xff8CC041),
            borderRadius: BorderRadius.circular(
              ScreenUtil().setWidth(20),
            ),
          ),
          child: Container(
            width: ScreenUtil().setWidth(47),
            child: Text(
              "保护盾",
              style: TextStyle(
                fontSize: ScreenUtil().setSp(42),
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///攻击卡背面
  Widget buildCardAttackBack() {
    return Visibility(
//      visible: _convertCardType == 0,
      child: Container(
        width: ScreenUtil().setWidth(221),
        height: ScreenUtil().setWidth(283),
        margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(26),
        ),
        child: KTKJMyOctoImage(
          image:
              "https://alipic.lanhuapp.com/xd847cabac-e726-4784-9411-28c47edf30da",
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  ///攻击卡正面
  Widget buildCardAttack() {
    return GestureDetector(
      onTap: () {
        if (mounted) {
          setState(() {
            _convertCardType = 0;
          });
        }
      },
      child: Visibility(
//        visible: _convertCardType != 0,
        child: Container(
          width: ScreenUtil().setWidth(221),
          height: ScreenUtil().setWidth(283),
          margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(26),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xffFC4044),
            borderRadius: BorderRadius.circular(
              ScreenUtil().setWidth(20),
            ),
          ),
          child: Container(
            width: ScreenUtil().setWidth(47),
            child: Text(
              "攻击卡",
              style: TextStyle(
                fontSize: ScreenUtil().setSp(42),
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
