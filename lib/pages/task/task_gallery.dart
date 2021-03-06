import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:star/utils/common_utils.dart';

import '../../global_config.dart';

class TaskGalleryPage extends StatefulWidget {
  TaskGalleryPage({Key key, this.galleryItems, this.index = 0})
      : super(key: key);
  final String title = "";
  var galleryItems;
  int index;

  @override
  _TaskGalleryPageState createState() => _TaskGalleryPageState();
}

class _TaskGalleryPageState extends State<TaskGalleryPage> {
  PageController pageController;
  int _currentIndex;
  Permission _permission = Permission.storage;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.index);
    _currentIndex = widget.index;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _saveImage(index) async {
    var response = await Dio().get(widget.galleryItems[index],
        options: Options(responseType: ResponseType.bytes));
    var result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "kt_${CommonUtils.currentTimeMillis() + index.toString()}");
    print("当前$index下载结果" + result);
    Fluttertoast.showToast(
        msg: "图片已下载",
        backgroundColor: Colors.white,
        textColor: Colors.black,
        gravity: ToastGravity.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
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
                              _permission, _saveImage(_currentIndex));
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
        child: Container(
            child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: Image.network(widget.galleryItems[index]).image,
              initialScale: PhotoViewComputedScale.contained * 1,
//          heroAttributes: HeroAttributes(tag: galleryItems[index].id),
            );
          },
          itemCount: widget.galleryItems.length,
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes,
              ),
            ),
          ),
//      backgroundDecoration: widget.backgroundDecoration,
          pageController: pageController,
          onPageChanged: onPageChanged,
        )),
      )),
    );
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
