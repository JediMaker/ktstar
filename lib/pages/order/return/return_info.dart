import 'package:star/pages/widget/my_octoimage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:star/models/order_detail_entity.dart';
import 'package:star/utils/common_utils.dart';
import 'package:image_picker/image_picker.dart';
import '../../../global_config.dart';
import 'package:star/http/http_manage.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:star/pages/task/task_gallery.dart';
import 'package:flutter/cupertino.dart';

///退货详情
class KeTaoFeaturedReturnInfoPage extends StatefulWidget {
  KeTaoFeaturedReturnInfoPage({Key key, this.product}) : super(key: key);
  final String title = "退款详情";
  OrderDetailDataGoodsList product;

  @override
  _ReturnInfoPageState createState() => _ReturnInfoPageState();
}

class _ReturnInfoPageState extends State<KeTaoFeaturedReturnInfoPage> {
  var _topBoxBgColor = Color(0xffF32E43);

  var _requestDesc = '平台会在7个工作日内给您答复，如有疑问请咨询客服。';
  var _requestDescTitle = '请等待平台处理';

  var _subDesc = '''平台同意，系统将退款给您。如若需要退换货物，请咨询客服退货地址，并请记录退货运单号。如平台拒绝，您可以去平台咨询客服。
  ''';
  var _subTitle = '您已成功发起退款/退货申请，请耐心等待商家处理';

  ///退货单状态
  var _returnOrderStatus = '3';
  bool _isReturnSuccess = false;

  TextEditingController _logisticsCompanyController =
      new TextEditingController();
  TextEditingController _logisticsNoController = new TextEditingController();
  TextEditingController _contactPhoneController = new TextEditingController();

  String phoneNumber = '';

//List<Asset> images2 = List<Asset>();
  List<Image> images = List<Image>();
  List<String> imageUrls = List<String>();
  var _indexVisible = false;
  int imgNum = 3;
  PickedFile _imageFile;
  dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();

  /// 存储所有上传图片的id constant
  List<String> allImgIds = List<String>();

  ///待处理
  static const String _STATUS_WAIT = '0';

  ///同意退货
  static const String _STATUS_AGREE_TO_RETURN = '1';

  ///同意换货
  static const String _STATUS_AGREE_TO_EXCHANGE = '2';

  ///退货成功
  static const String _STATUS_SUCCESSFUL_RETURN = '3';

  ///换货成功
  static const String _STATUS_SUCCESSFUL_REPLACEMENT = '4';

  ///退款成功
  static const String _STATUS_REFUND_SUCCESSFULLY = '5';

  @override
  void initState() {
    super.initState();
    product = widget.product;
    switch (_returnOrderStatus) {
      case _ReturnInfoPageState._STATUS_WAIT: //待处理
        _requestDesc = '平台会在7个工作日内给您答复，如有疑问请咨询客服。';
        _requestDescTitle = '请等待平台处理';

        break;
      case _ReturnInfoPageState._STATUS_AGREE_TO_RETURN: //同意退货
        _requestDesc = '请先咨询客服退货地址，并请记录退货运单号。';
        _requestDescTitle = '已同意退货申请';
        break;
      case _ReturnInfoPageState._STATUS_AGREE_TO_EXCHANGE: //同意换货
        _requestDesc = '请先咨询客服退货地址，并请记录退货运单号。';
        _requestDescTitle = '已同意换货申请';
        break;
      case _ReturnInfoPageState._STATUS_SUCCESSFUL_RETURN: //退货成功
        _requestDesc = '2020年12月01日  17:39';
        _requestDescTitle = '退款成功';
        _isReturnSuccess = true;
        break;
      case _ReturnInfoPageState._STATUS_SUCCESSFUL_REPLACEMENT: //换货成功
        _requestDesc = '2020年12月01日  17:39';
        _requestDescTitle = '退换成功';
        _isReturnSuccess = true;
        break;
      case _ReturnInfoPageState._STATUS_REFUND_SUCCESSFULLY: //退款成功
        _requestDesc = '2020年12月01日  17:39';
        _requestDescTitle = '退款成功';
        _isReturnSuccess = true;
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
      child: Scaffold(
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
          centerTitle: true,
          backgroundColor: KeTaoFeaturedGlobalConfig.taskNomalHeadColor,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTopStateBox(),
                buildWaitReturnContainer(),
                buildReturnFlowContainer(),
                buildReturnSuccessfulContainer(),
                buildTopGoodsContainer(),
                buildBottomInfoContainer(),
              ],
            ),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  ///退货物流
  ///
  ///
  ///
  ///
  Widget buildReturnFlowContainer() {
    return Visibility(
      visible: _returnOrderStatus ==
              _ReturnInfoPageState._STATUS_AGREE_TO_RETURN ||
          _returnOrderStatus == _ReturnInfoPageState._STATUS_AGREE_TO_EXCHANGE,
      child: Container(
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(60), horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: Text(
                '填写退货物流',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(42),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            buildLogisticsCompanyContainer(),
            buildLogisticsNoContainer(),
            buildContactPhoneContainer(),
            buildUploadCertificateContainer(), //上传凭证
            buildBtnLayout(),
          ],
        ),
      ),
    );
  }

