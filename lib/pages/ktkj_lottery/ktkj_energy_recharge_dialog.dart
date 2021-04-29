import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:star/pages/ktkj_recharge/ktkj_recharge_shopping_card.dart';
import 'package:star/pages/ktkj_task/ktkj_task_index.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_octoimage.dart';
import 'package:star/utils/ktkj_navigator_utils.dart';

///description:充值购物卡提示弹窗
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJEnergyRechargeDialog extends Dialog {
  final String noticeContent;
  final String noticeTitle;
  final bool isForce;
  var _width = 564;
  var _scale = ScreenUtil.screenWidth / 750;

  ///比例

  KTKJEnergyRechargeDialog({
    this.noticeContent,
    this.isForce,
    this.noticeTitle = '糟糕！能量槽耗尽',
  });

  @override
  Widget build(BuildContext context) {
//    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Center(
      child: Container(
        width: ScreenUtil().setWidth(_width * _scale),
        height: ScreenUtil().setWidth(850 * _scale),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                KTKJMyOctoImage(
                  width: ScreenUtil().setWidth(_width * _scale),
                  height: ScreenUtil().setWidth(389 * _scale),
                  fit: BoxFit.fill,
                  image:
                      "https://alipic.lanhuapp.com/ps3afc581652e22522-3a35-4c7b-8d53-d6fe2e6e046b",
                ),
                Container(
                  width: ScreenUtil().setWidth(_width * _scale),
                  height: ScreenUtil().setWidth(389 * _scale),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      ScreenUtil().setWidth(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                          top: ScreenUtil().setWidth(60 * _scale),
                          left: ScreenUtil().setWidth(30 * _scale),
                          right: ScreenUtil().setWidth(30 * _scale),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '糟糕！能量槽耗尽',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(53 * _scale),
                              color: Colors.white,
//                            fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(60 * _scale),
                          ),
                          width: ScreenUtil().setWidth(283 * _scale),
                          height: ScreenUtil().setWidth(144 * _scale),
                          child: KTKJMyOctoImage(
                            image:
                                "https://alipic.lanhuapp.com/ps13cdcc99b6798690-846b-42dc-bb84-df528ccb68ac",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: ScreenUtil().setWidth(_width * _scale),
              height: ScreenUtil().setWidth(330 * _scale),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    ScreenUtil().setWidth(30),
                  ),
                  bottomRight: Radius.circular(
                    ScreenUtil().setWidth(30),
                  ),
                ),
              ),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(
                        top: ScreenUtil().setWidth(40 * _scale),
                      ),
                      child: Text(
                        '快去补充能量吧！',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(36 * _scale),
                            color: Color(0xff222222),
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.none),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(
                        top: ScreenUtil().setWidth(20 * _scale),
                      ),
                      child: Text(
                        '充值购物卡可立即获得能量值',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(30 * _scale),
                            color: Color(0xff999999),
                            decoration: TextDecoration.none),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setWidth(30 * _scale),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            KTKJNavigatorUtils.navigatorRouterAndRemoveUntil(
                                context, KTKJTaskIndexPage());
                          },
                          child: Center(
                            child: Container(
                              alignment: Alignment.center,
                              width: ScreenUtil().setWidth(216 * _scale),
                              height: ScreenUtil().setWidth(108 * _scale),
                              child: KTKJMyOctoImage(
                                image:
                                    "https://alipic.lanhuapp.com/ps2a07b394f00f099b-bba9-4ccb-afdf-d375cdf1d90d",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            KTKJNavigatorUtils.navigatorRouter(
                                context, KTKJRechargeShoppingCardPage());
                          },
                          child: Center(
                            child: Container(
                              alignment: Alignment.center,
                              width: ScreenUtil().setWidth(246 * _scale),
                              height: ScreenUtil().setWidth(108 * _scale),
                              child: KTKJMyOctoImage(
                                image:
                                    "https://alipic.lanhuapp.com/ps7731e1c44dcc27ae-b861-4489-b785-df4bcf514407",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  width: ScreenUtil().setWidth(76 * _scale),
                  height: ScreenUtil().setWidth(76 * _scale),
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setWidth(51 * _scale),
                  ),
                  child: KTKJMyOctoImage(
                    image:
                        "https://alipic.lanhuapp.com/psa0c9690117516e50-aeba-4e45-982b-1212be608627",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///展示充能量弹窗
  static Future<bool> showEnergyRechargeDialog(
      {BuildContext context,
      String mNoticeContent,
      String noticeTitle,
      bool mIsForce}) async {
    return await showDialog(
        barrierDismissible: false, //屏蔽物理返回键（因为强更的时候点击返回键，弹窗会消失）
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              child: KTKJEnergyRechargeDialog(
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
