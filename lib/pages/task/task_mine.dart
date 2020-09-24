import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/user_info_entity.dart';
import 'package:star/pages/login/login.dart';
import 'package:star/pages/task/task_open_diamond.dart';
import 'package:star/utils/common_utils.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:star/utils/navigator_utils.dart';

import '../../global_config.dart';

class TaskMinePage extends StatefulWidget {
  TaskMinePage({Key key}) : super(key: key);
  final String title = "我的";

  @override
  _TaskMinePageState createState() => _TaskMinePageState();
}

class _TaskMinePageState extends State<TaskMinePage> {
  var headUrl;
  var nickName;
  var dialogNickName;
  var dialogPhoneNumber;
  var phoneNumber;
  var totalAssetsAmount; //总资产金额
  var availableCashAmount; // 可提现金额
  var cashWithdrawal; //  已提现金额
  bool isDiamonVip = false;
  var userType; //账号类型 0普通用户 1体验用户 2VIP用户 3代理
  UserInfoEntity entity;

  _initUserData() async {
    var result = await HttpManage.getUserInfo();
    if (result.status) {
      if (mounted) {
        setState(() {
          headUrl = result.data.avatar;
          nickName = result.data.username;
          userType = result.data.type;
          phoneNumber = result.data.tel;
          totalAssetsAmount = result.data.totalPrice;
          cashWithdrawal = result.data.txPrice;
          availableCashAmount = result.data.nowPrice;
          switch (result.data.type) {
            case "0":
            case "1":
              isDiamonVip = false;
              break;
            case "2":
            case "3":
              isDiamonVip = true;
              break;
          }
        });
      }
    }
  }

