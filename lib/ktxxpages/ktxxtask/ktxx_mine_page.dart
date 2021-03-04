import 'package:flutter/material.dart';
import 'package:star/ktxxmodels/ktxx_user_info_entity.dart';
import 'package:star/ktxxutils/ktxx_common_utils.dart';
import 'package:star/ktxxhttp/ktxx_http_manage.dart';
import '../../ktxx_global_config.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_mine.dart';
import 'package:star/ktxxpages/ktxxshareholders/ktxx_micro_mine.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedMinePagePage extends StatefulWidget {
  KeTaoFeaturedMinePagePage({Key key}) : super(key: key);
  final String title = "";
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

  @override
  _KeTaoFeaturedMinePagePageState createState() =>
      _KeTaoFeaturedMinePagePageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _KeTaoFeaturedMinePagePageState extends State<KeTaoFeaturedMinePagePage> {
  UserInfoData userInfoData;
  Widget rootView;
  int SVG_ANGLETYPE_DEG = 2;
  int SVG_ANGLETYPE_GRAD = 4;
  int SVG_ANGLETYPE_RAD = 3;
  int SVG_ANGLETYPE_UNKNOWN = 0;
  int SVG_ANGLETYPE_UNSPECIFIED = 1;

  ///  微股东等级
  ///
  ///  1 见习股东
  ///
  ///  2 不是微股东
  ///
  ///  3 vip股东
  ///
  ///  4 高级股东
  String _shareholderType = '';

  _initData() async {
    try {
      userInfoData = KeTaoFeaturedGlobalConfig.getUserInfo();
      if (!KeTaoFeaturedCommonUtils.isEmpty(userInfoData.isPartner)) {
        setState(() {
          _shareholderType = userInfoData.isPartner;
          /*var title = '';
          title = _shareholderType == '1'
              ? '见习股东'
              : _shareholderType == '3'
                  ? 'VIP股东'
                  : '高级股东';
          if (_shareholderType == '2') {
            rootView = TaskMinePage();
          } else {
            rootView = MicroMinePage(
              title: title,
            );
          }*/
        });
      }
    } catch (e) {}
    var result = await KeTaoFeaturedHttpManage.getUserInfo();
    if (result.status) {
      setState(() {
        _shareholderType = result.data.isPartner;
      });
    } else {
      if (KeTaoFeaturedCommonUtils.isEmpty(userInfoData.isPartner)) {
        var result = await KeTaoFeaturedHttpManage.getUserInfo();
        if (result.status) {
          if (mounted) {
            setState(() {
              _shareholderType = result.data.isPartner;
              var title = '';
              title = _shareholderType == '1'
                  ? '见习股东'
                  : _shareholderType == '3'
                      ? 'VIP股东'
                      : '高级股东';
              if (_shareholderType == '2') {
                rootView = KeTaoFeaturedTaskMinePage();
              } else {
                rootView = KeTaoFeaturedMicroMinePage();
              }
            });
          }
        } else {}
      }
    }
  }

  @override
  void initState() {
    super.initState();
    userInfoData = KeTaoFeaturedGlobalConfig.getUserInfo();
//    _initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var title = '个人中心';
    rootView = KeTaoFeaturedMicroMinePage(
//      title: title,
        );
    return rootView;
  }
}
