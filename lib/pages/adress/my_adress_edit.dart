//import 'package:star/pages/widget/my_octoimage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star/pages/widget/my_octoimage.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/pages/widget/jd_address_selector.dart';
import 'package:star/pages/widget/my_octoimage.dart';
import 'package:star/utils/common_utils.dart';

import '../../global_config.dart';
import 'my_adress.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedAddressDetailPage extends StatefulWidget {
  var addressId;
  String defaultAddressId;
  String title;
  int type; //0、订单选择地址  1、地址编辑修改

  KeTaoFeaturedAddressDetailPage({
    @required this.addressId,
    @required this.defaultAddressId,
    @required this.type = 1,
    this.title = '编辑收货地址',
    Key key,
  }) : super(key: key);

  @override
  _AddressDetailPageState createState() => _AddressDetailPageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _AddressDetailPageState extends State<KeTaoFeaturedAddressDetailPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  String defaultAddressId;
  TextEditingController _unameController;
  TextEditingController _phoneController;
  TextEditingController _addressDetailController;
  var _province = '';
  var _city = '';
  var _county = '';
  var _provinceId;
  var _cityId;
  var _countyId;
  var name;
  var iphone;
  var addressDetail;

  Future _initData() async {
    if (widget.addressId == null) {
      return;
    }
    var resultData =
        await HttpManage.getShippingAddressDetail(widget.addressId);
    if (mounted) {
      setState(() {
        if (resultData.status) {
          try {
            _province = resultData.data.province;
            _provinceId = resultData.data.provinceId;
            _city = resultData.data.city;
            _cityId = resultData.data.cityId;
            _county = resultData.data.county;
            _countyId = resultData.data.countyId;
            name = resultData.data.consignee;
            iphone = resultData.data.mobile;
            addressDetail = resultData.data.address;
            _defaultValue = resultData.data.isDefault == '1';
            _unameController.value =
                TextEditingValue(text: name == null ? "" : name);
            _phoneController.value =
                TextEditingValue(text: iphone == null ? "" : iphone);

            _addressDetailController.value = TextEditingValue(
                text: addressDetail == null ? "" : addressDetail);
          } catch (e) {}
        }
      });
    }
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _unameController = new TextEditingController();
    _phoneController = new TextEditingController();
    _addressDetailController = new TextEditingController();

    _initData();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _unameController.dispose();
    _phoneController.dispose();
    _addressDetailController.dispose();
    super.dispose();
  }

  bool _defaultValue = false;
  Color _textGray = Color(0xff999999);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
              color: Color(0xFF222222), fontSize: ScreenUtil().setSp(54)),
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
            Navigator.of(context).pop(false);
          },
        ),
        centerTitle: true,
        backgroundColor: KeTaoFeaturedGlobalConfig.taskNomalHeadColor,
        elevation: 0,
        actions: <Widget>[
          GestureDetector(
            child: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '保存',
                    style: TextStyle(
                      color: Color(0xFF222222),
                      fontSize: ScreenUtil().setSp(42),
                    ),
                  ),
                )),
            onTap: () async {
              if (KeTaoFeaturedCommonUtils.isEmpty(
                    _unameController.value.text,
                  ) ||
                  KeTaoFeaturedCommonUtils.isEmpty(
                    _phoneController.value.text,
                  ) ||
                  KeTaoFeaturedCommonUtils.isEmpty(
                    _province,
                  ) ||
                  KeTaoFeaturedCommonUtils.isEmpty(
                    _city,
                  ) ||
                  KeTaoFeaturedCommonUtils.isEmpty(
                    _county,
                  ) ||
                  KeTaoFeaturedCommonUtils.isEmpty(_addressDetailController.value.text)) {
                Fluttertoast.showToast(
                    msg: "请检查填写的信息是否完整！",
                    textColor: Colors.white,
                    backgroundColor: Colors.grey);
                return;
              }
              if (!KeTaoFeaturedCommonUtils.isPhoneLegal(_phoneController.value.text)) {
                KeTaoFeaturedCommonUtils.showSimplePromptDialog(
                    context, "温馨提示", "请输入正确的手机号");
                return;
              }
              if (widget.addressId != null) {
                var result = await HttpManage.modifyShippingAddress(
                  addressId: widget.addressId,
                  consignee: _unameController.value.text,
                  mobile: _phoneController.value.text,
                  address: _addressDetailController.value.text,
                  provinceId: _provinceId,
                  cityId: _cityId,
                  countyId: _countyId,
                  isDefault: _defaultValue ? "1" : "2",
                  /*widget.address.addressId,
                    _unameController.value.text,
                    _phoneController.value.text,
                    _province,
                    _provinceId,
                    _city,
                    _cityId,
                    _county,
                    _countyId,
                    _addressDetailController.value.text,
                    _defaultValue ? "1" : ""*/
                );
                if (result.status) {
                  Fluttertoast.showToast(
                      msg: "地址修改成功！",
                      toastLength: Toast.LENGTH_SHORT,
                      textColor: Colors.white,
                      backgroundColor: Colors.grey);
                  /*Fluttertoast.showToast(
                      msg: "地址修改成功 ！",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);*/
                  Navigator.of(context).pop(true);
                  /*  KeTaoFeaturedNavigatorUtils.navigatorRouterReplaceMent(
                      context,
                      KeTaoFeaturedAddressListPage(
                        type: widget.type,
                      ));*/
                  /*Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (context) {
                    return new KeTaoFeaturedAddressListPage(
                      type: widget.type,
                    );
                  }));
                  Navigator.of(context).pop();*/
                } else {
                  KeTaoFeaturedCommonUtils.showToast("${result.errMsg}");
                }
              } else {
                if (KeTaoFeaturedCommonUtils.isEmpty(
                      _unameController.value.text,
                    ) ||
                    KeTaoFeaturedCommonUtils.isEmpty(
                      _phoneController.value.text,
                    ) ||
                    KeTaoFeaturedCommonUtils.isEmpty(
                      _province,
                    ) ||
                    KeTaoFeaturedCommonUtils.isEmpty(
                      _city,
                    ) ||
                    KeTaoFeaturedCommonUtils.isEmpty(
                      _county,
                    ) ||
                    KeTaoFeaturedCommonUtils.isEmpty(_addressDetailController.value.text)) {
                  Fluttertoast.showToast(
                      msg: "请检查填写的信息是否完整！",
                      textColor: Colors.white,
                      backgroundColor: Colors.grey);
                  return;
                }
                if (!KeTaoFeaturedCommonUtils.isPhoneLegal(_phoneController.value.text)) {
                  KeTaoFeaturedCommonUtils.showSimplePromptDialog(
                      context, "温馨提示", "请输入正确的手机号");
                  return;
                }
                var result = await HttpManage.addShippingAddress(
                  consignee: _unameController.value.text,
                  mobile: _phoneController.value.text,
                  address: _addressDetailController.value.text,
                  provinceId: _provinceId,
                  cityId: _cityId,
                  countyId: _countyId,
                  isDefault: _defaultValue ? "1" : "2",
                );
                if (result.status) {
                  Fluttertoast.showToast(
                      msg: "地址添加成功！",
                      textColor: Colors.white,
                      backgroundColor: Colors.grey);
                  /*  KeTaoFeaturedNavigatorUtils.navigatorRouterReplaceMent(
                      context,
                      KeTaoFeaturedAddressListPage(
                        type: widget.type,
                      ));*/
                  Navigator.of(context).pop(true);
                  /*Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (context) {
                    return new KeTaoFeaturedAddressListPage(
                      type: widget.type,
                    );
                  }));
                  Navigator.of(context).pop();*/
                } else {
                  KeTaoFeaturedCommonUtils.showToast("${result.errMsg}");
                }
              }
            },
          )
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Container(
                height: 50,
                child: TextField(
                  controller: _unameController,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(42),
                  ),
                  decoration: InputDecoration(
                    /* labelText: widget.address.name == null
                          ? ''
                          : widget.address.name,*/
                    border: InputBorder.none,
                    hintText: '收货人',
                    hintStyle: TextStyle(
                      fontSize: ScreenUtil().setSp(42),
                      color: _textGray,
                    ),
                    suffix: KeTaoFeaturedMyOctoImage(
                      image:
                          "https://alipic.lanhuapp.com/xd99452e46-4542-4a53-b6ca-adfdec2bef69",
                      width: ScreenUtil().setWidth(45),
                      height: ScreenUtil().setHeight(48),
                    ),
/*
                    suffix: KeTaoFeaturedMyOctoImage(
                      image:
                          "https://alipic.lanhuapp.com/xd99452e46-4542-4a53-b6ca-adfdec2bef69",
                      width: ScreenUtil().setWidth(45),
                      height: ScreenUtil().setHeight(48),
                    ),
*/
                  ),
                ),
              ),
              Divider(),
              Container(
                height: 50,
                alignment: Alignment.center,
                child: TextField(
                  controller: _phoneController,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(42),
                  ),
                  decoration: InputDecoration(
                      /*  labelText: widget.address.iphone == null
                          ? ''
                          : widget.address.iphone,*/
                      border: InputBorder.none,
                      hintText: '手机号码',
                      hintStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(42),
                        color: _textGray,
                      ),
                      suffix: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            Text(
                              '+86',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(42),
                                color: _textGray,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Icon(
                              CupertinoIcons.forward,
                              color: _textGray,
                              size: ScreenUtil().setSp(42),
                            ),
                            SizedBox(
                              width: 8,
                            )
                          ],
                        ),
                      )),
                ),
              ),
              Divider(),
              Container(
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    _choiceAddressDialog();
                  },
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${KeTaoFeaturedCommonUtils.isEmpty(_province) ? '请选择省市区' : '$_province $_city $_county'}',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(42),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(''),
                        ),
                        Icon(
                          CupertinoIcons.forward,
                          color: _textGray,
                          size: ScreenUtil().setSp(42),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Divider(),
              Container(
                child: TextField(
                  controller: _addressDetailController,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(42),
                  ),
                  decoration: InputDecoration(
                    /*  labelText: widget.address.addressDetail == null
                        ? ''
                        : widget.address.addressDetail,*/
                    border: InputBorder.none,
                    hintText: '详细地址：如道路、门牌号、小区、楼栋号、单元室等',
                    hintStyle: TextStyle(
                      fontSize: ScreenUtil().setSp(42),
                      color: _textGray,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Ink(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _defaultValue = !_defaultValue;
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '设为默认地址',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(42),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Switch(
                          value: _defaultValue,
                          activeTrackColor: Colors.greenAccent[700],
                          activeColor: Colors.white,
                          onChanged: (value) {
                            setState(() {
                              _defaultValue = !_defaultValue;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                child: Ink(
                  child: GestureDetector(
                    onTap: () async {
                      var result = await HttpManage.deleteShippingAddress(
                          widget.addressId);
                      if (result.status) {
                        Fluttertoast.showToast(
                            msg: "地址删除成功！",
                            textColor: Colors.white,
                            backgroundColor: Colors.grey);
                        /*KeTaoFeaturedNavigatorUtils.navigatorRouterReplaceMent(
                            context,
                            KeTaoFeaturedAddressListPage(
                              type: 1,
                            ));*/
                        Navigator.of(context).pop(true);
                        /* Navigator.of(context)
                            .push(new MaterialPageRoute(builder: (context) {
                          return new KeTaoFeaturedAddressListPage(
                            type: 1,
                          );
                        }));*/
//                Navigator.of(context).pop();
                      } else {
                        Fluttertoast.showToast(
                            msg: "地址删除失败！",
                            textColor: Colors.white,
                            backgroundColor: Colors.grey);
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          '删除收货地址',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(42),
                            color: Color(0xffF93736),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                visible: widget.addressId != null,
              )
            ],
          )),
    );
  }

  void _choiceAddressDialog() async {
    print('======');
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return KeTaoFeaturedJDAddressDialog(
              onSelected:
                  (province, city, county, provinceId, cityId, countyId) async {
                var address =
                    '$province-$city-$county-$provinceId-$cityId-$countyId';

                setState(() {
                  _province = province;
                  _provinceId = provinceId;
                  _city = city;
                  _cityId = cityId;
                  _county = county;
                  _countyId = countyId;
                });
              },
              title: '选择地址',
              selectedColor: Colors.red,
              unselectedColor: Colors.black);
        });
  }
}
