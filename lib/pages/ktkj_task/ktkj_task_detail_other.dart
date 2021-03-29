import 'package:star/global_config.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_octoimage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/http/ktkj_http_manage.dart';
import 'package:star/models/message_list_entity.dart';
import 'package:star/models/task_detail_other_entity.dart';
import 'package:star/pages/ktkj_task/ktkj_task_gallery.dart';
import 'package:star/pages/ktkj_task/ktkj_task_other_submission.dart';
import 'package:star/utils/ktkj_common_utils.dart';
import 'package:star/utils/ktkj_navigator_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;


// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJTaskDetailOtherPage extends StatefulWidget {
  String taskId;

  KTKJTaskDetailOtherPage({Key key, @required this.taskId, this.pageType = 0})
      : super(key: key);
  final String title = "任务详情";
  int pageType;

  @override
  _TaskDetailOtherPageState createState() => _TaskDetailOtherPageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _TaskDetailOtherPageState extends State<KTKJTaskDetailOtherPage> {
  ///消息类型 0官方提醒 1 系统通知
  String noticeType = "0";
  int page = 1;
  bool isFirstLoading = true;
  List<TaskDetailOtherDataDescJson> _descJsonList;
  String title = '';
  bool showBtn = true;

  _initData() async {
    try {
      EasyLoading.show();
    } catch (e) {}
    var result = await HttpManage.getTaskDetailOther(widget.taskId);
    if (mounted) {
      if (result.status) {
        setState(() {
          _descJsonList = result.data.descJson;
          title = result.data.title;
          showBtn = result.data.showBtn;
        });
      } else {
        KTKJCommonUtils.showToast(result.errMsg);
      }
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
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);

    return FlutterEasyLoading(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.title,
              style: TextStyle(
                  color: Color(0xFF222222), fontSize: ScreenUtil().setSp(54)),
            ),
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
            centerTitle: true,
            brightness: Brightness.light,
            backgroundColor: KTKJGlobalConfig.taskNomalHeadColor,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              constraints: BoxConstraints(
                minHeight: ScreenUtil().setHeight(2436),
              ),
              color: Color(0xffFFF1F2),
              child: Column(
                children: <Widget>[
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Image.asset(
                        "static/images/bg_title.png",
                        width: ScreenUtil().setWidth(1125),
                        height: ScreenUtil().setHeight(363),
                        fit: BoxFit.fill,
                      ),
                      Text(
                        title,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(61)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(12),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      TaskDetailOtherDataDescJson listItem =
                          _descJsonList[index];
                      return buildItemLayout(listItem: listItem, index: index);
                    },
                    itemCount: _descJsonList == null ? 0 : _descJsonList.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      height: ScreenUtil().setHeight(0.1),
                      color: Color(0xffFFF1F2),
                    ),
                  ),
                  buildBtnLayout(),
                  SizedBox(
                    height: ScreenUtil().setHeight(120),
                  ),
                ],
              ),
            ),
          ) // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }

  Widget buildBtnLayout() {
    return Visibility(
      visible: _descJsonList != null && showBtn,
      child: Container(
        alignment: Alignment.center,
        height: ScreenUtil().setHeight(120),
        child: Ink(
          child: InkWell(
              onTap: () async {
                KTKJNavigatorUtils.navigatorRouter(
                    context,
                    KTKJTaskOtherSubmissionPage(
                      taskId: widget.taskId,
                      pageType: widget.pageType,
                    ));
              },
              child: Container(
                  alignment: Alignment.center,
                  width: ScreenUtil().setWidth(773),
                  height: ScreenUtil().setHeight(120),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(69.0),
                      color: Color(0XffF32E43)),
                  child: Text(
                    "去提交",
                    style: TextStyle(
                        color: Colors.white, fontSize: ScreenUtil().setSp(42)),
                  ))),
        ),
      ),
    );
  }

  Widget buildAspectRatio(images, index) {
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        Container(
          width: ScreenUtil().setWidth(760),
          child: ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: images
                .asMap()
                .keys
                .map<Widget>(
                    (index) => buildImagesItem(images, images[index], index))
                .toList(),
//            images.map((url) => buildAspectRatio(url)).toList(),
//            images.map((url) => buildAspectRatio(url)).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildImagesItem(images, url, index) {
    return Container(
      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          Opacity(
            opacity: 0.37,
            child: Container(
              color: Colors.white,
              width: ScreenUtil().setWidth(755),
              height: ScreenUtil().setWidth(755),
              margin: EdgeInsets.only(
                  right: ScreenUtil().setWidth(35),
                  top: ScreenUtil().setHeight(41)),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return KTKJTaskGalleryPage(
                  galleryItems: images,
                  index: index,
                );
              }));
            },
            child: Container(
                width: ScreenUtil().setWidth(730),
//        width: MediaQuery.of(context).size.width / 2.5,
                child: new KTKJMyOctoImage(
                  image: url,
                  width: ScreenUtil().setWidth(728),
                  height: ScreenUtil().setHeight(915),
                  fit: BoxFit.fitWidth,
                )),
          ),
        ],
      ),
    );
  }

  Widget buildDots(index) {
    bool showInLeft = index % 2 == 0;
    return Container(
      width: ScreenUtil().setWidth(180),
      height: ScreenUtil().setWidth(180),
      child: new GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          // 左右间隔
          crossAxisSpacing: ScreenUtil().setWidth(27),
          // 上下间隔
          mainAxisSpacing: ScreenUtil().setHeight(29),
          //宽高比 默认1
//              childAspectRatio: 3 / 4,
        ),
        itemBuilder: (context, index) {
          var _opacity = 1.0;
          if (showInLeft) {
            switch (index) {
              case 0:
              case 4:
              case 8:
              case 12:
                _opacity = 1;
                break;

              case 1:
              case 5:
              case 9:
              case 13:
                _opacity = 0.76;
                break;
              case 2:
              case 6:
              case 10:
              case 14:
                _opacity = 0.41;
                break;
              case 3:
              case 7:
              case 11:
              case 15:
                _opacity = 0.12;
                break;
            }
          } else {
            switch (index) {
              case 0:
              case 4:
              case 8:
              case 12:
                _opacity = 0.12;
                break;

              case 1:
              case 5:
              case 9:
              case 13:
                _opacity = 0.41;
                break;
              case 2:
              case 6:
              case 10:
              case 14:
                _opacity = 0.76;
                break;
              case 3:
              case 7:
              case 11:
              case 15:
                _opacity = 1;
                break;
            }
          }
          return Opacity(
            opacity: _opacity,
            child: ClipOval(
              child: Container(
                  width: ScreenUtil().setWidth(19),
                  height: ScreenUtil().setWidth(19),
                  color: Color(0xffFFA3AB)),
            ),
          );
        },
        itemCount: 16,
      ),
    );
  }

  buildItemLayout({TaskDetailOtherDataDescJson listItem, index}) {
    List<String> imgUrls = [];
    String stepIndexText = '${index + 1}';
    String stepDescText = '';
    try {
      imgUrls = listItem.img;
      stepDescText = listItem.text;
      /* price = listItem.price;
      type = listItem.type;
      status = listItem.status;
      rejectReason = listItem.rejectReason;
      createTime = listItem.createTime;
      timeDesc = listItem.timeDesc;
      desc = listItem.desc;*/
    } catch (e) {}

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 0, vertical: ScreenUtil().setHeight(0)),
      padding: EdgeInsets.all(ScreenUtil().setWidth(0)),
      decoration: BoxDecoration(
          color: Color(0xffFFF1F2),
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(30))),
          border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
              color: Colors.white,
              width: 0.5)),
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            alignment: index % 2 == 0 ? Alignment.topRight : Alignment.topLeft,
            margin: EdgeInsets.only(
              top: ScreenUtil().setHeight(250),
            ),
            child: Transform.rotate(
              //旋转90度
              angle: index % 2 == 0 ? math.pi / 2 : -math.pi / 2,
              child: ClipOval(
                child: Container(
                  width: ScreenUtil().setWidth(350),
                  height: ScreenUtil().setWidth(350),
                  decoration: BoxDecoration(
                    gradient: index % 2 == 0
                        ? LinearGradient(colors: [
                            Color(0xffFFF1F2),
                            Color(0xffFCDFDE),
                          ])
                        : LinearGradient(colors: [
                            Color(0xffFCDFDE),
                            Color(0xffFFF1F2),
                          ]),
                  ),
                ),
              ),
            ),
          ),
          Container(
            alignment:
                index % 2 == 0 ? Alignment.bottomLeft : Alignment.bottomRight,
            child: Container(
                width: ScreenUtil().setWidth(200),
                height: ScreenUtil().setWidth(200),
                margin: EdgeInsets.only(top: 300),
                child: buildDots(index)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image.asset(
                    "static/images/bg_mulitiborder.png",
                    width: ScreenUtil().setWidth(210),
                    height: ScreenUtil().setHeight(230),
                    fit: BoxFit.fill,
                  ),
                  Text(
                    stepIndexText,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(71)),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(8),
              ),
              Container(
                width: ScreenUtil().setWidth(760),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Visibility(
                      visible: false,
                      child: Transform.translate(
                        offset: Offset(0, 1 / 2),
                        child: Text(
                          "$stepDescText",
                          textAlign: TextAlign.center,
                          strutStyle: StrutStyle(
                              forceStrutHeight: true, height: 1, leading: 1),
                          style: TextStyle(
                              color: Colors.transparent,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xffFDFFFD),
                              letterSpacing: 1,
                              decorationThickness: 15,
                              fontSize: ScreenUtil().setSp(42)),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !_iSStepDescTextComtainsHtml(stepDescText),
                      child: Transform.translate(
                        offset: Offset(0, 1 / 2),
                        child: SelectableText(
                          "$stepDescText",
                          textAlign: TextAlign.center,
                          /*strutStyle: StrutStyle(
                              forceStrutHeight: true, height: 1, leading: 1),*/
                          style: TextStyle(
                              color: Color(0xffED7F6F),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                              decorationColor: Colors.transparent,
                              letterSpacing: 1,
                              decorationThickness: 15,
                              fontSize: ScreenUtil().setSp(42)),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _iSStepDescTextComtainsHtml(stepDescText),
                      child: Html(
                        data:
                            "<div>${stepDescText.replaceAll("</a>", "</a><br/>")}</div>",
                        style: {
                          "div": Style(
                            fontSize: FontSize(ScreenUtil().setSp(42)),
                            color: Color(0xffED7F6F),
                            fontWeight: FontWeight.w700,
                            margin: EdgeInsets.only(
                                bottom: ScreenUtil().setHeight(20)),
                            textAlign: TextAlign.center,
                          ),
                        },
                        onLinkTap: (url) async {
                          if (await canLaunch(url) != null) {
                            await launch(url, forceSafariVC: false);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(77),
              ),
              buildAspectRatio(imgUrls, index),
              SizedBox(
                height: ScreenUtil().setHeight(90),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _iSStepDescTextComtainsHtml(String desc) {
    if (KTKJCommonUtils.isEmpty(desc)) {
      return false;
    }
    if (desc.contains("</")) {
      return true;
    }
    return false;
  }
}
