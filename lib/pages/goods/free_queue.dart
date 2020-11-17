import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/goods_queue_entity.dart';
import 'package:star/pages/goods/free_queue_persional.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';
import 'package:star/pages/task/task_index.dart';

void main() {
  runApp(MaterialApp(
    home: Container(
      child: Center(
        child: FreeQueuePage(),
      ),
    ),
  ));
}

class FreeQueuePage extends StatefulWidget {
  FreeQueuePage({Key key, this.goodsId}) : super(key: key);
  final String title = "";
  String goodsId;

  @override
  _FreeQueuePageState createState() => _FreeQueuePageState();
}

class _FreeQueuePageState extends State<FreeQueuePage> {
  var _headImageUrl = '';
  var _nickName = '';
  bool _hasSort = false;
  List<GoodsQueueDataList> _queueList = List<GoodsQueueDataList>();

  @override
  void initState() {
    _initData();
    super.initState();
  }

  _initData() async {
    if (CommonUtils.isEmpty(widget.goodsId)) {
      return;
    }
    try {
      EasyLoading.show();
      var result = await HttpManage.getGoodsQueueList(widget.goodsId);
      if (mounted) {
        if (result.status) {
          setState(() {
            try {
              _queueList = result.data.xList;
              _headImageUrl = result.data.userInfo.avatar;
              _nickName = result.data.userInfo.username;
              _hasSort = result.data.userInfo.myStatus;
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
              "补贴奖励奖不停，购物省钱又省心",
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
                  child: CachedNetworkImage(
                imageUrl: "$_headImageUrl",
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
                  NavigatorUtils.navigatorRouterReplaceMent(
                      context, FreeQueuePersonalPage());
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Container(
                  margin: EdgeInsets.only(right: 16, left: 10),
                  child: _hasSort
                      ? Text.rich(
                          TextSpan(children: [
                            TextSpan(text: '个人所有排名'),
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
                            color: Color(0xff222222),
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
          child: CachedNetworkImage(
            imageUrl:
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
          child: CachedNetworkImage(
            imageUrl:
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
          child: CachedNetworkImage(
            imageUrl:
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
    try {
      _itemNickName = item.username;
      _avatarUrl = item.avatar;
      _dateJoin = item.createTime;
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
                  child: CachedNetworkImage(
                    imageUrl: "$_avatarUrl",
                    width: ScreenUtil().setWidth(100),
                    height: ScreenUtil().setWidth(100),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(left: 16),
                    child: Text(
                      "$_itemNickName",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(38),
                        color: Color(0xff222222),
                      ),
                    )),
              ),
              Container(
                  margin: EdgeInsets.only(right: 0, left: 10),
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
}
