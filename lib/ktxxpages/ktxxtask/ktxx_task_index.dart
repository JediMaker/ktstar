import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:star/ktxxbus/kt_my_event_bus.dart';
import 'package:star/ktxx_global_config.dart';
import 'package:star/ktxxhttp/ktxx_api.dart';
import 'package:star/ktxxhttp/ktxx_http_manage.dart';
import 'package:star/ktxxmodels/ktxx_home_entity.dart';
import 'package:star/ktxxpages/ktxxgoods/ktxxcategory/ktxx_classify.dart';
import 'package:star/ktxxpages/ktxxgoods/ktxxcategory/ktxx_new_classify.dart';
import 'package:star/ktxxpages/ktxxhomenew/ktxx_home_new_index.dart';
import 'package:star/ktxxpages/ktxxhomenew/ktxx_home_page.dart';
import 'package:star/ktxxpages/ktxxorder/ktxx_order_list.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_list.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_mine.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_mine_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/ktxxpages/ktxxwidget/ktxx_my_webview.dart';
import 'package:star/ktxxpages/ktxxwidget/ktxx_navigation_icon_view.dart';
import 'package:star/ktxxutils/ktxx_common_utils.dart';
import 'package:star/ktxxutils/ktxx_navigator_utils.dart';
import 'package:star/ktxxutils/ktxx_utils.dart';
import 'package:video_player/video_player.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedTaskIndexPage extends StatefulWidget {
  int currentIndex;

  KeTaoFeaturedTaskIndexPage({this.currentIndex = 0});

//    Container(
//height: 6.0,
//width: 6.0,
//decoration: BoxDecoration(
//color: furnitureCateDisableColor,
//shape: BoxShape.circle,
//),
//),
//SizedBox(
//width: 5.0,
//),
//Container(
//height: 5.0,
//width: 20.0,
//decoration: BoxDecoration(
//color: Colors.blue[700],
//borderRadius: BorderRadius.circular(10.0)),
//),
  @override
  State<StatefulWidget> createState() => new _KeTaoFeaturedTaskIndexPageState();
}

int SVG_ANGLETYPE_DEG = 2;
int SVG_ANGLETYPE_GRAD = 4;
int SVG_ANGLETYPE_RAD = 3;
int SVG_ANGLETYPE_UNKNOWN = 0;
int SVG_ANGLETYPE_UNSPECIFIED = 1;

