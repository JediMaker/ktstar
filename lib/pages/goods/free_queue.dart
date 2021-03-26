import 'package:star/pages/widget/my_octoimage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluwx/fluwx.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:star/global_config.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/goods_queue_entity.dart';
import 'package:star/pages/goods/free_queue_persional.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';
import 'package:star/pages/task/task_index.dart';

import 'goods_detail.dart';

void main() {
  runApp(MaterialApp(
    home: Container(
      child: Center(
        child: KTKJFreeQueuePage(),
      ),
    ),
  ));
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJFreeQueuePage extends StatefulWidget {
  KTKJFreeQueuePage({Key key, this.goodsId, this.pageType = 0})
      : super(key: key);
  final String title = "";
  String goodsId;

  /// 页面来源类型
  ///
  /// 0 默认
  ///
  /// 1 从个人中心跳转
  int pageType;

  @override
  _FreeQueuePageState createState() => _FreeQueuePageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _FreeQueuePageState extends State<KTKJFreeQueuePage> {
  var _headImageUrl = '';
  var _nickName = '';
  bool _hasSort = false;
  List<GoodsQueueDataList> _queueList = List<GoodsQueueDataList>();
  GoodsQueueDataGoodsInfo _goodsInfo;
  GoodsQueueDataSignPackage _signPackage;

  var _webUrl = '';
  var _shareTitle = '';
  var _shareDesc = '';
  var _shareThumbnail = '';
  var _powerNum = '0';

  @override
  void initState() {
    _initData();
    super.initState();
  }

  _initData() async {
    if (KTKJCommonUtils.isEmpty(widget.goodsId)) {
      return;
    }
    try {
      try {
        EasyLoading.show();
      } catch (e) {}
      var result = await HttpManage.getGoodsQueueList(widget.goodsId);
      if (mounted) {
        if (result.status) {
          setState(() {
            try {
              _queueList = result.data.xList;
              _goodsInfo = result.data.goodsInfo;
              _signPackage = result.data.signPackage;
              _headImageUrl = result.data.userInfo.avatar;
              _nickName = result.data.userInfo.username;
              _hasSort = result.data.userInfo.myStatus;
              _powerNum = result.data.userInfo.powerNum;
              _webUrl = _signPackage.url;
              _shareTitle = _goodsInfo.gName;
              _shareDesc = _goodsInfo.gDesc;
              _shareThumbnail = _goodsInfo.gImg;
            } catch (e) {}
          });
        } else {
          KTKJCommonUtils.showToast(result.errMsg);
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
    try {
      EasyLoading.dismiss();
    } catch (e) {}
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 1125, height: 2436, allowFontScaling: false);
    return FlutterEasyLoading(
      child: Scaffold(
          body: Container(
        width: double.maxFinite,
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            buildMainContent(),
            buildBottomLayout(context),
            Container(
              color: Color(0xff5752B6),
              height: 56 + ScreenUtil.statusBarHeight,
              padding: EdgeInsets.only(top: ScreenUtil.statusBarHeight),
              child: Stack(
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: <Widget>[
                            IconButton(
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
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              "消费补贴",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(54)),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                CupertinoIcons.share,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                showCupertinoModalBottomSheet(
                                  expand: false,
                                  context: this.context,
                                  backgroundColor: Colors.white,
                                  builder: (context) => shareItems(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ) // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }

  Widget buildMainContent() {
    return SingleChildScrollView(
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff5752B6),
              Color(0xff6F65C6),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                width: double.maxFinite,
                height: ScreenUtil().setHeight(651),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image.network(
                      "https://alipic.lanhuapp.com/xd1b3de0f3-69e2-406a-b22d-be4985aa3d00",
                      width: double.maxFinite,
                      height: ScreenUtil().setHeight(651),
                      fit: BoxFit.fill,
                    ).image,
                  ),
                ),
                child: buildTopContainer(),
                /*
                    child: KTKJMyOctoImage(
                      imageUrl:
                          "https://alipic.lanhuapp.com/xd1b3de0f3-69e2-406a-b22d-be4985aa3d00",
                    ),*/
              ),
              buildContentContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBottomLayout(BuildContext context) {
    return Positioned.fill(
        bottom: ScreenUtil().setHeight(0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Opacity(
            opacity: 0.9,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: double.maxFinite,
                height: ScreenUtil().setHeight(250),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xffdedede))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "去逛逛，继续购买商品参加排队~",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(38),
                        color: Color(0xff222222),
                      ),
                    ),
                    Icon(
                      CupertinoIcons.forward,
                      size: ScreenUtil().setSp(48),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget buildContentContainer() {
    return Container(
      child: Container(
        margin: EdgeInsets.only(
          left: 16,
          right: 16,
          top: ScreenUtil().setHeight(657),
          bottom: ScreenUtil().setHeight(280),
        ),
        padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(250)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(
              ScreenUtil().setHeight(121),
            ),
            topLeft: Radius.circular(
              ScreenUtil().setHeight(121),
            ),
            bottomRight: Radius.circular(
              ScreenUtil().setHeight(121),
            ),
            bottomLeft: Radius.circular(
              ScreenUtil().setHeight(121),
            ),
          ),
        ),
        child: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.only(bottom: 10),
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  ScreenUtil().setHeight(121),
                ),
              ),
              child: buildUserQueueContainer(),
            ),
            Container(
              color: Colors.white,
              constraints:
                  BoxConstraints(minHeight: ScreenUtil().setHeight(1400)),
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(_queueList.length, (index) {
                  return buildItem(index, _queueList[index]);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTopContainer() {
    return Container(
      margin: EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(263)),
            child: Text.rich(
              TextSpan(children: [
                TextSpan(text: 'TOP'),
                TextSpan(
                    text: '15',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(62),
                    )),
              ]),
              style: TextStyle(
                color: Color(0xffFFC928),
                fontSize: ScreenUtil().setSp(42),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10)),
            child: Text(
              "补贴榜单",
              style: TextStyle(
                color: CupertinoColors.white,
                fontSize: ScreenUtil().setSp(110),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            child: Text(
              "点击右上角可分享邀请好友助力",
              style: TextStyle(
                color: CupertinoColors.white,
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(36),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserQueueContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          ScreenUtil().setHeight(121),
        ),
      ),
      width: double.maxFinite,
      height: ScreenUtil().setHeight(242),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 11),
              child: ClipOval(
                  child: KTKJMyOctoImage(
                image: "$_headImageUrl",
                width: ScreenUtil().setWidth(182),
                height: ScreenUtil().setWidth(182),
              )),
            ),
            Expanded(
              child: Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Text(
                    "$_nickName",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(48),
                        color: Color(0xff222222),
                        fontWeight: FontWeight.bold),
                  )),
            ),
            GestureDetector(
              onTap: () {
                if (_hasSort) {
                  KTKJNavigatorUtils.navigatorRouterReplaceMent(
                      context, KTKJFreeQueuePersonalPage());
                } else {
                  if (widget.pageType == 1) {
                    KTKJNavigatorUtils.navigatorRouter(
                        context,
                        KTKJGoodsDetailPage(
                          productId: widget.goodsId,
                        ));
                  } else {
                    Navigator.of(context).pop();
                  }
                }
              },
              child: Container(
                  margin: EdgeInsets.only(right: 16, left: 10),
                  child: _hasSort
                      ? Text.rich(
                          TextSpan(children: [
                            TextSpan(text: '$_powerNum\t助力值'), //todo
                            WidgetSpan(
                                child: Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Icon(
                                CupertinoIcons.forward,
                                size: ScreenUtil().setSp(56),
                              ),
                            ))
                          ]),
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(48),
                            color: Color(0xffF32E43),
                          ),
                          textAlign: TextAlign.center,
                        )
                      : Text(
                          "立即参与",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(48),
                            color: Color(0xffF32E43),
                          ),
                        )),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIndexLabel(int index) {
    switch (index) {
      case 0:
        return Container(
          width: ScreenUtil().setWidth(100),
          height: ScreenUtil().setWidth(100),
          alignment: Alignment.center,
          child: KTKJMyOctoImage(
            image:
                "https://alipic.lanhuapp.com/xd0822cd7b-26b5-4c61-b922-c622e1f8f507",
            width: ScreenUtil().setWidth(65),
            height: ScreenUtil().setHeight(77),
          ),
        );
      case 1:
        return Container(
          width: ScreenUtil().setWidth(100),
          height: ScreenUtil().setWidth(100),
          alignment: Alignment.center,
          child: KTKJMyOctoImage(
            image:
                "https://alipic.lanhuapp.com/xd626c4b41-cf3d-459d-aa39-4c3e004aba02",
            width: ScreenUtil().setWidth(65),
            height: ScreenUtil().setHeight(77),
          ),
        );
      case 2:
        return Container(
          width: ScreenUtil().setWidth(100),
          height: ScreenUtil().setWidth(100),
          alignment: Alignment.center,
          child: KTKJMyOctoImage(
            image:
                "https://alipic.lanhuapp.com/xd07bf2202-80a8-47c3-a6b8-46b472ac4e1d",
            width: ScreenUtil().setWidth(65),
            height: ScreenUtil().setHeight(77),
          ),
        );
    }
    return Container(
      width: ScreenUtil().setWidth(100),
      height: ScreenUtil().setWidth(100),
      alignment: Alignment.center,
      child: Text(
        "${index + 1}",
        style: TextStyle(
          color: Color(0xff222222),
          fontSize: ScreenUtil().setSp(38),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildItem(index, GoodsQueueDataList item) {
    var _itemNickName = '';
    var _avatarUrl = '';
    var _dateJoin = '';
    var _powerNum = '0';
    try {
      _itemNickName = item.username;
      _avatarUrl = item.avatar;
      _dateJoin = item.createTime;
      _powerNum = item.powerNum;
    } catch (e) {}
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              buildIndexLabel(index),
              Container(
                margin: EdgeInsets.only(left: 8),
                child: ClipOval(
                  child: KTKJMyOctoImage(
                    image: "$_avatarUrl",
                    width: ScreenUtil().setWidth(100),
                    height: ScreenUtil().setWidth(100),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "$_itemNickName",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(38),
                            color: Color(0xff222222),
                          ),
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 4, left: 10),
                        child: Text(
                          "$_dateJoin",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(38),
                            color: Color(0xff999999),
                          ),
                        )),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        "$_powerNum",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(48),
                          color: Color(0xffF32E43),
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 4, left: 10),
                      child: Text(
                        "助力值",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(38),
                          color: Color(0xff999999),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(160),
              right: ScreenUtil().setWidth(50)),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: ScreenUtil().setHeight(1),
                      color: Color(0xffdedede)))),
        ),
      ],
    );
  }

  Widget shareItems() {
    return Container(
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
                Navigator.of(context).pop();
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
                          style:
                              new TextStyle(fontSize: ScreenUtil().setSp(32))),
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
                Navigator.of(context).pop();
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
                          style:
                              new TextStyle(fontSize: ScreenUtil().setSp(32))),
                    )
                  ],
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }

  void _saveImagesWithPermission() {}

  ///分享给微信好友或者朋友圈
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
