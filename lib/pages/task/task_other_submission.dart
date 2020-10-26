import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/pages/task/task_gallery.dart';
import 'package:star/pages/task/task_index.dart';
import 'package:star/utils/common_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:star/utils/navigator_utils.dart';

import '../../global_config.dart';

class TaskOtherSubmissionPage extends StatefulWidget {
  TaskOtherSubmissionPage(
      {Key key, @required this.taskId, this.pageType = 0, this.comId})
      : super(key: key);
  final String title = "提交截图审核";
  String taskId;

  ///任务提交记录id
  String comId;

  /// 页面类型 0 任务提交 1任务重新提交
  int pageType;

  @override
  _TaskOtherSubmissionPageState createState() =>
      _TaskOtherSubmissionPageState();
}

class _TaskOtherSubmissionPageState extends State<TaskOtherSubmissionPage> {
  //List<Asset> images2 = List<Asset>();
  List<Image> images = List<Image>();
  List<String> imageUrls = List<String>();
  var _indexVisible = false;
  int imgNum = 1;

  PickedFile _imageFile;
  dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();
  String _retrieveDataError;

  /// 存储所有上传图片的id
  List<String> allImgIds = List<String>();

  _onButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
      );
      _imageFile = pickedFile;
      EasyLoading.show(status: "图片上传中...");
      var entity = await HttpManage.uploadImage(File(_imageFile.path));
      if (entity.status) {
        var imageId = entity.data["id"].toString();

        if (allImgIds == null) {
          allImgIds = List<String>();
        }
        print("allImgIds=$imageId" + allImgIds.toString());
        allImgIds.add(imageId);
        var fileImage = Image.file(
          File(_imageFile.path),
          width: ScreenUtil().setWidth(327),
          height: ScreenUtil().setWidth(327),
          fit: BoxFit.fitWidth,
        );
        images.add(fileImage);
      } else {
        print("allImgIdsstatus=" + allImgIds.toString());
      }

      if (mounted) {
        setState(() {
          print("allImgIds=" + allImgIds.toString());
          print("images.length=" + images.length.toString());
          images = images;
        });
      }
      EasyLoading.dismiss();
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
      EasyLoading.dismiss();
    }
  }

  _initData() async {
    if (widget.pageType == 0) {
      var result = await HttpManage.getTaskOtherSubmitInfo(widget.taskId);
      if (mounted) {
        if (result.status) {
          setState(() {
            imgNum = result.data.imgNum ?? "0";
            widget.comId = result.data.comId ?? "";
            imageUrls = result.data.imgUrl;
            allImgIds = result.data.imgId;

            for (var url in imageUrls) {
              images.add(Image.network(
                url,
                width: ScreenUtil().setWidth(327),
                height: ScreenUtil().setWidth(327),
                fit: BoxFit.fitWidth,
              ));
            }
          });
        }
      }
    } else {
      var result = await HttpManage.getTaskOtherReSubmitInfo(
          widget.taskId, widget.comId);
      if (mounted) {
        if (result.status) {
          setState(() {
            imgNum = result.data.imgNum;
            allImgIds = result.data.imgId;
            imageUrls = result.data.imgUrl;
            for (var url in imageUrls) {
              images.add(Image.network(
                url,
                width: ScreenUtil().setWidth(327),
                height: ScreenUtil().setWidth(327),
                fit: BoxFit.fitWidth,
              ));
            }
          });
        }
      }
    }
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: ScreenUtil().setWidth(27),
      mainAxisSpacing: ScreenUtil().setWidth(27),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: List.generate((images.length + 1).toInt(), (index) {
        var plusVisible = false;
        if (widget.pageType == 0) {
          plusVisible = images.length < imgNum;
        } else {
          if (images.length != 0) {
            plusVisible = images.length < imgNum;
          }
        }
        if (index == images.length) {
          return Visibility(
            visible: plusVisible,
            child: GestureDetector(
              onTap: () {
                /* if(){

                }*/
                _indexVisible = false;
                CommonUtils.requestPermission(Permission.photos,
                    _onButtonPressed(ImageSource.gallery, context: context));
              },
              child: Image.asset(
                "static/images/icon_gv_plus.png",
                width: ScreenUtil().setWidth(327),
                height: ScreenUtil().setWidth(327),
                fit: BoxFit.fill,
              ),
            ),
          );
        } else {
          Image asset = images[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return TaskGalleryPage(
                  images: images,
                  index: index,
                  type: 1,
                );
              }));
            },
            onLongPress: () {
              setState(() {
                _indexVisible = !_indexVisible;
              });
            },
            child: Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                asset,
                GestureDetector(
                  onTap: () {
                    if (!mounted) return;
                    setState(() {
                      try {
                        images.removeAt(index);
                        allImgIds.removeAt(index);
                        _indexVisible = false;
                        print("allImgIds=" + allImgIds.toString());
                        print("images.length=" + images.length.toString());
                      } catch (e) {}
                    });
                  },
                  child: Visibility(
                    visible: _indexVisible,
                    child: Opacity(
                      opacity: 0.88,
                      child: Container(
                        width: ScreenUtil().setWidth(56),
                        height: ScreenUtil().setWidth(56),
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.only(bottom: ScreenUtil().setWidth(6)),
                        decoration: BoxDecoration(
                            color: Color(0xff99999970),
                            borderRadius: BorderRadius.all(
                                Radius.circular(ScreenUtil().setWidth(6)))),
                        child: Icon(
                          CupertinoIcons.clear_thick,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  /*Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 9,
        enableCamera: false,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
//          actionBarColor: "#abcdef",
//          actionBarTitle: "Example App",
//          allViewTitle: "All Photos",
//          useDetailsView: false,
//          selectCircleStrokeColor: "#000000",
            ),
      );
    } on Exception catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (resultList.length > 0) {
        images = resultList;
      }
    });
  }*/

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
          if (images.length == 0) {
            return;
          }
          String imgIds = allImgIds.join(",");
          if (widget.pageType == 0) {
            ///提交任务
            var result = await HttpManage.taskReSubmit(widget.comId, imgIds);
            if (result.status) {
              CommonUtils.showToast("提交成功");
              NavigatorUtils.navigatorRouterAndRemoveUntil(
                  context, TaskIndexPage());
            } else {
              CommonUtils.showToast(result.errMsg);
            }
          } else {
            ///重新提交任务
            var result = await HttpManage.taskReSubmit(widget.comId, imgIds);
            if (result.status) {
              CommonUtils.showToast("提交成功");
              NavigatorUtils.navigatorRouterAndRemoveUntil(
                  context, TaskIndexPage());
            } else {
              CommonUtils.showToast(result.errMsg);
            }

            ///
          }
        },
        child: Container(
          height: ScreenUtil().setHeight(135),
          width: ScreenUtil().setWidth(650),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: images.length == 0
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
      visible: images.length == 0,
      child: Container(
        alignment: Alignment.center,
        width: double.maxFinite,
        child: GestureDetector(
          onTap: () {},
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
    return FlutterEasyLoading(
      child: Scaffold(
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
            backgroundColor: GlobalConfig.taskHeadColor,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(32),
                vertical: ScreenUtil().setWidth(32)),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(32)),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "上传任务截图",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(42),
                          color: Color(0xff222222)),
                    ),
                  ),
                  buildGridView(),
                  SizedBox(
                    height: ScreenUtil().setHeight(32),
                  ),
                  Visibility(
                    visible: true,
                    child: Wrap(
                      children: <Widget>[
                        Text.rich(
                          TextSpan(
                            text: '* ',
                            style: TextStyle(color: Color(0xFFF93736)),
                            children: <InlineSpan>[
                              TextSpan(
                                text:
                                    '请按照任务要求上传任务截图，禁止随意修改，伪造图片，一经发现，任务给予驳回，追回任务奖励金额。',
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
//                buildUploadtButton(),
                  /* CachedNetworkImage(
                    imageUrl: "",
                  ),*/
                ],
              ),
            ),
          ) // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }
}
