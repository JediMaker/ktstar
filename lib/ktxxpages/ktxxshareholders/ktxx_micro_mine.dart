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
import 'package:star/ktxxpages/ktxxshareholders/ktxx_micro_equity.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_dividend_list.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_fans_list.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_income_list.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_invitation_poster.dart';
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
//  return Column(
//  mainAxisSize: MainAxisSize.min,
//  children: <Widget>[
//  Stack(
//  overflow: Overflow.visible,
//  children: <Widget>[
//  GestureDetector(
//  onTap: () {
//  if (catg.name == listProfileCategories[0].name)
//  Navigator.pushNamed(context, '/furniture');
//  },
//  child: Container(
//  padding: EdgeInsets.all(10.0),
//  decoration: BoxDecoration(
//  shape: BoxShape.circle,
//  color: profile_info_categories_background,
//  ),
//  child: Icon(
//  catg.icon,
//  // size: 20.0,
//  ),
//  ),
//  ),
//  catg.number > 0
//  ? Positioned(
//  right: -5.0,
//  child: Container(
//  padding: EdgeInsets.all(5.0),
//  decoration: BoxDecoration(
//  color: profile_info_background,
//  shape: BoxShape.circle,
//  ),
//  child: Text(
//  catg.number.toString(),
//  style: TextStyle(
//  color: Colors.white,
//  fontSize: 10.0,
//  ),
//  ),
//  ),
//  )
//      : SizedBox(),
//  ],
//  ),
//  SizedBox(
//  height: 10.0,
//  ),
//  Text(
//  catg.name,
//  style: TextStyle(
//  fontSize: 13.0,
//  ),
//  )
//  ],
//  );
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
///微股东个人中心页面
class KeTaoFeaturedMicroMinePage extends StatefulWidget {
  KeTaoFeaturedMicroMinePage({Key key,  this.userInfoData}) : super(key: key);
  KeTaoFeaturedUserInfoData userInfoData;
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;
  @override
  _KeTaoFeaturedMicroMinePageState createState() => _KeTaoFeaturedMicroMinePageState();
}
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _KeTaoFeaturedMicroMinePageState extends State<KeTaoFeaturedMicroMinePage>
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
  var _isFirst = true;
  var _pwdStatus = '';
  var _title = '个人中心';
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

  ///是否是微股东
  int isItAMicroShareholder = -1;
  var _payPwdStatus = '1';

  ///账号类型 0普通用户 1体验用户 2VIP用户 3代理 4钻石会员
  String userType;
  KeTaoFeaturedUserInfoEntity entity;
  Color _cardTextColor = Color(0xffD6B78E);
  Color _headBgColor = Color(0xffF93736);

  var _yesterdayProfit = '';

  var _sevenDayProfit = '';

  var _monthProfit = '';

  var _totalProfit = '';

  var _todayShouldBeScoredRed = '';

  var _todayActualDividend = '';
  KeTaoFeaturedUserInfoData _data;

  var _currentDividend = '0';

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
          _title = result.data.isPartner == '1'
              ? '见习股东'
              : result.data.isPartner == '3'
              ? 'VIP股东'
              : '高级股东';
          if (result.data.isPartner == '2') {
            _title= '个人中心';
          }
          _yesterdayProfit = result.data.partnerBonus.yesterday;
          _sevenDayProfit = result.data.partnerBonus.week;
          _monthProfit = result.data.partnerBonus.month;
          _totalProfit = result.data.partnerBonus.total;
          _todayShouldBeScoredRed = result.data.partnerBonus.todayDeserve;
          _todayActualDividend = result.data.partnerBonus.todayPrice;
          _currentDividend = result.data.partnerBonus.coin;
          switch (result.data.type) {
            case "0":
              isDiamonVip = false;
              _cardBgImageName = 'task_mine_card_bg.png';
              break;
            case "1":
              isDiamonVip = false;
              _cardBgImageName = 'task_mine_card_bg_expirence.png';
              break;
            case "2":
              isDiamonVip = true;
              _cardBgImageName = 'task_mine_card_bg_vip.png';
              break;
            case "3":
//              #F8D9BA
              isDiamonVip = true;
              _cardBgImageName = 'task_mine_card_bg_proxy.png';
              break;
            case "4":
//              #F8D9BA
              isDiamonVip = true;
              _cardBgImageName = 'task_mine_card_bg_proxy.png';
              break;
          }
        });
      }
    }
  }

  _clearWidgetData() {
    if (mounted) {
      setState(() {
        try {
          _title = "个人中心";
          headUrl = '';
          nickName = '';
          userType = '';
          _phoneNumber = '';
          _totalAssetsAmount = '0';
          _cashWithdrawal = '0';
          _availableCashAmount = '0';
          isWeChatBinded = 0;
          _isWithdrawal = '';
          registerTime = '';
          _weChatNo = '';
          _code = '';
          _dialogWeChatNo = '';
          _pwdStatus = '';
          _payPwdStatus = '';
          isWeChatNoBinded = 0;
          isItAMicroShareholder = 0;
          _yesterdayProfit = '0';
          _sevenDayProfit = '0';
          _monthProfit = '0';
          _totalProfit = '0';
          _todayShouldBeScoredRed = '0';
          _todayActualDividend = '0';
          _currentDividend = '0';
        } catch (e) {}
      });
    }
  }

  @override
  void initState() {
    _dialogPhoneNumberController = new TextEditingController();
    _dialogNickNameController = new TextEditingController();
    _dialogWeChatNoController = new TextEditingController();
    initWeChatResHandler();
    _initUserData();
    super.initState();
  }

  void _initWidgetData() {
    if (mounted) {
      setState(() {
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
          _yesterdayProfit = _data.partnerBonus.yesterday;
          _sevenDayProfit = _data.partnerBonus.week;
          _monthProfit = _data.partnerBonus.month;
          _totalProfit = _data.partnerBonus.total;
          _todayShouldBeScoredRed = _data.partnerBonus.todayDeserve;
          _todayActualDividend = _data.partnerBonus.todayPrice;
          _currentDividend = _data.partnerBonus.coin;
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
      });
    }
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

  int count = 0;

  @override
  Widget build(BuildContext context) {
    ///    组件创建完成的回调通知方法
    ///解决首次数据加载失败问题
    ///
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!KeTaoFeaturedCommonUtils.isEmpty(nickName)) {
      } else {
        if (KeTaoFeaturedGlobalConfig.isLogin() && count == 0) {
          _clearWidgetData();
          _initUserData();
          count++;
        } else if (!KeTaoFeaturedGlobalConfig.isLogin()) {
          _clearWidgetData();
        }
      }
    });
    return Scaffold(
        appBar: GradientAppBar(
//          gradient: buildBackgroundLinearGradient(),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xffCE0100),
                Color(0xffCE0100),
              ]),
          brightness: Brightness.dark,
          title: Text(
            "${_title}",
            /*style: TextStyle(
                color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                fontSize: ScreenUtil().setSp(54)),*/
            style: TextStyle(
                color: Colors.white, fontSize: ScreenUtil().setSp(54)),
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
              completeDuration: Duration(milliseconds: 1000),
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
          Stack(
            children: [
              ClipPath(
                // 只裁切底部的方法
                clipper: BottomClipper(),
                child: Container(
                  height: ScreenUtil().setWidth(865),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xffCE0100),
                          Color(0xffD5433E),
                        ]),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
//                buildTopLayout(),
                  buildHeadLayout(),
                  dividendComparisonLayout(),
                  buildCardInfo(),
                  itemsLayout(),
                  GestureDetector(
                    onTap: () {
                      KeTaoFeaturedNavigatorUtils.navigatorRouter(
                          context, KeTaoFeaturedInvitationPosterPage());
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setWidth(10)),
                      child: CachedNetworkImage(
                          width: ScreenUtil().setWidth(1058),
                          height: ScreenUtil().setWidth(302),
                          imageUrl:
                          "https://alipic.lanhuapp.com/xd8c0b346a-86c3-4734-996d-2f9b553c9ffa"),
                    ),
                  )
                ],
              ),
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
      margin: EdgeInsets.only(
          left: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
          right: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
          bottom: ScreenUtil().setHeight(30)),
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
            margin:
            EdgeInsets.symmetric(horizontal: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
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
            margin:
            EdgeInsets.symmetric(horizontal: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
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
            margin:
            EdgeInsets.symmetric(horizontal: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
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
            margin:
            EdgeInsets.symmetric(horizontal: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
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
                  margin: EdgeInsets.symmetric(
                      horizontal: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
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
            margin:
            EdgeInsets.symmetric(horizontal: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
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
                  margin: EdgeInsets.symmetric(
                      horizontal: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
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
              margin:
              EdgeInsets.symmetric(horizontal: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
              child: Divider(
                height: ScreenUtil().setHeight(1),
                color: Color(0xFFefefef),
              ),
            ),
          ),
          Visibility(
            visible:
            KeTaoFeaturedGlobalConfig.prefs.getBool('isHuaweiUnderReview') == null ||
                KeTaoFeaturedGlobalConfig.prefs.getBool('isHuaweiUnderReview') ||
                    Platform.isIOS
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
            margin:
            EdgeInsets.symmetric(horizontal: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
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
                            _clearWidgetData();
                            Navigator.pop(context);
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
          margin: EdgeInsets.only(
              left: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
              right: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
              top: 10,
              bottom: 10),
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

  ///分红对比
  Widget dividendComparisonLayout() {
    Color _itemsTextColor = Color(0xffD6B78E);
    Color _itemsAmountColor = Color(0xffFFFFFF);
    return Container(
      height: ScreenUtil().setWidth(346),
      margin: EdgeInsets.only(
        left: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
        right: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
        top: ScreenUtil().setWidth(30),
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color(0xff2a2a2a),
        borderRadius: BorderRadius.all(
          Radius.circular(
            ScreenUtil().setWidth(28),
          ),
        ),
        /*border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
            color: Colors.white,
            width: 0.5),*/
      ),
      child: Column(
        children: [
          Flexible(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Flexible(
                  fit: FlexFit.tight,
                  child: new InkWell(
                      onTap: () async {
                        /* NavigatorUtils.navigatorRouter(
                            context,
                            FansListPage(
                              isAgent: userType == "3",
                            ));*/
                      },
                      child: new Container(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                              margin: EdgeInsets.only(
                                right: ScreenUtil().setWidth(31),
                              ),
                              child: new CircleAvatar(
                                radius: 20.0,
                                backgroundColor: Colors.transparent,
                                child: CachedNetworkImage(
                                  imageUrl:
                                  'https://alipic.lanhuapp.com/xd9d064c12-dae4-4e4e-9b68-e15530e3738b',
                                  width: ScreenUtil().setWidth(96),
                                  height: ScreenUtil().setWidth(84),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                new Container(
                                  margin: const EdgeInsets.only(
                                    bottom: 3.0,
                                  ),
                                  child: new Text(
                                    "今日应得分红",
                                    style: new TextStyle(
                                      fontSize: ScreenUtil().setSp(32),
                                      color: _itemsTextColor,
                                    ),
                                  ),
                                ),
                                new Container(
                                  child: new Text(
                                    "￥$_todayShouldBeScoredRed",
                                    style: new TextStyle(
                                      fontSize: ScreenUtil().setSp(42),
                                      fontWeight: FontWeight.bold,
                                      color: _itemsAmountColor,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                ),
                Center(
                  child: Container(
                    color: Color(0xff5A524D),
                    width: ScreenUtil().setWidth(1),
                    height: ScreenUtil().setWidth(57),
                  ),
                ),
                new Flexible(
                  fit: FlexFit.tight,
                  child: new InkWell(
                      onTap: () {
//                  NavigatorUtils.navigatorRouter(context, TaskMessagePage());
                      },
                      child: new Container(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                              margin: EdgeInsets.only(
                                right: ScreenUtil().setWidth(31),
                              ),
                              child: new CircleAvatar(
                                radius: 20.0,
                                backgroundColor: Colors.transparent,
                                child: CachedNetworkImage(
                                  imageUrl:
                                  'https://alipic.lanhuapp.com/xdab2f2767-766c-481a-8f03-b799963ad02c',
                                  width: ScreenUtil().setWidth(96),
                                  height: ScreenUtil().setWidth(84),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                new Container(
                                  margin: const EdgeInsets.only(
                                    bottom: 3.0,
                                  ),
                                  child: new Text("今日实际分红",
                                      style: new TextStyle(
                                          color: _itemsTextColor,
                                          fontSize: ScreenUtil().setSp(32))),
                                ),
                                new Container(
                                  child: new Text("￥$_todayActualDividend",
                                      style: new TextStyle(
                                          color: _itemsAmountColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: ScreenUtil().setSp(42))),
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),

          ///分红金展示
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              KeTaoFeaturedNavigatorUtils.navigatorRouter(context, KeTaoFeaturedDividendListPage());
            },
            child: Container(
              height: ScreenUtil().setWidth(100),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xffE4C2A0),
                  Color(0xffD9A573),
                  Color(0xffDBB893),
                ]),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    ScreenUtil().setWidth(28),
                  ),
                  bottomRight: Radius.circular(
                    ScreenUtil().setWidth(28),
                  ),
                ),
                /*border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
              color: Colors.white,
              width: 0.5),*/
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Text(
                        "当前分红金：$_currentDividend元",
                        style: new TextStyle(
                          color: Color(0xff3a3a3a),
                          fontSize: ScreenUtil().setSp(42),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(51),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      right: ScreenUtil().setWidth(51),
                    ),
                    child: CachedNetworkImage(
                        width: ScreenUtil().setWidth(20),
                        height: ScreenUtil().setWidth(35),
                        imageUrl:
                        "https://alipic.lanhuapp.com/xdf759159d-dc19-4470-9107-bae18bdaec20"),
                  ),
                ],
              ),
            ),
          ),

          ///
        ],
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
      margin: EdgeInsets.symmetric(horizontal: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
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
                  await KeTaoFeaturedNavigatorUtils.navigatorRouter(
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
                        margin: const EdgeInsets.only(bottom: 3.0),
                        child: new CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.transparent,
                          child: CachedNetworkImage(
                            imageUrl:
                            "https://alipic.lanhuapp.com/xd2b9a895d-1adc-4f52-9a44-4cd72cadf49a",
                            width: ScreenUtil().setWidth(128),
                            height: ScreenUtil().setWidth(128),
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
                        margin: const EdgeInsets.only(bottom: 3.0),
                        child: new CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.transparent,
                          child: CachedNetworkImage(
                            imageUrl:
                            "https://alipic.lanhuapp.com/xd0eec94ec-72c2-4fd6-8f3f-05fcb9776510",
                            width: ScreenUtil().setWidth(128),
                            height: ScreenUtil().setWidth(128),
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
                          margin: const EdgeInsets.only(bottom: 3.0),
                          child: new CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.transparent,
                            child: CachedNetworkImage(
                              imageUrl:
                              "https://alipic.lanhuapp.com/xdc4d43f07-fd79-4ff1-b120-8689edc7c87a",
                              width: ScreenUtil().setWidth(128),
                              height: ScreenUtil().setWidth(128),
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
                          margin: const EdgeInsets.only(bottom: 3.0),
                          child: new CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.transparent,
                            child: CachedNetworkImage(
                              imageUrl:
                              "https://alipic.lanhuapp.com/xdcfe85aee-2dfa-43bc-83db-bfeab39ce1dc",
                              width: ScreenUtil().setWidth(128),
                              height: ScreenUtil().setWidth(128),
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
          margin: EdgeInsets.only(
              top: 10,
              left: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
              right: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
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
          horizontal: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN,
          vertical: ScreenUtil().setHeight(30)),
      child: Stack(
        children: <Widget>[
          Container(
            width: double.maxFinite,
            child: Column(
              children: <Widget>[
                Container(
                  height: ScreenUtil().setWidth(241),
                  child: Row(
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
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(60)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "账户余额",
                                      style: TextStyle(
                                          color: Color(0xff292929),
                                          fontWeight: FontWeight.w600,
                                          fontSize: ScreenUtil().setSp(36)),
                                    ),
                                    Icon(Icons.arrow_right,
                                        color: Color(0xff292929),
                                        size: ScreenUtil().setSp(42)),
                                  ],
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(16),
                                ),
                                Container(
                                  child: Text(
                                    "${_availableCashAmount == null
                                        ? '0'
                                        : '$_availableCashAmount'}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Color(0xff292929),
                                        fontSize: ScreenUtil().setSp(81),
                                        fontWeight: FontWeight.w600),
                                  ),
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
                                  double.parse(
                                      _availableCashAmount.toString()) <=
                                      0) {
                                KeTaoFeaturedCommonUtils.showToast("暂无可提现金额");
                                return;
                              }
                            } catch (e) {}

                            if (_isWithdrawal == "0") {
                              await KeTaoFeaturedNavigatorUtils.navigatorRouter(
                                  context,
                                  KeTaoFeaturedWithdrawalPage(
                                      availableCashAmount:
                                      _availableCashAmount));
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
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(240)),
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: ScreenUtil().setWidth(196),
                              height: ScreenUtil().setWidth(79),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xff2a2a2a),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(ScreenUtil().setWidth(51))),
                              ),
                              child: Text(
                                "提现",
                                style: TextStyle(
//                  color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                                    color: Color(0xFFFFFFFF),
                                    fontSize: ScreenUtil().setSp(36)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffFFEDDF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        ScreenUtil().setWidth(30),
                      ),
                      topRight: Radius.circular(
                        ScreenUtil().setWidth(30),
                      ),
                    ),
                    image: DecorationImage(
                        image: Image
                            .network(
                            "https://alipic.lanhuapp.com/xd4e927536-e390-4733-8ac9-8d83f22dbd9a")
                            .image),
                  ),
                ),
                Container(
                  height: ScreenUtil().setWidth(186),
                  child: Row(
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
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(60)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "累计收益",
                                  style: TextStyle(
                                      color: Color(0xff999999),
                                      fontSize: ScreenUtil().setSp(36)),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(16),
                                ),
                                Text(
                                  "${_totalAssetsAmount == null
                                      ? '0'
                                      : '$_totalAssetsAmount'}",
                                  style: TextStyle(
                                    color: Color(0xff222222),
                                    fontSize: ScreenUtil().setSp(42),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          color: Color(0xffd1d1d1),
                          width: ScreenUtil().setWidth(1),
                          height: ScreenUtil().setWidth(88),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "已提现",
                                  style: TextStyle(
                                      color: Color(0xff999999),
                                      fontSize: ScreenUtil().setSp(36)),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(16),
                                ),
                                Text(
                                  "${_cashWithdrawal == null
                                      ? '0'
                                      : '$_cashWithdrawal'}",
                                  style: TextStyle(
                                    color: Color(0xff222222),
                                    fontSize: ScreenUtil().setSp(42),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    color: Color(0xffe6e6e6),
                    width: ScreenUtil().setWidth(955),
                    height: ScreenUtil().setWidth(1),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8, bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "昨日分红",
                              style: TextStyle(
                                color: Color(0xffB9B9B9),
                                fontSize: ScreenUtil().setSp(32),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(10),
                              ),
                              child: Text.rich(
                                TextSpan(children: [
                                  WidgetSpan(
                                    child: Visibility(
                                      child: Text(
                                        "¥",
                                        style: TextStyle(
                                          color: Color(0xff222222),
                                          fontSize: ScreenUtil().setSp(32),
                                        ),
                                      ),
                                      visible: _yesterdayProfit != '0',
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                    "${_yesterdayProfit == '0'
                                        ? '0.00'
                                        : '$_yesterdayProfit'}",
                                  ),
                                ]),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xff222222),
                                  fontSize: ScreenUtil().setSp(32),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ), //
                      Center(
                        child: Container(
                          color: Color(0xffd1d1d1),
                          width: ScreenUtil().setWidth(1),
                          height: ScreenUtil().setWidth(46),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "近1周",
                              style: TextStyle(
                                color: Color(0xffB9B9B9),
                                fontSize: ScreenUtil().setSp(32),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(10),
                              ),
                              child: Text.rich(
                                TextSpan(children: [
                                  WidgetSpan(
                                    child: Visibility(
                                      child: Text(
                                        "¥",
                                        style: TextStyle(
                                          color: Color(0xff222222),
                                          fontSize: ScreenUtil().setSp(32),
                                        ),
                                      ),
                                      visible: _sevenDayProfit != '0',
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                    "${_sevenDayProfit == '0'
                                        ? '0.00'
                                        : '$_sevenDayProfit'}",
                                  ),
                                ]),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xff222222),
                                  fontSize: ScreenUtil().setSp(32),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Container(
                          color: Color(0xffd1d1d1),
                          width: ScreenUtil().setWidth(1),
                          height: ScreenUtil().setWidth(46),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "近1月",
                              style: TextStyle(
                                color: Color(0xffB9B9B9),
                                fontSize: ScreenUtil().setSp(32),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(10),
                              ),
                              child: Text.rich(
                                TextSpan(children: [
                                  WidgetSpan(
                                    child: Visibility(
                                      child: Text(
                                        "¥",
                                        style: TextStyle(
                                          color: Color(0xff222222),
                                          fontSize: ScreenUtil().setSp(32),
                                        ),
                                      ),
                                      visible: _monthProfit != '0',
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                    "${_monthProfit == '0'
                                        ? '0.00'
                                        : '$_monthProfit'}",
                                  ),
                                ]),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xff222222),
                                  fontSize: ScreenUtil().setSp(32),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Container(
                          color: Color(0xffd1d1d1),
                          width: ScreenUtil().setWidth(1),
                          height: ScreenUtil().setWidth(46),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "总分红",
                              style: TextStyle(
                                color: Color(0xffB9B9B9),
                                fontSize: ScreenUtil().setSp(32),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(10),
                              ),
                              child: Text.rich(
                                TextSpan(children: [
                                  WidgetSpan(
                                    child: Visibility(
                                      child: Text(
                                        "¥",
                                        style: TextStyle(
                                          color: Color(0xff222222),
                                          fontSize: ScreenUtil().setSp(32),
                                        ),
                                      ),
                                      visible: _totalProfit != '0',
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                    "${_totalProfit == '0'
                                        ? '0.00'
                                        : '$_totalProfit'}",
                                  ),
                                ]),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xff222222),
                                  fontSize: ScreenUtil().setSp(32),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
    text = _title;
    if (_title== '个人中心') {
      text = "普通用户";
    }
    if (!KeTaoFeaturedGlobalConfig.isLogin()) {
      nickName = "登陆/注册";
    }
    return Stack(
      children: [
        Container(
          width: ScreenUtil().setWidth(168),
          height: ScreenUtil().setWidth(200),
          margin: EdgeInsets.symmetric(horizontal: KeTaoFeaturedGlobalConfig.LAYOUT_MARGIN),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Positioned(
                bottom: ScreenUtil().setWidth(25),
                child: Container(
                  /* margin: EdgeInsets.only(
                      bottom: ScreenUtil().setWidth(25),
                    ),*/
                  child: headUrl == null
                      ? Visibility(
                      visible: false,
                      child: Image.asset(
                        "static/images/task_default_head.png",
                        width: ScreenUtil().setWidth(158),
                        height: ScreenUtil().setWidth(158),
                        fit: BoxFit.fill,
                      ))
                      : ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: "$headUrl",
                      fit: BoxFit.fill,
                      width: ScreenUtil().setWidth(158),
                      height: ScreenUtil().setWidth(158),
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Visibility(
//              visible: false,
                    child: Container(
                      child: Container(
                          width: ScreenUtil().setWidth(164),
                          height: ScreenUtil().setWidth(56),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(ScreenUtil().setWidth(28))),
                            gradient: LinearGradient(colors: [
                              Color(0xff505050),
                              Color(0xff222222),
                            ]),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                imageUrl:
                                'https://alipic.lanhuapp.com/xd85fc7a67-0912-4f32-91c3-f907fdc9284d',
                                width: ScreenUtil().setWidth(20),
                                height: ScreenUtil().setWidth(25),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(6),
                                  bottom: ScreenUtil().setWidth(6),
                                ),
                                child: Text("$text",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: _cardTextColor,
                                      fontSize: ScreenUtil().setSp(28),
                                    )),
                              ),
                            ],
                          )),
                    )),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(188),
          ),
          child: ListTile(
            onTap: () async {
              if (!KeTaoFeaturedGlobalConfig.isLogin()) {
                KeTaoFeaturedNavigatorUtils.navigatorRouter(context, KeTaoFeaturedLoginPage());
                return;
              }
              await KeTaoFeaturedNavigatorUtils.navigatorRouter(
                  context, KeTaoFeaturedMicroShareHolderEquityPage());
              _initUserData();
            },
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
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(42)),
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(26),
                  ),
                  Visibility(
                    visible: false,
                    child: Image.asset(
                      "static/images/${_getImgName(userType)}",
                      width: ScreenUtil().setWidth(185),
                      height: ScreenUtil().setHeight(67),
                      fit: BoxFit.fill,
                    ),
                  ),
//            Image.asset("", width:)
                ],
              ),
            ),
            subtitle: Text(
              "邀请码：${_code == null ? '' : _code}",
              style: TextStyle(
                  color: Colors.white, fontSize: ScreenUtil().setSp(42)),
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
                child: Container(
                  width: ScreenUtil().setWidth(236),
                  height: ScreenUtil().setWidth(83),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    /*gradient: LinearGradient(colors: [
                      Color(0xff252525),
                      Color(0xff414141),
                    ]),*/
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(51))),
                    border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                        color: Color(0xffFFFFFF),
                        width: ScreenUtil().setWidth(2)),
                  ),
                  child: Text(
                    "升级股东",
                    style: TextStyle(
//                  color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
                        color: Color(0xffFFFFFF),
                        fontSize: ScreenUtil().setSp(36)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showMyDialog({bool showNickName = false,
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
