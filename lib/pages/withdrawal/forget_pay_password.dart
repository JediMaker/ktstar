import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/pages/widget/time_widget.dart';
import 'package:star/utils/common_utils.dart';

import '../../global_config.dart';

class ForgetPayPasswordPage extends StatefulWidget {
  ForgetPayPasswordPage({Key key}) : super(key: key);
  final String title = "";

  @override
  _ForgetPayPasswordPageState createState() => _ForgetPayPasswordPageState();
}

class _ForgetPayPasswordPageState extends State<ForgetPayPasswordPage> {
  TextEditingController _checkCodeController;
  TextEditingController _passwordController;

  var _phoneNum = '132*****5555';

  @override
  void initState() {
    _checkCodeController = new TextEditingController()..addListener(() {});
    _passwordController = new TextEditingController()..addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    _checkCodeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "忘记密码",
              style: TextStyle(
                  color: Color(0xFF222222), fontSize: ScreenUtil().setSp(54)),
            ),
            leading: IconButton(
              icon: Image.asset(
                "static/images/icon_ios_back.png",
                width: ScreenUtil().setWidth(36),
                height: ScreenUtil().setHeight(63),
                fit: BoxFit.fill,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            brightness: Brightness.light,
            centerTitle: true,
            backgroundColor: GlobalConfig.taskNomalHeadColor,
            elevation: 0,
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    top: 16,
                    bottom: 16,
                    left: 16,
                  ),
                  child: Text(
                    "验证码将发送至已绑定手机号：$_phoneNum",
                    style: TextStyle(
                      color: Color(0xff222222),
                      fontSize: ScreenUtil().setSp(42),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                              width: ScreenUtil().setWidth(360),
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: 16,
                                ),
                                child: Text(
                                  "验证码:",
                                  style: TextStyle(
                                    color: Color(0xff222222),
                                    fontSize: ScreenUtil().setSp(42),
                                  ),
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
                      InkWell(
                          child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(32),
                        ),
                        height: 36,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(36.0),
                            color: Colors.white),
                        child: TimerWidget(
                          textColor: Color(0xffF32E43),
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
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    height: ScreenUtil().setHeight(1),
                    color: Color(0xFFefefef),
                  ),
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
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      /*  labelText: widget.address.addressDetail == null
                        ? ''
                        : widget.address.addressDetail,*/
                      border: InputBorder.none,
                      prefixIcon: Container(
                        width: ScreenUtil().setWidth(360),
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 16,
                          ),
                          child: Text(
                            "新支付密码:",
                            style: TextStyle(
                              color: Color(0xff222222),
                              fontSize: ScreenUtil().setSp(42),
                            ),
                          ),
                        ),
                      ),
                      hintText: '请输入6位数字支付密码',
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
                      if (_checkCodeController.value.text == null ||
                          _checkCodeController.value.text.isEmpty ||
                          _passwordController.value.text == null ||
                          _passwordController.value.text.isEmpty) {
                        CommonUtils.showToast("请检查填写的信息是否完整！");
                      } else {
                        var result = await HttpManage.modifyPayPassword(
                            "",
                            _checkCodeController.value.text,
                            _passwordController.value.text);
                        if (result.status) {
                          CommonUtils.showToast("设置支付密码成功！");
                          Navigator.of(context).pop();
                          return true;
                        } else {
                          CommonUtils.showToast("设置支付密码失败！");
                          return false;
                        }
                      }
                    },
                    child: Center(
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
          ) // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }

  Future<bool> smsSend(BuildContext context) async {
    if (CommonUtils.isPhoneLegal(_phoneNum)) {
      var result = await HttpManage.sendVerificationCode(_phoneNum, "4");
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
}
