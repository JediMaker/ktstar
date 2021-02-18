import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/ktxxhttp/ktxx_http_manage.dart';
import 'package:star/ktxxpages/ktxxwithdrawal/ktxx_withdrawal_result.dart';
import 'package:star/ktxxutils/ktxx_common_utils.dart';
import 'package:star/ktxxutils/ktxx_navigator_utils.dart';

import '../../ktxx_global_config.dart';

class KeTaoFeaturedWithdrawalPage extends StatefulWidget {
  KeTaoFeaturedWithdrawalPage({Key key, @required this.availableCashAmount})
      : super(key: key);
  final String title = "提现";
  String availableCashAmount; // 可提现金额

  @override
  _KeTaoFeaturedWithdrawalPageState createState() => _KeTaoFeaturedWithdrawalPageState();
}

class _KeTaoFeaturedWithdrawalPageState extends State<KeTaoFeaturedWithdrawalPage> {
  bool _aliPaySelected = true;
  TextEditingController _aliPayAccountController = new TextEditingController();
  FocusNode _aliPayAccountFocusNode = FocusNode();
  String _aliPayAccount;
  TextEditingController _aliPayNameController = new TextEditingController();
  FocusNode _aliPayNameFocusNode = FocusNode();
  String _aliPayName;
  TextEditingController _withdrawalAmountController =
      new TextEditingController();
  FocusNode _withdrawalAmountFocusNode = FocusNode();
  String _withdrawalAmount;

  bool startFlag = false;
  String lastDate = '';

  var _desc = '';

  _initData() async {
    var result = await KeTaoFeaturedHttpManage.getWithdrawalUserInfo();
    if (result.status) {
      if (mounted) {
        setState(() {
          try {
            _aliPayAccountController.text = result.data.user.zfbAccount;
            _aliPayAccount = result.data.user.zfbAccount;
            _aliPayNameController.text = result.data.user.zfbName;
            _aliPayName = result.data.user.zfbName;
            widget.availableCashAmount = result.data.user.price;
            startFlag = result.data.startFlag;
            lastDate = result.data.lastDate;
            if (!startFlag) {
              _desc = '限时免费（截止日期：$lastDate）';
            }
          } catch (e) {}
        });
      }
    }
  }

  @override
  void initState() {
//    var text = "13122223333".replaceFirst(new RegExp(r'\d{4}'), '****', 3);
    _initData();
    super.initState();
  }

