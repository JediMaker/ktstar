import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:star/bus/my_event_bus.dart';
import 'package:star/global_config.dart';
import 'package:star/http/api.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/home_entity.dart';
import 'package:star/pages/goods/category/classify.dart';
import 'package:star/pages/goods/category/new_classify.dart';
import 'package:star/pages/task/task_list.dart';
import 'package:star/pages/task/task_mine.dart';
import 'package:star/pages/task/mine_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/pages/widget/my_webview.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';
import 'package:star/utils/utils.dart';
import 'package:video_player/video_player.dart';

import '../widget/navigation_icon_view.dart';

class TaskIndexPage extends StatefulWidget {
  int currentIndex;

  TaskIndexPage({this.currentIndex = 0});

  @override
  State<StatefulWidget> createState() => new _TaskIndexPageState();
}

void main() {
  runApp(TaskIndexPage());
}

class _TaskIndexPageState extends State<TaskIndexPage>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  List<NavigationIconView> _navigationViews;
  List<StatefulWidget> _pageList;
  StatefulWidget _currentPage;

//默认索引
  int positionIndex = 0;

  _initVersionData() async {
    var versionInfo = await HttpManage.getVersionInfo();
    if (versionInfo.status) {
      switch (versionInfo.data.wxLogin) {
        case "1": //不显示
          GlobalConfig.displayThirdLoginInformation = false;

          if (mounted) {
            setState(() {});
          }
          break;

        case "2": //显示
          GlobalConfig.displayThirdLoginInformation = true;
          if (mounted) {
            setState(() {});
          }
          break;
      }
      if (versionInfo.data.whCheck) {
        //华为应用市场上架审核中
        GlobalConfig.prefs.setBool("isHuaweiUnderReview", true);
      } else {
        GlobalConfig.prefs.setBool("isHuaweiUnderReview", false);
      }
      if (!GlobalConfig.isAgreePrivacy && GlobalConfig.isHuaweiUnderReview) {
        Future.delayed(Duration(milliseconds: 30), () {
          showPrivacyDialog(context);
        });
      }
    }
  }

  ///展示隐私弹窗
  ///
  showPrivacyDialog(context) {
    return NavigatorUtils.showGSYDialog(
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
                                  NavigatorUtils.navigatorRouter(
                                      context,
                                      WebViewPage(
                                        initialUrl: APi.AGREEMENT_SERVICES_URL,
                                        showActions: false,
                                        title: "服务协议",
                                      ));
                                },
                                child: Text(
                                  "《服务协议》",
                                  style: TextStyle(
                                      color: GlobalConfig.taskHeadColor,
                                      fontSize: ScreenUtil().setSp(42)),
                                ),
                              ),
                            ),
                            //text: "《服务协议》",style: TextStyle(color: Colors.blueAccent)
                            TextSpan(text: "和"),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  NavigatorUtils.navigatorRouter(
                                      context,
                                      WebViewPage(
                                        initialUrl: APi.AGREEMENT_PRIVACY_URL,
                                        showActions: false,
                                        title: "隐私政策",
                                      ));
                                },
                                child: Text(
                                  "《隐私政策》",
                                  style: TextStyle(
                                      color: GlobalConfig.taskHeadColor,
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
                        GlobalConfig.prefs.setBool("isAgreePrivacy", true);
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
    Utils.checkAppVersion(context);
    _initVersionData();
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
      bus.emit("changeSelCategory", cid);
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
          _currentIndex = 1;
          _navigationViews[_currentIndex].controller.forward();
          _currentPage = _pageList[_currentIndex];
          _pageController.jumpToPage(_currentIndex);
        }
      });
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
                CommonUtils.showToast("再按一次返回键退出应用");
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
    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
          icon: SvgPicture.asset(
//                'https://alipic.lanhuapp.com/xd8c969d26-126e-4eeb-abf8-c58086628934',
            'static/images/icon_home.svg',
            width: ScreenUtil().setWidth(74),
            height: ScreenUtil().setWidth(76),
            color: Color(0xff777777),
          ),
/*
          icon: CachedNetworkImage(
            imageUrl:
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
          activeIcon: CachedNetworkImage(
            imageUrl:
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
      new NavigationIconView(
          icon: SvgPicture.asset(
//                'https://alipic.lanhuapp.com/xd8c969d26-126e-4eeb-abf8-c58086628934',
            'static/images/icon_category.svg',
            width: ScreenUtil().setWidth(74),
            height: ScreenUtil().setWidth(76),
            color: Color(0xff777777),
          ),
/*
          icon: CachedNetworkImage(
            imageUrl:
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
      new NavigationIconView(
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
    for (NavigationIconView view in _navigationViews) {
      view.controller.addListener(_rebuild);
    }

    _pageList = <StatefulWidget>[
//      new HomePage(tabIndex: _homeTabIndex),
      TaskListPage(),
      NewClassifyListPage(),
      MinePagePage(),
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
                    .map((NavigationIconView navigationIconView) =>
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
    for (NavigationIconView view in _navigationViews) {
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
