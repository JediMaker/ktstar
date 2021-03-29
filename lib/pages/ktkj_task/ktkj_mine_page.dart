import 'package:flutter/material.dart';
import 'package:star/global_config.dart';
import 'package:star/models/user_info_entity.dart';
import 'package:star/utils/ktkj_common_utils.dart';
import 'package:star/http/ktkj_http_manage.dart';
import 'package:star/pages/ktkj_task/ktkj_task_mine.dart';
import 'package:star/pages/ktkj_shareholders/ktkj_micro_mine.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJMinePagePage extends StatefulWidget {
  KTKJMinePagePage({Key key}) : super(key: key);
  final String title = "";

  @override
  _MinePagePageState createState() => _MinePagePageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _MinePagePageState extends State<KTKJMinePagePage> {
  UserInfoData userInfoData;
  Widget rootView;

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
      userInfoData = KTKJGlobalConfig.getUserInfo();
      if (!KTKJCommonUtils.isEmpty(userInfoData.isPartner)) {
        setState(() {
          _shareholderType = userInfoData.isPartner;
          /*var title = '';
          title = _shareholderType == '1'
              ? '见习股东'
              : _shareholderType == '3'
                  ? 'VIP股东'
                  : '高级股东';
          if (_shareholderType == '2') {
            rootView = KTKJTaskMinePage();
          } else {
            rootView = KTKJMicroMinePage(
              title: title,
            );
          }*/
        });
      }
    } catch (e) {}
    var result = await HttpManage.getUserInfo();
    if (result.status) {
      setState(() {
        _shareholderType = result.data.isPartner;
      });
    } else {
      if (KTKJCommonUtils.isEmpty(userInfoData.isPartner)) {
        var result = await HttpManage.getUserInfo();
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
                rootView = KTKJTaskMinePage();
              } else {
                rootView = KTKJMicroMinePage();
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
    userInfoData = KTKJGlobalConfig.getUserInfo();
//    _initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var title = '我的';
    rootView = KTKJMicroMinePage(
//      title: title,
        );
    return rootView;
  }
}
