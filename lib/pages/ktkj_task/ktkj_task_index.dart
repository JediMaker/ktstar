import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:star/bus/ktkj_my_event_bus.dart';
import 'package:star/global_config.dart';
import 'package:star/http/ktkj_api.dart';
import 'package:star/http/ktkj_http_manage.dart';
import 'package:star/pages/ktkj_goods/ktkj_cart/ktkj_goods_cart.dart';
import 'package:star/pages/ktkj_goods/ktkj_category/ktkj_new_classify.dart';
import 'package:star/pages/ktkj_merchantssettle/ktkj_shop_list.dart';
import 'package:star/pages/ktkj_task/ktkj_mine_page.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_octoimage.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_webview.dart';
import 'package:star/pages/ktkj_widget/ktkj_navigation_icon_view.dart';
import 'package:star/pages/ktxxhomenew/ktxx_home_page.dart';
import 'package:star/utils/ktkj_common_utils.dart';
import 'package:star/utils/ktkj_navigator_utils.dart';
import 'package:star/utils/ktkj_utils.dart';
import 'package:video_player/video_player.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJTaskIndexPage extends StatefulWidget {
  int currentIndex;

  KTKJTaskIndexPage({this.currentIndex = 0});

  @override
  State<StatefulWidget> createState() => new _TaskIndexPageState();
}

