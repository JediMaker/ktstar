import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/goods_queue_persional_entity.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';
import 'package:star/pages/task/task_index.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
          width: ScreenUtil().setWidth(60),
          height: ScreenUtil().setWidth(60),
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
    return Column(
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
                    child: Container(
                        margin: EdgeInsets.only(right: 0, left: 10),
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
