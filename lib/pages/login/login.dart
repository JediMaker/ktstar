import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/global_config.dart';
import 'package:star/http/api.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/result_bean_entity.dart';
import 'package:star/pages/task/task_index.dart';
import 'package:star/pages/widget/my_webview.dart';
import 'package:star/pages/widget/time_widget.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';
import 'package:star/utils/utils.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:star/models/login_entity.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  String title = "登录";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _description = '您好，\n请输入您的账号密码';
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _checkCodeController = new TextEditingController();
  TextEditingController _inviteCodeController = new TextEditingController();
  bool _pwdShow = false; //密码是否显示明文
  bool _checkCodeInputShow = false; //验证码输入框是否显示
  bool _pwdInputShow = true; //密码输入框是否显示
  String phoneNumber;
  String checkCode;
  String password;
  String inviteCode;
  int pageType = 0; //页面展示类型 0-登录  1-注册  2-快速登录
  ScrollController scrollController = ScrollController();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _checkCodeFocusNode = FocusNode();
  FocusNode _inviteCodeFocusNode = FocusNode();

  String _result = "无";

  void _scrollToEnd() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  void _scrollToTop() {
    scrollController.jumpTo(scrollController.position.minScrollExtent);
  }

  _initData() async {
    var versionInfo = await HttpManage.getVersionInfo();
    if (versionInfo.status) {
      switch (versionInfo.data.wxLogin) {
        case "1": //不显示
          GlobalConfig.displayThirdLoginInformation = false;

          if (mounted) {
            setState(() {});
          }
          break;

        case "2": //显示
          GlobalConfig.displayThirdLoginInformation = true;
          if (mounted) {
            setState(() {});
          }
          break;
      }
    }
  }

  @override
  void initState() {
    _initData();
    GlobalConfig.isBindWechat = false;
    fluwx.weChatResponseEventHandler
        .distinct((a, b) => a == b)
        .listen((res) async {
      if (res is fluwx.WeChatAuthResponse) {
        _result = "state :${res.state} \n code:${res.code}";
        print("微信授权结果：" + _result);
        print("微信授权code" + res.code.toString());
        if (CommonUtils.isEmpty(res.code)) {
          CommonUtils.showToast("微信授权获取失败，请重新授权！");
        } else {
          /* Fluttertoast.showToast(
              msg: "微信授权获取成功，正在登录！",
              textColor: Colors.white,
              backgroundColor: Colors.grey);*/
          if (GlobalConfig.isBindWechat) {
            return;
          }
          var result = await HttpManage.wechatLogin(res.code);
          if (result.status) {
            CommonUtils.showToast("登陆成功");
            NavigatorUtils.navigatorRouterAndRemoveUntil(
                context, TaskIndexPage());
          } else {
            CommonUtils.showToast(result.errMsg);
          }
        }
      }
    });

    super.initState();
    if (!GlobalConfig.isAgreePrivacy &&
        GlobalConfig.chanelType == GlobalConfig.CHANEL_HUAWEI) {
      Future.delayed(Duration(milliseconds: 500), () {
        showPrivacyDialog(context);
      });
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _checkCodeController.dispose();
    scrollController.dispose();
    _inviteCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 1125, height: 2436, allowFontScaling: false);

    return KeyboardDismissOnTap(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.title,
              style: TextStyle(fontSize: ScreenUtil().setSp(54)),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: GlobalConfig.taskHeadColor,
          ),
          body: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            color: Colors.white,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                        child: Column(
                      children: <Widget>[
                        Container(
                          width: double.maxFinite,
                          color: GlobalConfig.taskHeadColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 20),
                          child: Text(
                            _description,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(72),
                              letterSpacing: 1,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // 裁切的控件
                        Stack(
                          children: <Widget>[
                            ClipPath(
                              // 只裁切底部的方法
                              clipper: BottomClipper(),
                              child: Container(
                                color: GlobalConfig.taskHeadColor,
                                height: ScreenUtil().setHeight(500),
                              ),
                            ),
                            Container(
                              constraints: BoxConstraints(minHeight: 120),
                              width: double.maxFinite,
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              padding: EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  buildPhoneContainer(),
                                  buildCheckCodeLayout(),
                                  buildPasswordLayout(),
                                  buildInviteCodeLayout(),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(156),
                                  ),
                                  buildBtnLayout(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  buildBtnsRow(),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
                    buildWechatLoginContainer(),
                    Visibility(
                      visible: pageType == 0,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "注册即代表同意",
                              style: TextStyle(
                                  color: Color(0xFFAFAFAF),
                                  fontSize: ScreenUtil().setSp(32)),
                            ),
                            GestureDetector(
                              onTap: () {
                                NavigatorUtils.navigatorRouter(
                                    context,
                                    WebViewPage(
                                      initialUrl: APi.AGREEMENT_SERVICES_URL,
                                      showActions: false,
                                      title: "服务协议",
                                    ));
                              },
                              child: Text(
                                "《服务协议》",
                                style: TextStyle(
                                    color: GlobalConfig.taskHeadColor,
                                    fontSize: ScreenUtil().setSp(32)),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                NavigatorUtils.navigatorRouter(
                                    context,
                                    WebViewPage(
                                      initialUrl: APi.AGREEMENT_PRIVACY_URL,
                                      showActions: false,
                                      title: "隐私政策",
                                    ));
                              },
                              child: Text(
                                "&《隐私政策》",
                                style: TextStyle(
                                    color: GlobalConfig.taskHeadColor,
                                    fontSize: ScreenUtil().setSp(32)),
                              ),
                            ),
                          ],
                        ),
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

  ///
  /// 第三方登录--微信
  Widget buildWechatLoginContainer() {
    return Visibility(
      visible: Platform.isAndroid ||
          (Platform.isIOS && GlobalConfig.displayThirdLoginInformation),
      child: Container(
        margin: EdgeInsets.only(left: 24, right: 24, top: 40, bottom: 20),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Container(
                    color: Color(0xFFEFEFEF),
                    height: 1,
                  ),
                ),
                Container(
                  child: Text(
                    "第三方登录",
                    style: TextStyle(
                        color: Color(0xFFAFAFAF),
                        fontSize: ScreenUtil().setSp(42)),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    height: 1,
                    color: Color(0xFFEFEFEF),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 20),
              child: new FlatButton(
                  onPressed: () {
                    fluwx
                        .sendWeChatAuth(
                            scope: "snsapi_userinfo",
                            state: "wechat_sdk_demo_test")
                        .then((code) {});
                  },
                  child: new Container(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          margin: const EdgeInsets.only(bottom: 6.0),
                          child: new CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.transparent,
                            child: new Image.asset(
                              "static/images/task_wechat.png",
                              width: ScreenUtil().setWidth(138),
                              height: ScreenUtil().setWidth(138),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  ///展示隐私弹窗
  ///
  showPrivacyDialog(context) {
    return NavigatorUtils.showGSYDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: AlertDialog(
              title: Center(child: new Text('服务协议和隐私政策')), //
              content: Container(
                padding: EdgeInsets.all(0),
                height: 180,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: new Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text:
                                "请你务必审慎阅读、充分理解\“服务协议\”和\“隐私政策\”各条款，包括但不限于：为了向你提供购物、内容分享等服务，我们需要收集你的设备信息、操作日志等个人信息。你可以在“设置”中查看、变更、删除个人信息并管理你的授权。你可阅读"),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              NavigatorUtils.navigatorRouter(
                                  context,
                                  WebViewPage(
                                    initialUrl: APi.AGREEMENT_SERVICES_URL,
                                    showActions: false,
                                    title: "服务协议",
                                  ));
                            },
                            child: Text(
                              "《服务协议》",
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: ScreenUtil().setSp(42)),
                            ),
                          ),
                        ),
                        //text: "《服务协议》",style: TextStyle(color: Colors.blueAccent)
                        TextSpan(text: "和"),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              NavigatorUtils.navigatorRouter(
                                  context,
                                  WebViewPage(
                                    initialUrl: APi.AGREEMENT_PRIVACY_URL,
                                    showActions: false,
                                    title: "隐私政策",
                                  ));
                            },
                            child: Text(
                              "《隐私政策》",
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: ScreenUtil().setSp(42)),
                            ),
                          ),
                        ),
                        TextSpan(text: "了解详细信息。如你同意，请点击“同意”开始接受我们的服务。"),
                      ],
                    ),
                    style: TextStyle(fontSize: ScreenUtil().setSp(42)),
                  ),
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    },
                    child: new Text(
                      '暂不使用',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(42),
                          color: Colors.black54),
                    )),
                Container(
                  height: 30,
                  alignment: Alignment.center,
                  child: new FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        GlobalConfig.prefs.setBool("isAgreePrivacy", true);
                      },
                      child: new Text(
                        '同意',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: ScreenUtil().setSp(42),
                        ),
                      )),
                ),
              ],
            ),
          );
        });
  }

  Widget buildBtnsRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: <Widget>[
          GestureDetector(
              onTap: () {
                if (mounted) {
                  setState(() {
                    resetInputValues();
                    _scrollToTop();
                    switch (pageType) {
                      case 0:
                        pageType = 2;
                        _pwdInputShow = false;
                        _checkCodeInputShow = true;
                        _description = '您好，\n请输入您的手机号';
                        widget.title = '快速登陆';
                        break;
                      case 1:
                      case 2:
                        changToLogin();
                        break;
                    }
                  });
                }
              },
              child: Row(
                children: <Widget>[
//                                            Text('忘记密码? '),
                  Text(
                    '${pageType == 1 ? "登录" : pageType == 2 ? "密码登录" : "快速登录"}',
                    style: TextStyle(fontSize: ScreenUtil().setSp(42)),
                  ),
//                                            Text('  或  '),
//                                            Text(
//                                              '去修改',
//                                              style: TextStyle(
//                                                  color: GlobalConfig
//                                                      .colorPrimary),
//                                            ),
                ],
              )),
          Expanded(
            child: Text(''),
          ),
          GestureDetector(
              onTap: () {
                if (mounted) {
                  setState(() {
                    if (pageType == 1) {
                    } else {
                      resetInputValues();
                      _scrollToTop();
                      pageType = 1;
                      _pwdInputShow = true;
                      _checkCodeInputShow = true;
                      _description = '您好，\n请输入您的手机号';
                      widget.title = '注册';
                    }
                  });
                }
                ;
              },
              child: pageType == 1
                  ? Container(
                      child: Row(
                        children: <Widget>[
                          Text(
                            "注册即代表同意",
                            style: TextStyle(
                                color: Color(0xFFAFAFAF),
                                fontSize: ScreenUtil().setSp(32)),
                          ),
                          GestureDetector(
                            onTap: () {
                              NavigatorUtils.navigatorRouter(
                                  context,
                                  WebViewPage(
                                    initialUrl: APi.AGREEMENT_REGISTRATION_URL,
                                    showActions: false,
                                    title: "注册协议",
                                  ));
                            },
                            child: Text(
                              "《注册协议》",
                              style: TextStyle(
                                  color: GlobalConfig.taskHeadColor,
                                  fontSize: ScreenUtil().setSp(32)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              NavigatorUtils.navigatorRouter(
                                  context,
                                  WebViewPage(
                                    initialUrl: APi.AGREEMENT_SERVICES_URL,
                                    showActions: false,
                                    title: "服务协议",
                                  ));
                            },
                            child: Text(
                              "&《服务协议》",
                              style: TextStyle(
                                  color: GlobalConfig.taskHeadColor,
                                  fontSize: ScreenUtil().setSp(32)),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Text(
                      '注册',
                      style: TextStyle(fontSize: ScreenUtil().setSp(42)),
                    )),
        ],
      ),
    );
  }

  void changToLogin() {
    pageType = 0;
    _pwdInputShow = true;
    _checkCodeInputShow = false;
    _description = '您好，\n请输入您的账号密码';
    widget.title = '登录';
  }

  ///清空输入框
  resetInputValues() {
    phoneNumber = "";
    checkCode = "";
    password = "";
    inviteCode = "";
    _phoneController.text = "";
    _passwordController.text = "";
    _checkCodeController.text = "";
    _inviteCodeController.text = "";
    _phoneFocusNode.unfocus();
    _passwordFocusNode.unfocus();
    _checkCodeFocusNode.unfocus();
    _inviteCodeFocusNode.unfocus();
  }

  /// 登录/注册按钮操作
  Ink buildBtnLayout() {
    return Ink(
      child: InkWell(
          onTap: () async {
            switch (pageType) {
              case 0:
                //登录
                if (CommonUtils.isEmpty(phoneNumber) ||
                    CommonUtils.isEmpty(password)) {
                  CommonUtils.showToast("请检查填写的信息是否完整！");

                  return;
                }
                if (!CommonUtils.isPhoneLegal(phoneNumber)) {
                  CommonUtils.showSimplePromptDialog(
                      context, "温馨提示", "请输入正确的手机号");
                  return;
                }
                _login();
                break;
              case 1:
                //注册
                if (CommonUtils.isEmpty(phoneNumber) ||
                    CommonUtils.isEmpty(checkCode) ||
                    CommonUtils.isEmpty(password)) {
                  CommonUtils.showToast("请检查填写的信息是否完整！");
                  return;
                }
                if (!CommonUtils.isPhoneLegal(phoneNumber)) {
                  CommonUtils.showSimplePromptDialog(
                      context, "温馨提示", "请输入正确的手机号");
                  return;
                }
                _register();
                break;
              case 2:
                //快速登陆
                if (CommonUtils.isEmpty(phoneNumber) ||
                    CommonUtils.isEmpty(checkCode)) {
                  CommonUtils.showToast("请检查填写的信息是否完整！");
                  return;
                }
                if (!CommonUtils.isPhoneLegal(phoneNumber)) {
                  CommonUtils.showSimplePromptDialog(
                      context, "温馨提示", "请输入正确的手机号");
                  return;
                }
                _fastLogin();
                break;
            }
          },
          child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: ScreenUtil().setHeight(145),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36.0),
                  color: GlobalConfig.taskHeadColor),
              child: Text(
                "${pageType == 0 ? "登录" : pageType == 2 ? "快速登录" : "注册"}",
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(42)),
              ))),
    );
  }

  Widget buildPasswordLayout() {
    return Visibility(
      visible: _pwdInputShow,
      child: Container(
        height: ScreenUtil().setHeight(160),
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 24, right: 24, top: 20),
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(48),
        ),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.left,
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          obscureText: !_pwdShow,
          onChanged: (value) {
            password = value.trim();
          },
          decoration: InputDecoration(
              /*  labelText: widget.address.addressDetail == null
                                  ? ''
                                  : widget.address.addressDetail,*/
              border: InputBorder.none,
              alignLabelWithHint: true,
              prefixIcon: Container(
                alignment: Alignment.center,
                width: 50,
                child: Text(
                  "密码\t\t\t>",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFAFAFAF),
                    fontSize: ScreenUtil().setSp(30),
                  ),
                ),
              ),
              suffixIcon: IconButton(
                icon: _pwdShow
                    ? Image.asset(
                        "static/images/eye_open.png",
                        width: 20,
                        height: 20,
                      )
                    : Image.asset(
                        "static/images/eye_close.png",
                        width: 20,
                        height: 20,
                      ),
                onPressed: () {
                  setState(() {
                    _pwdShow = !_pwdShow;
                  });
                },
              ),
              hintText: '请输入密码',
              hintStyle: TextStyle(
                fontSize: ScreenUtil().setSp(42),
              )),
        ),
      ),
    );
  }

  Widget buildInviteCodeLayout() {
    return Visibility(
      visible: pageType == 1,
      child: Container(
        height: ScreenUtil().setHeight(160),
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 24, right: 24, top: 20),
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(48),
        ),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.left,
          controller: _inviteCodeController,
          focusNode: _inviteCodeFocusNode,
          onChanged: (value) {
            inviteCode = value.trim();
          },
          decoration: InputDecoration(
              /*  labelText: widget.address.addressDetail == null
                                  ? ''
                                  : widget.address.addressDetail,*/
              border: InputBorder.none,
              prefixIcon: Container(
                alignment: Alignment.center,
                width: 50,
                child: Text(
                  "邀请码\t\t>",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFAFAFAF),
                    fontSize: ScreenUtil().setSp(30),
                  ),
                ),
              ),
              hintText: '邀请码（选填）',
              hintStyle: TextStyle(
                fontSize: ScreenUtil().setSp(42),
              )),
        ),
      ),
    );
  }

  Widget buildCheckCodeLayout() {
    return Visibility(
      visible: _checkCodeInputShow,
      child: Container(
        height: ScreenUtil().setHeight(160),
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 24, right: 24, top: 20),
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(48),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.left,
                controller: _checkCodeController,
                focusNode: _checkCodeFocusNode,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  checkCode = value.trim();
                },
                inputFormatters: [
//                            WhitelistingTextInputFormatter(RegExp("[a-z,A-Z,0-9]")),      //限制只允许输入字母和数字
                  WhitelistingTextInputFormatter.digitsOnly,
                  //限制只允许输入数字
//                    LengthLimitingTextInputFormatter(8),                      //限制输入长度不超过8位
                ],
                decoration: InputDecoration(
                    /*  labelText: widget.address.iphone == null
                                          ? ''
                                          : widget.address.iphone,*/
                    border: InputBorder.none,
                    prefixIcon: Container(
                      alignment: Alignment.center,
                      width: 50,
                      child: Text(
                        "验证码\t>",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFAFAFAF),
                          fontSize: ScreenUtil().setSp(30),
                        ),
                      ),
                    ),
                    hintText: '请输入验证码',
                    hintStyle: TextStyle(
                      fontSize: ScreenUtil().setSp(42),
                    )),
              ),
            ),
            SizedBox(width: 15, child: Text('|')),
            InkWell(
                child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 36,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36.0),
                  color: GlobalConfig.taskHeadColor),
              child: TimerWidget(
                startCountAction: (BuildContext context) {
                  return smsSend(context);
                },
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget buildPhoneContainer() {
    return Container(
      height: ScreenUtil().setHeight(160),
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 24, right: 24, top: 20),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(48),
      ),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.left,
        controller: _phoneController,
        focusNode: _phoneFocusNode,
        keyboardType: TextInputType.number,
        maxLengthEnforced: false,
        onChanged: (value) {
          setState(() {
            phoneNumber = value.trim();
          });
        },
        decoration: InputDecoration(
            /* labelText: widget.address.name == null
                                  ? ''
                                  : widget.address.name,*/
            border: InputBorder.none,
            prefixIcon: Container(
              alignment: Alignment.center,
              width: 50,
              child: Text(
                "+86\t\t\t\t>",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFAFAFAF),
                  fontSize: ScreenUtil().setSp(30),
                ),
              ),
            ),
            suffixIcon: IconButton(
              icon: Image.asset(
                "static/images/close.png",
                width: 30,
                height: 30,
              ),
              onPressed: () {
                setState(() {
                  _phoneController.text = "";
                });
              },
            ),
            hintText: '请输入手机号',
            hintStyle: TextStyle(
              fontSize: ScreenUtil().setSp(42),
            )),
      ),
    );
  }

  Future<bool> smsSend(BuildContext context) async {
    if (CommonUtils.isPhoneLegal(phoneNumber)) {
      ResultBeanEntity result = await HttpManage.sendVerificationCode(
          phoneNumber,
          "${pageType == 1 ? '1' : pageType == 2 ? "2" : "3"}");

      if (result.status) {
        CommonUtils.showToast("验证码已发送，请注意查收！");
        return true;
      } else {
        CommonUtils.showToast(result.errMsg);
        return false;
      }
    } else {
      CommonUtils.showSimplePromptDialog(context, "温馨提示", "请输入正确的手机号");
      return false;
    }
  }

  Future<void> _login() async {
    LoginEntity result = await HttpManage.login(phoneNumber, password);
    if (result.status) {
      CommonUtils.showToast("登陆成功");
      GlobalConfig.saveLoginStatus(true);
      NavigatorUtils.navigatorRouterAndRemoveUntil(context, TaskIndexPage());
    } else {
      CommonUtils.showToast(result.errMsg);
    }
  }

  Future<void> _fastLogin() async {
    LoginEntity result = await HttpManage.quickLogin(phoneNumber, checkCode);
    if (result.status) {
      CommonUtils.showToast("登陆成功");
      GlobalConfig.saveLoginStatus(true);
      NavigatorUtils.navigatorRouterAndRemoveUntil(context, TaskIndexPage());
    } else {
      CommonUtils.showToast(result.errMsg);
    }
  }

  Future<void> _register() async {
    ResultBeanEntity result =
        await HttpManage.register(phoneNumber, checkCode, password, inviteCode);
    if (result.status) {
      CommonUtils.showToast("注册成功，请登陆！");
      if (mounted) {
        setState(() {
          changToLogin();
        });
      }
    } else {
      CommonUtils.showToast(result.errMsg);
      /*Fluttertoast.showToast(
          msg: "${result.errMsg}",
          textColor: Colors.white,
          backgroundColor: Colors.grey);*/
    }
  }
}
