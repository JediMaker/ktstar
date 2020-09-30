import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/utils/common_utils.dart';

import '../../global_config.dart';

class WithdrawalPage extends StatefulWidget {
  WithdrawalPage({Key key, @required this.availableCashAmount})
      : super(key: key);
  final String title = "提现";
  String availableCashAmount; // 可提现金额

  @override
  _WithdrawalPageState createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
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

  @override
  void initState() {
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
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(
                color: Color(0xFF222222), fontSize: ScreenUtil().setSp(54)),
          ),
          brightness: Brightness.dark,
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
          backgroundColor: GlobalConfig.taskNomalHeadColor,
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
                                              fontSize: ScreenUtil().setSp(48)),
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
                                    Fluttertoast.showToast(
                                        msg: "暂不支持提现到微信",
                                        backgroundColor: Colors.grey,
                                        textColor: Colors.white,
                                        gravity: ToastGravity.BOTTOM);
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
                                              fontSize: ScreenUtil().setSp(48)),
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
                    buildBtnLayout(),
                  ],
                ),
              ),
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
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
              if (CommonUtils.isEmpty(_aliPayAccount) ||
                  CommonUtils.isEmpty(_aliPayName) ||
                  CommonUtils.isEmpty(_withdrawalAmount)) {
                Fluttertoast.showToast(
                    msg: "请检查填写的信息是否完整！",
                    textColor: Colors.white,
                    backgroundColor: Colors.grey);
                return;
              }
              try {
                if (double.parse(_withdrawalAmount) >
                    double.parse(widget.availableCashAmount)) {
                  Fluttertoast.showToast(
                      msg: "提现金额不能超出账户可提现余额！",
                      textColor: Colors.white,
                      backgroundColor: Colors.grey);
                  return;
                }
              } catch (e) {}
              var result = await HttpManage.withdrawalApplication(
                  "1", _withdrawalAmount, _aliPayName, _aliPayAccount);
              if (result.status) {
                Fluttertoast.showToast(
                    msg: "提现申请已提交",
                    textColor: Colors.white,
                    backgroundColor: Colors.grey);
                Navigator.of(context).pop();
              } else {
                Fluttertoast.showToast(
                    msg: "${result.errMsg}",
                    textColor: Colors.white,
                    backgroundColor: Colors.grey);
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