  /// 提交按钮操作
  Widget buildBtnLayout() {
    return Container(
      margin: EdgeInsets.only(
        top: ScreenUtil().setHeight(257),
        bottom: ScreenUtil().setHeight(257),
      ),
      child: Ink(
        child: InkWell(
            onTap: () async {},
            child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 30),
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: ScreenUtil().setHeight(152),
                width: ScreenUtil().setWidth(810),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(100)),
                    color: Color(0xffF32E43)),
                child: Text(
                  "提交",
                  style: TextStyle(
                      color: Colors.white, fontSize: ScreenUtil().setSp(48)),
                ))),
      ),
    );
  }

  Widget buildPhoneContainer() {
    return Container(
      constraints: BoxConstraints(maxHeight: 48),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        controller: _contactPhoneController,
        keyboardType: TextInputType.number,
        maxLines: 1,
        maxLengthEnforced: false,
        onChanged: (value) {
          setState(() {
            phoneNumber = value.trim();
          });
        },
        decoration: InputDecoration(
            /* labelText: widget.address.name == null
                                  ? ''
                                  : widget.address.name,*/
            border: InputBorder.none,
            /* suffixIcon: IconButton(
              icon: Image.asset(
                "static/images/close.png",
              ),
              onPressed: () {
                setState(() {
                  _contactPhoneController.text = "";
                });
              },
            ),*/
            hintText: '请输入您的手机号',
            hintStyle: TextStyle(
              fontSize: ScreenUtil().setSp(42),
            )),
      ),
    );
  }

  Widget buildLogisticNoContainer() {
    return Container(
      constraints: BoxConstraints(maxHeight: 48),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.left,
        controller: _logisticsNoController,
        keyboardType: TextInputType.number,
        maxLengthEnforced: false,
        onChanged: (value) {
          setState(() {
            phoneNumber = value.trim();
          });
        },
        decoration: InputDecoration(
            /* labelText: widget.address.name == null
                                  ? ''
                                  : widget.address.name,*/
            border: InputBorder.none,
            /* suffixIcon: IconButton(
              icon: Image.asset(
                "static/images/close.png",
              ),
              onPressed: () {
                setState(() {
                  _contactPhoneController.text = "";
                });
              },
            ),*/
            hintText: '请输入快递单号',
            hintStyle: TextStyle(
              fontSize: ScreenUtil().setSp(42),
            )),
      ),
    );
  }

  ///物流公司
  Container buildLogisticsCompanyContainer() {
    return Container(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: Row(
        children: [
          Text(
            '物流公司：',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(42),
              color: Color(0xff222222),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: 4,
                right: 16,
              ),
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  SelectableText.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: '选择物流公司',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(42),
                          color: Color(0xff999999),
                        ),
                      ),
                    ]),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Text(
              '复制',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(42),
                color: _topBoxBgColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///物流单号
  Container buildLogisticsNoContainer() {
    return Container(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: Row(
        children: [
          Text(
            '物流单号：',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(42),
              color: Color(0xff222222),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: 4,
                right: 16,
              ),
              child: buildLogisticNoContainer(),
            ),
          ),
        ],
      ),
    );
  }

  ///联系电话
  Container buildContactPhoneContainer() {
    return Container(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: Row(
        children: [
          Text(
            '联系电话：',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(42),
              color: Color(0xff222222),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: 4,
                right: 16,
              ),
              child: buildPhoneContainer(), //,
            ),
          ),
        ],
      ),
    );
  }

  ///上传凭证
  Container buildUploadCertificateContainer() {
    return Container(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '上传凭证',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(42),
                  color: Color(0xff222222),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          buildGridView(),
        ],
      ),
    );
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
        plusVisible = images.length < imgNum;
        if (index == images.length) {
          return Visibility(
            visible: plusVisible,
            child: GestureDetector(
              onTap: () {
                /* if(){

                }*/
                _indexVisible = false;
                KeTaoFeaturedCommonUtils.requestPermission(Permission.photos,
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
                return KeTaoFeaturedTaskGalleryPage(
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

  Widget buildTopStateBox() {
    return Visibility(
        visible: !KeTaoFeaturedCommonUtils.isEmpty(_requestDesc),
        child: Container(
            width: double.infinity,
            color: _topBoxBgColor,
            height: ScreenUtil().setHeight(300),
            padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setHeight(60), horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: _isReturnSuccess,
                      child: Container(
                        margin: EdgeInsets.only(right: 8),
                        child: KeTaoFeaturedMyOctoImage(
                          image:
                              'https://alipic.lanhuapp.com/xd6099a4da-e864-47bf-8cf5-e859a821e962',
                          width: ScreenUtil().setWidth(60),
                          height: ScreenUtil().setWidth(60),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "$_requestDescTitle",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(48),
                        ),
                      ),
                    ),
                  ],
                ),
                Opacity(
                  opacity: 0.86,
                  child: Container(
                    margin: EdgeInsets.only(top: 4),
                    child: Text(
                      "$_requestDesc",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(36),
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }

  Widget buildWaitReturnContainer() {
    return Visibility(
        visible: _returnOrderStatus == _ReturnInfoPageState._STATUS_WAIT,
        child: Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setHeight(60), horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$_subTitle",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(42),
                  ),
                ),
                Opacity(
                  opacity: 1,
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      "$_subDesc",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: ScreenUtil().setSp(36),
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }

  Widget buildReturnSuccessfulContainer() {
    return Visibility(
        visible: _returnOrderStatus ==
            _ReturnInfoPageState._STATUS_SUCCESSFUL_RETURN,
        child: Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setHeight(60), horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "退款总金额",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(42),
                    ),
                  ),
                ),
                Opacity(
                  opacity: 1,
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      "￥111",
                      style: TextStyle(
                        color: Color(0xffF32E43),
                        fontSize: ScreenUtil().setSp(48),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }

  OrderDetailDataGoodsList product;

  Container buildTopGoodsContainer() {
    return Container(
      padding: EdgeInsets.only(
        top: 16,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      margin: EdgeInsets.only(
        top: 10,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(28))),
          border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
              color: Colors.white,
              width: 0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8),
            child: Text(
              '退款信息',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(42),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: KeTaoFeaturedMyOctoImage(
                  fadeInDuration: Duration(milliseconds: 0),
                  fadeOutDuration: Duration(milliseconds: 0),
                  fit: BoxFit.fill,
                  width: ScreenUtil().setWidth(243),
                  height: ScreenUtil().setWidth(243),
                  image: product.goodsImg == null ? "" : product.goodsImg,
                  /*   imageUrl: item.imageUrl,
                                    width: ScreenUtil().L(120),
                                    height: ScreenUtil().L(120),*/
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.goodsName == null ? "" : product.goodsName,
//                                  item.wareName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xff222222),
                        fontSize: ScreenUtil().setSp(42),
                      ),
                    ),
                    Container(
                      child: Text(
                        product.specItem == null ? "" : product.specItem,
//                                  item.wareName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(38),
                          color: Color(0xff666666),
                        ),
                      ),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(18)),
                    ),
                    /*Wrap(
                              children: product.option.map((op) {
                                return Container(
                                  child: Text(
                                    "${op.value} ",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                );
                              }).toList(),
                            ),*/
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Row(
//                            crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
//                              Expanded(child:,),
                            Flexible(
                              child: Text(
                                '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(),
                              ),
//                                flex: 2,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "￥${product.salePrice == null ? "" : product.salePrice}",
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(42),
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF93736),
                              ),
                            ),
                          ],
                        )),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'x${product.goodsNum}',
                            style: TextStyle(
                              color: Color(0xff222222),
                              fontSize: ScreenUtil().setSp(36),
                            ),
                          ),
                        ),
//                            Icon(
//                              Icons.more_horiz,
//                              size: 15,
//                              color: Color(0xFF979896),
//                            ),
                      ],
                    ),
                  ],
                ),
              ))
            ],
          ),
        ],
      ),
    );
  }

  Container buildBottomInfoContainer() {
    return Container(
      padding: EdgeInsets.only(
        bottom: 16,
        left: 16,
        right: 16,
      ),
      constraints: BoxConstraints(minHeight: 388),
      margin: EdgeInsets.only(
        top: 0,
      ),
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(28))),
          border: Border.all(
//                    color: isDiamonVip ? Color(0xFFF8D9BA) : Colors.white,
              color: Colors.white,
              width: 0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMoneyListTile(0),
          _buildMoneyListTile(1),
          _buildMoneyListTile(2),
          _buildMoneyListTile(3),
        ],
      ),
    );
  }

  Widget _buildMoneyListTile(int type) {
    var title = '';
    var subTitle = '';
    var iconUrl = '';
    try {
      switch (type) {
        case 0: //退款原因
          title = '退款原因';
          subTitle = '不可修改，最多10';
          iconUrl =
              'https://alipic.lanhuapp.com/xdc05c048e-39ae-442b-b7df-83a8d279efce';
          break;
        case 1: //    退款金额
          title = '退款金额';
          subTitle = '申请时间申请时间申请时间申请时间申请时间申请时间申请时间申请时间申请时间申请时间不可修改，最多10';
          iconUrl =
              'https://alipic.lanhuapp.com/xd27d999e2-a5f9-4a4b-84ce-f545b85f3a1d';
          break;
        case 2: //申请时间
          title = '申请时间';
          subTitle = '不可修改，最多10';
          iconUrl =
              'https://alipic.lanhuapp.com/xd0201789e-6702-4f31-8f40-48280f71d536';
          break;
        case 3: //退款编号
          title = '退款编号';
          subTitle = '15489565456265654354';
          iconUrl =
              'https://alipic.lanhuapp.com/xd0201789e-6702-4f31-8f40-48280f71d536';
          break;
      }
    } catch (e) {
      print(e);
    }
    return Container(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: Row(
        children: [
          Text(
            '$title',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(42),
              color: Color(0xff999999),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  SelectableText.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: '$subTitle',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(42),
                          color: Color(0xff222222),
                        ),
                      ),
                    ]),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: type == 3,
            child: GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: "$subTitle"));
                KeTaoFeaturedCommonUtils.showToast("已复制文本");
              },
              child: Container(
                child: Text(
                  '复制',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(42),
                    color: _topBoxBgColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
