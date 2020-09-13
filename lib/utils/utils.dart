import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/http/api.dart';
import 'package:star/utils/common_utils.dart';

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
        Fluttertoast.showToast(
            msg: '网络连接错误!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16.0);
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
      allKeys.add(key + value);
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
    String pairsString = allKeys.join("");

    /// 拼接 ABC 是你的秘钥
    String sign = pairsString + APi.INTERFACE_KEY;

    /// hash
    String signString = generateMd5(sign); //.toUpperCase()
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
}

///底部裁剪
class BottonClipper extends CustomClipper<Path> {
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
