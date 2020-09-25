import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/pages/task/task_index.dart';
import 'package:star/utils/common_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:star/utils/navigator_utils.dart';

import '../../global_config.dart';

class TaskSubmissionPage extends StatefulWidget {
  TaskSubmissionPage({Key key, @required this.taskId}) : super(key: key);
  final String title = "提交截图审核";
  String taskId;

  @override
  _TaskSubmissionPageState createState() => _TaskSubmissionPageState();
}

class _TaskSubmissionPageState extends State<TaskSubmissionPage> {
  PickedFile _imageFile;
  dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();
  String _retrieveDataError;

  _onButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
      );
      setState(() async {
        _imageFile = pickedFile;
        String imgBase64 =
            await CommonUtils.imageToBase64AndCompress(File(_imageFile.path));
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  String imgUrl;

  _initData() async {
    var result = await HttpManage.getTaskSubmitInfo(widget.taskId);
    if (mounted) {
      if (result.status) {
        setState(() {
          imgUrl = result.data.imgUrl;
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

  Widget buildSubmitButton() {
    return Container(
      alignment: Alignment.center,
      width: double.maxFinite,
      child: GestureDetector(
        onTap: () async {
          var entity = await HttpManage.uploadImage(File(_imageFile.path));
          if (entity.status) {
            var imageId = entity.data["id"].toString();
            var result = await HttpManage.taskSubmit(widget.taskId, imageId);
            if (result.status) {
              Fluttertoast.showToast(
                  msg: "提交成功",
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  gravity: ToastGravity.BOTTOM);
              NavigatorUtils.navigatorRouterAndRemoveUntil(
                  context, TaskIndexPage());
            } else {
              Fluttertoast.showToast(
                  msg: "${result.errMsg}",
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  gravity: ToastGravity.BOTTOM);
            }
          } else {
            Fluttertoast.showToast(
                msg: "${entity.errMsg}",
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                gravity: ToastGravity.BOTTOM);
          }
        },
        child: Container(
          height: ScreenUtil().setHeight(135),
          width: ScreenUtil().setWidth(650),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: _imageFile == null
                  ? GlobalConfig.taskHeadDisableColor
                  : GlobalConfig.taskHeadColor,
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
                border: Border.all(color: GlobalConfig.taskHeadColor),
                borderRadius: BorderRadius.circular(48)),
            child: Text(
              '重新上传',
              style: TextStyle(
                  color: GlobalConfig.taskHeadColor,
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
          centerTitle: true,
          elevation: 0,
          backgroundColor: GlobalConfig.taskHeadColor,
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
                            CommonUtils.requestPermission(
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
