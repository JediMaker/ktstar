import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:star/ktxxhttp/ktxx_http_manage.dart';
import 'package:star/ktxxutils/ktxx_common_utils.dart';
import 'package:star/ktxxutils/ktxx_navigator_utils.dart';

import '../../ktxx_global_config.dart';
import 'ktxx_my_adress_edit.dart';
import 'package:star/ktxxmodels/ktxx_address_list_entity.dart';

///
/// 地址列表
///
///
///
///
///
/// // Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
//// for details. All rights reserved. Use of this source code is governed by a
//// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedAddressListPage extends StatefulWidget {
  int type; //0、订单选择地址  1、地址编辑修改  2退换货地址修改
  String orderId;
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;
  KeTaoFeaturedAddressListPage({
    @required this.type = 1,
    this.orderId,
    Key key,
  }) : super(key: key);

  @override
  _KeTaoFeaturedAddressListPageState createState() =>
      _KeTaoFeaturedAddressListPageState();
}

//  return Column(
//  mainAxisSize: MainAxisSize.min,
//  children: <Widget>[
//  Stack(
//  overflow: Overflow.visible,
//  children: <Widget>[
//  GestureDetector(
//  onTap: () {
//  if (catg.name == listProfileCategories[0].name)
//  Navigator.pushNamed(context, '/furniture');
//  },
//  child: Container(
//  padding: EdgeInsets.all(10.0),
//  decoration: BoxDecoration(
//  shape: BoxShape.circle,
//  color: profile_info_categories_background,
//  ),
//  child: Icon(
//  catg.icon,
//  // size: 20.0,
//  ),
//  ),
//  ),
//  catg.number > 0
//  ? Positioned(
//  right: -5.0,
//  child: Container(
//  padding: EdgeInsets.all(5.0),
//  decoration: BoxDecoration(
//  color: profile_info_background,
//  shape: BoxShape.circle,
//  ),
//  child: Text(
//  catg.number.toString(),
//  style: TextStyle(
//  color: Colors.white,
//  fontSize: 10.0,
//  ),
//  ),
//  ),
//  )
//      : SizedBox(),
//  ],
//  ),
//  SizedBox(
//  height: 10.0,
//  ),
//  Text(
//  catg.name,
//  style: TextStyle(
//  fontSize: 13.0,
//  ),
//  )
//  ],
//  );
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _KeTaoFeaturedAddressListPageState
    extends State<KeTaoFeaturedAddressListPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  List<AddressListData> addresses;
  String defaultAddressId;
  bool needRefresh = false;

  Future _initData() async {
    //    AddressBeanEntity resultData = await HttpManage.getListOfAddresses();
    var resultData = await KeTaoFeaturedHttpManage.getListOfAddresses();
    if (mounted) {
      setState(() {
        if (resultData.status) {
//          defaultAddressId = resultData.data.defaultAddressId;
          addresses = resultData.data;
        }
      });
    }
  }

  Widget _buildListTile(BuildContext context, AddressListData item) {
    var avatarName = '';
    var name = '';
    var phone = '';
    var province = '';
    var city = '';
    var county = '';
    var addressDetail = '';
    var statusDesc = "默认";
    var isDefault = "";
    var itemId;
    var bgColor = Color(0xffFFC4C4);
    var txtColor = Color(0xffF93736);
    try {
      avatarName = item.consignee == null ? '' : item.consignee.substring(0, 1);
      name = item.consignee;
      phone = item.mobile;
      addressDetail = item.address;
      isDefault = item.isDefault;
      itemId = item.id;
    } catch (e) {
      print(e);
    }
    return MergeSemantics(
      child: ListTile(
        isThreeLine: true,
        dense: false,
        onTap: () async {
          if (widget.type == 0) {
            var result = await KeTaoFeaturedHttpManage.orderChangeBindAddress(
                widget.orderId, itemId);
            if (result.status) {
              Navigator.of(context).pop(true);
            } else {
              KeTaoFeaturedCommonUtils.showToast("${result.errMsg}");
            }
          } else if (widget.type == 2) {
            // todo
            /* var result =
                await HttpManage.returnChangeBindAddress( itemId);
            if (result.status) {
              Navigator.of(context).pop(true);
            } else {
              CommonUtils.showToast("${result.errMsg}");
            }*/
          } else {
            bool result = await KeTaoFeaturedNavigatorUtils.navigatorRouter(
                context,
                KeTaoFeaturedAddressDetailPage(
                    type: widget.type,
                    addressId: itemId,
                    defaultAddressId: defaultAddressId));
            if (result) {
              _initData();
              if (mounted) {
                setState(() {
                  needRefresh = true;
                });
              }
            }

            /*Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return new AddressDetailPage(
                  type: widget.type,
                  address: item,
                  defaultAddressId: defaultAddressId);
            }));
            Navigator.of(context).pop();*/
          }
        },
        /* leading: ExcludeSemantics(
            child: CircleAvatar(
                backgroundColor: Colors.black26,
                foregroundColor: Colors.white,
                child: Text(avatarName))),*/
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              '$name',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(48),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              '$phone',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(48),
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Text.rich(
                TextSpan(children: [
                  WidgetSpan(
                    //状态：
                    child: Visibility(
                      visible: isDefault == "1",
                      child: Container(
                        child: Container(
                          width: ScreenUtil().setWidth(90),
                          height: ScreenUtil().setHeight(48),
                          margin: EdgeInsets.only(
                            bottom: ScreenUtil().setHeight(6),
                            right: ScreenUtil().setWidth(20),
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: bgColor,
                          ),
                          child: Text(
                            //状态：
                            statusDesc,
                            style: TextStyle(
                              color: txtColor,
                              fontSize: ScreenUtil().setSp(32),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextSpan(
                    text: '$addressDetail',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(42),
                        color: Color(0xff222222)),
                  ),
                ]),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        trailing: Container(
          child: GestureDetector(
            onTap: () async {
              bool result = await KeTaoFeaturedNavigatorUtils.navigatorRouter(
                  context,
                  KeTaoFeaturedAddressDetailPage(
                      type: widget.type,
                      addressId: itemId,
                      defaultAddressId: defaultAddressId));
              if (result) {
                _initData();
                if (mounted) {
                  setState(() {
                    needRefresh = true;
                  });
                }
              }

              /*Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (context) {
                return new AddressDetailPage(
                    type: widget.type,
                    address: item,
                    defaultAddressId: defaultAddressId);
              }));*/
            },
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '|    编辑',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(42),
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _initData();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '我的收货地址',
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
            Navigator.of(context).pop(needRefresh);
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
                    '添加新地址',
                    style: TextStyle(
                      color: Color(0xFF222222),
                      fontSize: ScreenUtil().setSp(42),
                    ),
                  ),
                )),
            onTap: () async {
              bool result = await KeTaoFeaturedNavigatorUtils.navigatorRouter(
                  context,
                  KeTaoFeaturedAddressDetailPage(
                      type: widget.type,
//                        address: AddressBeanDataAddress(),
                      addressId: null,
                      title: '添加收货地址',
                      defaultAddressId: null));
              if (result) {
                _initData();
              }

              /*Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (context) {
                return new AddressDetailPage(
                    type: widget.type,
                    address: AddressBeanDataAddress(),
                    defaultAddressId: null);
              }));*/
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 8),
        child: ListView.builder(
          itemBuilder: ((BuildContext context, int index) {
            AddressListData item;
            try {
              item = addresses[index];
            } catch (e) {}
            return _buildListTile(context, item);
          }),
          itemCount:
              addresses == null || addresses.length == 0 ? 0 : addresses.length,
        ),
      ),
    );
  }
}