void main() {
  runApp(KTKJTaskIndexPage());
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _TaskIndexPageState extends State<KTKJTaskIndexPage>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  List<KTKJNavigationIconView> _navigationViews;
  List<StatefulWidget> _pageList;
  StatefulWidget _currentPage;

//默认索引
  int positionIndex = 0;

  _initVersionData() async {
    await KTKJGlobalConfig.initUserLocationWithPermission(count: 0);
    if (KTKJGlobalConfig.isLogin()) {
      await HttpManage.getUserInfo();
    }
    var versionInfo = await HttpManage.getVersionInfo();
    if (versionInfo.status) {
      switch (versionInfo.data.wxLogin) {
        case "1": //不显示
          KTKJGlobalConfig.displayThirdLoginInformation = false;

          if (mounted) {
            setState(() {});
          }
          break;

        case "2": //显示
          KTKJGlobalConfig.displayThirdLoginInformation = true;
          if (mounted) {
            setState(() {});
          }
          break;
      }
      if (versionInfo.data.whCheck) {
        //华为应用市场上架审核中
        KTKJGlobalConfig.prefs.setBool("isHuaweiUnderReview", true);
      } else {
        KTKJGlobalConfig.prefs.setBool("isHuaweiUnderReview", false);
      }
      if (!KTKJGlobalConfig.isAgreePrivacy &&
          KTKJGlobalConfig.isHuaweiUnderReview) {
        Future.delayed(Duration(milliseconds: 30), () {
          if (Platform.isAndroid) {
            showPrivacyDialog(context);
          }
        });
      }
    }
  }

  ///展示隐私弹窗
  ///
  showPrivacyDialog(context) {
    return KTKJNavigatorUtils.showGSYDialog(
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
                                  KTKJNavigatorUtils.navigatorRouter(
                                      context,
                                      KTKJWebViewPage(
                                        initialUrl: APi.AGREEMENT_SERVICES_URL,
                                        showActions: false,
                                        title: "服务协议",
                                      ));
                                },
                                child: Text(
                                  "《服务协议》",
                                  style: TextStyle(
                                      color: KTKJGlobalConfig.taskHeadColor,
                                      fontSize: ScreenUtil().setSp(42)),
                                ),
                              ),
                            ),
                            //text: "《服务协议》",style: TextStyle(color: Colors.blueAccent)
                            TextSpan(text: "和"),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  KTKJNavigatorUtils.navigatorRouter(
                                      context,
                                      KTKJWebViewPage(
                                        initialUrl: APi.AGREEMENT_PRIVACY_URL,
                                        showActions: false,
                                        title: "隐私政策",
                                      ));
                                },
                                child: Text(
                                  "《隐私政策》",
                                  style: TextStyle(
                                      color: KTKJGlobalConfig.taskHeadColor,
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
                        KTKJGlobalConfig.prefs.setBool("isAgreePrivacy", true);
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

  ///页面是否首次加载
  var isFirst = true;

  @override
  void initState() {
    KTKJUtils.checkAppVersion(context);
    _initVersionData();

    super.initState();
    _currentIndex = widget.currentIndex;
    bus.on("changBottomBar", (arg) {
      if (!mounted) {
        return;
      }
      setState(() {
        /*if (index == 1) {
                      if (!KTKJGlobalConfig.isLogin()) {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return KTKJLoginPage();
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
          _currentIndex = arg;
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
                      if (!KTKJGlobalConfig.isLogin()) {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return KTKJLoginPage();
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (isFirst) {
        isFirst = false;
        _currentPage = _pageList[_currentIndex];
        _pageController.jumpToPage(_currentIndex);
      }
    });
    return KeyboardDismissOnTap(
      child: Scaffold(
        body: WillPopScope(
            onWillPop: () async {
              if (_lastQuitTime == null ||
                  DateTime.now().difference(_lastQuitTime).inSeconds > 1) {
                /*Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('再按一次 Back 按钮退出')));*/
                KTKJCommonUtils.showToast("再按一次返回键退出应用");
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
    _navigationViews = <KTKJNavigationIconView>[
      new KTKJNavigationIconView(
          icon: SvgPicture.asset(
//                'https://alipic.lanhuapp.com/xd8c969d26-126e-4eeb-abf8-c58086628934',
            'static/images/icon_home.svg',
            width: ScreenUtil().setWidth(74),
            height: ScreenUtil().setWidth(76),
            color: Color(0xff777777),
          ),
/*
          icon: KTKJMyOctoImage(
            image:
//                'https://alipic.lanhuapp.com/xd8c969d26-126e-4eeb-abf8-c58086628934',
                'https://alipic.lanhuapp.com/xde9009b67-5da3-4cb5-ae5e-0a6adaf47e9e',
            width: ScreenUtil().setWidth(74),
            height: ScreenUtil().setWidth(76),
          ),
*/
          activeIcon: SvgPicture.asset(
//                'https://alipic.lanhuapp.com/xd8c969d26-126e-4eeb-abf8-c58086628934',
            'static/images/icon_home_sel.svg',
            width: ScreenUtil().setWidth(74),
            height: ScreenUtil().setWidth(76),
            color: Color(0xffce0100),
          ),
/*
          activeIcon: KTKJMyOctoImage(
            image:
                'https://alipic.lanhuapp.com/xd456bae13-0c32-4df3-a87f-f2f93c5961aa',
            width: ScreenUtil().setWidth(74),
            height: ScreenUtil().setWidth(76),
          ),
*/
          title: new Text(
            '首页',
            style: TextStyle(fontSize: ScreenUtil().setSp(28)),
          ),
          vsync: this),
      new KTKJNavigationIconView(
          icon: SvgPicture.asset(
//                'https://alipic.lanhuapp.com/xd8c969d26-126e-4eeb-abf8-c58086628934',
            'static/images/icon_category.svg',
            width: ScreenUtil().setWidth(74),
            height: ScreenUtil().setWidth(76),
            color: Color(0xff777777),
          ),
/*
          icon: KTKJMyOctoImage(
            image:
                'https://alipic.lanhuapp.com/xda87fe7ad-f66f-4d6a-a344-5bfcd0664c21',
            width: ScreenUtil().setWidth(75),
            height: ScreenUtil().setWidth(75),
          ),
*/
          activeIcon: SvgPicture.asset(
//                'https://alipic.lanhuapp.com/xd8c969d26-126e-4eeb-abf8-c58086628934',
            'static/images/icon_category_sel.svg',
            width: ScreenUtil().setWidth(74),
            height: ScreenUtil().setWidth(76),
            color: Color(0xffce0100),
          ),
          title: new Text(
            '分类',
            style: TextStyle(fontSize: ScreenUtil().setSp(28)),
          ),
          vsync: this),
      new KTKJNavigationIconView(
          /* icon: SvgPicture.asset(
//                'https://alipic.lanhuapp.com/xd8c969d26-126e-4eeb-abf8-c58086628934',
            'static/images/icon_category.svg',
            width: ScreenUtil().setWidth(74),
            height: ScreenUtil().setWidth(76),
            color: Color(0xff777777),
          ),*/
          icon: KTKJMyOctoImage(
            image:
                'https://alipic.lanhuapp.com/xd6a74748b-ce4e-4e98-99e4-2603cedfd48f',
            width: ScreenUtil().setWidth(80),
            height: ScreenUtil().setWidth(76),
          ),
          /*activeIcon: SvgPicture.asset(
//                'https://alipic.lanhuapp.com/xd8c969d26-126e-4eeb-abf8-c58086628934',
            'static/images/icon_category_sel.svg',
            width: ScreenUtil().setWidth(74),
            height: ScreenUtil().setWidth(76),
            color: Color(0xffce0100),
          ),*/
          activeIcon: KTKJMyOctoImage(
            image:
                'https://alipic.lanhuapp.com/xdf6407325-4243-4676-abd2-fa4d2b151c50',
            width: ScreenUtil().setWidth(80),
            height: ScreenUtil().setWidth(76),
          ),
          title: new Text(
            '购物车',
            style: TextStyle(fontSize: ScreenUtil().setSp(28)),
          ),
          vsync: this),
      new KTKJNavigationIconView(
          /* icon: SvgPicture.asset(
//                'https://alipic.lanhuapp.com/xd8c969d26-126e-4eeb-abf8-c58086628934',
            'static/images/icon_category.svg',
            width: ScreenUtil().setWidth(74),
            height: ScreenUtil().setWidth(76),
            color: Color(0xff777777),
          ),*/
          icon: KTKJMyOctoImage(
            image:
                'https://alipic.lanhuapp.com/xd182ca7eb-0c78-44f8-8ae3-b86073dfcbcb',
            width: ScreenUtil().setWidth(80),
            height: ScreenUtil().setWidth(79),
          ),
          /*activeIcon: SvgPicture.asset(
//                'https://alipic.lanhuapp.com/xd8c969d26-126e-4eeb-abf8-c58086628934',
            'static/images/icon_category_sel.svg',
            width: ScreenUtil().setWidth(74),
            height: ScreenUtil().setWidth(76),
            color: Color(0xffce0100),
          ),*/
          activeIcon: KTKJMyOctoImage(
            image:
                'https://alipic.lanhuapp.com/xdda990b37-c04e-43e7-be69-871b56aa0e28',
            width: ScreenUtil().setWidth(77),
            height: ScreenUtil().setWidth(75),
          ),
          title: new Text(
            '联盟商家',
            style: TextStyle(fontSize: ScreenUtil().setSp(28)),
          ),
          vsync: this),
      new KTKJNavigationIconView(
          icon: SvgPicture.asset(
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
          ),
          title: new Text(
            '我的',
            style: TextStyle(fontSize: ScreenUtil().setSp(28)),
          ),
          vsync: this)
    ];
    for (KTKJNavigationIconView view in _navigationViews) {
      view.controller.addListener(_rebuild);
    }

    _pageList = <StatefulWidget>[
//      new HomePage(tabIndex: _homeTabIndex),
      KTKJHomePagePage(),
      KTKJNewClassifyListPage(),
      KTKJShoppingCartPage(),
      /*KTKJMicroShareHolderEquityPage(
        showBackBtnIcon: false,
      ),*/
      KTKJShopListPage(),
      KTKJMinePagePage(),
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
                    .map((KTKJNavigationIconView navigationIconView) =>
                        navigationIconView.item)
                    .toList(),
                currentIndex: _currentIndex,
                fixedColor: Color(0xffCE0100),
                type: BottomNavigationBarType.fixed,
                onTap: (int index) {
                  setState(() {
                    /*if (index == 1) {
                      if (!KTKJGlobalConfig.isLogin()) {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return KTKJLoginPage();
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
    for (KTKJNavigationIconView view in _navigationViews) {
      view.controller.dispose();
    }
  }
}

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
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