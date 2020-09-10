import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/utils/common_utils.dart';
import 'package:image_picker/image_picker.dart';

import '../../global_config.dart';

class TaskSubmissionPage extends StatefulWidget {
  TaskSubmissionPage({Key key}) : super(key: key);
  final String title = "提交截图审核";

  @override
  _TaskSubmissionPageState createState() => _TaskSubmissionPageState();
}

class _TaskSubmissionPageState extends State<TaskSubmissionPage> {
  PickedFile _imageFile;
  dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();
  String _retrieveDataError;

  void _onButtonPressed(ImageSource source, {BuildContext context}) async {
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

  @override
  void initState() {
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
        onTap: () {
          //todo 提交任务截图
        },
        child: Container(
          height: 46,
          width: 216,
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
            style: TextStyle(color: Colors.white),
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
            height: 46,
            width: 216,
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
              style: TextStyle(color: GlobalConfig.taskHeadColor),
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
          title: Text(widget.title),
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
                        child: Image.asset(
                          "static/images/task_example_img.png",
                          width: 140,
                          height: 240,
                          fit: BoxFit.fill,
                        )),
                    Visibility(
                      visible: _imageFile != null,
                      child: Image.file(
                        File(_imageFile != null
                            ? _imageFile.path == null ? "" : _imageFile.path
                            : ""),
                        width: 140,
                        height: 240,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Container(
                          height: 30,
                          child: Text("${_imageFile != null ? '我的：' : '例如：'}")),
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
                          onTap: () {
                            _onButtonPressed(ImageSource.gallery,
                                context: context);
                          },
                          child: Image.asset(
                            "static/images/task_img_pick.png",
                            width: 140,
                            height: 96,
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
