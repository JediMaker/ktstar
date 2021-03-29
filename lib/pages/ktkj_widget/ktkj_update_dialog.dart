import 'package:star/pages/ktkj_widget/ktkj_my_octoimage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///created by WGH
///on 2020/7/23
///description:版本更新提示弹窗
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJUpdateDialog extends Dialog {
  final String upDateContent;
  final bool isForce;

  KTKJUpdateDialog({this.upDateContent, this.isForce});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(706),
            height: ScreenUtil().setWidth(1087),
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                KTKJMyOctoImage(
                  width: ScreenUtil().setWidth(706),
                  height: ScreenUtil().setWidth(1087),
                  image:
                      "https://alipic.lanhuapp.com/xdca0eb379-4282-42ea-ad98-531697ac2309",
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                          top: ScreenUtil().setWidth(336),
                        ),
                        child: Text('发现新版本',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(63),
                                color: Colors.white,
                                decoration: TextDecoration.none)),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: ScreenUtil().setWidth(236),
                        ),
                        height: ScreenUtil().setWidth(160),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text(upDateContent,
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(38),
                                      color: Color(0xff222222),
                                      letterSpacing: 1,
                                      decoration: TextDecoration.none)),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(435),
                        height: ScreenUtil().setWidth(102),
                        margin: EdgeInsets.only(
                          top: ScreenUtil().setWidth(30),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(49)),
                          gradient: LinearGradient(
//                              begin: Alignment.topCenter,
//                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xffFF3434),
                                Color(0xffF32E43),
                              ]),
                        ),
                        child: RaisedButton(
                            color: Color(0xffFF3434),
                            shape: StadiumBorder(),
                            child: Text(
                              '立即更新',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(38),
                                  color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.pop(context, true);
                            }),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, false);
                        },
                        child: Offstage(
                          offstage: isForce,
                          child: Container(
                            margin: EdgeInsets.only(
                              bottom: ScreenUtil().setWidth(50),
                              top: ScreenUtil().setWidth(20),
                            ),
                            child: Text("放弃",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(38),
                                    color: Color(0xffafafaf),
                                    letterSpacing: 1,
                                    decoration: TextDecoration.none)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Future<bool> showUpdateDialog(
      BuildContext context, String mUpdateContent, bool mIsForce) async {
    return await showDialog(
        barrierDismissible: false, //屏蔽物理返回键（因为强更的时候点击返回键，弹窗会消失）

        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              child: KTKJUpdateDialog(
                  upDateContent: mUpdateContent, isForce: mIsForce),
              onWillPop: _onWillPop);
        });
  }

  static Future<bool> _onWillPop() async {
    return false;
  }
}
