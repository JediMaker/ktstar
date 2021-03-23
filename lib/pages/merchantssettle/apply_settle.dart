import 'dart:io';

import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:star/pages/widget/my_octoimage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:star/global_config.dart';
import 'package:star/http/api.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/shop_type_entity.dart';
import 'package:star/pages/merchantssettle/chose_location.dart';
import 'package:star/pages/task/task_gallery.dart';
import 'package:star/pages/widget/my_webview.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';
import 'package:image_cropper/image_cropper.dart';

///申请商家入驻
class KeTaoFeaturedApplySettlePage extends StatefulWidget {
  KeTaoFeaturedApplySettlePage({Key key, this.applyStatus, this.rejectMsg, this.shopId})
      : super(key: key);
  final String title = "申请商家入驻";

  ///商家入驻申请状态
  ///0 未申请
  ///1 审核中
  ///2 通过
  ///3 拒绝
  var applyStatus;
  var rejectMsg;
  var shopId;

  @override
  _ApplySettlePageState createState() => _ApplySettlePageState();
}

class _ApplySettlePageState extends State<KeTaoFeaturedApplySettlePage> {
  Location _location;

  /* _initData() async {
    if (widget.applyStatus != "0") {
      var result = await HttpManage.getShopInfo(widget.shopId);
      if (mounted) {
        if (result.status) {
          setState(() {
            imgNum = result.data.imgNum ?? "0";
            widget.comId = result.data.comId ?? "";
            imageUrls = result.data.imgUrl;
            allImgIds = result.data.imgId;
            try {
              _needRemark = result.data.needRemark == "2";
            } catch (e) {
              _needRemark = false;
            }

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
*/

  /// 动态申请定位权限
  void requestPermission() async {
    // 申请权限
    bool hasLocationPermission = await requestLocationPermission();
    if (hasLocationPermission) {
      print("定位权限申请通过");
      getLocation();
    } else {
      print("定位权限申请不通过");
    }
  }

