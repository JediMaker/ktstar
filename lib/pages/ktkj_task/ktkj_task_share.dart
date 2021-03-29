import 'package:star/global_config.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_octoimage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluwx/fluwx.dart';
import 'package:star/http/ktkj_http_manage.dart';
import 'package:star/pages/ktkj_task/ktkj_task_gallery.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_webview.dart';
import 'package:star/utils/ktkj_common_utils.dart';
import 'package:star/utils/ktkj_navigator_utils.dart';
import 'package:url_launcher/url_launcher.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJTaskSharePage extends StatefulWidget {
  KTKJTaskSharePage({
    Key key,
    @required this.taskId,
  }) : super(key: key);
  final String title = "任务分享";
  String taskId;

  @override
  _TaskSharePageState createState() => _TaskSharePageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _TaskSharePageState extends State<KTKJTaskSharePage> {
//  final Color _requestDescBgColor = Color(0xffFFD7C2);
  final Color _requestDescBgColor = Color(0xffF32E43);

//  final Color _requestDescTxtColor = Color(0xffD95E00);
  final Color _requestDescTxtColor = Colors.white;
  final Color _nickColor = Color(0xff576A94);
  final Color _bgGreyColor = Color(0xffF5F5F5);

  var _requestDesc = '';

  var _nickName = ""; //
  var _headUrl = "";
  var _copyWriting = "";
  var _commment = ""; //
  var images = [
    /*"https://pic1.zhimg.com/50/v2-0008057d1ad2bd813aea4fc247959e63_400x224.jpg",
    "https://pic3.zhimg.com/50/v2-7fc9a1572c6fc72a3dea0b73a9be36e7_400x224.jpg",
    "https://pic1.zhimg.com/50/v2-0008057d1ad2bd813aea4fc247959e63_400x224.jpg",
    "https://pic3.zhimg.com/50/v2-7fc9a1572c6fc72a3dea0b73a9be36e7_400x224.jpg",*/
//    "https://pic4.zhimg.com/50/v2-898f43a488b606061c877ac2a471e221_400x224.jpg",
//    "https://dss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1906469856,4113625838&fm=26&gp=0.jpg",
//    "https://dss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1141259048,554497535&fm=26&gp=0.jpg",
//    "https://dss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2396361575,51762536&fm=26&gp=0.jpg",
  ];

  var _adImgUrl = '';

//      'https://alipic.lanhuapp.com/xdcd65bc53-f967-48f4-9e9a-de6c04f0ff6d?x-oss-process=image/quality,q_lossless/format,webp';
  var _adUrl = '';
  var _webUrl = '';
  var _shareTitle = '';
  var _shareDesc = '';
  var _shareThumbnail = '';

//      'https://s4-cs-pub-std.oss-cn-hangzhou.aliyuncs.com/im_plugin_button_image/tid552/kefu_1599649701199_j2rmr.png';

  _initData() async {
    var result = await HttpManage.getTaskDetailWechat(widget.taskId);
    if (result.status) {
      if (mounted) {
        setState(() {
          try {
            _requestDesc = result.data.requireDesc;
            _nickName = result.data.username;
            _headUrl = result.data.avatar;
            _copyWriting = result.data.text;
            _commment = result.data.commentDesc;
            images = result.data.fileId;
            _adImgUrl = result.data.footerImg.image;
            _adUrl = result.data.footerImg.link;
            _webUrl = result.data.shareInfo.link;
            _shareTitle = result.data.shareInfo.title;
            _shareDesc = result.data.shareInfo.desc;
            _shareThumbnail = result.data.shareInfo.icon;
          } catch (e) {
            print(e);
          }
        });
      }
    }
  }

  @override
  void initState() {
    _initData();
    super.initState();
  }

  @override
  void dispose() {
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
            icon: Image.asset(
              "static/images/icon_ios_back.png",
              width: ScreenUtil().setWidth(36),
              height: ScreenUtil().setHeight(63),
              fit: BoxFit.fill,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: KTKJGlobalConfig.taskNomalHeadColor,
          centerTitle: true,
//          backgroundColor: Color(0xfff5f5f5),
          elevation: 0,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
              width: double.infinity,
              height: double.infinity,
              margin: EdgeInsets.only(bottom: 100),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Visibility(
                        visible: !KTKJCommonUtils.isEmpty(_requestDesc),
                        child: Container(
                            width: double.infinity,
                            color: _requestDescBgColor,
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(28),
                                horizontal: ScreenUtil().setWidth(32)),
                            child: Text(
                              "$_requestDesc",
                              style: TextStyle(
                                color: _requestDescTxtColor,
                                fontSize: ScreenUtil().setSp(36),
                              ),
                            ))),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: new KTKJMyOctoImage(
                                  image: _headUrl,
                                  width: ScreenUtil().setWidth(120),
                                  height: ScreenUtil().setWidth(120),
                                  fit: BoxFit.fill,
                                ),
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            ScreenUtil().setWidth(11)))),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "$_nickName",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: _nickColor,
                                          fontSize: ScreenUtil().setSp(47),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: SelectableText(
                                        "$_copyWriting",
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(47),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: buildTopLayout(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          Container(
                            color: _bgGreyColor,
                            width: double.maxFinite,
                            margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(32)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: SelectableText(
                              "$_commment",
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(47),
                              ),
                            ),
                          ),
                          buildAd(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            shareItems(),
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget buildTopLayout() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      child: new GridView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          // 左右间隔
          crossAxisSpacing: 0,
          // 上下间隔
          mainAxisSpacing: 8,
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
    );
  }

  Widget buildAspectRatio(url, index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return KTKJTaskGalleryPage(
            galleryItems: images,
            index: index,
          );
        }));
      },
      child: Container(
          margin: const EdgeInsets.only(right: 8.0),
//        width: MediaQuery.of(context).size.width / 2.5,
          child: new KTKJMyOctoImage(
            image: url,
            width: ScreenUtil().setWidth(256),
            height: ScreenUtil().setWidth(256),
            fit: BoxFit.fill,
          )),
    );
  }

  Widget buildAd() {
    return GestureDetector(
      onTap: () {
//          HttpManage.getTheMissionWallEntrance("13122336666");
        if (!KTKJCommonUtils.isEmpty(_adUrl)) {
          KTKJNavigatorUtils.navigatorRouter(
              context,
              KTKJWebViewPage(
                initialUrl: "$_adUrl",
                showActions: true,
                title: "",
                appBarBackgroundColor: Color(0xFFD72825),
              ));
        }
      },
      child: Container(
        height: ScreenUtil().setHeight(550),
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setWidth(30)))),
        child: ClipRRect(
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(30))),
          child: KTKJMyOctoImage(
            image: _adImgUrl,
            width: ScreenUtil().setWidth(1061),
            height: ScreenUtil().setHeight(550),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget shareItems() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 100,
        alignment: Alignment.center,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Visibility(
              child: new Container(
                width: MediaQuery.of(context).size.width / 4,
                child: new FlatButton(
                    child: KTKJCommonUtils.getNoDuplicateSubmissionWidget(
                  fun: _saveImagesWithPermission,
                  childWidget: new Container(
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
                  ),
                )),
              ),
              visible: false,
            ),
            Visibility(
              child: new Container(
                width: MediaQuery.of(context).size.width / 4,
                child: new FlatButton(
                    child: KTKJCommonUtils.getNoDuplicateSubmissionWidget(
                  fun: _copyText,
                  childWidget: new Container(
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
                  ),
                )),
              ),
              visible: false,
            ),
            new Container(
              width: MediaQuery.of(context).size.width / 2,
              child: new FlatButton(
                  child: KTKJCommonUtils.getNoDuplicateSubmissionWidget(
                fun: () {
                  _goWechat(type: 0);
                },
                childWidget: new Container(
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
                ),
              )),
            ),
            new Container(
              width: MediaQuery.of(context).size.width / 2,
              child: new FlatButton(
                  child: KTKJCommonUtils.getNoDuplicateSubmissionWidget(
                fun: () {
                  _goWechat(type: 1);
                },
                childWidget: new Container(
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
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  void _saveImagesWithPermission() {}

  void _goWechat({int type = 0}) {
    if (KTKJCommonUtils.isEmpty(_webUrl)) {
      return;
    }
    if (KTKJCommonUtils.isEmpty(_shareThumbnail)) {
      _shareThumbnail =
          'https://static-ud.s4.udesk.cn/im_client/images/plugin404.8de7c6fd.png?v=1597492382675';
    }
    if (KTKJCommonUtils.isEmpty(_shareTitle)) {
      _shareTitle = '1';
    }
    try {
      shareToWeChat(WeChatShareWebPageModel("$_webUrl",
          title: _shareTitle,
          description: _shareDesc,
          scene: type == 0 ? WeChatScene.SESSION : WeChatScene.TIMELINE,
          thumbnail: WeChatImage.network("$_shareThumbnail")));
    } catch (e) {}
  }

  void _copyText() {}
}
