import 'dart:typed_data';

import 'package:star/pages/widget/my_octoimage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/utils.dart';

import '../../global_config.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedInvitationPosterPage extends StatefulWidget {
  KeTaoFeaturedInvitationPosterPage({Key key}) : super(key: key);
  final String title = "邀请好友";

  @override
  _InvitationPosterPageState createState() => _InvitationPosterPageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _InvitationPosterPageState extends State<KeTaoFeaturedInvitationPosterPage> {
  List<String> _bannerList = [];
  var _bannerIndex = 0;
  var _linkUrl;
  var _inviteCode;
  var _canLoop = false;
  Permission _permission = Permission.storage;
  SwiperController _swiperController;

  void _initData() async {
    var result = await HttpManage.getInvitationPosters();
    if (result.status) {
      if (mounted) {
        setState(() {
          _bannerList = result.data.imgs;
          _linkUrl = result.data.url;
          _inviteCode = result.data.code;
          _canLoop = true;
          try {
            if (_bannerList.length > 2) {
              _bannerIndex = 1;
            }
          } catch (e) {
            print(e);
          }
        });
      }
    } else {
      KeTaoFeaturedCommonUtils.showToast(result.errMsg);
    }
  }

  @override
  void initState() {
    _initData();

    super.initState();
  }

  @override
  void dispose() {
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
          backgroundColor: KeTaoFeaturedGlobalConfig.taskNomalHeadColor,
          elevation: 0,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: ScreenUtil().setWidth(927),
                child: Image.asset(
                  "static/images/invite_bg_bottom.png",
                  height: ScreenUtil().setWidth(927),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setWidth(32),
                ),
                child: Column(
                  children: <Widget>[
                    buildBannerLayout(),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                        top: ScreenUtil().setWidth(135),
                        bottom: ScreenUtil().setWidth(181),
                      ),
                      child: Container(
                        width: ScreenUtil().setWidth(793),
                        height: ScreenUtil().setWidth(126),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().setWidth(30))),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Clipboard.setData(
                                      ClipboardData(text: "可淘星选:$_linkUrl"));
                                  KeTaoFeaturedCommonUtils.showToast("已复制文本");
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "static/images/icon_share.png",
                                        width: ScreenUtil().setWidth(45),
                                        height: ScreenUtil().setWidth(45),
                                      ),
                                      SizedBox(
                                        width: ScreenUtil().setWidth(26),
                                      ),
                                      Text(
                                        "分享链接",
                                        style: TextStyle(
//                                          color: Color(0xFFF93736),
                                          fontSize: ScreenUtil().setSp(42),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
//                              color: Colors.red,
                              margin: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setHeight(30)),
                              color: Color(0xFFd1d1d1),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  KeTaoFeaturedCommonUtils.requestPermission(
                                      _permission, _savePosterImg());
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "static/images/icon_download.png",
                                        width: ScreenUtil().setWidth(46),
                                        height: ScreenUtil().setHeight(43),
                                      ),
                                      SizedBox(
                                        width: ScreenUtil().setWidth(26),
                                      ),
                                      Text(
                                        "保存图片",
                                        style: TextStyle(
//                                        color: Colors.white,
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
                    ),
                  ],
                ),
              ),
            )
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  _savePosterImg() async {
    try {
      var response = await HttpManage.dio.get(_bannerList[_bannerIndex],
          options: Options(responseType: ResponseType.bytes));
      var result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 60,
          name:
              "ktxx_${KeTaoFeaturedCommonUtils.currentTimeMillis() + _bannerIndex.toString()}");
      print("posterDownloadResult=" + result.toString());
      KeTaoFeaturedCommonUtils.showToast("图片已保存");
    } catch (e) {
      print("err=" + e.toString());
      KeTaoFeaturedCommonUtils.showToast("图片下载失败");
    }
  }

  Widget buildBannerLayout() {
    return Container(
      height: ScreenUtil().setWidth(1570),
      width: double.maxFinite,
//      width: ScreenUtil().setWidth(1125),
      /*  decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),*/
      child: Swiper(
        itemCount: _bannerList == null ? 0 : _bannerList.length,
//        key: GlobalKey(),
        /*itemWidth: ScreenUtil().setWidth(1125),
        itemHeight: ScreenUtil().setHeight(623),
        transformer: ScaleAndFadeTransformer(scale: 0, fade: 0),*/
        //bannerList == null ? 0 : bannerList.length,
        controller: _swiperController,
        autoplay: false,
        loop: _canLoop,
        key: UniqueKey(),
        index: _bannerIndex,
        viewportFraction: 0.75,
        scale: 0.9,
//          indicatorLayout: PageIndicatorLayout.COLOR,
        onIndexChanged: (index) {
          _bannerIndex = index;
          print(_bannerIndex.toString());

          /*if (mounted) {
            setState(() {
              _bannerIndex = index;
            });
          }*/
        },
        /*pagination: SwiperPagination(
            builder: DotSwiperPaginationBuilder(
                //自定义指示器颜色
                color: Colors.white,
                size: 8.0,
                activeColor: KeTaoFeaturedGlobalConfig.taskHeadColor,
                activeSize: 10.0)),*/
        itemBuilder: (context, index) {
          var bannerData = _bannerList[index];
          return GestureDetector(
            onTap: () {},
            child: ClipRRect(
              borderRadius:
                  BorderRadius.all(Radius.circular(ScreenUtil().setWidth(30))),
              child: KeTaoFeaturedMyOctoImage(
                image: bannerData,
                height: ScreenUtil().setHeight(623),
//              width: ScreenUtil().setWidth(1125),
                fit: BoxFit.fill,
              ),
            ),
          );
        },
      ),
    );
  }
}
