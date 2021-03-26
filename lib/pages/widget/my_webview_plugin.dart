// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alipay/flutter_alipay.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../global_config.dart';
import 'loading_nomal.dart';

void main() => runApp(MaterialApp(
        home: KTKJWebViewPluginPage(
      initialUrl: 'https://baidu.com',
    )));

String selectedUrl =
    'https://ms.czb365.com/?platformType=92657653&platformCode=15695657828&t=1606702970.981 ';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJWebViewPluginPage extends StatefulWidget {
  var initialUrl;
  var title;
  Color appBarBackgroundColor;
  bool showActions;

  KTKJWebViewPluginPage(
      {@required this.initialUrl,
      this.title,
      this.showActions = false,
      this.appBarBackgroundColor = KTKJGlobalConfig.taskHeadColor});

  @override
  _WebViewPluginPageState createState() => _WebViewPluginPageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _WebViewPluginPageState extends State<KTKJWebViewPluginPage> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  var _loadingVisiablity = true;
  bool showToast = true;

  // On destroy stream
  StreamSubscription _onDestroy;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  StreamSubscription<WebViewHttpError> _onHttpError;

  StreamSubscription<double> _onProgressChanged;

  StreamSubscription<double> _onScrollYChanged;

  StreamSubscription<double> _onScrollXChanged;

  @override
  void initState() {
    super.initState();

    flutterWebViewPlugin.close();

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        /*  _scaffoldKey.currentState.showSnackBar(
            const SnackBar(content: const Text('Webview Destroyed')));*/
      }
    });

    // Add a listener to on url changed
    _onUrlChanged =
        flutterWebViewPlugin.onUrlChanged.listen((String url) async {
      print('onUrlChanged: $url');
      /* if (url.startsWith("weixin://")) {
        flutterWebViewPlugin.goBack();
        if (canLaunch(url) != null) {
          launch(url, forceSafariVC: false);
        } else {
          KTKJCommonUtils.showToast("未安装相应的客户端");
        }
      }
      if (url.contains("alipay://") || url.contains("alipays://platformapi")) {
        flutterWebViewPlugin.goBack();
        try {
          var payResult = await FlutterAlipay.pay(url);
          print('onUrlChanged--payResult: $payResult');
        } on Exception catch (e) {}
      }*/
    });

    _onProgressChanged =
        flutterWebViewPlugin.onProgressChanged.listen((double progress) {
      /* if (mounted) {
            setState(() {
              _history.add('onProgressChanged: $progress');
            });
          }*/
      print('onProgressChanged: $progress');
    });

    _onScrollYChanged =
        flutterWebViewPlugin.onScrollYChanged.listen((double y) {
      /*  if (mounted) {
            setState(() {
              _history.add('Scroll in Y Direction: $y');

            });
          }*/
//      print('Scroll in Y Direction: $y');
    });

    _onScrollXChanged =
        flutterWebViewPlugin.onScrollXChanged.listen((double x) {
      /*   if (mounted) {
            setState(() {
              _history.add('Scroll in X Direction: $x');
            });
          }*/
//      print('Scroll in X Direction: $x');
    });

    _onStateChanged = flutterWebViewPlugin.onStateChanged
        .listen((WebViewStateChanged state) async {
      /*  if (mounted) {
            setState(() {
              _history.add('onStateChanged: ${state.type} ${state.url}');
            });
          }*/
      print('onStateChanged: ${state.type} ${state.url}');
      if (state.type == WebViewState.shouldStart) {
        //拦截即将展现的页面
        if (state.url.startsWith("weixin://") ||
            state.url.startsWith("alipays://") ||
            state.url.startsWith("alipay://") ||
            state.url.startsWith("pinduoduo://") ||
            state.url.startsWith("androidamap://route") ||
            state.url.startsWith("http://ditu.amap.com")) {
          flutterWebViewPlugin.stopLoading(); //停止加载
          try {
            if (await canLaunch(state.url)) {
              await launch(state.url);
              flutterWebViewPlugin.goBack();
            } else {
              if (state.url.startsWith("pinduoduo://")) {
                if (showToast) {
                  showToast = false;
                  KTKJCommonUtils.showToast("亲，您还未安装拼多多客户端哦！");
                  /* Navigator.of(context).pop();
                  KTKJNavigatorUtils.navigatorRouter(
                      context,
                      KTKJWebViewPluginPage(
                        initialUrl: widget.pinduoduoAlternativeUrl,
                        showActions: true,
                        title: "拼多多",
                        appBarBackgroundColor: Colors.transparent,
                      ));*/
                  /*flutterWebViewPlugin
                      .reloadUrl(widget.pinduoduoAlternativeUrl);*/
                  /*KTKJNavigatorUtils.navigatorRouterReplaceMent(
                      context,
                      KTKJWebViewPluginPage(
                        initialUrl: widget.pinduoduoAlternativeUrl,
                        showActions: true,
                        title: "拼多多",
                        appBarBackgroundColor: Colors.transparent,
                      ));*/
                }
              } else {
                KTKJCommonUtils.showToast("未安装相应的客户端");
              }
            }
          } catch (e) {}
        }
      }
    });

    _onHttpError =
        flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) {
      /* if (mounted) {
            setState(() {
              _history.add('onHttpError: ${error.code} ${error.url}');
            });
          }*/
      print('onHttpError: ${error.code} ${error.url}');
    });
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return WebviewScaffold(
      appBar: AppBar(
        backgroundColor: widget.appBarBackgroundColor,
        title: Text(
          widget.title == null ? '' : widget.title,
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: ScreenUtil().setSp(54),
          ),
        ),
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
          onPressed: () async {
            if (await flutterWebViewPlugin.canGoBack()) {
              await flutterWebViewPlugin.goBack();
            } else {
              Navigator.of(context).pop();
              return;
            }
          },
        ),
        centerTitle: true,
        brightness: Brightness.light,
        elevation: 0,
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        actions: <Widget>[
          Visibility(
            child: Row(
              children: <Widget>[
                /*  IconButton(
                  icon: const Icon(CupertinoIcons.back),
                  onPressed: () async {
                    if (await flutterWebViewPlugin.canGoBack()) {
                      await flutterWebViewPlugin.goBack();
                    } else {
                      Scaffold.of(this.context).showSnackBar(
                        const SnackBar(content: Text("没有上一页了。。。")),
                      );
                      return;
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(CupertinoIcons.forward),
                  onPressed: () async {
                    if (await flutterWebViewPlugin.canGoForward()) {
                      await flutterWebViewPlugin.goForward();
                    } else {
                      Scaffold.of(this.context).showSnackBar(
                        const SnackBar(content: Text("没有下一页了。。。")),
                      );
                      return;
                    }
                  },
                ),*/
                IconButton(
                  icon: const Icon(
                    CupertinoIcons.refresh,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    flutterWebViewPlugin.reload();
                  },
                ),
                IconButton(
                  icon: Text(
                    '关闭',
                    style: TextStyle(
                      color: Color(0xFF222222),
                      fontSize: ScreenUtil().setSp(38),
                    ),
                  ),
                  onPressed: () {
//                    flutterWebViewPlugin.reload();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            visible: widget.showActions,
          ),
//          SampleMenu(_controller.future),
        ],
      ),
      url: widget.initialUrl,
      javascriptChannels: jsChannels,
      withJavascript: true,
      useWideViewPort: true,
      withOverviewMode: true,
      mediaPlaybackRequiresUserGesture: false,
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      geolocationEnabled: true,
      ignoreSSLErrors: Platform.isAndroid ? true : false,
//      userAgent: "gaoyongApp",
    );
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    _onProgressChanged.cancel();
    _onScrollXChanged.cancel();
    _onScrollYChanged.cancel();

    flutterWebViewPlugin.dispose();

    super.dispose();
  }

// ignore: prefer_collection_literals
  final Set<JavascriptChannel> jsChannels = [
    JavascriptChannel(
        name: 'Print',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
        }),
  ].toSet();
}