  /// 申请定位权限
  /// 授予定位权限返回true， 否则返回false
  Future<bool> requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        getLocation();
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    applyStatus = widget.applyStatus;
    _rejectMsg = widget.rejectMsg;
    setViewVisibility();
    _shopProfitRatioController.text = _selectProfit + "";
    _shopProfitRatioFocusNode.addListener(() {
//      _shopProfitRatioFocusNode.i
      if (_shopProfitRatioFocusNode.hasFocus) {}
    });
//    requestPermission();
    _initData();
  }

  void setViewVisibility() {
    if (applyStatus == STATUS_NOT_APPLIED) {
      if (mounted) {
        setState(() {
          _showApplyInfo = true;
          _showApplyUnderReview = false;
          _showApplyRefused = false;
        });
      }
    }
    if (applyStatus == STATUS_UNDER_REVIEW) {
      if (mounted) {
        setState(() {
          _showApplyInfo = false;
          _showApplyUnderReview = true;
          _showApplyRefused = false;
        });
      }
    }
    if (applyStatus == STATUS_REFUSE) {
      if (mounted) {
        setState(() {
          _showApplyInfo = false;
          _showApplyUnderReview = false;
          _showApplyRefused = true;
        });
      }
    }
  }

  ///获取定位初始化定位信息
  getLocation() async {
    //获取所在城市
    _location = await AmapLocation.instance
        .fetchLocation(mode: LocationAccuracy.High, needAddress: true);
    if (!KeTaoFeaturedCommonUtils.isEmpty(_location)) {
      if (mounted) {
        setState(() {
          _shopLocation = "${_location.country + _location.address}";
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  _initShopListData() async {
    var result = await HttpManage.getShopTypeList();
    if (result.status) {
      if (mounted) {
        setState(() {
          _shopTypeList = KeTaoFeaturedGlobalConfig.getShopTypeListData();
        });
      }
    }
  }

  var textDescColor = Color(0xff222222);
  var textDescGreyColor = Color(0xffb9b9b9);
  var textStatusDescGreyColor = Color(0xff666666);
  var dividerColor = Color(0xffefefef);

  ///商家入驻申请状态
  ///0 未申请
  ///1 审核中
  ///2 通过
  ///3 拒绝
  var applyStatus = '';

//   ignore: non_constant_identifier_names
  final String STATUS_NOT_APPLIED = '0';

  //   ignore: non_constant_identifier_names
  final String STATUS_UNDER_REVIEW = '1';

  //   ignore: non_constant_identifier_names
  final String STATUS_DONE = '2';

  //   ignore: non_constant_identifier_names
  final String STATUS_REFUSE = '3';

  var _showApplyInfo = true;
  var _showApplyUnderReview = false;
  var _showApplyRefused = false;

  TextEditingController _shopNameController =
      new TextEditingController(); //店铺名称
  FocusNode _shopNameFocusNode = FocusNode();
  var _shopName = '';

  TextEditingController _contactDetailsController =
      new TextEditingController(); //联系方式
  FocusNode _contactDetailsFocusNode = FocusNode();
  var _contactDetails = '';

  TextEditingController _shopLocationController =
      new TextEditingController(); //店铺位置
  FocusNode _shopLocationFocusNode = FocusNode();
  var _shopLocation = '';
  Map _selectAddressInfo;

  TextEditingController _shopTypeController =
      new TextEditingController(); //店铺类型
  FocusNode _shopTypeFocusNode = FocusNode();
  var _shopType = '';
  var _selectShopTypeIndex = -1;
  var _selectTypeId = "";

  TextEditingController _shopProfitRatioController =
      new TextEditingController(); //让利比例
  FocusNode _shopProfitRatioFocusNode = FocusNode();
  var _shopProfitRatio = "10";
  var _showProfitWarningText = false;
  var _selectProfit = "";
  var _selectProfitDifference = "0"; //分红金差额
  var _estimateProfit = "";

  TextEditingController _shopDescController =
      new TextEditingController(); //店铺描述
  FocusNode _shopDescFocusNode = FocusNode();
  var _shopDesc = "";

  //入驻申请信息编辑
  buildApplyInfo() {
    return Visibility(
      visible: _showApplyInfo,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(35),
        ),
        child: Column(
          children: [
            buildShopNameInput(),
            buildDivider(),
            buildContactDetailsInput(),
            buildDivider(),
            buildShopLocationInput(),
            buildDivider(),
            buildShopTypeInput(),
            buildDivider(),
            buildShopProfitRatioInput(),
            buildDivider(),
            buildShopDescInput(),
            buildDivider(),
            buildShopPhotosInput(),
            buildShopPhotosInput2(),
            buildSubmitButton(),
            Container(
              height: ScreenUtil().setWidth(200),
            )
          ],
        ),
      ),
    );
  }

  ///店铺名称
  Widget buildShopNameInput() {
    return Container(
      height: ScreenUtil().setWidth(180),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(
              right: ScreenUtil().setWidth(65),
            ),
            child: Text(
              "店铺名称",
              style: TextStyle(
                color: textDescColor,
                fontSize: ScreenUtil().setSp(42),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              maxLines: 1,
              controller: _shopNameController,
              focusNode: _shopNameFocusNode,

              maxLengthEnforced: false,
//              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _shopName = value.trim();
                });
              },
              style: TextStyle(
                color: textDescColor,
                fontSize: ScreenUtil().setSp(42),
              ),
              decoration: InputDecoration(
                  /* labelText: widget.address.name == null
                                  ? ''
                                  : widget.address.name,*/
                  border: InputBorder.none,
                  hintText: '请输入店铺名称',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: textDescGreyColor,
                    fontSize: ScreenUtil().setSp(42),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContactDetailsInput() {
    return Container(
      height: ScreenUtil().setWidth(180),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(
              right: ScreenUtil().setWidth(65),
            ),
            child: Text(
              "联系方式",
              style: TextStyle(
                color: textDescColor,
                fontSize: ScreenUtil().setSp(42),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              maxLines: 1,
              controller: _contactDetailsController,
              focusNode: _contactDetailsFocusNode,
              maxLengthEnforced: false,
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                setState(() {
                  _contactDetails = value.trim();
                });
              },
              style: TextStyle(
                color: textDescColor,
                fontSize: ScreenUtil().setSp(42),
              ),
              decoration: InputDecoration(
                  /* labelText: widget.address.name == null
                                  ? ''
                                  : widget.address.name,*/
                  border: InputBorder.none,
                  hintText: '请输入真实手机号',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: textDescGreyColor,
                    fontSize: ScreenUtil().setSp(42),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildShopLocationInput() {
//    _shopLocation = '东京起i商家位置商家位置商家位置商家位置商家位置商家位置商家位置商家位置商家位置';
//    _shopLocationController.text = _shopLocation;
    return GestureDetector(
      onTap: () async {
        Map selectAddressInfo =
            await KeTaoFeaturedNavigatorUtils.navigatorRouter(context, KeTaoFeaturedChoseLocationPage());
        /* 'title': await item.title,
        'addressDetail': distance +
        await item.provinceName +
        await item.cityName +
        await item.adName +
        await item.address,
        'position': await item.latLng,
        'distance': distance,
        'latitude': endlat.latitude,
        'longitude': endlat.longitude,
        'provinceName': await item.provinceName,
        'cityName': await item.cityName,
        'adName': await item.adName,
        'address': await item.address,*/
        if (KeTaoFeaturedCommonUtils.isEmpty(selectAddressInfo)) {
          return;
        }
        if (mounted) {
          setState(() {
            _selectAddressInfo = selectAddressInfo;
            _shopLocation = selectAddressInfo['addressDetail']
                .toString()
                .replaceAll(selectAddressInfo['distance'].toString(), "");
          });
        }
      },
      child: Container(
        height: ScreenUtil().setWidth(180),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                right: ScreenUtil().setWidth(65),
              ),
              child: Text(
                "商家位置",
                style: TextStyle(
                  color: textDescColor,
                  fontSize: ScreenUtil().setSp(42),
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Visibility(
                    visible: KeTaoFeaturedCommonUtils.isEmpty(_shopLocation),
                    child: TextField(
                      maxLines: 1,
                      controller: _shopLocationController,
                      focusNode: _shopLocationFocusNode,
                      maxLengthEnforced: false,
                      enabled: false,
//              keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        setState(() {
                          _shopLocation = value.trim();
                        });
                      },
                      style: TextStyle(
                        color: textDescColor,
                        fontSize: ScreenUtil().setSp(42),
                      ),
                      decoration: InputDecoration(
                          /* labelText: widget.address.name == null
                                          ? ''
                                          : widget.address.name,*/
                          border: InputBorder.none,
                          hintText: '请输入真实店铺位置',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: textDescGreyColor,
                            fontSize: ScreenUtil().setSp(42),
                          )),
                    ),
                  ),
                  Visibility(
                    visible: !KeTaoFeaturedCommonUtils.isEmpty(_shopLocation),
                    child: Container(
                      child: Text(
                        "$_shopLocation",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textDescColor,
                          fontSize: ScreenUtil().setSp(42),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(30),
                right: ScreenUtil().setWidth(30),
              ),
              child: KeTaoFeaturedMyOctoImage(
                image:
                    "https://alipic.lanhuapp.com/xdffeb73c5-368b-4086-b4af-907535f9ff3b",
                width: ScreenUtil().setWidth(35),
                height: ScreenUtil().setWidth(47),
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 店铺行业类型
  ///
  List<ShopTypeDataList> _shopTypeList;

  Widget buildShopTypeInput() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        showShopTypeSheet();
      },
      child: Container(
        height: ScreenUtil().setWidth(180),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                right: ScreenUtil().setWidth(65),
              ),
              child: Text(
                "所属类型",
                style: TextStyle(
                  color: textDescColor,
                  fontSize: ScreenUtil().setSp(42),
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Visibility(
                    visible: KeTaoFeaturedCommonUtils.isEmpty(_shopType),
                    child: TextField(
                      maxLines: 1,
                      controller: _shopTypeController,
                      focusNode: _shopTypeFocusNode,
                      maxLengthEnforced: false,
                      enabled: false,
//              keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        setState(() {
                          _shopType = value.trim();
                        });
                      },
                      style: TextStyle(
                        color: textDescColor,
                        fontSize: ScreenUtil().setSp(42),
                      ),
                      decoration: InputDecoration(
                          /* labelText: widget.address.name == null
                                          ? ''
                                          : widget.address.name,*/
                          border: InputBorder.none,
                          hintText: '请选择行业类型',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: textDescGreyColor,
                            fontSize: ScreenUtil().setSp(42),
                          )),
                    ),
                  ),
                  Visibility(
                    visible: !KeTaoFeaturedCommonUtils.isEmpty(_shopType),
                    child: Container(
                      child: Text(
                        "$_shopType",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textDescColor,
                          fontSize: ScreenUtil().setSp(42),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(30),
                right: ScreenUtil().setWidth(30),
              ),
              child: KeTaoFeaturedMyOctoImage(
                image:
                    "https://alipic.lanhuapp.com/xde52a3d9c-25c5-4378-9e95-967be98fa594",
                width: ScreenUtil().setWidth(36),
                height: ScreenUtil().setWidth(23),
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }

  showShopTypeSheet() {
    showBarModalBottomSheet(
      expand: false,
      context: this.context,
      elevation: 0,
      backgroundColor: Colors.white,
      builder: (context) => listView(),
    );
  }

  Widget listView() {
    return StatefulBuilder(
      builder: (context, state) {
        return Container(
          height: 400,
          color: Colors.white,
          child: ListView.builder(
            itemBuilder: (context, index) {
              ShopTypeDataList item;
              item = _shopTypeList[index];
              return ListTile(
                onTap: () async {
                  state(() {
                    _selectShopTypeIndex = index;
                    Navigator.of(context).pop();
                  });
                  setState(() {
                    _showProfitWarningText = false;
                    _shopType = item.name;
                    _selectProfit = item.profit;
                    _selectTypeId = item.id;
                    _selectProfitDifference = item.coin;
                    _shopProfitRatio = _selectProfit;
                    _shopProfitRatioController.text = "$_shopProfitRatio";
                    try {
                      var ep = double.parse(_shopProfitRatio) -
                          double.parse(_selectProfitDifference);
                      _estimateProfit = ep.toString();
                    } catch (e) {
                      print(e);
                    }
                  });
                },
                selected: _selectShopTypeIndex == index,
                title: Text(
                  '${item.name}',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(48),
                    color: Color(0xff222222),
                  ),
                ),
                trailing: KeTaoFeaturedMyOctoImage(
                  image:
                      "${_selectTypeId == item.id ? "https://alipic.lanhuapp.com/xda760ae72-7c57-4c57-b898-6b6a00d16c9c" : "https://alipic.lanhuapp.com/xd9cbbe519-1886-421d-a02e-27d8c33cfc90"}",
                  width: ScreenUtil().setWidth(60),
                  height: ScreenUtil().setWidth(60),
                  fit: BoxFit.fill,
                ),
              );
            },
            itemCount: _shopTypeList.length,
          ),
        );
      },
    );
  }

  ///让利比例
  Widget buildShopProfitRatioInput() {
    return Container(
      height: ScreenUtil().setWidth(180),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(
              right: ScreenUtil().setWidth(65),
            ),
            child: Text(
              "让利比例",
              style: TextStyle(
                color: textDescColor,
                fontSize: ScreenUtil().setSp(42),
              ),
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(165),
            child: Stack(
              children: [
                TextField(
                  maxLines: 1,
                  controller: _shopProfitRatioController,
                  focusNode: _shopProfitRatioFocusNode,
                  maxLengthEnforced: true,
                  maxLength: 3,
//              enabled: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [],
                  onChanged: (value) {
                    setState(() {
                      _shopProfitRatio = value.trim();
                      if (KeTaoFeaturedCommonUtils.isEmpty(_selectProfit)) {
                        return;
                      }
                      if (double.parse(_shopProfitRatio) <
                          double.parse(_selectProfit)) {
                        _showProfitWarningText = true;
                      } else {
                        _showProfitWarningText = false;
                      }
                      var ep = double.parse(_shopProfitRatio) -
                          double.parse(_selectProfitDifference);
                      _estimateProfit = ep.toString();
                    });
                  },
                  onEditingComplete: () {
                    setState(() {
                      /*if (!_shopProfitRatioController.text.contains("%")) {
                        _shopProfitRatioController.text = "$_selectProfit%";
                      } else {
                        _shopProfitRatioController.text = "$_selectProfit";
                      }*/
                      _shopProfitRatioController.text = "$_shopProfitRatio";
                    });
                  },
                  style: TextStyle(
                    color: textDescColor,
                    fontSize: ScreenUtil().setSp(42),
                  ),
                  decoration: null,
                ),
                Visibility(
                  visible: !KeTaoFeaturedCommonUtils.isEmpty(_shopProfitRatio),
                  child: GestureDetector(
                    onTap: () {
                      _shopProfitRatioFocusNode.requestFocus();
                    },
                    child: Container(
                      child: Text(
                        "$_shopProfitRatio%",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textDescColor,
                          fontSize: ScreenUtil().setSp(42),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible:
                _showProfitWarningText && !KeTaoFeaturedCommonUtils.isEmpty(_selectProfit),
            child: Container(
              child: Text(
                "*该行业让利比例最低为$_selectProfit%",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xfff32e43),
                  fontSize: ScreenUtil().setSp(32),
                ),
              ),
            ),
          ),
          Visibility(
            visible:
                !_showProfitWarningText && !KeTaoFeaturedCommonUtils.isEmpty(_selectProfit),
            child: Container(
              child: Text(
                "*用户预估分红金可得$_estimateProfit%",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xfff32e43),
                  fontSize: ScreenUtil().setSp(32),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///店铺描述
  Widget buildShopDescInput() {
    return Container(
      height: ScreenUtil().setWidth(180),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(
              right: ScreenUtil().setWidth(40),
            ),
            child: Text(
              "描述(选填)",
              style: TextStyle(
                color: textDescColor,
                fontSize: ScreenUtil().setSp(42),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                TextField(
                  maxLines: 1,
                  controller: _shopDescController,
                  focusNode: _shopDescFocusNode,
                  maxLengthEnforced: true,
                  maxLength: 100,
//              enabled: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [],
                  onChanged: (value) {
                    setState(() {
                      _shopDesc = value.trim();
                    });
                  },
                  style: TextStyle(
                    color: textDescColor,
                    fontSize: ScreenUtil().setSp(42),
                  ),
                  decoration: null,
                ),
                Visibility(
                  visible: KeTaoFeaturedCommonUtils.isEmpty(_shopDesc),
                  child: GestureDetector(
                    onTap: () {
                      _shopDescFocusNode.requestFocus();
                    },
                    child: Container(
                      child: Text(
                        "请控制在100个字符以内",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textDescGreyColor,
                          fontSize: ScreenUtil().setSp(42),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int imgNum = 1;
  PickedFile _imageFile;
  dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();
  String _retrieveDataError;
  List<Image> images = List<Image>();
  List<String> imageUrls = List<String>();

  /// 存储所有上传图片的id
  List<String> allImgIds = List<String>();
  var _indexVisible = false;

  int imgNum2 = 1;
  PickedFile _imageFile2;
  dynamic _pickImageError2;
  final ImagePicker _picker2 = ImagePicker();
  String _retrieveDataError2;
  List<Image> images2 = List<Image>();
  List<String> imageUrls2 = List<String>();

  /// 存储所有上传图片的id
  List<String> allImgIds2 = List<String>();
  var _indexVisible2 = false;

  ///店铺图片
  Widget buildShopPhotosInput() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(60),
                  bottom: ScreenUtil().setWidth(60),
                ),
                child: Text(
                  "店铺头像：",
                  style: TextStyle(
                    color: textDescColor,
                    fontSize: ScreenUtil().setSp(42),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(60),
                  bottom: ScreenUtil().setWidth(60),
                ),
                child: Text(
                  "(该图片显示于列表页/收款码)",
                  style: TextStyle(
                    color: Color(0xffafafaf),
                    fontSize: ScreenUtil().setSp(32),
                  ),
                ),
              ),
            ],
          ),
          buildGridView(),
        ],
      ),
    );
  }

  _onButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
      );
      _imageFile = pickedFile;
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: _imageFile.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
//            CropAspectRatioPreset.ratio3x2,
//            CropAspectRatioPreset.original,
//            CropAspectRatioPreset.ratio4x3,
//            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: '图片裁剪',
              toolbarColor: KeTaoFeaturedGlobalConfig.taskHeadColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
            aspectRatioLockDimensionSwapEnabled: true,
            aspectRatioLockEnabled: true,
          ));

      EasyLoading.show(status: "图片上传中...");
      var entity = await HttpManage.uploadImage(
          croppedFile); //File(_imageFile.path) croppedFile
      if (entity.status) {
        var imageId = entity.data["id"].toString();

        if (allImgIds == null) {
          allImgIds = List<String>();
        }
        print("allImgIds=$imageId" + allImgIds.toString());
        allImgIds.add(imageId);
        var fileImage = Image.file(
          croppedFile,
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

  Widget buildGridView() {
    return Center(
      child: GridView.count(
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
                child: KeTaoFeaturedMyOctoImage(
                  image:
                      "https://alipic.lanhuapp.com/xdae253960-0d6f-4146-a4f4-46e348039361",
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
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
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
                        opacity: 0.48,
                        child: Container(
                          width: ScreenUtil().setWidth(60),
                          height: ScreenUtil().setWidth(60),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Color(0xff222222),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(6)))),
                          child: Center(
                            child: Icon(
                              CupertinoIcons.clear_thick,
                              color: Colors.white,
                              size: ScreenUtil().setSp(38),
                            ),
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
      ),
    );
  }

  ///店铺图片
  Widget buildShopPhotosInput2() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(60),
                  bottom: ScreenUtil().setWidth(60),
                ),
                child: Text(
                  "门头图片：",
                  style: TextStyle(
                    color: textDescColor,
                    fontSize: ScreenUtil().setSp(42),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(60),
                  bottom: ScreenUtil().setWidth(60),
                ),
                child: Text(
                  "(该图片将用于店铺详情页展示、选填)",
                  style: TextStyle(
                    color: Color(0xffafafaf),
                    fontSize: ScreenUtil().setSp(32),
                  ),
                ),
              ),
            ],
          ),
          buildGridView2(),
        ],
      ),
    );
  }

  _onButtonPressed2(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker2.getImage(
        source: source,
      );
      _imageFile2 = pickedFile;
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: _imageFile2.path,
          aspectRatioPresets: [
//            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
//            CropAspectRatioPreset.original,
//            CropAspectRatioPreset.ratio4x3,
//            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: '图片裁剪',
              toolbarColor: KeTaoFeaturedGlobalConfig.taskHeadColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.ratio3x2,
              lockAspectRatio: true),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
            aspectRatioLockDimensionSwapEnabled: true,
            aspectRatioLockEnabled: true,
          ));
      EasyLoading.show(status: "图片上传中...");
      var entity =
          await HttpManage.uploadImage(croppedFile); //File(_imageFile2.path)
      if (entity.status) {
        var imageId = entity.data["id"].toString();

        if (allImgIds2 == null) {
          allImgIds2 = List<String>();
        }
        print("allImgIds2=$imageId" + allImgIds2.toString());
        allImgIds2.add(imageId);
        var fileImage = Image.file(
          croppedFile,
//          File(_imageFile2.path),
          width: ScreenUtil().setWidth(327),
          height: ScreenUtil().setWidth(327),
          fit: BoxFit.fitWidth,
        );
        images2.add(fileImage);
      } else {
        print("allImgIds2status=" + allImgIds2.toString());
      }

      if (mounted) {
        setState(() {
          print("allImgIds2=" + allImgIds2.toString());
          print("images2.length=" + images2.length.toString());
          images2 = images2;
        });
      }
      EasyLoading.dismiss();
    } catch (e) {
      setState(() {
        _pickImageError2 = e;
      });
      EasyLoading.dismiss();
    }
  }

  /* 'title': await item.title,
        'addressDetail': distance +
        await item.provinceName +
        await item.cityName +
        await item.adName +
        await item.address,
        'position': await item.latLng,
        'distance': distance,
        'latitude': endlat.latitude,
        'longitude': endlat.longitude,
        'provinceName': await item.provinceName,
        'cityName': await item.cityName,
        'adName': await item.adName,
        'address': await item.address,*/
  var _latitude;
  var _longitude;
  var _provinceName;
  var _cityName;
  var _adName;
  var _address;

  _initData() async {
    _initShopListData();
    if (KeTaoFeaturedCommonUtils.isEmpty(KeTaoFeaturedGlobalConfig.prefs.getString("latitude"))) {
      await KeTaoFeaturedGlobalConfig.initUserLocationWithPermission(count: 0);
      _latitude = KeTaoFeaturedGlobalConfig.prefs.getString("latitude");
      _longitude = KeTaoFeaturedGlobalConfig.prefs.getString("longitude");
    } else {
      _latitude = KeTaoFeaturedGlobalConfig.prefs.getString("latitude");
      _longitude = KeTaoFeaturedGlobalConfig.prefs.getString("longitude");
    }

    if (applyStatus != STATUS_NOT_APPLIED) {
      var result = await HttpManage.getShopInfo(
          storeId: widget.shopId, latitude: _latitude, longitude: _longitude);
      if (mounted) {
        if (result.status) {
          setState(() {
            try {
              _shopTypeList = KeTaoFeaturedGlobalConfig.getShopTypeListData();
              _shopName = result.data.storeName;
              _shopNameController.text = _shopName;
              _contactDetails = result.data.storeTel;
              _contactDetailsController.text = _contactDetails;
              _selectTypeId = result.data.tradeId;
              for (var item in _shopTypeList) {
                if (item.id == _selectTypeId) {
                  _shopType = item.name;
                  _selectProfitDifference = item.coin;
                  _selectProfit = item.profit;
                }
              }

              _shopDesc = result.data.storeDesc;
              _shopDescController.text = _shopDesc;
              _shopLocation =
                  "${result.data.storeProvince + result.data.storeCity + result.data.storeDistrict + result.data.storeAddr}";

              _shopProfitRatio = result.data.storeRatio;
              var ep = double.parse(_shopProfitRatio) -
                  double.parse(_selectProfitDifference);
              _estimateProfit = ep.toString();
              _showProfitWarningText = false;
              _storeImg = result.data.storeImg;
              _storeLogo = result.data.storeLogo;
              _provinceName = result.data.storeProvince;
              _cityName = result.data.storeCity;
              _adName = result.data.storeDistrict;
              _address = result.data.storeAddr;
              if (!KeTaoFeaturedCommonUtils.isEmpty(result.data.storeLogoUrl)) {
                var netImage = Image.network(
                  result.data.storeLogoUrl,
                  width: ScreenUtil().setWidth(327),
                  height: ScreenUtil().setWidth(327),
                  fit: BoxFit.fill,
                );
                images.add(netImage);
              }
              if (!KeTaoFeaturedCommonUtils.isEmpty(result.data.storeImgUrl)) {
                var netImage = Image.network(
                  result.data.storeImgUrl,
                  width: ScreenUtil().setWidth(327),
                  height: ScreenUtil().setWidth(327),
                  fit: BoxFit.fill,
                );
                images2.add(netImage);
              }
            } catch (e) {
              print(e);
            }
          });
        }
      }
    }
  }

  Widget buildGridView2() {
    return Center(
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: ScreenUtil().setWidth(27),
        mainAxisSpacing: ScreenUtil().setWidth(27),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate((images2.length + 1).toInt(), (index) {
          var plusVisible = false;
          plusVisible = images2.length < imgNum;
          if (index == images2.length) {
            return Visibility(
              visible: plusVisible,
              child: GestureDetector(
                onTap: () {
                  /* if(){

                  }*/
                  _indexVisible2 = false;
                  KeTaoFeaturedCommonUtils.requestPermission(Permission.photos,
                      _onButtonPressed2(ImageSource.gallery, context: context));
                },
                child: KeTaoFeaturedMyOctoImage(
                  image:
                      "https://alipic.lanhuapp.com/xdae253960-0d6f-4146-a4f4-46e348039361",
                  width: ScreenUtil().setWidth(327),
                  height: ScreenUtil().setWidth(327),
                  fit: BoxFit.fill,
                ),
              ),
            );
          } else {
            Image asset = images2[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return KeTaoFeaturedTaskGalleryPage(
                    images: images2,
                    index: index,
                    type: 1,
                  );
                }));
              },
              onLongPress: () {
                setState(() {
                  _indexVisible2 = !_indexVisible2;
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
                          images2.removeAt(index);
                          allImgIds2.removeAt(index);
                          _indexVisible2 = false;
                          print("allImgIds2=" + allImgIds2.toString());
                          print("images2.length=" + images2.length.toString());
                        } catch (e) {}
                      });
                    },
                    child: Visibility(
                      visible: _indexVisible2,
                      child: Opacity(
                        opacity: 0.48,
                        child: Container(
                          width: ScreenUtil().setWidth(60),
                          height: ScreenUtil().setWidth(60),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Color(0xff222222),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(6)))),
                          child: Center(
                            child: Icon(
                              CupertinoIcons.clear_thick,
                              color: Colors.white,
                              size: ScreenUtil().setSp(38),
                            ),
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
      ),
    );
  }

  var _isAgreementChecked = true;
  var _storeLogo;
  var _storeImg;

  ///提交审核
  Widget buildSubmitButton() {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: double.maxFinite,
          child: GestureDetector(
            onTap: () async {
              if (KeTaoFeaturedCommonUtils.isEmpty(_shopName) ||
                  KeTaoFeaturedCommonUtils.isEmpty(_shopProfitRatio) ||
                  KeTaoFeaturedCommonUtils.isEmpty(_shopType) ||
                  KeTaoFeaturedCommonUtils.isEmpty(_shopLocation) ||
                  KeTaoFeaturedCommonUtils.isEmpty(_contactDetails)) {
                KeTaoFeaturedCommonUtils.showToast("必填项内容未填写！");
                return;
              }
              if (!KeTaoFeaturedCommonUtils.isPhoneLegal(_contactDetails)) {
                KeTaoFeaturedCommonUtils.showToast("请输入正确的手机号！");
                return;
              }
              if (_showProfitWarningText) {
                KeTaoFeaturedCommonUtils.showToast("请填写合适的让利比例！");
                return;
              }
              if (images.length == 0) {
                KeTaoFeaturedCommonUtils.showToast("未上传店铺头像！");
                return;
              }
              if (!_isAgreementChecked) {
                KeTaoFeaturedCommonUtils.showToast("请选择同意入驻规则！");
                return;
              }
              if (!KeTaoFeaturedCommonUtils.isEmpty(allImgIds)) {
                _storeLogo = allImgIds.join(",");
              }
              if (!KeTaoFeaturedCommonUtils.isEmpty(allImgIds2)) {
                _storeImg = allImgIds2.join(",");
              }
              /* 'title': await item.title,
        'addressDetail': distance +
        await item.provinceName +
        await item.cityName +
        await item.adName +
        await item.address,
        'position': await item.latLng,
        'distance': distance,
        'latitude': endlat.latitude,
        'longitude': endlat.longitude,
        'provinceName': await item.provinceName,
        'cityName': await item.cityName,
        'adName': await item.adName,
        'address': await item.address,*/
              if (!KeTaoFeaturedCommonUtils.isEmpty(_selectAddressInfo)) {
                _latitude = _selectAddressInfo["latitude"].toString();
                _longitude = _selectAddressInfo["longitude"].toString();
                _provinceName = _selectAddressInfo["provinceName"].toString();
                _cityName = _selectAddressInfo["cityName"].toString();
                _adName = _selectAddressInfo["adName"].toString();
                _address = _selectAddressInfo["address"].toString();
              }

              ///提交申请
              var result = await HttpManage.shopRegistrationApplication(
                storeName: _shopName,
                storeLogo: _storeLogo,
                storeImg: _storeImg,
                tradeId: _selectTypeId,
                storeTel: _contactDetails,
                storeLat: _latitude,
                storeLng: _longitude,
                storeProvince: _provinceName,
                storeCity: _cityName,
                storeDistrict: _adName,
                storeAddr: _address,
                storeRatio: _shopProfitRatio,
                storeDesc: _shopDesc,
                storeId: widget.shopId,
              );
              if (result.status) {
                KeTaoFeaturedCommonUtils.showToast("申请已提交");
                Navigator.of(context).pop();
              } else {
                KeTaoFeaturedCommonUtils.showToast("${result.errMsg}");
              }

//              HttpManage.s
              /*String imgIds = allImgIds.join(",");
              if (widget.pageType == 0) {
                ///提交任务
                var result = await HttpManage.taskReSubmit(widget.comId, imgIds,
                    remark: _remark);
                if (result.status) {
                  KeTaoFeaturedCommonUtils.showToast("提交成功");
                  KeTaoFeaturedNavigatorUtils.navigatorRouterAndRemoveUntil(
                      context, KeTaoFeaturedTaskIndexPage());
                } else {
                  KeTaoFeaturedCommonUtils.showToast(result.errMsg);
                }
              } else {
                ///重新提交任务
                var result = await HttpManage.taskReSubmit(widget.comId, imgIds,
                    remark: _remark);
                if (result.status) {
                  KeTaoFeaturedCommonUtils.showToast("提交成功");
                  KeTaoFeaturedNavigatorUtils.navigatorRouterAndRemoveUntil(
                      context, KeTaoFeaturedTaskIndexPage());
                } else {
                  KeTaoFeaturedCommonUtils.showToast(result.errMsg);
                }

                ///
              }*/
            },
            child: Container(
              height: ScreenUtil().setWidth(140),
              margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(60),
                vertical: ScreenUtil().setWidth(60),
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: images.length == 0
                      ? KeTaoFeaturedGlobalConfig.taskHeadDisableColor
                      : KeTaoFeaturedGlobalConfig.taskHeadColor,
                  gradient: LinearGradient(
                      colors: [Color(0xFFF36B2E), Color(0xFFF32E43)]),
                  borderRadius: BorderRadius.circular(70)),
              child: Text(
                '立即提交',
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(48)),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _isAgreementChecked = !_isAgreementChecked;
            });
          },
          child: Text.rich(
            TextSpan(children: [
              WidgetSpan(
                child: KeTaoFeaturedMyOctoImage(
                  image:
                      "${_isAgreementChecked ? 'https://alipic.lanhuapp.com/xd6edb8e0a-146d-4eb6-901a-941895b3c0c6' : 'https://alipic.lanhuapp.com/xd7951edab-996a-47cb-967d-3d79f757ecc1'}",
                  width: ScreenUtil().setWidth(42),
                  height: ScreenUtil().setWidth(42),
                ),
              ),
              TextSpan(text: "  "),
              TextSpan(text: "同意并认真阅读"),
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    if (KeTaoFeaturedCommonUtils.isEmpty(
                        APi.AGREEMENT_SHOP_ENTRY_RULES_URL)) {
                      return;
                    }
                    KeTaoFeaturedNavigatorUtils.navigatorRouter(
                        context,
                        KeTaoFeaturedWebViewPage(
                          initialUrl: APi.AGREEMENT_SHOP_ENTRY_RULES_URL,
                          showActions: false,
                          title: "商家入驻规则协议",
                        ));
                  },
                  child: Text(
                    "《商家入驻规则协议》",
                    style: TextStyle(
                        color: KeTaoFeaturedGlobalConfig.taskHeadColor,
                        fontSize: ScreenUtil().setSp(32)),
                  ),
                ),
              )
            ]),
            style: TextStyle(
              color: Color(0xff656565),
              fontSize: ScreenUtil().setSp(32),
            ),
          ),
        )
      ],
    );
  }

  Widget buildDivider() {
    return Container(
      color: dividerColor,
      height: ScreenUtil().setWidth(1),
    );
  }

  Widget buildUnderReviewWidget() {
    return Visibility(
      visible: _showApplyUnderReview,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setWidth(91),
            ),
            child: KeTaoFeaturedMyOctoImage(
              image:
                  "https://alipic.lanhuapp.com/xd6ba64a76-9a7e-4320-a416-83c7f0ef6dba",
              width: ScreenUtil().setWidth(350),
              height: ScreenUtil().setWidth(359),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setWidth(121),
            ),
            child: Text(
              "平台正在审核中，请耐心等待...",
              style: TextStyle(
                color: textStatusDescGreyColor,
                fontSize: ScreenUtil().setSp(38),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: double.maxFinite,
            child: GestureDetector(
              onTap: () async {
                if (mounted) {
                  setState(() {
                    _showApplyInfo = true;
                    _showApplyUnderReview = false;
                    _showApplyRefused = false;
                  });
                }
                /*String imgIds = allImgIds.join(",");
              if (widget.pageType == 0) {
                ///提交任务
                var result = await HttpManage.taskReSubmit(widget.comId, imgIds,
                    remark: _remark);
                if (result.status) {
                  KeTaoFeaturedCommonUtils.showToast("提交成功");
                  KeTaoFeaturedNavigatorUtils.navigatorRouterAndRemoveUntil(
                      context, KeTaoFeaturedTaskIndexPage());
                } else {
                  KeTaoFeaturedCommonUtils.showToast(result.errMsg);
                }
              } else {
                ///重新提交任务
                var result = await HttpManage.taskReSubmit(widget.comId, imgIds,
                    remark: _remark);
                if (result.status) {
                  KeTaoFeaturedCommonUtils.showToast("提交成功");
                  KeTaoFeaturedNavigatorUtils.navigatorRouterAndRemoveUntil(
                      context, KeTaoFeaturedTaskIndexPage());
                } else {
                  KeTaoFeaturedCommonUtils.showToast(result.errMsg);
                }

                ///
              }*/
              },
              child: Container(
                height: ScreenUtil().setWidth(140),
                margin: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(60),
                  vertical: ScreenUtil().setWidth(145),
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFFF36B2E), Color(0xFFF32E43)]),
                    borderRadius: BorderRadius.circular(70)),
                child: Text(
                  '修改信息',
                  style: TextStyle(
                      color: Colors.white, fontSize: ScreenUtil().setSp(48)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  var _rejectMsg;

  Widget buildRefusedWidget() {
    return Visibility(
      visible: _showApplyRefused,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setWidth(91),
            ),
            child: KeTaoFeaturedMyOctoImage(
              image:
                  "https://alipic.lanhuapp.com/xdd0101e83-7469-42e6-8236-60872e06737e",
              width: ScreenUtil().setWidth(386),
              height: ScreenUtil().setWidth(338),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setWidth(121),
            ),
            child: Text(
              "$_rejectMsg",
              style: TextStyle(
                color: textStatusDescGreyColor,
                fontSize: ScreenUtil().setSp(38),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: double.maxFinite,
            child: GestureDetector(
              onTap: () async {
                if (mounted) {
                  setState(() {
                    _showApplyInfo = true;
                    _showApplyUnderReview = false;
                    _showApplyRefused = false;
                  });
                }
                /*String imgIds = allImgIds.join(",");
              if (widget.pageType == 0) {
                ///提交任务
                var result = await HttpManage.taskReSubmit(widget.comId, imgIds,
                    remark: _remark);
                if (result.status) {
                  KeTaoFeaturedCommonUtils.showToast("提交成功");
                  KeTaoFeaturedNavigatorUtils.navigatorRouterAndRemoveUntil(
                      context, KeTaoFeaturedTaskIndexPage());
                } else {
                  KeTaoFeaturedCommonUtils.showToast(result.errMsg);
                }
              } else {
                ///重新提交任务
                var result = await HttpManage.taskReSubmit(widget.comId, imgIds,
                    remark: _remark);
                if (result.status) {
                  KeTaoFeaturedCommonUtils.showToast("提交成功");
                  KeTaoFeaturedNavigatorUtils.navigatorRouterAndRemoveUntil(
                      context, KeTaoFeaturedTaskIndexPage());
                } else {
                  KeTaoFeaturedCommonUtils.showToast(result.errMsg);
                }

                ///
              }*/
              },
              child: Container(
                height: ScreenUtil().setWidth(140),
                margin: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(60),
                  vertical: ScreenUtil().setWidth(145),
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFFF36B2E), Color(0xFFF32E43)]),
                    borderRadius: BorderRadius.circular(70)),
                child: Text(
                  '重新申请',
                  style: TextStyle(
                      color: Colors.white, fontSize: ScreenUtil().setSp(48)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
      child: KeyboardDismissOnTap(
          child: Scaffold(
              appBar: AppBar(
                title: Text(
                  widget.title,
                  style: TextStyle(
                      color: Color(0xFF222222),
                      fontSize: ScreenUtil().setSp(54)),
                ),
                brightness: Brightness.light,
                leading: IconButton(
                  icon: Container(
                    width: ScreenUtil().setWidth(63),
                    height: ScreenUtil().setHeight(63),
                    child: Center(
                      child: Image.asset(
                        "static/images/icon_ios_back.png",
                        width: ScreenUtil().setWidth(36),
                        height: ScreenUtil().setHeight(63),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                centerTitle: true,
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              body: Container(
                color: Colors.white,
                height: double.infinity,
                margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(30),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildApplyInfo(),
                      buildUnderReviewWidget(),
                      buildRefusedWidget(),
                    ],
                  ),
                ),
              ) // This trailing comma makes auto-formatting nicer for build methods.
              )),
    );
  }
}