  @override
  void initState() {
    _initUserData();

    GlobalConfig.isBindWechat = true;
    fluwx.weChatResponseEventHandler
        .distinct((a, b) => a == b)
        .listen((res) async {
      if (res is fluwx.WeChatAuthResponse) {
        print("微信授权结果：" + "state :${res.state} \n code:${res.code}");
        print("微信授权code" + res.code.toString());
        if (CommonUtils.isEmpty(res.code)) {
          Fluttertoast.showToast(
              msg: "微信授权获取失败，请重新授权！",
              textColor: Colors.white,
              backgroundColor: Colors.grey);
        } else {
          /* Fluttertoast.showToast(
              msg: "微信授权获取成功，正在登录！",
              textColor: Colors.white,
              backgroundColor: Colors.grey);*/
          if (!GlobalConfig.isBindWechat) {
            return;
          }
          var result = await HttpManage.bindWechat(res.code);
          if (result.status) {
            Fluttertoast.showToast(
                msg: "微信授权成功,去领任务吧",
                textColor: Colors.white,
                backgroundColor: Colors.grey);
          } else {
            Fluttertoast.showToast(
                msg: "${result.errMsg}",
                textColor: Colors.white,
                backgroundColor: Colors.grey);
          }
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(
          gradient: buildBackgroundLinearGradient(),
          title: Text(
            "我的",
            style: TextStyle(
                color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                fontSize: ScreenUtil().setSp(54)),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                buildTopLayout(),
                buildCardInfo(),
                !isDiamonVip ? buildBanner(context) : buildProxyBanner(context),
              ],
            ),
            ListTile(
              title: Text("微信绑定"),
              onTap: () {
                fluwx
                    .sendWeChatAuth(
                        scope: "snsapi_userinfo", state: "wechat_sdk_demo_test")
                    .then((code) {});
              },
            ),
            Visibility(
              visible: false,
              child: Flexible(
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                  margin:
                      EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Text(
                                "时间",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF999999),
                                    fontSize: ScreenUtil().setSp(36)),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Text(
                                "金额",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF999999),
                                    fontSize: ScreenUtil().setSp(36)),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Text(
                                "说明",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF999999),
                                    fontSize: ScreenUtil().setSp(36)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                            height: 1,
                            color: Color(0xFFEFEFEF),
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(
                              alignment: Alignment.topRight,
                              children: <Widget>[
                                Image.asset(
                                  "static/images/task_uncompleted.png",
                                  fit: BoxFit.cover,
                                  width: 40,
                                  height: 40,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  alignment: Alignment.center,
                                  height: 48,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Text(
                                          "2020-01-32",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color(0xFF222222),
                                              fontSize: ScreenUtil().setSp(36)),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Text(
                                          "1元",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color(0xFF222222),
                                              fontSize: ScreenUtil().setSp(36)),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Text(
                                          "每天任务完成",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color(0xFF222222),
                                              fontSize: ScreenUtil().setSp(36)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                          itemCount: 10,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  LinearGradient buildBackgroundLinearGradient() {
    return userType == "3"
        ? LinearGradient(colors: [
            Color(0xFFFC767E),
            Color(0xFFFD9245),
          ])
        : userType == "2"
            ? LinearGradient(colors: [
                Color(0xFF363636),
                Color(0xFF363636),
              ])
            : LinearGradient(colors: [
                Color(0xFFD8C2A4),
                Color(0xFFCC9976),
              ]);
  }

  GestureDetector buildBanner(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return TaskOpenDiamondPage();
        }));
      },
      child: Visibility(
        visible: !isDiamonVip,
        child: Container(
          width: double.maxFinite,
          child: Image.asset(
            "static/images/task_vip_banner.png",
            width: ScreenUtil().setWidth(1194),
            height: ScreenUtil().setHeight(425),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  int memberNum = 0;

  GestureDetector buildProxyBanner(BuildContext context) {
    //
    return GestureDetector(
      onTap: () {
        showMyDialog(showNickName: false);
      },
      child: Visibility(
        visible: !isDiamonVip,
        child: Container(
          width: double.maxFinite,
          margin: EdgeInsets.only(top: 10, left: 16, right: 16),
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Image.asset(
                "static/images/task_proxy_banner.png",
                fit: BoxFit.fill,
                height: 103,
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  "开通VIP会员",
                  style: TextStyle(
                      color: Color(0xFFFCF1D6),
                      fontSize: ScreenUtil().setSp(64)),
                ),
              ),
              Container(
                  height: 22,
                  margin: EdgeInsets.only(top: 55),
                  constraints: BoxConstraints(maxWidth: 126),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                    gradient: LinearGradient(colors: [
                      Color(0xffFBF5E1),
                      Color(0xffF0CF99),
                    ]),
                  ),
                  child: Text(
                    "现名下已有$memberNum人",
                    style: TextStyle(
                        color: Color(0xFF3C2C1A),
                        fontSize: ScreenUtil().setSp(36)),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCardInfo() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            height: ScreenUtil().setHeight(140),
            decoration:
                BoxDecoration(gradient: buildBackgroundLinearGradient()),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Container(
              height: ScreenUtil().setHeight(257),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "任务奖励金",
                          style: TextStyle(
                              color: Color(0xFF222222),
                              fontSize: ScreenUtil().setSp(42)),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(16),
                        ),
                        Text(
                          "${totalAssetsAmount == null ? '¥ 0' : '¥ $totalAssetsAmount'}",
                          style: TextStyle(
                              color: Color(0xFF222222),
                              fontSize: ScreenUtil().setSp(56),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "已提现",
                          style: TextStyle(
                              color: Color(0xFF222222),
                              fontSize: ScreenUtil().setSp(42)),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(16),
                        ),
                        Text(
                          "${cashWithdrawal == null ? '¥ 0' : '¥ $cashWithdrawal'}",
                          style: TextStyle(
                              color: Color(0xFF222222),
                              fontSize: ScreenUtil().setSp(56),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
          )
        ],
      ),
    );
  }

  Widget buildTopLayout() {
    return Container(
        height: 100,
        decoration: BoxDecoration(gradient: buildBackgroundLinearGradient()),
        child: Column(
          children: <Widget>[
            Visibility(
              visible: false,
              child: Container(
                  alignment: Alignment.center,
                  height: 56,
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text("${widget.title}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          letterSpacing: 1))),
            ),
            buildHeadLayout(),
          ],
        ));
  }

  Widget buildHeadLayout() {
    return GestureDetector(
      onTap: () {
        showMyDialog(showNickName: false);
      },
      child: ListTile(
        leading: headUrl == null
            ? Image.asset(
                "static/images/task_default_head.png",
                width: 60,
                height: 60,
              )
            : ClipOval(
                child: CachedNetworkImage(
                  imageUrl: headUrl,
                  width: ScreenUtil().setWidth(120),
                  height: ScreenUtil().setWidth(120),
                  fit: BoxFit.cover,
                ),
              ),
        title: Row(
          children: <Widget>[
            Text(
              "${nickName == null ? '' : nickName}",
              style: TextStyle(
                  color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(42)),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(26),
            ),
//            Image.asset("", width:)
          ],
        ),
        subtitle: Text(
          "${phoneNumber == null ? '' : phoneNumber}",
          style: TextStyle(
              color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
              fontSize: ScreenUtil().setSp(42)),
        ),
        trailing: GestureDetector(
          onTap: () async {
            //todo 提现到微信
            /* Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return LoginPage();
            }));*/
            if (CommonUtils.isEmpty(availableCashAmount) ||
                int.parse(availableCashAmount.toString()) <= 0) {
              return;
            }
            var result = await HttpManage.withdrawalApplication(
                "2",
                availableCashAmount == null ? "1" : availableCashAmount,
                "",
                "");
            if (result.status) {
              /* Fluttertoast.showToast(
                  msg: "提现申请已提交",
                  textColor: Colors.white,
                  backgroundColor: Colors.grey);*/
              _initUserData();
            } else {
              Fluttertoast.showToast(
                  msg: "${result.errMsg}",
                  textColor: Colors.white,
                  backgroundColor: Colors.grey);
            }
          },
          child: Container(
            width: 60,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(24)),
                border: Border.all(
                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                    width: 0.5)),
            child: Text(
              "去提现",
              style: TextStyle(
                  color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                  fontSize: ScreenUtil().setSp(38)),
            ),
          ),
        ),
      ),
    );
  }

  void showMyDialog({bool showNickName}) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: <Widget>[
              Visibility(
                visible: showNickName,
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  height: 46,
                  decoration: BoxDecoration(
                      color: Color(0xFFEFEFEF),
                      borderRadius: BorderRadius.all(Radius.circular(46))),
                  child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(fontSize: 14),
                      textInputAction: TextInputAction.send,
                      decoration: new InputDecoration(
                        hintText: '昵称：',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 15.0),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(46)),
                            // 边框默认色
                            borderSide:
                                const BorderSide(color: Colors.transparent)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(46)),
                            borderSide:
                                const BorderSide(color: Colors.transparent)
                            // 聚焦之后的边框色
                            ),
                      ),
                      onChanged: (value) {
                        dialogNickName = value.trim();
                      }),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                height: 46,
                decoration: BoxDecoration(
                    color: Color(0xFFEFEFEF),
                    borderRadius: BorderRadius.all(Radius.circular(46))),
                child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(fontSize: 14),
                    textInputAction: TextInputAction.send,
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                      hintText: '手机号：',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 15.0),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(46)),
                          // 边框默认色
                          borderSide:
                              const BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(46)),
                          borderSide:
                              const BorderSide(color: Colors.transparent)
                          // 聚焦之后的边框色
                          ),
                    ),
                    onChanged: (value) {
                      dialogPhoneNumber = value.trim();
                    }),
              ),
              Container(
                height: 1,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xFFEFEFEF),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          child: Text(
                            "取消",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFF222222)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      color: Color(0xFFEFEFEF),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap: () async {
                          if ( //CommonUtils.isEmpty(dialogNickName) ||
                              CommonUtils.isEmpty(dialogPhoneNumber)) {
                            Fluttertoast.showToast(
                                msg: "请检查填写的信息是否完整！",
                                textColor: Colors.white,
                                backgroundColor: Colors.grey);
                            return;
                          }
                          if (!CommonUtils.isPhoneLegal(dialogPhoneNumber)) {
                            CommonUtils.showSimplePromptDialog(
                                context, "温馨提示", "请输入正确的手机号");
                            return;
                          }

                          var result = await HttpManage.bindPhone(
                              tel: dialogPhoneNumber.toString());
                          if (result.status) {
                            Fluttertoast.showToast(
                                msg: "绑定成功！",
                                textColor: Colors.white,
                                backgroundColor: Colors.grey);
                          } else {
                            Fluttertoast.showToast(
                                msg: "${result.errMsg}",
                                textColor: Colors.white,
                                backgroundColor: Colors.grey);
                          }
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "确定",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFF3668F2)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
