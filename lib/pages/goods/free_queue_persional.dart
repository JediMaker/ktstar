import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluwx/fluwx.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/goods_queue_persional_entity.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';
import 'package:star/pages/task/task_index.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'goods_list.dart';

void main() {
  runApp(MaterialApp(
    home: Container(
      child: Center(
        child: FreeQueuePersonalPage(),
      ),
    ),
  ));
}

class FreeQueuePersonalPage extends StatefulWidget {
  FreeQueuePersonalPage({Key key}) : super(key: key);
  final String title = "";

  @override
  _FreeQueuePersonalPageState createState() => _FreeQueuePersonalPageState();
}

class _FreeQueuePersonalPageState extends State<FreeQueuePersonalPage> {
  List<GoodsQueuePersionalData> _dataList = List<GoodsQueuePersionalData>();

  _initData() async {
    try {
      EasyLoading.show();
      var result = await HttpManage.getGoodsQueuePersonalList();
      if (mounted) {
        if (result.status) {
          setState(() {
            try {
              _dataList = result.data;
            } catch (e) {}
          });
        } else {
          CommonUtils.showToast(result.errMsg);
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
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "消费补贴",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(54)),
                    ),
                  ),
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
                    child: CachedNetworkImage(
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
          top: ScreenUtil().setHeight(627),
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
            Visibility(
              visible: CommonUtils.isEmpty(_dataList),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  NavigatorUtils.navigatorRouter(context, GoodsListPage());
                },
                behavior: HitTestBehavior.opaque,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 16,
                      ),
                      child: Text(
                        '您还没有订单参与消费补贴哦',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(42),
                          color: Color(0xff222222),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 8,
                      ),
                      child: Text(
                        '点击参与',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(56),
                          color: Color(0xffF32E43),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              constraints:
                  BoxConstraints(minHeight: ScreenUtil().setHeight(1600)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(
                    ScreenUtil().setHeight(121),
                  ),
                  topLeft: Radius.circular(
                    ScreenUtil().setHeight(121),
                  ),
                ),
              ),
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(_dataList.length, (index) {
                  return buildItem(index, _dataList[index]);
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
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10)),
            child: Text(
              "个人榜单",
              style: TextStyle(
                color: CupertinoColors.white,
                fontSize: ScreenUtil().setSp(110),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            "补贴奖励奖不停，购物省钱又省心",
            style: TextStyle(
              color: CupertinoColors.white,
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil().setSp(36),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIndexLabel(int index, {done = false}) {
    if (done) {
      return Container(
        width: ScreenUtil().setWidth(100),
        height: ScreenUtil().setWidth(100),
        alignment: Alignment.center,
        child: CachedNetworkImage(
          imageUrl:
              "https://alipic.lanhuapp.com/xde429b121-45d4-4b1a-97ea-0dedaed74a42",
          width: ScreenUtil().setWidth(100),
          height: ScreenUtil().setWidth(100),
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

  var _webUrl = '';
  var _shareTitle = '';
  var _shareDesc = '';
  var _shareThumbnail = '';

  Widget buildItem(index, GoodsQueuePersionalData item) {
    var _itemNickName = '';
    var _dateJoin = '';
    var _queueStatus = '';
    var _queueStatusText = '';
    var _queueStatusTextColor = Color(0xff999999);
    var _queuePrice = '';
    var goodsId = '';
    var _imageUrl = '';
    var _powerNum = '';
    bool done = false;
    try {
      goodsId = item.goodsId;
      _imageUrl = item.goodsImg;
      _itemNickName = item.goodsName;
      _dateJoin = item.createTime;
      index = item.rank;
      _queueStatus = item.status;
      _queuePrice = item.goodsPrice;
      _powerNum = item.powerNum;
    } catch (e) {}
    switch (_queueStatus) {
      case "2":
        _queueStatusText = '已补贴';
        _queueStatusTextColor = Color(0xff999999);
        done = true;
        break;
      case "1":
        _queueStatusText = '助力值';
        break;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (CommonUtils.isEmpty(goodsId) || done) {
          return;
        }
        try {
          EasyLoading.show();
          var result = await HttpManage.getGoodsQueueList(goodsId);
          EasyLoading.dismiss();
          if (mounted) {
            if (result.status) {
              setState(() {
                try {
                  var _goodsInfo = result.data.goodsInfo;
                  var _signPackage = result.data.signPackage;
                  _webUrl = _signPackage.url;
                  _shareTitle = _goodsInfo.gName;
                  _shareDesc = _goodsInfo.gDesc;
                  _shareThumbnail = _goodsInfo.gImg;
                } catch (e) {}
              });
              showCupertinoModalBottomSheet(
                expand: false,
                context: this.context,
                backgroundColor: Colors.white,
                builder: (context) => shareItems(),
              );
            } else {
              CommonUtils.showToast(result.errMsg);
            }
          }
        } catch (e) {
          EasyLoading.dismiss();
        }
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                buildIndexLabel(index, done: done),
                Container(
                  margin: EdgeInsets.only(left: 8),
                  child: CachedNetworkImage(
                    imageUrl: "$_imageUrl",
                    width: ScreenUtil().setWidth(120),
                    height: ScreenUtil().setWidth(120),
                    fit: BoxFit.fill,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 8),
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
                          margin: EdgeInsets.only(top: 4, left: 8),
                          child: Text(
                            "$_dateJoin",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(32),
                              color: Color(0xff999999),
                            ),
                          )),
                      Visibility(
                        visible: !done,
                        child: Container(
                            margin: EdgeInsets.only(top: 4, left: 8),
                            child: Text(
                              "￥$_queuePrice",
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(38),
                                color: !done
                                    ? Color(0xffF32E43)
                                    : _queueStatusTextColor,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: !done,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 3, left: 10),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://alipic.lanhuapp.com/xdbc37de1c-84ed-41a8-bd8b-c0c9729f1e3c",
                              width: ScreenUtil().setWidth(20),
                              height: ScreenUtil().setHeight(40),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(right: 0, left: 0),
                              child: Text(
                                "$_powerNum",
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(48),
                                  color: !done
                                      ? Color(0xffF32E43)
                                      : _queueStatusTextColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: done,
                      child: Container(
                          margin: EdgeInsets.only(top: 4, left: 8),
                          child: Text(
                            "￥$_queuePrice",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(38),
                              color: !done
                                  ? Color(0xffF32E43)
                                  : _queueStatusTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 4, left: 10),
                        child: Text(
                          "$_queueStatusText",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(32),
                            color: _queueStatusTextColor,
                          ),
                        )),
                  ],
                ),
                Visibility(
                  visible: !done,
                  child: Container(
                    margin: EdgeInsets.only(top: 0, left: 8),
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://alipic.lanhuapp.com/xd2e6c09da-9f63-4b1b-9c30-a41ca0a63491",
                      width: ScreenUtil().setWidth(40),
                      height: ScreenUtil().setHeight(40),
                    ),
                  ),
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
      ),
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
                  child: CommonUtils.getNoDuplicateSubmissionWidget(
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
                  child: CommonUtils.getNoDuplicateSubmissionWidget(
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
                child: CommonUtils.getNoDuplicateSubmissionWidget(
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
                child: CommonUtils.getNoDuplicateSubmissionWidget(
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
    if (CommonUtils.isEmpty(_webUrl)) {
      return;
    }
    if (CommonUtils.isEmpty(_shareThumbnail)) {
      _shareThumbnail =
          'https://static-ud.s4.udesk.cn/im_client/images/plugin404.8de7c6fd.png?v=1597492382675';
    }
    if (CommonUtils.isEmpty(_shareTitle)) {
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
