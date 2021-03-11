import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:star/global_config.dart';
import 'package:star/utils/common_utils.dart';

class ShopQrCodePage extends StatefulWidget {
  ShopQrCodePage({Key key, this.qrCodeUrl}) : super(key: key);
  final String title = "我的收款码";
  var qrCodeUrl;

  @override
  _ShopQrCodePageState createState() => _ShopQrCodePageState();
}

class _ShopQrCodePageState extends State<ShopQrCodePage> {
  Permission _permission = Permission.storage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
          backgroundColor: GlobalConfig.taskNomalHeadColor,
          elevation: 0,
        ),
        body: GestureDetector(
          onLongPress: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    height: 150,
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ListTile(
                          onTap: () async {
                            Navigator.of(context).pop();
                            CommonUtils.requestPermission(
                                _permission, _saveImage(0));
                          },
                          title: Text(
                            "保存",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          title: Text(
                            "取消",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setWidth(100),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: "${widget.qrCodeUrl}",
                    width: ScreenUtil().setWidth(1030),
                    height: ScreenUtil().setWidth(1373),
                  ),
                ),
              ],
            ),
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  _saveImage(index) async {
    var response = await Dio().get(widget.qrCodeUrl,
        options: Options(responseType: ResponseType.bytes));
    var result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "kt_${CommonUtils.currentTimeMillis() + index.toString()}");
    print("当前二维码图片下载结果" + result);
    CommonUtils.showToast("图片已下载");
  }
}
