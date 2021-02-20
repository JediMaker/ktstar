import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:star/ktxxhttp/ktxx_http_manage.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_index.dart';
import 'package:star/ktxxutils/ktxx_common_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:star/ktxxutils/ktxx_navigator_utils.dart';

import '../../ktxx_global_config.dart';
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedTaskSubmissionPage extends StatefulWidget {
  KeTaoFeaturedTaskSubmissionPage(
      {Key key, @required this.taskId, this.pageType = 0, this.comId})
      : super(key: key);
  final String title = "提交截图审核";
  String taskId;

  ///任务提交记录id
  String comId;

  /// 页面类型 0 朋友圈任务提交 1任务重新提交
  int pageType;
//    Container(
//height: 6.0,
//width: 6.0,
//decoration: BoxDecoration(
//color: furnitureCateDisableColor,
//shape: BoxShape.circle,
//),
//),
//SizedBox(
//width: 5.0,
//),
//Container(
//height: 5.0,
//width: 20.0,
//decoration: BoxDecoration(
//color: Colors.blue[700],
//borderRadius: BorderRadius.circular(10.0)),
//),
  @override
  _KeTaoFeaturedTaskSubmissionPageState createState() => _KeTaoFeaturedTaskSubmissionPageState();
}
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _KeTaoFeaturedTaskSubmissionPageState extends State<KeTaoFeaturedTaskSubmissionPage> {
  PickedFile _imageFile;
  dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();
  String _retrieveDataError;

  _onButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
      );
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;
  String imgUrl;

  _initData() async {
    if (widget.pageType == 0) {
      var result = await KeTaoFeaturedHttpManage.getTaskSubmitInfo(widget.taskId);
      if (mounted) {
        if (result.status) {
          setState(() {
            imgUrl = result.data.imgUrl;
            widget.comId = result.data.comId;
          });
        }
      }
    } else {
      var result =
          await KeTaoFeaturedHttpManage.getTaskReSubmitInfo(widget.taskId, widget.comId);
      if (mounted) {
        if (result.status) {
          setState(() {
            imgUrl = result.data.imgUrl;
          });
        }
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

  Widget buildSubmitButton() {
    return Container(
      alignment: Alignment.center,
      width: double.maxFinite,
      child: GestureDetector(
        onTap: () async {
          var entity = await KeTaoFeaturedHttpManage.uploadImage(File(_imageFile.path));
          if (entity.status) {
            var imageId = entity.data["id"].toString();
            var result = await KeTaoFeaturedHttpManage.taskReSubmit(widget.comId, imageId);
            if (result.status) {
              KeTaoFeaturedCommonUtils.showToast("提交成功");
              KeTaoFeaturedNavigatorUtils.navigatorRouterAndRemoveUntil(
                  context, KeTaoFeaturedTaskIndexPage());
            } else {
              KeTaoFeaturedCommonUtils.showToast(result.errMsg);
            }
          } else {
            KeTaoFeaturedCommonUtils.showToast(entity.errMsg);
          }
        },
        child: Container(
          height: ScreenUtil().setHeight(135),
          width: ScreenUtil().setWidth(650),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: _imageFile == null
                  ? KeTaoFeaturedGlobalConfig.taskHeadDisableColor
                  : KeTaoFeaturedGlobalConfig.taskHeadColor,
              /*gradient: LinearGradient(
                  colors: [Color(0xFFFE9322), Color(0xFFFFB541)]),*/
              borderRadius: BorderRadius.circular(48)),
          child: Text(
            '立即提交',
            style: TextStyle(
                color: Colors.white, fontSize: ScreenUtil().setSp(48)),
          ),
        ),
      ),
    );
  }

  Widget buildUploadtButton() {
    return Visibility(
      visible: _imageFile != null,
      child: Container(
        alignment: Alignment.center,
        width: double.maxFinite,
        child: GestureDetector(
          onTap: () {
            _onButtonPressed(ImageSource.gallery, context: context);
          },
          child: Container(
            height: ScreenUtil().setHeight(135),
            width: ScreenUtil().setWidth(650),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                /*color: _imageFile == null
                    ? GlobalConfig.taskHeadDisableColor
                    : GlobalConfig.taskHeadColor,*/
                /*gradient: LinearGradient(
                    colors: [Color(0xFFFE9322), Color(0xFFFFB541)]),*/
                border: Border.all(color: KeTaoFeaturedGlobalConfig.taskHeadColor),
                borderRadius: BorderRadius.circular(48)),
            child: Text(
              '重新上传',
              style: TextStyle(
                  color: KeTaoFeaturedGlobalConfig.taskHeadColor,
                  fontSize: ScreenUtil().setSp(48)),
            ),
          ),
        ),
      ),
    );
  }

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
          elevation: 0,
          backgroundColor: KeTaoFeaturedGlobalConfig.taskHeadColor,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Visibility(
                        visible: _imageFile == null,
                        child: imgUrl == null
                            ? Image.asset(
                                "static/images/task_example_img.png",
                                width: ScreenUtil().setWidth(401),
                                height: ScreenUtil().setHeight(695),
                                fit: BoxFit.fill,
                              )
                            : CachedNetworkImage(imageUrl: imgUrl)),
                    Visibility(
                      visible: _imageFile != null,
                      child: Image.file(
                        File(_imageFile != null
                            ? _imageFile.path == null ? "" : _imageFile.path
                            : ""),
                        width: ScreenUtil().setWidth(401),
                        height: ScreenUtil().setHeight(695),
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Container(
                          height: 30,
                          child: Text(
                            "${_imageFile != null ? '我的：' : '例如：'}",
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(42),
                                color: Color(0xFF222222)),
                          )),
                    ),
                    /*Image.asset(
                       ),*/
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Visibility(
                      visible: _imageFile == null,
                      child: GestureDetector(
                          onTap: () async {
                            KeTaoFeaturedCommonUtils.requestPermission(
                                Permission.photos,
                                _onButtonPressed(ImageSource.gallery,
                                    context: context));
                          },
                          child: Image.asset(
                            "static/images/task_img_pick.png",
                            width: ScreenUtil().setWidth(425),
                            height: ScreenUtil().setHeight(290),
                          ))),
                ),
                Visibility(
                  visible: _imageFile == null,
                  child: Wrap(
                    children: <Widget>[
                      Text.rich(
                        TextSpan(
                          text: '* ',
                          style: TextStyle(color: Color(0xFFF93736)),
                          children: <InlineSpan>[
                            TextSpan(
                              text: '请上传朋友圈截图，不可设置分组且禁止随意修改伪造图片，一经发现，金额清零。',
                              style: TextStyle(
                                color: Color(0xFFB9B9B9),
                                fontSize: ScreenUtil().setSp(36),
//                            decoration: TextDecoration.underline,
//                            decorationStyle: TextDecorationStyle.wavy,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                buildSubmitButton(),
                buildUploadtButton(),
                /* CachedNetworkImage(
                  imageUrl: "",
                ),*/
              ],
            ),
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
