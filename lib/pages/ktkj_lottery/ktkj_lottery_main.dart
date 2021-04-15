import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
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
  ///总能量值
  var _totalEnergy = "999999999";

  ///单次抽奖消耗能量值
  var _consumeEnergy = '999999999';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Stack(
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
                        ///todo 跳转能量大作战消息列表
                        KTKJCommonUtils.showToast("跳转能量大作战消息列表");

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
                    Container(
                      margin: EdgeInsets.only(
                        top: ScreenUtil().setWidth(279),
//                        left: ScreenUtil().setWidth(30),
//                        right: ScreenUtil().setWidth(30),
                      ),
                      child: Center(
                        child: KTKJLotteryView(),
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
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                KTKJMyOctoImage(
                                  image:
                                      "https://alipic.lanhuapp.com/xdd234d3a3-7e0e-4f10-b3c7-eeb0867b79d8",
                                  width: ScreenUtil().setWidth(206),
                                  height: ScreenUtil().setWidth(206),
                                ),
                                Center(
                                  child: Container(
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
                            Container(
                              width: ScreenUtil().setWidth(515),
                              height: ScreenUtil().setWidth(248),
                              margin: EdgeInsets.only(
                                top: ScreenUtil().setWidth(180),
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
                                    fontSize: ScreenUtil().setSp(61),
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff780200),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
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
                                  Visibility(
                                    visible: true,
                                    child: Container(
                                      width: ScreenUtil().setWidth(98),
                                      height: ScreenUtil().setWidth(40),
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(
                                        top: ScreenUtil().setWidth(60),
                                        left: ScreenUtil().setWidth(49),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xffFC4044),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                ScreenUtil().setWidth(25))),
                                      ),
                                      child: Text(
                                        "${'3/20'}",
//                                        "${'$completeTaskNum/$totalTaskNum'}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(21)),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: true,
                                    child: Container(
                                      width: ScreenUtil().setWidth(98),
                                      height: ScreenUtil().setWidth(40),
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(
                                        top: ScreenUtil().setWidth(60),
                                        left: ScreenUtil().setWidth(49),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xffFC4044),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                ScreenUtil().setWidth(25))),
                                      ),
                                      child: Text(
                                        "${'3/20'}",
//                                        "${'$completeTaskNum/$totalTaskNum'}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(21)),
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
                                      child: Container(
                                        width: ScreenUtil().setWidth(192),
                                        height: ScreenUtil().setWidth(67),
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                          top: ScreenUtil().setWidth(60),
                                          left: ScreenUtil().setWidth(49),
                                        ),
                                        decoration: BoxDecoration(
//                                        color: Color(0xffFC4044),
                                          gradient: LinearGradient(colors: [
                                            Color(0xffFFFFFF),
                                            Color(0xffFFC5C6),
                                          ]),
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
                                              color: Colors.white,
                                              fontSize: ScreenUtil().setSp(21)),
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
                                      "https://alipic.lanhuapp.com/xd4abe7981-957d-4601-b361-de1d742d77eb",
                                  width: ScreenUtil().setWidth(326),
                                  height: ScreenUtil().setWidth(416),
                                  fit: BoxFit.fill,
                                ),
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
        );
  }

  ///使用攻击卡
  useAttackCards() {}

  ///使用万能卡
  useUniversalCards() {}
}
