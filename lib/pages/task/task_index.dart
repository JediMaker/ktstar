import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:star/global_config.dart';
import 'package:star/pages/task/task_list.dart';
import 'package:star/pages/task/task_mine.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  @override
  void initState() {
    initPlatformState();
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  String debugLable = 'Unknown';
  final JPush jpush = new JPush();

  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotification: $message");
        setState(() {
          debugLable = "flutter onReceiveNotification: $message";
        });
      }, onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
        setState(() {
          debugLable = "flutter onOpenNotification: $message";
        });
      }, onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");
        setState(() {
          debugLable = "flutter onReceiveMessage: $message";
        });
      }, onReceiveNotificationAuthorization:
              (Map<String, dynamic> message) async {
        print("flutter onReceiveNotificationAuthorization: $message");
        setState(() {
          debugLable = "flutter onReceiveNotificationAuthorization: $message";
        });
      });
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    jpush.setup(
      appKey: GlobalConfig.JPUSH_APPKEY, //你自己应用的 AppKey
      channel: "theChannel",
      production: false,
      debug: true,
    );
    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));

    // Platform messages may fail, so we use a try/catch PlatformException.
    jpush.getRegistrationID().then((rid) {
      print("flutter get registration id : $rid");
      setState(() {
        debugLable = "flutter getRegistrationID: $rid";
      });
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      debugLable = platformVersion;
      print(debugLable.toString());
    });
  }

  DateTime _lastQuitTime;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 1125, height: 2436, allowFontScaling: false);
    return Scaffold(
      body: WillPopScope(
          onWillPop: () async {
            if (_lastQuitTime == null ||
                DateTime.now().difference(_lastQuitTime).inSeconds > 1) {
              /*Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('再按一次 Back 按钮退出')));*/
              Fluttertoast.showToast(
                  msg: "再按一次返回键退出应用",
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  gravity: ToastGravity.BOTTOM);
              _lastQuitTime = DateTime.now();
              return false;
            } else {
              // 退出app
              await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//              Navigator.of(context).pop(true);
              return true;
            }
          },
          child: buildHomeWidget()),
    );
  }

  Scaffold buildHomeWidget() {
    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
          icon: Image.asset(
            "static/images/home_unselect.png",
            width: 29,
            height: 25,
          ),
          activeIcon: Image.asset(
            "static/images/home_select.png",
            width: 29,
            height: 25,
          ),
          title: new Text(
            '任务大厅',
            style: TextStyle(fontSize: ScreenUtil().setSp(28)),
          ),
          vsync: this),
      new NavigationIconView(
          icon: Image.asset(
            "static/images/mine_unselect.png",
            width: 20,
            height: 25,
          ),
          activeIcon: Image.asset(
            "static/images/mine_select.png",
            width: 20,
            height: 25,
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
      TaskMinePage(),
      /*   new NoticePage(),
      new MyPage()*/
    ];
    _currentPage = _pageList[_currentIndex];
    return new Scaffold(
        body: new Center(child: _currentPage),
        bottomNavigationBar: Builder(
            builder: (context) => BottomNavigationBar(
                items: _navigationViews
                    .map((NavigationIconView navigationIconView) =>
                        navigationIconView.item)
                    .toList(),
                currentIndex: _currentIndex,
                fixedColor: GlobalConfig.taskHeadColor,
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
