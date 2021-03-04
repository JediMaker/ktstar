import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:star/ktxxhttp/ktxx_http_manage.dart';
import 'package:star/ktxxmodels/ktxx_user_info_entity.dart';
import 'package:star/ktxxpages/ktxxadress/ktxx_my_adress.dart';
import 'package:star/ktxxpages/ktxxgoods/ktxx_free_queue_persional.dart';
import 'package:star/ktxxpages/ktxxlogin/ktxx_login.dart';
import 'package:star/ktxxpages/ktxxlogin/ktxx_modify_password.dart';
import 'package:star/ktxxpages/ktxxorder/ktxx_order_list.dart';
import 'package:star/ktxxpages/ktxxorder/ktxx_recharge_order_list.dart';
import 'package:star/ktxxpages/ktxxrecharge/ktxx_recharge_result.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_new_income_list.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_pay_result.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_about.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_message.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_open_diamond.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_open_diamond_dialog.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_open_vip.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_record_list.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_safe_setting.dart';
import 'package:star/ktxxpages/ktxxwithdrawal/ktxx_withdrawal.dart';
import 'package:star/ktxxutils/ktxx_common_utils.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:star/ktxxutils/ktxx_navigator_utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:star/ktxxutils/ktxx_utils.dart';

import '../../ktxx_global_config.dart';
import 'ktxx_fans_list.dart';
import 'ktxx_income_list.dart';
import 'ktxx_invitation_poster.dart';
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedTaskMinePage extends StatefulWidget {
  KeTaoFeaturedTaskMinePage({Key key, this.userInfoData}) : super(key: key);
  final String title = "个人中心";
  UserInfoData userInfoData;
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;
  @override
  _KeTaoFeaturedTaskMinePageState createState() => _KeTaoFeaturedTaskMinePageState();
}
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _KeTaoFeaturedTaskMinePageState extends State<KeTaoFeaturedTaskMinePage>
    with AutomaticKeepAliveClientMixin {
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
  var _pwdStatus = '';
  TextEditingController _dialogPhoneNumberController;
  TextEditingController _dialogNickNameController;
  TextEditingController _dialogWeChatNoController;
//    Container(
//height: 6.0,
//width: 6.0,
//decoration: BoxDecoration(
//color: furnitureCateDisableColor,
//shape: BoxShape.circle,
//),
//),
//SizedBox(
//width: 5.0,
//),
//Container(
//height: 5.0,
//width: 20.0,
//decoration: BoxDecoration(
//color: Colors.blue[700],
//borderRadius: BorderRadius.circular(10.0)),
//),
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

  ///是否是微股东
  int isItAMicroShareholder = -1;
  var _payPwdStatus = '1';

  ///账号类型 0普通用户 1体验用户 2VIP用户 3代理 4钻石会员
  String userType;
  UserInfoEntity entity;
  Color _cardTextColor = Colors.white;
  Color _headBgColor = Color(0xffF93736);
  UserInfoData _data;

  _initUserData() async {
    var result = await KeTaoFeaturedHttpManage.getUserInfo();
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
          _pwdStatus = result.data.pwdStatus;
          _payPwdStatus = result.data.payPwdStatus;
          isWeChatNoBinded = !KeTaoFeaturedCommonUtils.isEmpty(result.data.wxNo) ? 1 : 0;
          isItAMicroShareholder = result.data.isPartner == "1" ? 1 : 0;
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
            case "4":
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
    initWeChatResHandler();
    try {
      _data = widget.userInfoData;
      headUrl = _data.avatar;
      nickName = _data.username;
      userType = _data.type;
      _phoneNumber = _data.tel;
      _totalAssetsAmount = _data.totalPrice;
      _cashWithdrawal = _data.txPrice;
      _availableCashAmount = _data.nowPrice;
      isWeChatBinded = _data.bindThird;
      _isWithdrawal = _data.isWithdrawal;
      registerTime = _data.regDate;
      _weChatNo = _data.wxNo;
      _code = _data.code;
      _dialogWeChatNo = _data.wxNo;
      _pwdStatus = _data.pwdStatus;
      _payPwdStatus = _data.payPwdStatus;
      isWeChatNoBinded = !KeTaoFeaturedCommonUtils.isEmpty(_data.wxNo) ? 1 : 0;
      isItAMicroShareholder = _data.isPartner == "1" ? 1 : 0;
      switch (_data.type) {
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
        case "4":
//              #F8D9BA
          isDiamonVip = true;
          _cardTextColor = Color(0xffF8D9BA);
          _cardBgImageName = 'task_mine_card_bg_proxy.png';
          break;
      }
    } catch (e) {}

    super.initState();
  }

  initWeChatResHandler() async {
    KeTaoFeaturedGlobalConfig.isBindWechat = true;
    fluwx.weChatResponseEventHandler
        .distinct((a, b) => a == b)
        .listen((res) async {
      if (res is fluwx.WeChatAuthResponse) {
        print("微信授权结果：" + "state :${res.state} \n code:${res.code}");
        print("微信授权code" + res.code.toString());
        if (KeTaoFeaturedCommonUtils.isEmpty(res.code)) {
          KeTaoFeaturedCommonUtils.showToast("微信授权获取失败，请重新授权！");
        } else {
          /* Fluttertoast.showToast(
              msg: "微信授权获取成功，正在登录！",
              textColor: Colors.white,
              backgroundColor: Colors.grey);*/
          if (KeTaoFeaturedGlobalConfig.isBindWechat) {
            var result = await KeTaoFeaturedHttpManage.bindWechat(res.code);
            if (result.status) {
              String isMerge = result.data["is_merge"].toString();
              switch (isMerge) {
                case "1":
                  KeTaoFeaturedCommonUtils.showToast("微信授权绑定成功");
                  break;
                case "2":
                  KeTaoFeaturedCommonUtils.showToast("微信账户数据合并成功，请重新登录！");
                  break;
              }
            } else {
              KeTaoFeaturedCommonUtils.showToast(result.errMsg);
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
    ///    组件创建完成的回调通知方法
    ///解决首次数据加载失败问题
    ///
    /* WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!CommonUtils.isEmpty(headUrl)) {
      } else {
        _initUserData();
      }
    });*/
    return Scaffold(
        appBar: GradientAppBar(
//          gradient: buildBackgroundLinearGradient(),
          gradient: LinearGradient(colors: [
//            Color(0xfff5f5f5),
//            Color(0xfff5f5f5),
            KeTaoFeaturedGlobalConfig.taskNomalHeadColor,
            KeTaoFeaturedGlobalConfig.taskNomalHeadColor,
          ]),
          brightness: Brightness.light,
          title: Text(
            "个人中心",
            /*style: TextStyle(
                color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                fontSize: ScreenUtil().setSp(54)),*/
            style: TextStyle(
                color: Color(0xFF222222), fontSize: ScreenUtil().setSp(54)),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: EasyRefresh.custom(
          enableControlFinishLoad: false,
          onRefresh: () async {
            _initUserData();
          },
          header: CustomHeader(
//              completeDuration: Duration(seconds: 2),
              headerBuilder: (context,
                  refreshState,
                  pulledExtent,
                  refreshTriggerPullDistance,
                  refreshIndicatorExtent,
                  axisDirection,
                  float,
                  completeDuration,
                  enableInfiniteRefresh,
                  success,
                  noMore) {
                return Stack(
                  children: <Widget>[
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        width: 30.0,
                        height: 30.0,
                        child: SpinKitCircle(
                          color: KeTaoFeaturedGlobalConfig.taskBtnTxtGreyColor,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ],
                );
              }),
          slivers: <Widget>[
            buildContent(),
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget buildContent() {
    return SliverToBoxAdapter(
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
    );
  }

  Container buildListItem() {
    var bindWechatText = "";
    var title = "设置密码";
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
    var whetherMicroShareholder = "";
    switch (isItAMicroShareholder) {
      case 0:
        whetherMicroShareholder = "申请";
        break;
      case 1:
        whetherMicroShareholder = '已开通';
        break;
      default:
        whetherMicroShareholder = "申请";
        break;
    }
    switch (_pwdStatus) {
      case "1":
        break;
      case "2":
        title = "修改密码";
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
                  "微股东",
                  style: TextStyle(
//                color:  Color(0xFF222222) ,
                      fontSize: ScreenUtil().setSp(38)),
                ),
              ],
            ),
            onTap: () async {
              if (isItAMicroShareholder != 1) {
                //
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        content: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              '自2021年1月1日起，实付消费金额达300元即可申请成为微股东，享受每日微股东分红权益',
                              style: TextStyle(
//                color:  Color(0xFF222222) ,
                                fontSize: ScreenUtil().setSp(42),
                              ),
                            )),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            child: Text(
                              '取消',
                              style: TextStyle(
                                color: Color(0xff222222),
                                fontSize: ScreenUtil().setSp(42),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoDialogAction(
                            child: Text(
                              '确定',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(42),
                              ),
                            ),
                            onPressed: () async {
                              var result = await KeTaoFeaturedHttpManage
                                  .applyToBecomeAMicroShareholder();
                              if (result.status) {
                                KeTaoFeaturedCommonUtils.showToast("微股东申请开通成功！");
                              } else {
                                KeTaoFeaturedCommonUtils.showToast("${result.errMsg}");
                              }
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              }
            },
            trailing: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Container(
                  child: Text(
                    "$whetherMicroShareholder",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(38),
                        color: isItAMicroShareholder != 1
                            ? Color(0xffF93736)
                            : Color(0xff999999)),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: ScreenUtil().setWidth(200),
                  ),
                ),
                /*Text(
                  "\t>",
                  style: TextStyle(color: Color(0xff999999)),
                ),*/
                Visibility(
                  visible: isItAMicroShareholder != 1,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: ScreenUtil().setWidth(32),
                    color: Color(0xff999999),
                  ),
                ),
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
                /*  Image.asset(
                  "static/images/icon_fans.png",
                  width: ScreenUtil().setWidth(44),
                  height: ScreenUtil().setWidth(71),
                ),*/
                Text(
                  "收货地址",
                  style: TextStyle(
//                color:  Color(0xFF222222) ,
                      fontSize: ScreenUtil().setSp(38)),
                ),
              ],
            ),
            onTap: () {
              KeTaoFeaturedNavigatorUtils.navigatorRouter(context, KeTaoFeaturedAddressListPage(type: 1));
            },
            trailing: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                /*Text(
                  "",
                  style: TextStyle(color: Color(0xff999999)),
                ),*/
                Icon(
                  Icons.arrow_forward_ios,
                  size: ScreenUtil().setWidth(32),
                  color: Color(0xff999999),
                ),
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
              if (KeTaoFeaturedCommonUtils.isEmpty(_phoneNumber)) {
                _dialogPhoneNumberController.text = "";
                //绑定手机号
                showMyDialog(showPhone: true, bindPhone: true);
              } else {
                _dialogPhoneNumberController.text = _phoneNumber;
                //修改手机号
                showMyDialog(showPhone: true, modifyPhone: true);
              }
            },
            trailing: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Text(
                  _phoneNumber == null ? "" : _phoneNumber,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(38),
                      color: Color(0xff999999)),
                ),
                /*Text(
                  "",
                  style: TextStyle(color: Color(0xff999999)),
                ),*/
                Icon(
                  Icons.arrow_forward_ios,
                  size: ScreenUtil().setWidth(32),
                  color: Color(0xff999999),
                ),
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
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Text(
                  bindWechatText,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(38),
                      color: isWeChatBinded == 1
                          ? Color(0xffF93736)
                          : Color(0xff999999)),
                ),
                /* Text(
                  isWeChatBinded == 1 ? "\t>" : "",
                  style: TextStyle(color: Color(0xff999999)),
                ),*/
                Visibility(
                    visible: isWeChatBinded == 1,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: ScreenUtil().setWidth(32),
                      color: Color(0xff999999),
                    )),
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
                Container(
                  child: Text(
                    "微信号输入",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
//                color:  Color(0xFF222222) ,
                        fontSize: ScreenUtil().setSp(38)),
                  ),
                ),
                Container(
                  child: Text(
                    "(便于您的粉丝联系您)",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: ScreenUtil().setSp(32)),
                  ),
                ),
              ],
            ),
            onTap: () {
              //todo 绑定微信号
              if (KeTaoFeaturedCommonUtils.isEmpty(_weChatNo)) {
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
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Container(
                  child: Text(
                    bindWechatNoText,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(38),
                        color: isWeChatNoBinded == 0
                            ? Color(0xffF93736)
                            : Color(0xff999999)),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: ScreenUtil().setWidth(200),
                  ),
                ),
                /*Text(
                  "\t>",
                  style: TextStyle(color: Color(0xff999999)),
                ),*/
                Icon(
                  Icons.arrow_forward_ios,
                  size: ScreenUtil().setWidth(32),
                  color: Color(0xff999999),
                ),
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
            visible: true,
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
                        title,
                        style: TextStyle(
//                color:  Color(0xFF222222) ,
                            fontSize: ScreenUtil().setSp(38)),
                      ),
                    ],
                  ),
                  onTap: () async {
                    await KeTaoFeaturedNavigatorUtils.navigatorRouter(
                        context,
                        KeTaoFeaturedModifyPasswordPage(
                          title: title,
                        ));
                    _initUserData();
                  },
                  trailing: Wrap(
                    children: <Widget>[
                      /*Text(
                        "\t>",
                        style: TextStyle(color: Color(0xff999999)),
                      )*/
                      Icon(
                        Icons.arrow_forward_ios,
                        size: ScreenUtil().setWidth(32),
                        color: Color(0xff999999),
                      ),
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
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
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
            visible: true,
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
                    KeTaoFeaturedNavigatorUtils.navigatorRouter(context, KeTaoFeaturedAboutPage());
                  },
                  trailing: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      /* Text(
                        "\t>",
                        style: TextStyle(color: Color(0xff999999)),
                      ),*/
                      Icon(
                        Icons.arrow_forward_ios,
                        size: ScreenUtil().setWidth(32),
                        color: Color(0xff999999),
                      ),
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
          Visibility(
            //todo
            visible: true,
            child: ListTile(
              title: Row(
                children: <Widget>[
                  /* Image.asset(
                    "static/images/icon_fans.png",
                    width: ScreenUtil().setWidth(44),
                    height: ScreenUtil().setWidth(71),
                  ),*/
                  Text(
                    "安全设置",
                    style: TextStyle(
//                color:  Color(0xFF222222) ,
                        fontSize: ScreenUtil().setSp(38)),
                  ),
                ],
              ),
              onTap: () {
                KeTaoFeaturedNavigatorUtils.navigatorRouter(
                    context,
                    KeTaoFeaturedSafeSettingsPage(
                      hasPayPassword: _payPwdStatus == "2",
                      phoneNum: _phoneNumber,
                    ));
              },
              trailing: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.arrow_forward_ios,
                    size: ScreenUtil().setWidth(32),
                    color: Color(0xff999999),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: KeTaoFeaturedGlobalConfig.prefs.getBool('needUpdate') == null
                ? false
                : KeTaoFeaturedGlobalConfig.prefs.getBool('needUpdate'),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                height: ScreenUtil().setHeight(1),
                color: Color(0xFFefefef),
              ),
            ),
          ),
          Visibility(
            visible:
                KeTaoFeaturedGlobalConfig.prefs.getBool('isHuaweiUnderReview') == null ||
                        (KeTaoFeaturedGlobalConfig.prefs.getBool('isHuaweiUnderReview') &&
                            Platform.isIOS)
                    ? false
                    : true,
            child: ListTile(
              title: Row(
                children: <Widget>[
                  /* Image.asset(
                    "static/images/icon_fans.png",
                    width: ScreenUtil().setWidth(44),
                    height: ScreenUtil().setWidth(71),
                  ),*/
                  Text(
                    "检测更新",
                    style: TextStyle(
//                color:  Color(0xFF222222) ,
                        fontSize: ScreenUtil().setSp(38)),
                  ),
                ],
              ),
              onTap: () {
                KeTaoFeaturedUtils.checkAppVersion(context, checkDerictly: true);
              },
              trailing: Visibility(
                visible: KeTaoFeaturedGlobalConfig.prefs.getBool('needUpdate') == null
                    ? false
                    : KeTaoFeaturedGlobalConfig.prefs.getBool('needUpdate'),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Text(
                      "有新版本可以更新",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: ScreenUtil().setSp(38)),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: ScreenUtil().setWidth(32),
                      color: Color(0xff999999),
                    ),
                  ],
                ),
              ),
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
                            style: TextStyle(color: KeTaoFeaturedGlobalConfig.checkedColor),
                          ),
                          onPressed: () {
                            KeTaoFeaturedGlobalConfig.prefs.remove("hasLogin");
                            KeTaoFeaturedGlobalConfig.prefs.remove("token");
                            KeTaoFeaturedGlobalConfig.prefs.remove("loginData");
                            KeTaoFeaturedGlobalConfig.saveLoginStatus(false);
                            KeTaoFeaturedNavigatorUtils.navigatorRouter(
                                context, KeTaoFeaturedLoginPage());
                          },
                        ),
                      ],
                    );
                  });
            },
            trailing: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
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
                  KeTaoFeaturedNavigatorUtils.navigatorRouter(
                      context,
                      KeTaoFeaturedFansListPage(
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
                  KeTaoFeaturedNavigatorUtils.navigatorRouter(context, KeTaoFeaturedTaskMessagePage());
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
                      KeTaoFeaturedNavigatorUtils.navigatorRouter(
                          context, KeTaoFeaturedTaskRecordListPage());
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
                    /* Fluttertoast.showToast(
                        msg: "暂未开放",
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        gravity: ToastGravity.BOTTOM);
                    return;*/
                    KeTaoFeaturedNavigatorUtils.navigatorRouter(context, KeTaoFeaturedOrderListPage());
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
                    /* Fluttertoast.showToast(
                        msg: "暂未开放",
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        gravity: ToastGravity.BOTTOM);
                    return;*/
                    KeTaoFeaturedNavigatorUtils.navigatorRouter(
                        context, KeTaoFeaturedInvitationPosterPage());
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
          return KeTaoFeaturedTaskOpenDiamondPage();
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
      elevation: 0,
      margin: EdgeInsets.symmetric(
          horizontal: 16, vertical: ScreenUtil().setHeight(39)),
      child: Stack(
        children: <Widget>[
          /* Image.asset(
            "static/images/$_cardBgImageName",
            fit: BoxFit.fill,
          ),*/
          Container(
            height: ScreenUtil().setHeight(490),
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
                          KeTaoFeaturedNavigatorUtils.navigatorRouter(
                              context, KeTaoFeaturedNewIncomeListPage());
                        },
                        child: Container(
                          //
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
                            if (KeTaoFeaturedCommonUtils.isEmpty(_availableCashAmount) ||
                                double.parse(_availableCashAmount.toString()) <=
                                    0) {
                              KeTaoFeaturedCommonUtils.showToast("暂无可提现金额");
                              return;
                            }
                          } catch (e) {}

                          if (_isWithdrawal == "0") {
                            await KeTaoFeaturedNavigatorUtils.navigatorRouter(
                                context,
                                KeTaoFeaturedWithdrawalPage(
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
                            KeTaoFeaturedCommonUtils.showToast("暂不可提现");
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
                  height: ScreenUtil().setHeight(81),
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap: () {
                          KeTaoFeaturedNavigatorUtils.navigatorRouter(
                              context, KeTaoFeaturedNewIncomeListPage());
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
                          KeTaoFeaturedNavigatorUtils.navigatorRouter(
                              context,
                              KeTaoFeaturedIncomeListPage(
                                pageType: 2,
                                showAppBar: true,
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
      case "4":
        return "icon_diamond.png";
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
        text = "vip会员";
        break;
      case "3":
        text = "代理";
        break;
      case "4":
        text = "钻石会员";
        break;
    }
    return ListTile(
      onTap: () async {
        switch (userType) {
          case "0":
          case "1":
            if (Platform.isIOS) {
              KeTaoFeaturedCommonUtils.showIosPayDialog();
              return;
            }
            await KeTaoFeaturedNavigatorUtils.navigatorRouter(context, KeTaoFeaturedTaskOpenVipPage());
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
                                KeTaoFeaturedCommonUtils.isEmpty(_dialogPhoneNumber)) {
                              KeTaoFeaturedCommonUtils.showToast("请检查填写的信息是否完整！");
                              return;
                            }
                            if (!KeTaoFeaturedCommonUtils.isPhoneLegal(_dialogPhoneNumber)) {
                              KeTaoFeaturedCommonUtils.showSimplePromptDialog(
                                  context, "温馨提示", "请输入正确的手机号");
                              return;
                            }

                            if (bindPhone) {
                              //绑定手机号
                              var result = await KeTaoFeaturedHttpManage.bindPhone(
                                  tel: _dialogPhoneNumber.toString());
                              if (result.status) {
                                String isMerge =
                                    result.data["is_merge"].toString();
                                switch (isMerge) {
                                  case "1":
                                    KeTaoFeaturedCommonUtils.showToast("手机号绑定成功");
                                    _initUserData();
                                    break;

                                  case "2":
                                    KeTaoFeaturedCommonUtils.showToast("手机账户数据合并成功，请重新登录！");
                                    break;
                                }
                              } else {
                                KeTaoFeaturedCommonUtils.showToast(result.errMsg);
                              }
                            }
                            if (modifyPhone) {
                              //todo 修改手机号
                              var result = await KeTaoFeaturedHttpManage.bindPhone(
                                  tel: _dialogPhoneNumber.toString());
                              if (result.status) {
                                KeTaoFeaturedCommonUtils.showToast("手机号修改成功");
                                _initUserData();
                              } else {
                                KeTaoFeaturedCommonUtils.showToast(result.errMsg);
                              }
                            }
                            if (addExperienceAccount) {
                              var result =
                                  await KeTaoFeaturedHttpManage.addExperienceMemberPhone(
                                      tel: _dialogPhoneNumber.toString());
                              if (result.status) {
                                KeTaoFeaturedCommonUtils.showToast("体验会员添加成功");
                              } else {
                                KeTaoFeaturedCommonUtils.showToast(result.errMsg);
                              }
                            }
                          }
                          if (showWeChatNo) {
                            if ( //CommonUtils.isEmpty(dialogNickName) ||
                                KeTaoFeaturedCommonUtils.isEmpty(_dialogWeChatNo)) {
                              KeTaoFeaturedCommonUtils.showToast("微信号不能为空！");
                              return;
                            }
                            if (bindWeChatNo) {
                              var result = await KeTaoFeaturedHttpManage.bindWeChatNo(
                                  _dialogWeChatNo.toString());
                              if (result.status) {
                                KeTaoFeaturedCommonUtils.showToast("微信号绑定成功");
                                _initUserData();
                              } else {
                                KeTaoFeaturedCommonUtils.showToast(result.errMsg);
                              }
                            } else {
                              //微信号修改
                              var result = await KeTaoFeaturedHttpManage.modifyWeChatNo(
                                  _dialogWeChatNo.toString());
                              if (result.status) {
                                KeTaoFeaturedCommonUtils.showToast("微信号修改成功");
                                _initUserData();
                              } else {
                                KeTaoFeaturedCommonUtils.showToast(result.errMsg);
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