  @override
  void dispose() {
    _aliPayAccountController.dispose();
    _aliPayAccountFocusNode.dispose();
    _aliPayNameController.dispose();
    _aliPayNameFocusNode.dispose();
    _withdrawalAmountFocusNode.dispose();
    _withdrawalAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
      child: KeyboardDismissOnTap(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                widget.title,
                style: TextStyle(
                    color: Color(0xFF222222), fontSize: ScreenUtil().setSp(54)),
              ),
              brightness: Brightness.light,
              leading: IconButton(
                icon: Image.asset(
                  "static/images/list_return.png",
                  width: ScreenUtil().setWidth(63),
                  height: ScreenUtil().setHeight(44),
                  fit: BoxFit.fill,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              centerTitle: true,
              backgroundColor: KeTaoFeaturedGlobalConfig.taskNomalHeadColor,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(top: 16),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "提现方式",
                          style: TextStyle(
//                color:  Color(0xFF222222) ,
                              fontSize: ScreenUtil().setSp(48)),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(55),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap: () {
                                    if (mounted) {
                                      setState(() {
                                        _aliPaySelected = true;
                                      });
                                    }
                                  },
                                  child: Stack(
                                    alignment: Alignment.topLeft,
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.center,
                                        width: ScreenUtil().setWidth(500),
                                        height: ScreenUtil().setHeight(127),
                                        decoration: BoxDecoration(
                                          color: _aliPaySelected
                                              ? Colors.white
                                              : Color(0xffEFEFEF),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  ScreenUtil().setWidth(20))),
                                          border: Border.all(
                                              color: _aliPaySelected
                                                  ? Color(0xffF32E43)
                                                  : Color(0xffEFEFEF),
                                              width: 0.5),
                                        ),
                                        child: Wrap(
                                          alignment: WrapAlignment.center,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          spacing: ScreenUtil().setWidth(21),
                                          children: <Widget>[
                                            Image.asset(
                                              "static/images/withdrawal_zfb.png",
                                              width: ScreenUtil().setWidth(63),
                                              height: ScreenUtil().setWidth(63),
                                              fit: BoxFit.fill,
                                            ),
                                            Text(
                                              "支付宝",
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(48)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: _aliPaySelected,
                                        child: Image.asset(
                                          "static/images/withdrawal_checked.png",
                                          width: ScreenUtil().setWidth(72),
                                          height: ScreenUtil().setHeight(59),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap: () {
                                    if (mounted) {
                                      setState(() {
//                                _aliPaySelected = false;
                                        KeTaoFeaturedCommonUtils.showToast("暂不支持提现到微信");
                                      });
                                    }
                                  },
                                  child: Stack(
                                    alignment: Alignment.topLeft,
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.center,
                                        width: ScreenUtil().setWidth(500),
                                        height: ScreenUtil().setHeight(127),
                                        decoration: BoxDecoration(
                                          color: !_aliPaySelected
                                              ? Colors.white
                                              : Color(0xffEFEFEF),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  ScreenUtil().setWidth(20))),
                                          border: Border.all(
                                              color: !_aliPaySelected
                                                  ? Color(0xffF32E43)
                                                  : Color(0xffEFEFEF),
                                              width: 0.5),
                                        ),
                                        child: Wrap(
                                          spacing: ScreenUtil().setWidth(21),
                                          alignment: WrapAlignment.center,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: <Widget>[
                                            Image.asset(
                                              "static/images/withdrawal_wx.png",
                                              width: ScreenUtil().setWidth(63),
                                              height: ScreenUtil().setWidth(63),
                                              fit: BoxFit.fill,
                                            ),
                                            Text(
                                              "微信",
                                              style: TextStyle(
//                color:  Color(0xFF222222) ,
                                                  fontSize:
                                                      ScreenUtil().setSp(48)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: !_aliPaySelected,
                                        child: Image.asset(
                                          "static/images/withdrawal_checked.png",
                                          width: ScreenUtil().setWidth(72),
                                          height: ScreenUtil().setHeight(59),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(55),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "支付宝账号",
                              style: TextStyle(
//                color:  Color(0xFF222222) ,
                                  fontSize: ScreenUtil().setSp(48)),
                            ),
                            Expanded(
                              child: buildAliPayAccountContainer(),
                            ),
                            GestureDetector(
                              onTap: () {
                                _aliPayAccountController.text = "";
                                _aliPayAccount = "";
                              },
                              child: Image.asset(
                                "static/images/money_del.png",
                                width: ScreenUtil().setWidth(45),
                                height: ScreenUtil().setWidth(45),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(55),
                        ),
                        Divider(
                          height: ScreenUtil().setHeight(1),
                          color: Color(0xFFdddddd),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(67),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "支付宝姓名",
                              style: TextStyle(
//                color:  Color(0xFF222222) ,
                                  fontSize: ScreenUtil().setSp(48)),
                            ),
                            Expanded(
                              child: buildAliPayNameContainer(),
                            ),
                            GestureDetector(
                              onTap: () {
                                _aliPayNameController.text = "";
                                _aliPayName = "";
                              },
                              child: Image.asset(
                                "static/images/money_del.png",
                                width: ScreenUtil().setWidth(45),
                                height: ScreenUtil().setWidth(45),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    color: Colors.white,
                    constraints: BoxConstraints(
                      minHeight: ScreenUtil().setHeight(1350),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "提现金额",
                          style: TextStyle(
//                color:  Color(0xFF222222) ,
                              fontSize: ScreenUtil().setSp(48)),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(55),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "￥",
                              style: TextStyle(
//                color:  Color(0xFF222222) ,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(56)),
                            ),
                            Expanded(
                              child: buildWithdrawalAmountContainer(),
                            ),
                            GestureDetector(
                              onTap: () {
                                _withdrawalAmountController.text = "";
                                _withdrawalAmount = "";
                              },
                              child: Image.asset(
                                "static/images/money_del.png",
                                width: ScreenUtil().setWidth(45),
                                height: ScreenUtil().setWidth(45),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(55),
                        ),
                        Divider(
                          height: ScreenUtil().setHeight(1),
                          color: Color(0xFFdddddd),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(67),
                        ),
                        Text(
                          "可提现余额￥${widget.availableCashAmount}",
                          style: TextStyle(
                              color: Color(0xFF999999),
                              fontSize: ScreenUtil().setSp(36)),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                        Text(
                          "*请填写正确的支付宝账号，以防止造成资金损失\n*提现手续费10% \t$_desc",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: ScreenUtil().setSp(32)),
                        ),
                        buildBtnLayout(),
                      ],
                    ),
                  ),
                ],
              ),
            ) // This trailing comma makes auto-formatting nicer for build methods.
            ),
      ),
    );
  }

  /// 登录/注册按钮操作
  Widget buildBtnLayout() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        top: ScreenUtil().setHeight(257),
      ),
      child: Ink(
        child: InkWell(
            onTap: () async {
              if (KeTaoFeaturedCommonUtils.isEmpty(_aliPayAccount) ||
                  KeTaoFeaturedCommonUtils.isEmpty(_aliPayName) ||
                  KeTaoFeaturedCommonUtils.isEmpty(_withdrawalAmount)) {
                KeTaoFeaturedCommonUtils.showToast("请检查填写的信息是否完整！");
                return;
              }
              try {
                if (double.parse(_withdrawalAmount) >
                    double.parse(widget.availableCashAmount)) {
                  KeTaoFeaturedCommonUtils.showToast("提现金额不能超出账户可提现余额！");
                  return;
                }
              } catch (e) {}
              EasyLoading.show();
              var result = await KeTaoFeaturedHttpManage.withdrawalApplication(
                  "1", _withdrawalAmount, _aliPayName, _aliPayAccount);
              EasyLoading.dismiss();
              if (result.status) {
                KeTaoFeaturedCommonUtils.showToast("提现申请已提交");
//                Navigator.of(context).pop();
                KeTaoFeaturedNavigatorUtils.navigatorRouterReplaceMent(
                    context, KeTaoFeaturedWithdrawalResultPage());
              } else {
                KeTaoFeaturedCommonUtils.showToast(result.errMsg);
              }
            },
            child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 30),
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: ScreenUtil().setHeight(152),
                width: ScreenUtil().setWidth(810),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(100)),
                    color: Color(0xffF32E43)),
                child: Text(
                  "提现",
                  style: TextStyle(
                      color: Colors.white, fontSize: ScreenUtil().setSp(48)),
                ))),
      ),
    );
  }

  Widget buildAliPayAccountContainer() {
    return Container(
      height: ScreenUtil().setHeight(160),
      alignment: Alignment.center,
//      margin: EdgeInsets.only(left: 24, right: 24, top: 20),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
//        color: Color(0xFFF5F5F5),
//        borderRadius: BorderRadius.circular(48),
          ),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.left,
        style: TextStyle(
            color: Color(0xFF222222),
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtil().setSp(56)),
        controller: _aliPayAccountController,
        focusNode: _aliPayAccountFocusNode,
        keyboardType: TextInputType.number,
        maxLengthEnforced: false,
        onChanged: (value) {
          setState(() {
            _aliPayAccount = value.trim();
          });
        },
        decoration: InputDecoration(
            /* labelText: widget.address.name == null
                                  ? ''
                                  : widget.address.name,*/
            border: InputBorder.none,
            hintText: '请输入支付宝账号',
            hintStyle: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: ScreenUtil().setSp(42),
            )),
      ),
    );
  }

  Widget buildAliPayNameContainer() {
    return Container(
      height: ScreenUtil().setHeight(160),
      alignment: Alignment.center,
//      margin: EdgeInsets.only(left: 24, right: 24, top: 20),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
//        color: Color(0xFFF5F5F5),
//        borderRadius: BorderRadius.circular(48),
          ),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.left,
        style: TextStyle(
            color: Color(0xFF222222),
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtil().setSp(56)),
        controller: _aliPayNameController,
        focusNode: _aliPayNameFocusNode,
        maxLengthEnforced: false,
        onChanged: (value) {
          setState(() {
            _aliPayName = value.trim();
          });
        },
        decoration: InputDecoration(
            /* labelText: widget.address.name == null
                                  ? ''
                                  : widget.address.name,*/
            border: InputBorder.none,
            hintText: '请输入支付宝姓名',
            hintStyle: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: ScreenUtil().setSp(42),
            )),
      ),
    );
  }

  Widget buildWithdrawalAmountContainer() {
    return Container(
      height: ScreenUtil().setHeight(160),
      alignment: Alignment.center,
//      margin: EdgeInsets.only(left: 24, right: 24, top: 20),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
//        color: Color(0xFFF5F5F5),
//        borderRadius: BorderRadius.circular(48),
          ),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.left,
        style: TextStyle(
            color: Color(0xFF222222),
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtil().setSp(99)),
        controller: _withdrawalAmountController,
        focusNode: _withdrawalAmountFocusNode,
        keyboardType: TextInputType.number,
        maxLengthEnforced: false,
        onChanged: (value) {
          setState(() {
            _withdrawalAmount = value.trim();
          });
        },
        decoration: InputDecoration(
            /* labelText: widget.address.name == null
                                  ? ''
                                  : widget.address.name,*/
            border: InputBorder.none,
            hintText: '请输入提现金额',
            hintStyle: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: ScreenUtil().setSp(42),
            )),
      ),
    );
  }
}
