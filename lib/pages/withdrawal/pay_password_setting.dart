import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';

import '../../global_config.dart';

class PayPasswordSettingPage extends StatefulWidget {
  PayPasswordSettingPage(
      {Key key,
      this.pageType = 0,
      this.isModifyType = false,
      this.password = ''})
      : super(key: key);
  final String title = "";

  ///页面类型，
  ///
  /// 0，设置密码
  /// 1，设置密码确认
  /// 2，修改密码
  ///
  int pageType;

  ///是否是修改密码页面
  bool isModifyType;

  var password;

  @override
  _PayPasswordSettingPageState createState() => _PayPasswordSettingPageState();
}

class _PayPasswordSettingPageState extends State<PayPasswordSettingPage> {
  var _titieText = "";
  var _descText = "";
  bool _canSubmit = false;
  var _currentpPassword = '';

  @override
  void initState() {
    switch (widget.pageType) {
      case 0:
        _titieText = "设置支付密码";
        _descText = "请设置支付密码，用于支付验证";
        break;
      case 1:
        _titieText = "确认支付密码";
        _descText = "请再次填写以确认";
        break;
      case 2:
        _titieText = "修改密码";
        _descText = "请输入支付密码，以验证身份";
        break;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                widget.title,
                style: TextStyle(
                    color: Color(0xFF222222), fontSize: ScreenUtil().setSp(54)),
              ),
              brightness: Brightness.light,
              leading: IconButton(
                icon: Text(
                  "取消",
                  style: TextStyle(
                    color: Color(0xff222222),
                    fontSize: ScreenUtil().setSp(54),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              centerTitle: true,
              backgroundColor: GlobalConfig.taskNomalHeadColor,
              elevation: 0,
            ),
            body: Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Visibility(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: ScreenUtil().setHeight(200),
                          bottom: ScreenUtil().setHeight(40),
                        ),
                        child: Text(
                          "$_titieText",
                          style: TextStyle(
                            color: Color(0xff222222),
                            fontSize: ScreenUtil().setSp(60),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      child: Container(
                        child: Text(
                          "$_descText",
                          style: TextStyle(
                            color: Color(0xff222222),
                            fontSize: ScreenUtil().setSp(48),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 40),
                      child: PinCodeTextField(
                        length: 6,
                        obsecureText: true,
                        autoFocus: true,
                        animationType: AnimationType.fade,
                        mainAxisAlignment: MainAxisAlignment.center,
                        autoDismissKeyboard: true,
                        textInputType: TextInputType.number,
                        errorTextSpace: 0,
                        textStyle: TextStyle(fontSize: ScreenUtil().setSp(42)),
                        validator: (v) {
                          if (v.length < 3) {
                            return "I'm from validator";
                          } else {
                            return null;
                          }
                        },

                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderWidth: ScreenUtil().setWidth(1),
                          borderRadius: BorderRadius.circular(0),
                          fieldHeight: ScreenUtil().setWidth(130),
                          fieldWidth: ScreenUtil().setWidth(130),
                          activeColor: Color(0xffeaeaea),
                          activeFillColor: Colors.white,
                          selectedColor: Color(0xffeaeaea),
                          selectedFillColor: Colors.white,
                          inactiveColor: Color(0xffeaeaea),
                          inactiveFillColor: Colors.white,
                          disabledColor: Colors.white,
                        ),
                        animationDuration: Duration(milliseconds: 300),
//                        backgroundColor: Colors.green.shade50,
                        enableActiveFill: true,
                        onCompleted: (v) {
                          if (mounted) {
                            setState(() {
                              _canSubmit = true;
                              _currentpPassword = v;
                            });
                          }
                        },
                        onChanged: (value) {
                          print(value);
                          if (_currentpPassword != value) {
                            if (mounted) {
                              setState(() {
                                _canSubmit = false;
                              });
                            }
                          }
                        },
                        beforeTextPaste: (text) {
                          print("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                      ),
                    ),
                    Visibility(
                      child: GestureDetector(
                        onTap: () {
                          if (!_canSubmit) {
                            return;
                          }
                          switch (widget.pageType) {
                            case 0:
                              if (widget.isModifyType) {
                                //todo 调用接口设置支付密码

                              } else {
                                //确认密码
                                NavigatorUtils.navigatorRouterReplaceMent(
                                    context,
                                    PayPasswordSettingPage(
                                      password: _currentpPassword,
                                      pageType: 1,
                                    ));
                              }

                              break;
                            case 1:
                              if (widget.password != _currentpPassword) {
                                CommonUtils.showToast("两次输入的密码不一致");
                                return;
                              }
                              //todo 调用接口设置支付密码

                              break;
                            case 2:
                              //todo 调用接口校验支付密码正确性

                              NavigatorUtils.navigatorRouterReplaceMent(
                                  context,
                                  PayPasswordSettingPage(
                                    password: _currentpPassword,
                                    pageType: 0,
                                    isModifyType: true,
                                  ));
                              break;
                          }
                        },
                        child: Opacity(
                          opacity: _canSubmit ? 1 : 0.6,
                          child: Container(
                            alignment: Alignment.center,
                            height: ScreenUtil().setHeight(130),
                            width: ScreenUtil().setWidth(964),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(15),
                              ),
                              color: Color(0xff06C15F),
                            ),
                            child: Text(
                              "完成",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(48),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ) // This trailing comma makes auto-formatting nicer for build methods.
            ));
  }
}
