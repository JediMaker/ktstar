import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/user_info_entity.dart';
import 'package:star/pages/login/login.dart';
import 'package:star/pages/login/modify_password.dart';
import 'package:star/pages/order/recharge_order_list.dart';
import 'package:star/pages/recharge/recharge_result.dart';
import 'package:star/pages/task/pay_result.dart';
import 'package:star/pages/task/task_message.dart';
import 'package:star/pages/task/task_open_diamond.dart';
import 'package:star/pages/task/task_open_diamond_dialog.dart';
import 'package:star/pages/task/task_record_list.dart';
import 'package:star/pages/withdrawal/withdrawal.dart';
import 'package:star/utils/common_utils.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:star/utils/navigator_utils.dart';

import '../../global_config.dart';
import 'fans_list.dart';
import 'income_list.dart';
import 'invitation_poster.dart';

class TaskMinePage extends StatefulWidget {
  TaskMinePage({Key key}) : super(key: key);
  final String title = "我的";

  @override
  _TaskMinePageState createState() => _TaskMinePageState();
}

class _TaskMinePageState extends State<TaskMinePage> {
  var headUrl;
  var nickName = '';
  var _dialogNickName;
  var _dialogPhoneNumber = '';
  var _weChatNo = "";
  var _dialogWeChatNo = '';
  var _phoneNumber = '';
  var _code = '';
  var _phoneHintText = '请输入您的手机号';
  var _cardBgImageName = '';
  var _isWithdrawal = '';
  TextEditingController _dialogPhoneNumberController;
  TextEditingController _dialogNickNameController;
  TextEditingController _dialogWeChatNoController;

  var _totalAssetsAmount; //总资产金额
  var _availableCashAmount; // 可提现金额
  var _cashWithdrawal; //  已提现金额
  ///  注册时间
  var registerTime;
  bool isDiamonVip = true;

  ///微信授权绑定
  int isWeChatBinded = -1;

  ///微信账号绑定
  int isWeChatNoBinded = -1;

  ///账号类型 0普通用户 1体验用户 2VIP用户 3代理
  String userType;
  UserInfoEntity entity;
  Color _cardTextColor = Colors.white;
  Color _headBgColor = Color(0xffF93736);

  _initUserData() async {
    var result = await HttpManage.getUserInfo();
    if (result.status) {
      if (mounted) {
        setState(() {
          headUrl = result.data.avatar;
          nickName = result.data.username;
          userType = result.data.type;
          _phoneNumber = result.data.tel;
          _totalAssetsAmount = result.data.totalPrice;
          _cashWithdrawal = result.data.txPrice;
          _availableCashAmount = result.data.nowPrice;
          isWeChatBinded = result.data.bindThird;
          _isWithdrawal = result.data.isWithdrawal;
          registerTime = result.data.regDate;
          _weChatNo = result.data.wxNo;
          _code = result.data.code;
          _dialogWeChatNo = result.data.wxNo;
          isWeChatNoBinded = !CommonUtils.isEmpty(result.data.wxNo) ? 1 : 0;
          switch (result.data.type) {
            case "0":
              isDiamonVip = false;
              _cardBgImageName = 'task_mine_card_bg.png';
              break;
            case "1":
              isDiamonVip = false;
              _headBgColor = Color(0xffcc9976);
              _cardBgImageName = 'task_mine_card_bg_expirence.png';
              break;
            case "2":
              isDiamonVip = true;
              _cardBgImageName = 'task_mine_card_bg_vip.png';
              break;
            case "3":
//              #F8D9BA
              isDiamonVip = true;
              _cardTextColor = Color(0xffF8D9BA);
              _cardBgImageName = 'task_mine_card_bg_proxy.png';
              break;
          }
        });
      }
    }
  }

  @override
  void initState() {
    _dialogPhoneNumberController = new TextEditingController();
    _dialogNickNameController = new TextEditingController();
    _dialogWeChatNoController = new TextEditingController();
    _initUserData();
    initWeChatResHandler();
    super.initState();
  }

