import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/global_config.dart';
import 'package:star/http/ktkj_http_manage.dart';
import 'package:star/pages/ktkj_widget/ktkj_time_widget.dart';
import 'package:star/utils/ktkj_common_utils.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJModifyPasswordPage extends StatefulWidget {
  String title;

  KTKJModifyPasswordPage({Key key, this.title}) : super(key: key);

  @override
  _ModifyPasswordPageState createState() => _ModifyPasswordPageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _ModifyPasswordPageState extends State<KTKJModifyPasswordPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  TextEditingController _checkCodeController;
  TextEditingController _phoneController;
  TextEditingController _passwordController;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _checkCodeController = new TextEditingController()..addListener(() {});
    _phoneController = new TextEditingController()..addListener(() {});
    _passwordController = new TextEditingController()..addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _checkCodeController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
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
            icon: Container(
              width: ScreenUtil().setWidth(63),
              height: ScreenUtil().setHeight(63),
              child: Center(
                child: Image.asset(
                  "static/images/icon_ios_back.png",
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
          centerTitle: true,
          backgroundColor: KTKJGlobalConfig.taskNomalHeadColor,
          elevation: 0,
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
            child: Column(
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(147),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.left,
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    maxLengthEnforced: false,
                    decoration: InputDecoration(
                      /* labelText: widget.address.name == null
                            ? ''
                            : widget.address.name,*/
                      border: InputBorder.none,
                      prefixIcon: Container(
                        width: ScreenUtil().setWidth(60),
                        child: Center(
                          child: Image.asset(
                            "static/images/icon_pwd_phone.png",
                            width: ScreenUtil().setWidth(30),
                            height: ScreenUtil().setHeight(54),
                          ),
                        ),
                      ),
                      hintText: '手机号',
                      hintStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(42),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: ScreenUtil().setHeight(147),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _checkCodeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            /*  labelText: widget.address.iphone == null
                                  ? ''
                                  : widget.address.iphone,*/
                            border: InputBorder.none,
                            prefixIcon: Container(
                              width: ScreenUtil().setWidth(60),
                              child: Center(
                                child: Image.asset(
                                  "static/images/icon_pwd_code.png",
                                  width: ScreenUtil().setWidth(44),
                                  height: ScreenUtil().setHeight(49),
                                ),
                              ),
                            ),
                            hintText: '验证码',
                            hintStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(42),
                            ),
                          ),
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
                            color: Colors.white),
                        child: KTKJTimerWidget(
                          textColor: Color(0xff333333),
                          startCountAction: (BuildContext context) {
                            return smsSend(context);
                          },
                        ),
/*
                              child: Text(
                                "获取验证码",
                                style: TextStyle(color: Colors.white),
                              ),
*/
                      ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: ScreenUtil().setHeight(147),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      /*  labelText: widget.address.addressDetail == null
                          ? ''
                          : widget.address.addressDetail,*/
                      border: InputBorder.none,
                      prefixIcon: Container(
                        width: ScreenUtil().setWidth(60),
                        child: Center(
                          child: Image.asset(
                            "static/images/icon_pwd_pwd.png",
                            width: ScreenUtil().setWidth(41),
                            height: ScreenUtil().setHeight(48),
                          ),
                        ),
                      ),
                      hintText: '新登陆密码',
                      hintStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(42),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Ink(
                  child: InkWell(
                      onTap: () async {
                        if (_phoneController.value.text == null ||
                            _phoneController.value.text.isEmpty ||
                            _checkCodeController.value.text == null ||
                            _checkCodeController.value.text.isEmpty ||
                            _passwordController.value.text == null ||
                            _passwordController.value.text.isEmpty) {
                          KTKJCommonUtils.showToast("请检查填写的信息是否完整！");
                        } else {
                          var result = await HttpManage.modifyPassword(
                              _phoneController.value.text,
                              _checkCodeController.value.text,
                              _passwordController.value.text);
                          if (result.status) {
                            KTKJCommonUtils.showToast(
                                "${widget.title == "设置密码" ? "设置" : "修改"}密码成功！");
                            Navigator.of(context).pop();
                            return true;
                          } else {
                            KTKJCommonUtils.showToast("${result.errMsg}");
                            /*   KTKJCommonUtils.showToast(
                                "${widget.title == "设置密码" ? "设置" : "修改"}密码失败！");*/
                            return false;
                          }
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: ScreenUtil().setHeight(130),
                            width: ScreenUtil().setWidth(810),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(36.0),
                                color: Color(0xffF32E43)),
                            child: Text(
                              widget.title == "设置密码" ? "确认" : "确认修改",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(48)),
                            )),
                      )),
                ),
              ],
            )),
      ),
    );
  }

  Future<bool> smsSend(BuildContext context) async {
    if (KTKJCommonUtils.isPhoneLegal(_phoneController.value.text)) {
      var result = await HttpManage.sendVerificationCode(
          _phoneController.value.text, "4");
      if (result.status) {
        KTKJCommonUtils.showToast("验证码已发送，请注意查收！");
        return true;
      } else {
        KTKJCommonUtils.showToast(result.errMsg);
        return false;
      }
    } else {
      KTKJCommonUtils.showSimplePromptDialog(context, "温馨提示", "请输入正确的手机号");
      return false;
    }
  }
}