import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/global_config.dart';
import 'package:star/http/api.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/version_info_entity.dart';
import 'package:star/utils/common_utils.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static double formatNum(double num, int postion) {
    /*if ((num.toString().length - num.toString().lastIndexOf(".") - 1) <
        postion) {
      //小数点后有几位小数
//      print( num.toStringAsFixed(postion).substring(0,num.toString().lastIndexOf(".")+postion+1).toString());
      return double.parse(num.toStringAsFixed(postion)
          .substring(0, num.toString().lastIndexOf(".") + postion + 1)
          .toString());
    } else {
      double.parse(num.toString()
          .substring(0, num.toString().lastIndexOf(".") + postion + 1)
          .toString());
*/ /*
      print(num.toString()
          .substring(0, num.toString().lastIndexOf(".") + postion + 1)
          .toString());
*/ /*
    }*/
    return double.parse(num.toStringAsFixed(3));
  }

  ///
  /// 当有界面使用的时候
  //
  //@override //初始化 void initState() {
  // super.initState();
  //  initConnectivity(); //网络监听（开始）
  //  connectivityInitState(); //网络监听（进行）  /**  * @Wait 版本更新写在这  */
  //}
  //界面结束时记得关闭监听
  //
  //@override //结束
  // void dispose() {
  //　　　　super.dispose();
  //  　　connectivityDispose(); //网络监听（结束）
  // }
  ///
  ///
  ///

  //定义变量（网络状态）
  String _connectionStatus = 'Unknown';
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  //网络初始状态
  connectivityInitState() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print(result.toString());
      if (result.toString() == 'ConnectivityResult.none') {
        CommonUtils.showToast("无网络连接");
      }
    });
  }

  //网络结束监听
  connectivityDispose() {
    _connectivitySubscription.cancel();
  }

  //网络进行监听
  Future<Null> initConnectivity() async {
    String connectionStatus;
    //平台消息可能会失败，因此我们使用Try/Catch PlatformException。
    try {
      connectionStatus = (await Connectivity().checkConnectivity()).toString();

      if (connectionStatus == ConnectivityResult.mobile) {
        // I am connected to a mobile network.
      } else if (connectionStatus == ConnectivityResult.wifi) {
        // I am connected to a wifi network.
      }
    } on PlatformException catch (e) {
      print(e.toString());
      connectionStatus = 'Failed to get connectivity.';
    }
  }

  static String getSign(Map parameter) {
    /// 存储所有key
    List<String> allKeys = [];
    parameter.forEach((key, value) {
      allKeys.add(key + "=" + value);
    });

    /// key排序
    allKeys.sort((obj1, obj2) {
      return obj1.compareTo(obj2);
    });
    // /// 存储所有键值对
    // List<String> pairs = [];
    // /// 添加键值对
    // allKeys.forEach((key){
    //   pairs.add("$key${parameter[key]}");
    // });
    /// 数组转string
    String pairsString = allKeys.join("&");

    /// 拼接 秘钥
    String sign = pairsString + APi.INTERFACE_KEY;
    print("sign:" + sign);

    /// hash
    String signString = generateMd5(sign); //.toUpperCase()
    print("MD5sign:" + signString);
    //String signString = md5.convert(utf8.encode(sign)).toString().toUpperCase();  //直接写也可以
    return signString;
  }

  /// md5加密
  static String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }

  static String _localVersion;
  static String _flatform;
  static String url;