  initWeChatResHandler() async {
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
          if (GlobalConfig.isBindWechat) {
            var result = await HttpManage.bindWechat(res.code);
            if (result.status) {
              String isMerge = result.data["is_merge"].toString();
              switch (isMerge) {
                case "1":
                  Fluttertoast.showToast(
                      msg: "微信授权绑定成功！",
                      textColor: Colors.white,
                      backgroundColor: Colors.grey);
                  break;
                case "2":
                  Fluttertoast.showToast(
                      msg: "微信账户数据合并成功，请重新登录！",
                      textColor: Colors.white,
                      backgroundColor: Colors.grey);
                  break;
              }
            } else {
              Fluttertoast.showToast(
                  msg: "${result.errMsg}",
                  textColor: Colors.white,
                  backgroundColor: Colors.grey);
            }
          }
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: GradientAppBar(
//          gradient: buildBackgroundLinearGradient(),
            gradient: LinearGradient(colors: [
//            Color(0xfff5f5f5),
//            Color(0xfff5f5f5),
              GlobalConfig.taskNomalHeadColor,
              GlobalConfig.taskNomalHeadColor,
            ]),
            brightness: Brightness.dark,
            title: Text(
              "我的",
              /*style: TextStyle(
                  color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                  fontSize: ScreenUtil().setSp(54)),*/
              style: TextStyle(
                  color: Color(0xFF222222), fontSize: ScreenUtil().setSp(54)),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
//                buildTopLayout(),
                    buildHeadLayout(),
                    buildCardInfo(),
//                !isDiamonVip ? buildBanner(context) : buildProxyBanner(context),
                    itemsLayout(),
                  ],
                ),
                buildListItem(),
              ],
            ),
          ) // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }

  Container buildListItem() {
    var bindWechatText = "";
    switch (isWeChatBinded) {
      case 1:
        bindWechatText = "未绑定";
        break;
      case 2:
        bindWechatText = "已绑定";
        break;
    }
    var bindWechatNoText = "";
    switch (isWeChatNoBinded) {
      case 0:
        bindWechatNoText = "未设置";
        break;
      case 1:
        bindWechatNoText = _weChatNo;
        break;
    }
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 16, vertical: ScreenUtil().setHeight(30)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(30))),
          border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
              color: Colors.white,
              width: 0.5)),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Row(
              children: <Widget>[
                /*  Image.asset(
                  "static/images/icon_fans.png",
                  width: ScreenUtil().setWidth(44),
                  height: ScreenUtil().setWidth(71),
                ),*/
                Text(
                  "手机号",
                  style: TextStyle(
//                color:  Color(0xFF222222) ,
                      fontSize: ScreenUtil().setSp(38)),
                ),
              ],
            ),
            onTap: () {
              _phoneHintText = "请输入您的手机号";
              if (CommonUtils.isEmpty(_phoneNumber)) {
                _dialogPhoneNumberController.text = "";
                //绑定手机号
                showMyDialog(showPhone: true, bindPhone: true);
              } else {
                _dialogPhoneNumberController.text = _phoneNumber;
                //修改手机号
//                showMyDialog(showPhone: true, modifyPhone: true);
              }
            },
            trailing: Wrap(
              children: <Widget>[
                Text(
                  _phoneNumber == null ? "" : _phoneNumber,
                  style: TextStyle(color: Color(0xff999999)),
                ),
                Text(
                  "",
                  style: TextStyle(color: Color(0xff999999)),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: ScreenUtil().setHeight(1),
              color: Color(0xFFefefef),
            ),
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                /* Image.asset(
                  "static/images/icon_fans.png",
                  width: ScreenUtil().setWidth(44),
                  height: ScreenUtil().setWidth(71),
                ),*/
                Text(
                  "微信授权",
                  style: TextStyle(
//                color:  Color(0xFF222222) ,
                      fontSize: ScreenUtil().setSp(38)),
                ),
              ],
            ),
            onTap: () {
              if (isWeChatBinded == 1) {
                fluwx
                    .sendWeChatAuth(
                        scope: "snsapi_userinfo", state: "wechat_sdk_demo_test")
                    .then((code) {});
              }
            },
            trailing: Wrap(
              children: <Widget>[
                Text(
                  bindWechatText,
                  style: TextStyle(
                      color: isWeChatBinded == 1
                          ? Color(0xffF93736)
                          : Color(0xff999999)),
                ),
                Text(
                  isWeChatBinded == 1 ? "\t>" : "",
                  style: TextStyle(color: Color(0xff999999)),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: ScreenUtil().setHeight(1),
              color: Color(0xFFefefef),
            ),
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                /*Image.asset(
                  "static/images/icon_fans.png",
                  width: ScreenUtil().setWidth(44),
                  height: ScreenUtil().setWidth(71),
                ),*/
                Text(
                  "微信号输入",
                  style: TextStyle(
//                color:  Color(0xFF222222) ,
                      fontSize: ScreenUtil().setSp(38)),
                ),
                Text(
                  "(便于您的粉丝联系您)",
                  style: TextStyle(
                      color: Color(0xFF999999),
                      fontSize: ScreenUtil().setSp(32)),
                ),
              ],
            ),
            onTap: () {
              //todo 绑定微信号
              if (CommonUtils.isEmpty(_weChatNo)) {
                _dialogWeChatNoController.text = "";
                //绑定微信号
                showMyDialog(showWeChatNo: true, bindWeChatNo: true);
              } else {
                _dialogWeChatNoController.text = _weChatNo;
                //修改微信号
                showMyDialog(showWeChatNo: true, bindWeChatNo: false);
              }
            },
            trailing: Wrap(
              children: <Widget>[
                Text(
                  bindWechatNoText,
                  style: TextStyle(
                      color: isWeChatNoBinded == 0
                          ? Color(0xffF93736)
                          : Color(0xff999999)),
                ),
                Text(
                  "\t>",
                  style: TextStyle(color: Color(0xff999999)),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: ScreenUtil().setHeight(1),
              color: Color(0xFFefefef),
            ),
          ),
          Visibility(
            visible: false,
//            visible: !CommonUtils.isEmpty(_phoneNumber),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Row(
                    children: <Widget>[
                      /* Image.asset(
                        "static/images/icon_fans.png",
                        width: ScreenUtil().setWidth(44),
                        height: ScreenUtil().setWidth(71),
                      ),*/
                      Text(
                        "设置密码",
                        style: TextStyle(
//                color:  Color(0xFF222222) ,
                            fontSize: ScreenUtil().setSp(38)),
                      ),
                    ],
                  ),
                  onTap: () {
                    //todo 设置密码跳转
                    var title = "设置密码";
                    NavigatorUtils.navigatorRouter(
                        context,
                        ModifyPasswordPage(
                          title: title,
                        ));
                  },
                  trailing: Wrap(
                    children: <Widget>[
                      Text(
                        "\t>",
                        style: TextStyle(color: Color(0xff999999)),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    height: ScreenUtil().setHeight(1),
                    color: Color(0xFFefefef),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                /*Image.asset(
                  "static/images/icon_fans.png",
                  width: ScreenUtil().setWidth(44),
                  height: ScreenUtil().setWidth(71),
                ),*/
                Text(
                  "注册时间",
                  style: TextStyle(
//                color:  Color(0xFF222222) ,
                      fontSize: ScreenUtil().setSp(38)),
                ),
              ],
            ),
            onTap: () {},
            trailing: Wrap(
              children: <Widget>[
                Text(
                  registerTime == null ? "" : registerTime,
                  style: TextStyle(
//                color:  Color(0xFF222222) ,
                      fontSize: ScreenUtil().setSp(38)),
                ),
                Text(
                  "",
                  style: TextStyle(color: Color(0xff999999)),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: ScreenUtil().setHeight(1),
              color: Color(0xFFefefef),
            ),
          ),
          Visibility(
            visible: false,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Row(
                    children: <Widget>[
                      /*Image.asset(
                        "static/images/icon_fans.png",
                        width: ScreenUtil().setWidth(44),
                        height: ScreenUtil().setWidth(71),
                      ),*/
                      Text(
                        "关于我们",
                        style: TextStyle(
//                color:  Color(0xFF222222) ,
                            fontSize: ScreenUtil().setSp(38)),
                      ),
                    ],
                  ),
                  onTap: () {
                    //todo 关于我们跳转
                  },
                  trailing: Wrap(
                    children: <Widget>[
                      Text(
                        "\t>",
                        style: TextStyle(color: Color(0xff999999)),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    height: ScreenUtil().setHeight(1),
                    color: Color(0xFFefefef),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                /* Image.asset(
                  "static/images/icon_fans.png",
                  width: ScreenUtil().setWidth(44),
                  height: ScreenUtil().setWidth(71),
                ),*/
                Text(
                  "退出登录",
                  style: TextStyle(
//                color:  Color(0xFF222222) ,
                      fontSize: ScreenUtil().setSp(38)),
                ),
              ],
            ),
            onTap: () {
              showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text('提示'),
                      content: Text('确认退出登录吗？'),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          child: Text('取消'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text(
                            '退出',
                            style: TextStyle(color: GlobalConfig.colorPrimary),
                          ),
                          onPressed: () {
                            GlobalConfig.prefs.remove("hasLogin");
                            GlobalConfig.saveLoginStatus(false);
                            NavigatorUtils.navigatorRouterAndRemoveUntil(
                                context, LoginPage());
                          },
                        ),
                      ],
                    );
                  });
            },
            trailing: Wrap(
              children: <Widget>[
                Text(
                  "",
                  style: TextStyle(color: Color(0xff999999)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Visibility buildtasklistVisibility() {
    return Visibility(
      visible: false,
      child: Flexible(
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          margin: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
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
                            crossAxisAlignment: CrossAxisAlignment.center,
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
    );
  }

  Widget itemsLayout() {
    bool isProxy = false;
    if ("3" == userType) {
      isProxy = true;
    }
    Color _itemsTextColor = Color(0xff666666);
    return Container(
      height: ScreenUtil().setHeight(292),
      margin: EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(28))),
          border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
              color: Colors.white,
              width: 0.5)),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Flexible(
            fit: FlexFit.tight,
            child: new InkWell(
                onTap: () async {
                  NavigatorUtils.navigatorRouter(
                      context,
                      FansListPage(
                        isAgent: userType == "3",
                      ));
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
                            "static/images/icon_fans.png",
                            width: ScreenUtil().setWidth(110),
                            height: ScreenUtil().setWidth(110),
                          ),
                        ),
                      ),
                      new Container(
                        child: new Text(
                          "粉丝",
                          style: new TextStyle(
                            fontSize: ScreenUtil().setSp(38),
                            color: _itemsTextColor,
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ),
          new Flexible(
            fit: FlexFit.tight,
            child: new InkWell(
                onTap: () {
                  NavigatorUtils.navigatorRouter(context, TaskMessagePage());
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
                            "static/images/icon_message.png",
                            width: ScreenUtil().setWidth(110),
                            height: ScreenUtil().setWidth(110),
                          ),
                        ),
                      ),
                      new Container(
                        child: new Text("消息",
                            style: new TextStyle(
                                color: _itemsTextColor,
                                fontSize: ScreenUtil().setSp(38))),
                      )
                    ],
                  ),
                )),
          ),
          new Flexible(
            fit: FlexFit.tight,
            child: Ink(
              child: new InkWell(
                  onTap: () {
                    if (isProxy) {
                      _dialogPhoneNumberController.text = "";
                      _phoneHintText = "请输入要添加的手机号";
                      showMyDialog(addExperienceAccount: true, showPhone: true);
                    } else {
                      NavigatorUtils.navigatorRouter(
                          context, TaskRecordListPage());
                    }
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
                              "static/images/icon_task_record.png",
                              width: ScreenUtil().setWidth(110),
                              height: ScreenUtil().setWidth(110),
                            ),
                          ),
                        ),
                        new Container(
                          child: new Text("${isProxy ? "添加会员" : "任务记录"}",
                              style: new TextStyle(
                                  color: _itemsTextColor,
                                  fontSize: ScreenUtil().setSp(38))),
                        )
                      ],
                    ),
                  )),
            ),
          ),
          new Flexible(
            fit: FlexFit.tight,
            child: Container(
              child: new InkWell(
                  onTap: () {
                    Fluttertoast.showToast(
                        msg: "暂未开放",
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        gravity: ToastGravity.BOTTOM);
                    return;
                    /*  NavigatorUtils.navigatorRouter(
                        context, RechargeOrderListPage());*/
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
                              "static/images/icon_order.png",
                              width: ScreenUtil().setWidth(110),
                              height: ScreenUtil().setWidth(110),
                            ),
                          ),
                        ),
                        new Container(
                          child: new Text("订单",
                              style: new TextStyle(
                                  color: _itemsTextColor,
                                  fontSize: ScreenUtil().setSp(38))),
                        )
                      ],
                    ),
                  )),
            ),
          ),
          new Flexible(
            fit: FlexFit.tight,
            child: Container(
              child: new InkWell(
                  onTap: () {
                    Fluttertoast.showToast(
                        msg: "暂未开放",
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        gravity: ToastGravity.BOTTOM);
                    return;
                    /* NavigatorUtils.navigatorRouter(
                        context, InvitationPosterPage());*/
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
                              "static/images/icon_invite.png",
                              width: ScreenUtil().setWidth(110),
                              height: ScreenUtil().setWidth(110),
                            ),
                          ),
                        ),
                        new Container(
                          child: new Text("邀请好友",
                              style: new TextStyle(
                                  color: _itemsTextColor,
                                  fontSize: ScreenUtil().setSp(38))),
                        )
                      ],
                    ),
                  )),
            ),
          ),
        ],
      ),
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
        /* showMyDialog(
          showPhone: true,
        );*/
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
    //话费 话费充值
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: 16, vertical: ScreenUtil().setHeight(39)),
      child: Stack(
        children: <Widget>[
          /* Image.asset(
            "static/images/$_cardBgImageName",
            fit: BoxFit.fill,
          ),*/
          Container(
            height: ScreenUtil().setHeight(437),
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(64)),
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: Image.asset(
                      "static/images/$_cardBgImageName",
                      fit: BoxFit.fill,
                    ).image)),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap: () {
                          NavigatorUtils.navigatorRouter(
                              context,
                              IncomeListPage(
                                pageType: 0,
                              ));
                        },
                        child: Container(
                          padding:
                              EdgeInsets.only(left: ScreenUtil().setWidth(60)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    "可提现(元)",
                                    style: TextStyle(
                                        color: _cardTextColor,
                                        fontSize: ScreenUtil().setSp(32)),
                                  ),
                                  Icon(Icons.arrow_right,
                                      color: _cardTextColor,
                                      size: ScreenUtil().setSp(42)),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(16),
                              ),
                              Text(
                                "${_availableCashAmount == null ? '¥ 0' : '¥ $_availableCashAmount'}",
                                style: TextStyle(
                                    color: _cardTextColor,
                                    fontSize: ScreenUtil().setSp(42),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap: () async {
                          try {
                            if (CommonUtils.isEmpty(_availableCashAmount) ||
                                double.parse(_availableCashAmount.toString()) <=
                                    0) {
                              Fluttertoast.showToast(
                                  msg: "暂无可提现金额",
                                  textColor: Colors.white,
                                  backgroundColor: Colors.grey);
                              return;
                            }
                          } catch (e) {
                            return;
                          }

                          if (_isWithdrawal == "0") {
                            await NavigatorUtils.navigatorRouter(
                                context,
                                WithdrawalPage(
                                    availableCashAmount: _availableCashAmount));
                            _initUserData();
                            /*var result = await HttpManage.withdrawalApplication(
                                "2", _availableCashAmount, "", "");
                            if (result.status) {
                              Fluttertoast.showToast(
                                  msg: "提现申请已提交",
                                  textColor: Colors.white,
                                  backgroundColor: Colors.grey);
                              _initUserData();
                            } else {
                              Fluttertoast.showToast(
                                  msg: "${result.errMsg}",
                                  textColor: Colors.white,
                                  backgroundColor: Colors.grey);
                            }*/
                          } else {
                            Fluttertoast.showToast(
                                msg: "暂不可提现",
                                textColor: Colors.white,
                                backgroundColor: Colors.grey);
                          }
                        },
                        child: Container(
                          padding:
                              EdgeInsets.only(left: ScreenUtil().setWidth(240)),
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: ScreenUtil().setWidth(196),
                            height: ScreenUtil().setHeight(79),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(ScreenUtil().setWidth(51))),
                                border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                                    color: _cardTextColor,
                                    width: 0.5)),
                            child: Text(
                              "去提现",
                              style: TextStyle(
//                  color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                                  color: _cardTextColor,
                                  fontSize: ScreenUtil().setSp(38)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(48),
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap: () {
                          NavigatorUtils.navigatorRouter(
                              context,
                              IncomeListPage(
                                pageType: 1,
                              ));
                        },
                        child: Container(
                          padding:
                              EdgeInsets.only(left: ScreenUtil().setWidth(60)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    "总资产(元)",
                                    style: TextStyle(
                                        color: _cardTextColor,
                                        fontSize: ScreenUtil().setSp(32)),
                                  ),
                                  Icon(Icons.arrow_right,
                                      color: _cardTextColor,
                                      size: ScreenUtil().setSp(42)),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(16),
                              ),
                              Text(
                                "${_totalAssetsAmount == null ? '¥ 0' : '¥ $_totalAssetsAmount'}",
                                style: TextStyle(
                                    color: _cardTextColor,
                                    fontSize: ScreenUtil().setSp(42),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap: () {
                          NavigatorUtils.navigatorRouter(
                              context,
                              IncomeListPage(
                                pageType: 2,
                              ));
                        },
                        child: Container(
                          padding:
                              EdgeInsets.only(left: ScreenUtil().setWidth(240)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "已提现(元)",
                                    style: TextStyle(
                                        color: _cardTextColor,
                                        fontSize: ScreenUtil().setSp(32)),
                                  ),
                                  Icon(Icons.arrow_right,
                                      color: _cardTextColor,
                                      size: ScreenUtil().setSp(42)),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(16),
                              ),
                              Text(
                                "${_cashWithdrawal == null ? '¥ 0' : '¥ $_cashWithdrawal'}",
                                style: TextStyle(
                                    color: _cardTextColor,
                                    fontSize: ScreenUtil().setSp(42),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
    );
  }

  Widget buildTopLayout() {
    return Container(
        decoration: BoxDecoration(gradient: buildBackgroundLinearGradient()),
        child: Column(
          children: <Widget>[
            buildHeadLayout(),
          ],
        ));
  }

  String _getImgName(_type) {
    switch (_type) {
      case "0":
        return "icon_nomal.png";
      case "1":
        return "icon_experience.png";
      case "2":
        return "icon_vip.png";
    }
    return "";
  }

  Widget buildHeadLayout() {
    String text = "";
    switch (userType) {
      case "0":
        text = "普通会员";
        break;
      case "1":
        text = "体验会员";
        break;
      case "2":
        text = "钻石vip";
        break;
      case "3":
        text = "代理";
        break;
    }
    return ListTile(
      onTap: () async {
        switch (userType) {
          case "0":
          case "1":
            await NavigatorUtils.navigatorRouter(
                context, TaskOpenDiamondPage());
            /* NavigatorUtils.navigatorRouterAndRemoveUntil(
                context, RechargeResultPage());*/
            /*var result = await showDialog(
                context: context,
                builder: (context) {
                  return TaskOpenDiamondDialogPage();
                });*/
//            NavigatorUtils.navigatorRouter(context, PayResultPage());
            _initUserData();
            break;
        }
      },
      leading: Container(
        width: ScreenUtil().setWidth(168),
        height: ScreenUtil().setWidth(168),
        child: Stack(
          children: <Widget>[
            headUrl == null
                ? Visibility(
                    visible: false,
                    child: Image.asset(
                      "static/images/task_default_head.png",
                      width: ScreenUtil().setWidth(146),
                      height: ScreenUtil().setWidth(146),
                      fit: BoxFit.fill,
                    ))
                : ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: headUrl,
                      width: ScreenUtil().setWidth(146),
                      height: ScreenUtil().setWidth(146),
                      fit: BoxFit.fill,
                    ),
                  ),
            Visibility(
                child: Container(
              alignment: Alignment.bottomLeft,
              child: Container(
                  width: ScreenUtil().setWidth(147),
                  height: ScreenUtil().setHeight(45),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(23))),
                    gradient: LinearGradient(colors: [
                      Color(0xff505050),
                      Color(0xff222222),
                    ]),
                  ),
                  child: Text("$text",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _cardTextColor,
                        fontSize: ScreenUtil().setSp(28),
                      ))),
            ))
          ],
        ),
      ),
      title: Container(
        child: Row(
          children: <Widget>[
            Container(
              child: Text(
                "${nickName == null ? '' : nickName}",
                /*style: TextStyle(
                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(42)),*/
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Color(0xFF222222),
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(42)),
              ),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(26),
            ),
            Image.asset(
              "static/images/${_getImgName(userType)}",
              width: ScreenUtil().setWidth(185),
              height: ScreenUtil().setHeight(67),
              fit: BoxFit.fill,
            ),
//            Image.asset("", width:)
          ],
        ),
      ),
      subtitle: Text(
        "邀请码：${_code == null ? '' : _code}",
        style: TextStyle(
            color: Color(0xFF222222), fontSize: ScreenUtil().setSp(42)),
      ),
      trailing: GestureDetector(
        /* onTap: () async {
          */ /* Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return LoginPage();
          }));*/ /*
          try {
            if (CommonUtils.isEmpty(availableCashAmount) ||
                int.parse(availableCashAmount.toString()) <= 0) {
              return;
            }
          } catch (e) {
            return;
          }
          var result = await HttpManage.withdrawalApplication(
              "2",
              availableCashAmount == null ? "1" : availableCashAmount,
              "",
              "");
          if (result.status) {
            */ /* Fluttertoast.showToast(
                msg: "提现申请已提交",
                textColor: Colors.white,
                backgroundColor: Colors.grey);*/ /*
            _initUserData();
          } else {
            Fluttertoast.showToast(
                msg: "${result.errMsg}",
                textColor: Colors.white,
                backgroundColor: Colors.grey);
          }
        },*/
        child: Visibility(
          visible: !isDiamonVip,
          child: Container(
            width: ScreenUtil().setWidth(196),
            height: ScreenUtil().setHeight(79),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: _headBgColor,
                borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().setWidth(51))),
                border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                    color: _headBgColor,
                    width: 0.5)),
            child: Text(
              "点亮vip",
              style: TextStyle(
//                  color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(38)),
            ),
          ),
        ),
      ),
    );
  }

  void showMyDialog(
      {bool showNickName = false,
      bool showPhone = false,
      bool bindPhone = false,
      bool bindWeChatNo = false,
      bool modifyPhone = false,
      bool addExperienceAccount = false,
      bool showWeChatNo = false}) {
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
                        _dialogNickName = value.trim();
                      }),
                ),
              ),
              Visibility(
                visible: showPhone,
                child: Container(
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
                      controller: _dialogPhoneNumberController,
                      decoration: new InputDecoration(
                        hintText: _phoneHintText,
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
                        _dialogPhoneNumber = value.trim();
                      }),
                ),
              ),
              Visibility(
                visible: showWeChatNo,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  height: 46,
                  decoration: BoxDecoration(
                      color: Color(0xFFEFEFEF),
                      borderRadius: BorderRadius.all(Radius.circular(46))),
                  child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(fontSize: 14),
                      textInputAction: TextInputAction.send,
                      controller: _dialogWeChatNoController,
                      decoration: new InputDecoration(
                        hintText: '请输入您的微信号：',
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
                        _dialogWeChatNo = value.trim();
                      }),
                ),
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
                          if (showPhone) {
                            if ( //CommonUtils.isEmpty(dialogNickName) ||
                                CommonUtils.isEmpty(_dialogPhoneNumber)) {
                              Fluttertoast.showToast(
                                  msg: "请检查填写的信息是否完整！",
                                  textColor: Colors.white,
                                  backgroundColor: Colors.grey);
                              return;
                            }
                            if (!CommonUtils.isPhoneLegal(_dialogPhoneNumber)) {
                              CommonUtils.showSimplePromptDialog(
                                  context, "温馨提示", "请输入正确的手机号");
                              return;
                            }

                            if (bindPhone) {
                              //绑定手机号
                              var result = await HttpManage.bindPhone(
                                  tel: _dialogPhoneNumber.toString());
                              if (result.status) {
                                String isMerge =
                                    result.data["is_merge"].toString();
                                switch (isMerge) {
                                  case "1":
                                    Fluttertoast.showToast(
                                        msg: "手机号绑定成功！",
                                        textColor: Colors.white,
                                        backgroundColor: Colors.grey);
                                    _initUserData();
                                    break;

                                  case "2":
                                    Fluttertoast.showToast(
                                        msg: "手机账户数据合并成功，请重新登录！",
                                        textColor: Colors.white,
                                        toastLength: Toast.LENGTH_LONG,
                                        backgroundColor: Colors.grey);
                                    break;
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: "${result.errMsg}",
                                    textColor: Colors.white,
                                    backgroundColor: Colors.grey);
                              }
                            }
                            if (modifyPhone) {
                              //todo 修改手机号
                              var result = await HttpManage.bindPhone(
                                  tel: _dialogPhoneNumber.toString());
                              if (result.status) {
                                Fluttertoast.showToast(
                                    msg: "手机号修改成功！",
                                    textColor: Colors.white,
                                    backgroundColor: Colors.grey);
                                _initUserData();
                              } else {
                                Fluttertoast.showToast(
                                    msg: "${result.errMsg}",
                                    textColor: Colors.white,
                                    backgroundColor: Colors.grey);
                              }
                            }
                            if (addExperienceAccount) {
                              var result =
                                  await HttpManage.addExperienceMemberPhone(
                                      tel: _dialogPhoneNumber.toString());
                              if (result.status) {
                                Fluttertoast.showToast(
                                    msg: "体验会员添加成功！",
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
                          if (showWeChatNo) {
                            if ( //CommonUtils.isEmpty(dialogNickName) ||
                                CommonUtils.isEmpty(_dialogWeChatNo)) {
                              Fluttertoast.showToast(
                                  msg: "微信号不能为空！",
                                  textColor: Colors.white,
                                  backgroundColor: Colors.grey);
                              return;
                            }
                            if (bindWeChatNo) {
                              var result = await HttpManage.bindWeChatNo(
                                  _dialogWeChatNo.toString());
                              if (result.status) {
                                Fluttertoast.showToast(
                                    msg: "微信号绑定成功！",
                                    textColor: Colors.white,
                                    backgroundColor: Colors.grey);
                                _initUserData();
                              } else {
                                Fluttertoast.showToast(
                                    msg: "${result.errMsg}",
                                    textColor: Colors.white,
                                    backgroundColor: Colors.grey);
                              }
                            } else {
                              //微信号修改
                              var result = await HttpManage.modifyWeChatNo(
                                  _dialogWeChatNo.toString());
                              if (result.status) {
                                Fluttertoast.showToast(
                                    msg: "微信号修改成功！",
                                    textColor: Colors.white,
                                    backgroundColor: Colors.grey);
                                _initUserData();
                              } else {
                                Fluttertoast.showToast(
                                    msg: "${result.errMsg}",
                                    textColor: Colors.white,
                                    backgroundColor: Colors.grey);
                              }
                            }
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