void main() {
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;
  runApp(KeTaoFeaturedTaskIndexPage());
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _KeTaoFeaturedTaskIndexPageState extends State<KeTaoFeaturedTaskIndexPage>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  List<KeTaoFeaturedNavigationIconView> _navigationViews;
  List<StatefulWidget> _pageList;
  StatefulWidget _currentPage;
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;

//默认索引
  int positionIndex = 0;

  ///展示隐私弹窗
  ///
  showPrivacyDialog(context) {
    return KeTaoFeaturedNavigatorUtils.showGSYDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: AlertDialog(
              title: Center(child: new Text('服务协议和隐私政策')), //
              content: Container(
                padding: EdgeInsets.all(0),
                height: 180,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      new Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text:
                                    "请你务必审慎阅读、充分理解\“服务协议\”和\“隐私政策\”各条款，包括但不限于：为了向你提供购物、内容分享等服务，我们需要收集你的设备信息、操作日志等个人信息。你可以在“设置”中查看、变更、删除个人信息并管理你的授权。你可阅读"),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  KeTaoFeaturedNavigatorUtils.navigatorRouter(
                                      context,
                                      KeTaoFeaturedWebViewPage(
                                        initialUrl: KeTaoFeaturedAPi
                                            .AGREEMENT_SERVICES_URL,
                                        showActions: false,
                                        title: "服务协议",
                                      ));
                                },
                                child: Text(
                                  "《服务协议》",
                                  style: TextStyle(
                                      color: KeTaoFeaturedGlobalConfig
                                          .taskHeadColor,
                                      fontSize: ScreenUtil().setSp(42)),
                                ),
                              ),
                            ),
                            //text: "《服务协议》",style: TextStyle(color: Colors.blueAccent)
                            TextSpan(text: "和"),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  KeTaoFeaturedNavigatorUtils.navigatorRouter(
                                      context,
                                      KeTaoFeaturedWebViewPage(
                                        initialUrl: KeTaoFeaturedAPi
                                            .AGREEMENT_PRIVACY_URL,
                                        showActions: false,
                                        title: "隐私政策",
                                      ));
                                },
                                child: Text(
                                  "《隐私政策》",
                                  style: TextStyle(
                                      color: KeTaoFeaturedGlobalConfig
                                          .taskHeadColor,
                                      fontSize: ScreenUtil().setSp(42)),
                                ),
                              ),
                            ),
                            TextSpan(text: "了解详细信息。如你同意，请点击“同意”开始接受我们的服务。"),
                          ],
                        ),
                        style: TextStyle(fontSize: ScreenUtil().setSp(42)),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    },
                    child: new Text(
                      '暂不使用',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(42),
                          color: Colors.black54),
                    )),
                Container(
                  height: 30,
                  alignment: Alignment.center,
                  child: new FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        KeTaoFeaturedGlobalConfig.prefs
                            .setBool("isAgreePrivacy", true);
                      },
                      child: new Text(
                        '同意',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: ScreenUtil().setSp(42),
                        ),
                      )),
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
//    KeTaoFeaturedUtils.checkAppVersion(context);
//    _initVersionData();
    super.initState();

    _currentIndex = widget.currentIndex;
    bus.on("changBottomBar", (arg) {
      if (!mounted) {
        return;
      }
      setState(() {
        /*if (index == 1) {
                      if (!GlobalConfig.isLogin()) {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return LoginPage();
                        }));
                      } else {
                        _navigationViews[_currentIndex].controller.reverse();
                        _currentIndex = index;
                        _navigationViews[_currentIndex].controller.forward();
                        _currentPage = _pageList[_currentIndex];
                      }
                    } else {
                      _navigationViews[_currentIndex].controller.reverse();
                      _currentIndex = index;
                      _navigationViews[_currentIndex].controller.forward();
                      _currentPage = _pageList[_currentIndex];
                    }*/
        {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = 0;
          _navigationViews[_currentIndex].controller.forward();
          _currentPage = _pageList[_currentIndex];
          _pageController.jumpToPage(_currentIndex);
        }
      });
    });
    bus.on("changeBottomNavigatorBarWithCategoryId", (cid) {
      if (mounted) {
        setState(() {
          /*if (index == 1) {
                      if (!GlobalConfig.isLogin()) {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return LoginPage();
                        }));
                      } else {
                        _navigationViews[_currentIndex].controller.reverse();
                        _currentIndex = index;
                        _navigationViews[_currentIndex].controller.forward();
                        _currentPage = _pageList[_currentIndex];
                      }
                    } else {
                      _navigationViews[_currentIndex].controller.reverse();
                      _currentIndex = index;
                      _navigationViews[_currentIndex].controller.forward();
                      _currentPage = _pageList[_currentIndex];
                    }*/
          {
            _navigationViews[_currentIndex].controller.reverse();
            _currentIndex = 1;
            _navigationViews[_currentIndex].controller.forward();
            _currentPage = _pageList[_currentIndex];
            _pageController.jumpToPage(_currentIndex);
            bus.emit("changeSelCategory", cid);
          }
        });
      }
    });
  }

  DateTime _lastQuitTime;
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 1125, height: 2436, allowFontScaling: false);

    return KeyboardDismissOnTap(
      child: Scaffold(
        body: WillPopScope(
            onWillPop: () async {
              if (_lastQuitTime == null ||
                  DateTime.now().difference(_lastQuitTime).inSeconds > 1) {
                /*Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('再按一次 Back 按钮退出')));*/
                KeTaoFeaturedCommonUtils.showToast("再按一次返回键退出应用");
                _lastQuitTime = DateTime.now();
                return false;
              } else {
                // 退出app
                await SystemChannels.platform
                    .invokeMethod('SystemNavigator.pop');
//              Navigator.of(context).pop(true);
                return true;
              }
            },
            child: buildHomeWidget()),
      ),
    );
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Scaffold buildHomeWidget() {
    _navigationViews = <KeTaoFeaturedNavigationIconView>[
      new KeTaoFeaturedNavigationIconView(
          /*  icon: SvgPicture.asset(
//                'https://alipic.lanhuapp.com/xd8c969d26-126e-4eeb-abf8-c58086628934',
            'static/images/icon_home.svg',
            width: ScreenUtil().setWidth(74),
            height: ScreenUtil().setWidth(76),
            color: Color(0xff777777),
          ),*/
          icon: CachedNetworkImage(
            imageUrl:
//                'https://alipic.lanhuapp.com/xd8c969d26-126e-4eeb-abf8-c58086628934',
//                'https://alipic.lanhuapp.com/xde9009b67-5da3-4cb5-ae5e-0a6adaf47e9e',
                'https://alipic.lanhuapp.com/xdd80e7e5c-243b-411f-8454-9a48f25853d2',
            width: ScreenUtil().setWidth(63),
            height: ScreenUtil().setWidth(65),
          ),
          /*  activeIcon: SvgPicture.asset(
//                'https://alipic.lanhuapp.com/xd8c969d26-126e-4eeb-abf8-c58086628934',
            'static/images/icon_home_sel.svg',
            width: ScreenUtil().setWidth(74),
            height: ScreenUtil().setWidth(76),
            color: Color(0xffce0100),
          ),*/
          activeIcon: CachedNetworkImage(
            imageUrl:
                'https://alipic.lanhuapp.com/xde2a3868a-a068-45f6-ac12-81660cc87de6',
/*
            imageUrl:
                'https://alipic.lanhuapp.com/xd456bae13-0c32-4df3-a87f-f2f93c5961aa',
*/
            width: ScreenUtil().setWidth(63),
            height: ScreenUtil().setWidth(65),
          ),
          title: new Text(
            '首页',
            style: TextStyle(fontSize: ScreenUtil().setSp(28)),
          ),
          vsync: this),
      new KeTaoFeaturedNavigationIconView(
          /* icon: SvgPicture.asset(
//                'https://alipic.lanhuapp.com/xd8c969d26-126e-4eeb-abf8-c58086628934',
            'static/images/icon_category.svg',
            width: ScreenUtil().setWidth(74),
            height: ScreenUtil().setWidth(76),
            color: Color(0xff777777),
          ),*/
          icon: CachedNetworkImage(
            imageUrl:
                'https://alipic.lanhuapp.com/xd12d320c0-c1d3-419f-badd-8e4cd2059fc4',
            width: ScreenUtil().setWidth(65),
            height: ScreenUtil().setWidth(65),
          ),
          /*activeIcon: SvgPicture.asset(
//                'https://alipic.lanhuapp.com/xd8c969d26-126e-4eeb-abf8-c58086628934',
            'static/images/icon_category_sel.svg',
            width: ScreenUtil().setWidth(74),
            height: ScreenUtil().setWidth(76),
            color: Color(0xffce0100),
          ),*/
          activeIcon: CachedNetworkImage(
            imageUrl:
                'https://alipic.lanhuapp.com/xdc0651a96-9f94-404c-accc-7a96d4b0afdc',
            width: ScreenUtil().setWidth(65),
            height: ScreenUtil().setWidth(65),
          ),
          title: new Text(
            '分类',
            style: TextStyle(fontSize: ScreenUtil().setSp(28)),
          ),
          vsync: this),
      new KeTaoFeaturedNavigationIconView(
          /* icon: SvgPicture.asset(
//                'https://alipic.lanhuapp.com/xd8c969d26-126e-4eeb-abf8-c58086628934',
            'static/images/icon_category.svg',
            width: ScreenUtil().setWidth(74),
            height: ScreenUtil().setWidth(76),
            color: Color(0xff777777),
          ),*/
          icon: CachedNetworkImage(
            imageUrl:
                'https://alipic.lanhuapp.com/xd22d681ac-1152-4270-972e-06f8bddc8ff1',
            width: ScreenUtil().setWidth(65),
            height: ScreenUtil().setWidth(65),
          ),
          /*activeIcon: SvgPicture.asset(
//                'https://alipic.lanhuapp.com/xd8c969d26-126e-4eeb-abf8-c58086628934',
            'static/images/icon_category_sel.svg',
            width: ScreenUtil().setWidth(74),
            height: ScreenUtil().setWidth(76),
            color: Color(0xffce0100),
          ),*/
          activeIcon: CachedNetworkImage(
            imageUrl:
                'https://alipic.lanhuapp.com/xdbd0f90f1-6c3e-4e00-90ca-b3e0280c9aed',
            width: ScreenUtil().setWidth(65),
            height: ScreenUtil().setWidth(65),
          ),
          title: new Text(
            '订单',
            style: TextStyle(fontSize: ScreenUtil().setSp(28)),
          ),
          vsync: this),
      new KeTaoFeaturedNavigationIconView(
          /*icon: SvgPicture.asset(
//                'https://alipic.lanhuapp.com/xd8c969d26-126e-4eeb-abf8-c58086628934',
            'static/images/icon_mine.svg',
            width: ScreenUtil().setWidth(56),
            height: ScreenUtil().setWidth(76),
            color: Color(0xff777777),
          ),
          activeIcon: SvgPicture.asset(
//                'https://alipic.lanhuapp.com/xd8c969d26-126e-4eeb-abf8-c58086628934',
            'static/images/icon_mine_sel.svg',
            width: ScreenUtil().setWidth(56),
            height: ScreenUtil().setWidth(76),
            color: Color(0xffce0100),
          ),*/
          icon: CachedNetworkImage(
            imageUrl:
                'https://alipic.lanhuapp.com/xd170fdd91-f0f6-4126-a795-c27c5450f5b9',
            width: ScreenUtil().setWidth(65),
            height: ScreenUtil().setWidth(65),
          ),
          /*activeIcon: SvgPicture.asset(
//                'https://alipic.lanhuapp.com/xd8c969d26-126e-4eeb-abf8-c58086628934',
            'static/images/icon_category_sel.svg',
            width: ScreenUtil().setWidth(74),
            height: ScreenUtil().setWidth(76),
            color: Color(0xffce0100),
          ),*/
          activeIcon: CachedNetworkImage(
            imageUrl:
                'https://alipic.lanhuapp.com/xdbfc72cc5-8334-440b-ad19-76f4327a2d7a',
            width: ScreenUtil().setWidth(65),
            height: ScreenUtil().setWidth(65),
          ),
          title: new Text(
            '个人中心',
            style: TextStyle(fontSize: ScreenUtil().setSp(28)),
          ),
          vsync: this)
    ];
    for (KeTaoFeaturedNavigationIconView view in _navigationViews) {
      view.controller.addListener(_rebuild);
    }

    _pageList = <StatefulWidget>[
//      new HomePage(tabIndex: _homeTabIndex),
      KeTaoFeaturedHomePagePage(),
      KeTaoFeaturedNewClassifyListPage(),
      KeTaoFeaturedOrderListPage(
        showBackBtnIcon: false,
      ),
      KeTaoFeaturedMinePagePage(),
      /*   new NoticePage(),
      new MyPage()*/
    ];
    _currentPage = _pageList[_currentIndex];
    return new Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: _pageList,
          physics: NeverScrollableScrollPhysics(), // 禁止滑动
        ),
        bottomNavigationBar: Builder(
            builder: (context) => BottomNavigationBar(
                items: _navigationViews
                    .map((KeTaoFeaturedNavigationIconView navigationIconView) =>
                        navigationIconView.item)
                    .toList(),
                currentIndex: _currentIndex,
                fixedColor: Color(0xffCE0100),
                type: BottomNavigationBarType.fixed,
                onTap: (int index) {
                  setState(() {
                    /*if (index == 1) {
                      if (!GlobalConfig.isLogin()) {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return LoginPage();
                        }));
                      } else {
                        _navigationViews[_currentIndex].controller.reverse();
                        _currentIndex = index;
                        _navigationViews[_currentIndex].controller.forward();
                        _currentPage = _pageList[_currentIndex];
                      }
                    } else {
                      _navigationViews[_currentIndex].controller.reverse();
                      _currentIndex = index;
                      _navigationViews[_currentIndex].controller.forward();
                      _currentPage = _pageList[_currentIndex];
                    }*/
                    {
                      _navigationViews[_currentIndex].controller.reverse();
                      _currentIndex = index;
                      _navigationViews[_currentIndex].controller.forward();
                      _currentPage = _pageList[_currentIndex];
                      _pageController.jumpToPage(_currentIndex);
                    }
                  });
                })));
  }

  void _rebuild() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    for (KeTaoFeaturedNavigationIconView view in _navigationViews) {
      view.controller.dispose();
    }
  }
}

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.network('https://v-cdn.zjol.com.cn/277003.mp4')
          ..initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class KeTaoFeaturedHomeEmpty extends StatefulWidget {
  @override
  _KeTaoFeaturedHomeEmptyState createState() => _KeTaoFeaturedHomeEmptyState();
}

class _KeTaoFeaturedHomeEmptyState extends State<KeTaoFeaturedHomeEmpty>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}