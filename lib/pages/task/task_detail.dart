import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/task_detail_entity.dart';
import 'package:star/pages/task/task_gallery.dart';
import 'package:star/pages/task/task_submission.dart';
import 'package:star/utils/common_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../../global_config.dart';

class TaskDetailPage extends StatefulWidget {
  String taskId;

  TaskDetailPage({Key key, @required this.taskId}) : super(key: key);
  final String title = "任务下载";

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

void main() {}

class _TaskDetailPageState extends State<TaskDetailPage> {
  Permission _permission = Permission.storage;

  String _response = "";
  WeChatImage source;

  @override
  void initState() {
    weChatResponseEventHandler.listen((res) {
      if (res is WeChatShareResponse) {
        setState(() {
          _response = "state :${res.isSuccessful}";
        });
      }
    });
    _initData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  var images = [
    /*  "https://pic1.zhimg.com/50/v2-0008057d1ad2bd813aea4fc247959e63_400x224.jpg",
    "https://pic3.zhimg.com/50/v2-7fc9a1572c6fc72a3dea0b73a9be36e7_400x224.jpg",
    "https://pic4.zhimg.com/50/v2-898f43a488b606061c877ac2a471e221_400x224.jpg",*/
//    "https://dss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1906469856,4113625838&fm=26&gp=0.jpg",
//    "https://dss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1141259048,554497535&fm=26&gp=0.jpg",
//    "https://dss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2396361575,51762536&fm=26&gp=0.jpg",
  ];
  var des = "";

/*
  var des = "南湖月饼礼盒八饼八味伴手礼多口味蛋黄莲蓉五仁老广式酥皮水果味\n" +
      "【价格】25.8元\n" +
      "  【券后价】9.8元\n" +
      "【下载来可淘再省】2.35元\n" +
      " 【8饼4味】流心月饼伴手礼盒，浙江知名品牌，线下门店热销，精选原材料，口味新颖，甜而不腻，中秋团圆时刻，月饼不可少~\n" +
      "--------\n" +
      "复ૢ製评论¢9XBPc3Y8XcJ₳\n" +
      "【tao寶】即可️💕查看";
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(fontSize: ScreenUtil().setSp(54)),
          ),
          leading: IconButton(
            icon: Image.asset(
              "static/images/icon_ios_back_white.png",
              width: ScreenUtil().setWidth(36),
              height: ScreenUtil().setHeight(63),
              fit: BoxFit.fill,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          backgroundColor: GlobalConfig.taskHeadColor,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 120),
              child: CustomScrollView(
                slivers: <Widget>[
                  buildTopLayout(),
                  SliverToBoxAdapter(
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          child: Wrap(
                            spacing: 10,
                            children: <Widget>[
                              Text(
                                des,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(36),
                                    color: Color(0xFF222222)),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildCopyButton(),
//            buildTaskWall(),
                ],
              ),
            ),
            row(),
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget buildTopLayout() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: new GridView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            // 左右间隔
            crossAxisSpacing: 8,
            // 上下间隔
            mainAxisSpacing: 4,
            //宽高比 默认1
//              childAspectRatio: 3 / 4,
          ),
          children: images
              .asMap()
              .keys
              .map((index) => buildAspectRatio(images[index], index))
              .toList(),
//            images.map((url) => buildAspectRatio(url)).toList(),
//            images.map((url) => buildAspectRatio(url)).toList(),
        ),
      ),
    );
  }

  Widget buildTopLayout2() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: new SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: new Row(
            children: <Widget>[
              new Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  margin: const EdgeInsets.only(right: 6.0),
                  child: buildAspectRatio(images[0], 0)),
              new Container(
                  margin: const EdgeInsets.only(right: 6.0),
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: new AspectRatio(
                      aspectRatio: 1,
                      child: new Container(
                        foregroundDecoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new NetworkImage(
                                "https://pic3.zhimg.com/50/v2-7fc9a1572c6fc72a3dea0b73a9be36e7_400x224.jpg"),
                            centerSlice:
                                new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                          ),
                          /*borderRadius: const BorderRadius.all(
                                const Radius.circular(6.0))*/
                        ),
                      ))),
              new Container(
                  margin: const EdgeInsets.only(right: 6.0),
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: new AspectRatio(
                      aspectRatio: 4.0 / 3.0,
                      child: new Container(
                        foregroundDecoration: new BoxDecoration(
                            image: new DecorationImage(
                              image: new NetworkImage(
                                  "https://pic4.zhimg.com/50/v2-898f43a488b606061c877ac2a471e221_400x224.jpg"),
                              centerSlice: new Rect.fromLTRB(
                                  270.0, 180.0, 1360.0, 730.0),
                            ),
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(6.0))),
                      ))),
              new Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: new AspectRatio(
                      aspectRatio: 4.0 / 3.0,
                      child: new Container(
                        foregroundDecoration: new BoxDecoration(
                            image: new DecorationImage(
                              image: new NetworkImage(
                                  "https://pic1.zhimg.com/50/v2-0008057d1ad2bd813aea4fc247959e63_400x224.jpg"),
                              centerSlice: new Rect.fromLTRB(
                                  270.0, 180.0, 1360.0, 730.0),
                            ),
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(6.0))),
                      )))
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAspectRatio(url, index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return TaskGalleryPage(
            galleryItems: images,
            index: index,
          );
        }));
      },
      child: Container(
          margin: const EdgeInsets.only(right: 10.0),
//        width: MediaQuery.of(context).size.width / 2.5,
          child: new CachedNetworkImage(
            imageUrl: url,
            width: ScreenUtil().setWidth(274),
            height: ScreenUtil().setWidth(274),
            fit: BoxFit.fill,
          )),
    );
  }

  Widget buildBannerLayout() {
    return SliverToBoxAdapter(
      child: Container(
        height: 150,
        child: Swiper(
          itemCount: images.length,
          autoplay: true,
          itemBuilder: (context, index) {
            return CachedNetworkImage(
              imageUrl: images[index],
              width: 1920,
              height: 150,
              fit: BoxFit.fill,
            );
          },
        ),
      ),
    );
  }

  Widget myServiceCard() {
    return SliverToBoxAdapter(
      child: new Container(
        margin: const EdgeInsets.only(top: 6.0, bottom: 6.0),
        padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
        child: new Column(
          children: <Widget>[
            new Container(
              child: row(),
            ),
            new Container(
              margin: const EdgeInsets.only(top: 16.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    width: MediaQuery.of(context).size.width / 4,
                    child: new FlatButton(
                        onPressed: () {},
                        child: new Container(
                          child: new Column(
                            children: <Widget>[
                              new Container(
                                margin: const EdgeInsets.only(bottom: 6.0),
                                child: new CircleAvatar(
                                  radius: 20.0,
                                  child:
                                      new Icon(Icons.shop, color: Colors.white),
                                  backgroundColor: new Color(0xFF088DB4),
                                ),
                              ),
                              new Container(
                                child: new Text(
                                  "一键发圈",
                                  style: new TextStyle(fontSize: 14.0),
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                  new Container(
                    width: MediaQuery.of(context).size.width / 4,
                    child: new FlatButton(
                        onPressed: () {},
                        child: new Container(
                          child: new Column(
                            children: <Widget>[
                              new Container(
                                margin: const EdgeInsets.only(bottom: 6.0),
                                child: new CircleAvatar(
                                  radius: 20.0,
                                  child: new Icon(Icons.radio,
                                      color: Colors.white),
                                  backgroundColor: Colors.blue,
                                ),
                              ),
                              new Container(
                                child: new Text("qq空间",
                                    style: new TextStyle(fontSize: 14.0)),
                              )
                            ],
                          ),
                        )),
                  ),
                  new Container(
                    width: MediaQuery.of(context).size.width / 4,
                    child: new FlatButton(
                        onPressed: () {},
                        child: new Container(
                          child: new Column(
                            children: <Widget>[
                              new Container(
                                margin: const EdgeInsets.only(bottom: 6.0),
                                child: new CircleAvatar(
                                  radius: 20.0,
                                  child: new Icon(Icons.wifi_tethering,
                                      color: Colors.white),
                                  backgroundColor: new Color(0xFF029A3F),
                                ),
                              ),
                              new Container(
                                child: new Text("微博",
                                    style: new TextStyle(fontSize: 14.0)),
                              )
                            ],
                          ),
                        )),
                  ),
                  new Container(
                    width: MediaQuery.of(context).size.width / 4,
                    child: new FlatButton(
                        onPressed: () {},
                        child: new Container(
                          child: new Column(
                            children: <Widget>[
                              new Container(
                                margin: const EdgeInsets.only(bottom: 6.0),
                                child: new CircleAvatar(
                                  radius: 20.0,
                                  child: new Icon(Icons.query_builder,
                                      color: Colors.white),
                                  backgroundColor: Colors.blueAccent,
                                ),
                              ),
                              new Container(
                                child: new Text("QQ",
                                    style: new TextStyle(fontSize: 14.0)),
                              )
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _save(index) async {
    var response = await Dio()
        .get(images[index], options: Options(responseType: ResponseType.bytes));
    var result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "ktxx_${CommonUtils.currentTimeMillis() + index.toString()}");
    print("当前$index下载结果" + result);
  }

  _saveImages() {
    for (var i = 0; i < images.length; i++) {
      _save(i);
    }
    Fluttertoast.showToast(
        msg: "图片已下载",
        backgroundColor: Colors.white,
        textColor: Colors.black,
        gravity: ToastGravity.BOTTOM);
  }

  void _shareImage(scene) {
    shareToWeChat(WeChatShareImageModel(source, scene: scene));
  }

  Widget row() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 130,
        alignment: Alignment.center,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
              width: MediaQuery.of(context).size.width / 4,
              child: new FlatButton(
                  onPressed: () async {
                    CommonUtils.requestPermission(_permission, _saveImages());
                  },
                  child: new Container(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          margin: const EdgeInsets.only(bottom: 6.0),
                          child: new CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.transparent,
                            child: new Image.asset(
                              "static/images/task_download_img.png",
                              width: ScreenUtil().setWidth(138),
                              height: ScreenUtil().setWidth(138),
                            ),
                          ),
                        ),
                        new Container(
                          child: new Text(
                            "下载图片",
                            style:
                                new TextStyle(fontSize: ScreenUtil().setSp(32)),
                          ),
                        )
                      ],
                    ),
                  )),
            ),
            new Container(
              width: MediaQuery.of(context).size.width / 4,
              child: new FlatButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: des));
                    Fluttertoast.showToast(
                        msg: "已复制文案",
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        gravity: ToastGravity.BOTTOM);
                  },
                  child: new Container(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          margin: const EdgeInsets.only(bottom: 6.0),
                          child: new CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.transparent,
                            child: new Image.asset(
                              "static/images/task_text_copy.png",
                              width: ScreenUtil().setWidth(138),
                              height: ScreenUtil().setWidth(138),
                            ),
                          ),
                        ),
                        new Container(
                          child: new Text("复制文案",
                              style: new TextStyle(
                                  fontSize: ScreenUtil().setSp(32))),
                        )
                      ],
                    ),
                  )),
            ),
            new Container(
              width: MediaQuery.of(context).size.width / 4,
              child: new FlatButton(
                  onPressed: () {
                    source = WeChatImage.network(images[0]);
                    _shareImage(WeChatScene.SESSION);
                  },
                  child: new Container(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          margin: const EdgeInsets.only(bottom: 6.0),
                          child: new CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.transparent,
                            child: new Image.asset(
                              "static/images/task_wechat.png",
                              width: ScreenUtil().setWidth(138),
                              height: ScreenUtil().setWidth(138),
                            ),
                          ),
                        ),
                        new Container(
                          child: new Text("微信",
                              style: new TextStyle(
                                  fontSize: ScreenUtil().setSp(32))),
                        )
                      ],
                    ),
                  )),
            ),
            new Container(
              width: MediaQuery.of(context).size.width / 4,
              child: new FlatButton(
                  onPressed: () {
                    source = WeChatImage.network(images[0]);
                    _shareImage(WeChatScene.TIMELINE);
                  },
                  child: new Container(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          margin: const EdgeInsets.only(bottom: 6.0),
                          child: new CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.transparent,
                            child: new Image.asset(
                              "static/images/task_wechat_friends_circle.png",
                              width: ScreenUtil().setWidth(138),
                              height: ScreenUtil().setWidth(138),
                            ),
                          ),
                        ),
                        new Container(
                          child: new Text("朋友圈",
                              style: new TextStyle(
                                  fontSize: ScreenUtil().setSp(32))),
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget myServiceCard2() {
    return SliverToBoxAdapter(
      child: new Container(
        margin: const EdgeInsets.only(top: 6.0, bottom: 6.0),
        padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
        child: new Column(
          children: <Widget>[
            new Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    width: MediaQuery.of(context).size.width / 4,
                    child: new FlatButton(
                        onPressed: () {},
                        child: new Container(
                          child: new Column(
                            children: <Widget>[
                              new Container(
                                margin: const EdgeInsets.only(bottom: 6.0),
                                child: new CircleAvatar(
                                  radius: 20.0,
                                  child:
                                      new Icon(Icons.book, color: Colors.white),
                                  backgroundColor: Colors.green,
                                ),
                              ),
                              new Container(
                                child: new Text(
                                  "保存图片",
                                  style: new TextStyle(fontSize: 14.0),
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                  new Container(
                    width: MediaQuery.of(context).size.width / 4,
                    child: new FlatButton(
                        onPressed: () {},
                        child: new Container(
                          child: new Column(
                            children: <Widget>[
                              new Container(
                                margin: const EdgeInsets.only(bottom: 6.0),
                                child: new CircleAvatar(
                                  radius: 20.0,
                                  child: new Icon(Icons.flash_on,
                                      color: Colors.white),
                                  backgroundColor: Colors.blue,
                                ),
                              ),
                              new Container(
                                child: new Text("复制文案",
                                    style: new TextStyle(fontSize: 14.0)),
                              )
                            ],
                          ),
                        )),
                  ),
                  new Container(
                    width: MediaQuery.of(context).size.width / 4,
                    child: new FlatButton(
                        onPressed: () {},
                        child: new Container(
                          child: new Column(
                            children: <Widget>[
                              new Container(
                                margin: const EdgeInsets.only(bottom: 6.0),
                                child: new CircleAvatar(
                                  radius: 20.0,
                                  child: new Icon(Icons.free_breakfast,
                                      color: Colors.white),
                                  backgroundColor: new Color(0xFFA68F52),
                                ),
                              ),
                              new Container(
                                child: new Text("微信",
                                    style: new TextStyle(fontSize: 14.0)),
                              )
                            ],
                          ),
                        )),
                  ),
                  new Container(
                    width: MediaQuery.of(context).size.width / 4,
                    child: new FlatButton(
                        onPressed: () {},
                        child: new Container(
                          child: new Column(
                            children: <Widget>[
                              new Container(
                                margin: const EdgeInsets.only(bottom: 6.0),
                                child: new CircleAvatar(
                                  radius: 20.0,
                                  child: new Icon(Icons.attach_money,
                                      color: Colors.white),
                                  backgroundColor: new Color(0xFF355A9B),
                                ),
                              ),
                              new Container(
                                child: new Text("朋友圈",
                                    style: new TextStyle(fontSize: 14.0)),
                              )
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
            new Container(
              margin: const EdgeInsets.only(top: 16.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    width: MediaQuery.of(context).size.width / 4,
                    child: new FlatButton(
                        onPressed: () {},
                        child: new Container(
                          child: new Column(
                            children: <Widget>[
                              new Container(
                                margin: const EdgeInsets.only(bottom: 6.0),
                                child: new CircleAvatar(
                                  radius: 20.0,
                                  child:
                                      new Icon(Icons.shop, color: Colors.white),
                                  backgroundColor: new Color(0xFF088DB4),
                                ),
                              ),
                              new Container(
                                child: new Text(
                                  "一键发圈",
                                  style: new TextStyle(fontSize: 14.0),
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                  new Container(
                    width: MediaQuery.of(context).size.width / 4,
                    child: new FlatButton(
                        onPressed: () {},
                        child: new Container(
                          child: new Column(
                            children: <Widget>[
                              new Container(
                                margin: const EdgeInsets.only(bottom: 6.0),
                                child: new CircleAvatar(
                                  radius: 20.0,
                                  child: new Icon(Icons.radio,
                                      color: Colors.white),
                                  backgroundColor: Colors.blue,
                                ),
                              ),
                              new Container(
                                child: new Text("qq空间",
                                    style: new TextStyle(fontSize: 14.0)),
                              )
                            ],
                          ),
                        )),
                  ),
                  new Container(
                    width: MediaQuery.of(context).size.width / 4,
                    child: new FlatButton(
                        onPressed: () {},
                        child: new Container(
                          child: new Column(
                            children: <Widget>[
                              new Container(
                                margin: const EdgeInsets.only(bottom: 6.0),
                                child: new CircleAvatar(
                                  radius: 20.0,
                                  child: new Icon(Icons.wifi_tethering,
                                      color: Colors.white),
                                  backgroundColor: new Color(0xFF029A3F),
                                ),
                              ),
                              new Container(
                                child: new Text("微博",
                                    style: new TextStyle(fontSize: 14.0)),
                              )
                            ],
                          ),
                        )),
                  ),
                  new Container(
                    width: MediaQuery.of(context).size.width / 4,
                    child: new FlatButton(
                        onPressed: () {},
                        child: new Container(
                          child: new Column(
                            children: <Widget>[
                              new Container(
                                margin: const EdgeInsets.only(bottom: 6.0),
                                child: new CircleAvatar(
                                  radius: 20.0,
                                  child: new Icon(Icons.query_builder,
                                      color: Colors.white),
                                  backgroundColor: Colors.blueAccent,
                                ),
                              ),
                              new Container(
                                child: new Text("QQ",
                                    style: new TextStyle(fontSize: 14.0)),
                              )
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTaskWall() {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 80,
          alignment: Alignment.center,
          child: Text(
            '任务墙',
            style: TextStyle(color: Colors.green),
          ),
        ),
      ),
    );
  }

  Widget buildCopyButton() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(bottom: 40),
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: des));
                  Fluttertoast.showToast(
                      msg: "已复制文案",
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      gravity: ToastGravity.BOTTOM);
                },
                child: Container(
                  height: 46,
                  width: 216,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      /*color: _imageFile == null
                        ? GlobalConfig.taskHeadDisableColor
                        : GlobalConfig.taskHeadColor,*/
                      /*gradient: LinearGradient(
                        colors: [Color(0xFFFE9322), Color(0xFFFFB541)]),*/
                      border: Border.all(color: GlobalConfig.taskHeadColor),
                      borderRadius: BorderRadius.circular(48)),
                  child: Text(
                    '复制文案',
                    style: TextStyle(
                        color: GlobalConfig.taskHeadColor,
                        fontSize: ScreenUtil().setSp(42)),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return TaskSubmissionPage(
                      taskId: widget.taskId,
                    );
                  }));
                },
                child: Container(
                  height: 48,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: GlobalConfig.taskHeadColor,
                      /*gradient: LinearGradient(
                          colors: [Color(0xFFFE9322), Color(0xFFFFB541)]),*/
                      borderRadius: BorderRadius.circular(48)),
                  child: Text(
                    '去提交',
                    style: TextStyle(
                        color: Colors.white, fontSize: ScreenUtil().setSp(42)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTaskItemLayout() {
    return ListTile(
      leading: CachedNetworkImage(
        width: 40,
        height: 40,
        imageUrl:
            "https://img2020.cnblogs.com/blog/2016690/202009/2016690-20200901173254702-27754128.png",
      ),
      title: Text('转发朋友圈'),
      subtitle: Container(
        child: Row(
          children: <Widget>[
            Container(
                width: 6,
                height: 6,
                child: CircleAvatar(backgroundColor: Color(0xFFFF8800))),
            Text('10元现金奖励'),
          ],
        ),
      ),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            border: Border.all(
                width: 0.5,
                color: Color(0xFFFF8800),
                style: BorderStyle.solid)),
        child: Text(
          "已完成",
          style: TextStyle(color: Color(0xFFFF8800)),
        ),
      ),
    );
  }

  Widget taskCard() {
    return SliverToBoxAdapter(
      child: Card(
//      elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        child: Column(
          children: <Widget>[
            Text(
              "任务一",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            buildTaskItemLayout(),
            buildTaskItemLayout(),
            buildTaskItemLayout(),
            SizedBox(
              height: 20,
            ),
//        Container(height: 400,width: 400,color: Colors.red, child: _buildPhotosWidget(post),),

//          post.messageImage != null
//              ? Image.network(
//                  post.messageImage,
//                  fit: BoxFit.cover,
//                )
//              : Container(),
//          post.messageImage != null
//              ? Container()
//              : Divider(
//                  color: Colors.grey.shade300,
//                  height: 8.0,
//                ),
          ],
        ),
      ),
    );
  }

  _initData() async {
    var result = await HttpManage.getTaskDetail(widget.taskId);
    if (mounted) {
      if (result.status) {
        setState(() {
          des = result.data.title + "\n" + result.data.text;
          images = result.data.fileId;
        });
      } else {
        Fluttertoast.showToast(
            msg: "${result.errMsg}",
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            gravity: ToastGravity.BOTTOM);
      }
    }
  }
}
