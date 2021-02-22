import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:star/ktxx_global_config.dart';
import 'package:star/ktxxpages/ktxx_base_router/ktxx_app_analysis.dart';
import 'package:star/ktxxpages/ktxx_base_router/ktxx_myrouter.dart';
import 'package:star/ktxxpages/ktxxlogin/ktxx_login.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_index.dart';
import 'package:star/ktxxpages/ktxxwidget/ktxx_splash_page.dart';
import 'package:star/ktxxutils/ktxx_common_utils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'ktxxpages/ktxxwidget/ktxx_common_localizations.dart';
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
void main() {
  WidgetsFlutterBinding.ensureInitialized(); //确认初始化操作完成
//
  KeTaoFeaturedGlobalConfig.init().then((value) async => {runApp(MyApp())});
  /*if (Platform.isAndroid) {
    //设置状态栏颜色
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //设置为透明
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }*/

/*//  链接：https://juejin.im/post/6844903762398560270
  ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
    print(flutterErrorDetails.toString());
    return Center(
      child: Text("哎呀呀！走神了。。。"),
    );
  };*/
}
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '可淘星选',
      navigatorKey: KeTaoFeaturedGlobalConfig.navigatorKey,
      onGenerateRoute: MyRouters.generateRoute,
      navigatorObservers: [KeTaoFeaturedAppAnalysis()],
      theme: ThemeData(
//        primarySwatch: CommonUtils.createMaterialColor(Colors.white),
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: Color(0xfff5f5f5),
      ),
      home: KeTaoFeaturedTaskIndexPage(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,

        ///自定义代理
        KeTaoFeaturedCommonLocalizationsDelegate(),
      ],

      ///指定简体中文
      locale: const Locale('zh', 'CN'),
      supportedLocales: [
        const Locale('zh', 'CN'),
        const Locale('en', 'US'),
      ],
    );
  }
}
// _getRemoteConfig() async {
//   if (remoteConfig == null) remoteConfig = await RemoteConfig.instance;
//   final Map<String, dynamic> defaults = {
//     "news": "[]",
//     "survey": "",
//   };
//   await remoteConfig.setDefaults(defaults);
//   await remoteConfig.fetch(expiration: const Duration(hours: 12));
//   await remoteConfig.activateFetched();
//   final String value = remoteConfig.getString('news');
//   final String surval = remoteConfig.getString('survey');
//   setState(() {
//     announcements = List<Map<String, dynamic>>.from(json.decode(value))
//         .map((data) => Announcement.fromMap(data))
//         .toList();
//     if(surval.isNotEmpty)
//     survey =
//         SurveyItem.fromMap(Map<String, dynamic>.from(json.decode(surval)));
//   });
// }
///过时的代码 已停用
/*class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}*/