//  https://www.jianshu.com/p/89f619c632dd
  static checkAppVersion(BuildContext context,
      {bool checkDerictly = false}) async {
    /// 获取当前版本
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _localVersion = packageInfo.version;
    String updateTime = GlobalConfig.prefs.getString('updateTime') ?? null;

    if (GlobalConfig.isHuaweiUnderReview) {
      if (checkDerictly) {
        CommonUtils.showToast("当前已是最新版本");
      }
      return;
    }

    /// 一天之内只提醒一次需要更新
    if (!checkDerictly) {
      if (updateTime != null &&
          DateTime.parse(updateTime).day == DateTime.now().day) {
        return;
      }
    }

    var versionInfo = await HttpManage.getVersionInfo();
    try {
      if (versionInfo.status) {
        print(
            "_localVersion=$_localVersion；versionInfo。versionNo=${versionInfo.data.versionNo}");
        bool needUpdate =
            isVersionGreatThanLocal(versionInfo.data.versionNo, _localVersion);
        if (!needUpdate) {
          if (checkDerictly) {
            CommonUtils.showToast("当前已是最新版本");
          }
          return;
        }
        if (needUpdate) {
          GlobalConfig.prefs.setBool('needUpdate', true);
          final bool wantsUpdate = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) =>
                _buildDialog(context, packageInfo, versionInfo),
            barrierDismissible: false,
          );
          if (Platform.isIOS) {
            url = versionInfo.data.iosUrl;
          } else {
            url = versionInfo.data.androidUrl;
          }
          if (wantsUpdate != null && wantsUpdate) {
            GlobalConfig.prefs.remove('updateTime');
            GlobalConfig.prefs.remove('needUpdate');
            await launchUrl(url);
          } else {
            GlobalConfig.prefs
                .setString('updateTime', DateTime.now().toString());
          }
        } else {
          GlobalConfig.prefs.setBool('needUpdate', false);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static bool isVersionGreatThanLocal(
      String versionRemote, String clientVersion) {
    versionRemote.compareTo(clientVersion);
    bool result = false;
    if (!CommonUtils.isEmpty(versionRemote) &&
        versionRemote.indexOf(".") >= 0) {
      List<String> versionNum = versionRemote.split(".");
      List<String> currentNum = clientVersion.split(".");
      int loop_count = versionNum.length;
      if (currentNum.length < versionNum.length) {
        loop_count = currentNum.length;
      }

      for (int i = 0; i < loop_count; i++) {
        if (int.parse(versionNum[i]) > int.parse(currentNum[i])) {
          result = true;
          break;
        } else if (int.parse(versionNum[i]) == int.parse(currentNum[i])) {
          continue;
        } else {
          return result;
        }
      }
    }
    return result;
  }

  static launchUrl(url) async {
    if (await canLaunch(url) != null) {
      await launch(url, forceSafariVC: false);
    } else {
//      throw 'Could not launch $url';
      CommonUtils.showToast("链接打开失败！");
    }
  }
}

Widget _buildDialog(BuildContext context, PackageInfo packageInfo,
    VersionInfoEntity versionInfo) {
  final ThemeData theme = Theme.of(context);

  /*final TextStyle dialogTextStyle =
      theme.textTheme.subhead.copyWith(color: theme.textTheme.caption.color);*/

  return CupertinoAlertDialog(
    title: Text('v${versionInfo.data.versionNo}版本更新啦！'),
    content: Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        '${versionInfo.data.desc}',
      ),
    ),
    actions: <Widget>[
      CupertinoDialogAction(
        child: Text(
          '以后再说',
          style: TextStyle(
            color: Color(0xff222222),
            fontSize: ScreenUtil().setSp(42),
          ),
        ),
        onPressed: () {
          Navigator.pop(context, false);
        },
      ),
      CupertinoDialogAction(
        child: Text(
          '立即更新',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(42),
          ),
        ),
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
    ],
  );
}

Future updateNow(BuildContext context) async {
  if (Platform.isIOS) {
    print('is ios');
    final url =
        "https://itunes.apple.com/cn/app/id1380512641"; // id 后面的数字换成自己的应用 id 就行了
    if (await canLaunch(url) != null) {
      await launch(url, forceSafariVC: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}

///底部裁剪
class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // 路径
    var path = Path();
    // 设置路径的开始点
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 50);

    // 设置曲线的开始样式
    var firstControlPoint = Offset(size.width / 2, size.height);
    // 设置曲线的结束样式
    var firstEndPont = Offset(size.width, size.height - 50);
    // 把设置的曲线添加到路径里面
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPont.dx, firstEndPont.dy);

    // 设置路径的结束点
    path.lineTo(size.width, size.height - 50);
    path.lineTo(size.width, 0);

    // 返回路径
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

///顶部裁剪
class TopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // 路径
    var path = Path();
    // 设置路径的开始点
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width / 2, 50);

    // 设置曲线的开始样式
    var firstControlPoint = Offset(50, 0);
    // 设置曲线的结束样式
    var firstEndPont = Offset(size.width, 0);
    // 把设置的曲线添加到路径里面
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPont.dx, firstEndPont.dy);

    // 设置路径的结束点
    path.lineTo(0, 50);
    path.lineTo(size.width, 50);

    // 返回路径
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
