import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:star/global_config.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_octoimage.dart';

///description:公告提示弹窗
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJNoticeDialog extends Dialog {
  final String noticeContent;
  final String noticeTitle;
  final bool isForce;

  KTKJNoticeDialog({
    this.noticeContent,
    this.isForce,
    this.noticeTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: ScreenUtil().setWidth(860),
            height: ScreenUtil().setWidth(994),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                ScreenUtil().setWidth(30),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                KTKJMyOctoImage(
                  width: ScreenUtil().setWidth(860),
                  height: ScreenUtil().setWidth(270),
                  image:
                      "https://alipic.lanhuapp.com/xd00180cfb-2cb1-48b5-833b-aea9b4c27397",
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setWidth(50),
                    left: ScreenUtil().setWidth(30),
                    right: ScreenUtil().setWidth(30),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$noticeTitle',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(53),
                        color: Color(0xffF32E43),
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setWidth(30),
                    left: ScreenUtil().setWidth(30),
                    right: ScreenUtil().setWidth(30),
                    bottom: ScreenUtil().setWidth(80),
                  ),
                  height: ScreenUtil().setWidth(400),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          '$noticeContent',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(38),
                              fontWeight: FontWeight.w400,
                              color: Color(0xff222222),
                              decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              KTKJGlobalConfig.prefs
                  .setString('noticeTime', DateTime.now().toString());
              Navigator.of(context).pop();
            },
            child: Container(
              margin: EdgeInsets.only(
                top: ScreenUtil().setWidth(935),
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xffEF4C3C),
                borderRadius: BorderRadius.circular(
                  ScreenUtil().setWidth(85),
                ),
              ),
              width: ScreenUtil().setWidth(439),
              height: ScreenUtil().setWidth(118),
              child: Text(
                '我知道了',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(48),
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///展示公告弹窗
  static Future<bool> showNoticeDialog(
      {BuildContext context,
      String mNoticeContent,
      String noticeTitle,
      bool mIsForce}) async {
    return await showDialog(
        barrierDismissible: false, //屏蔽物理返回键（因为强更的时候点击返回键，弹窗会消失）
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              child: KTKJNoticeDialog(
                  noticeContent: mNoticeContent,
                  noticeTitle: noticeTitle,
                  isForce: mIsForce),
              onWillPop: _onWillPop);
        });
  }

  static Future<bool> _onWillPop() async {
    return false;
  }
}
