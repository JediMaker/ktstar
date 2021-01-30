import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:star/global_config.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/home_entity.dart';
import 'package:star/pages/goods/category/classify.dart';
import 'package:star/pages/task/task_list.dart';
import 'package:star/pages/task/task_mine.dart';
import 'package:star/pages/task/mine_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/utils/common_utils.dart';
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

  @override
  void initState() {
    Utils.checkAppVersion(context);
    super.initState();

    _currentIndex = widget.currentIndex;
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
          icon: CachedNetworkImage(
            imageUrl:
            'https://alipic.lanhuapp.com/xd8c969d26-126e-4eeb-abf8-c58086628934',
            width: ScreenUtil().setWidth(74),
            height: ScreenUtil().setWidth(76),
          ),
          activeIcon: CachedNetworkImage(
            imageUrl:
            'https://alipic.lanhuapp.com/xd456bae13-0c32-4df3-a87f-f2f93c5961aa',
            width: ScreenUtil().setWidth(74),
            height: ScreenUtil().setWidth(76),
          ),
          title: new Text(
            '首页',
            style: TextStyle(fontSize: ScreenUtil().setSp(28)),
          ),
          vsync: this),
      new NavigationIconView(
          icon: CachedNetworkImage(
            imageUrl:
                'https://alipic.lanhuapp.com/xda87fe7ad-f66f-4d6a-a344-5bfcd0664c21',
            width: ScreenUtil().setWidth(75),
            height: ScreenUtil().setWidth(75),
          ),
          activeIcon: CachedNetworkImage(
            imageUrl:
                'https://alipic.lanhuapp.com/xdb5e9695f-3ead-4ba1-b2df-3390f0abef31',
            width: ScreenUtil().setWidth(75),
            height: ScreenUtil().setWidth(75),
          ),
          title: new Text(
            '分类',
            style: TextStyle(fontSize: ScreenUtil().setSp(28)),
          ),
          vsync: this),
      new NavigationIconView(
          icon: CachedNetworkImage(
            imageUrl:
            'https://alipic.lanhuapp.com/xdc5273bd2-20f1-4a0b-9ee8-4db8e81dd1c8',
            width: ScreenUtil().setWidth(56),
            height: ScreenUtil().setWidth(76),
          ),
          activeIcon: CachedNetworkImage(
            imageUrl:
            'https://alipic.lanhuapp.com/xd6b741c9c-ec84-4146-b72a-3705771a4bc5',
            width: ScreenUtil().setWidth(56),
            height: ScreenUtil().setWidth(76),
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
      ClassifyListPage(),
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
