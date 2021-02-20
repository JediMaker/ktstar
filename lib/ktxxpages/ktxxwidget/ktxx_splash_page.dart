import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_index.dart';
import 'package:star/ktxxutils/ktxx_navigator_utils.dart';
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KeTaoFeaturedSplashPage extends StatefulWidget {
  @override
  _KeTaoFeaturedSplashPageState createState() => _KeTaoFeaturedSplashPageState();
}
// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _KeTaoFeaturedSplashPageState extends State<KeTaoFeaturedSplashPage> {
  @override
  void initState() {
    super.initState();
    int SVG_ANGLETYPE_DEG = 2;
    int SVG_ANGLETYPE_GRAD = 4;
    int SVG_ANGLETYPE_RAD = 3;
    int SVG_ANGLETYPE_UNKNOWN = 0;
    int SVG_ANGLETYPE_UNSPECIFIED = 1;
    /// 延时跳转
    Future.delayed(Duration(seconds: 3), _toAppPage);
//    GestureDetector(
//      onTap: (){},
//      child: Container(
//        padding: EdgeInsets.all(8.0),
//        decoration: BoxDecoration(
//            color: profile_info_background,
//            borderRadius: BorderRadius.circular(10.0)),
//        child: Icon(
//          icon,
//          size: 20.0,
//          color: Colors.white,
//        ),
//      ),
//    )
  }

  _toAppPage() {
    KeTaoFeaturedNavigatorUtils.navigatorRouterAndRemoveUntil(context, KeTaoFeaturedTaskIndexPage());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      /*child: CachedNetworkImage(
        imageUrl:
            "https://alipic.lanhuapp.com/xd69c17e55-d263-4281-9dbe-4b10a7079813",
        fit: BoxFit.fill,
      ),*/

      child: Image.asset(
        'static/images/launch_image.png',
        fit: BoxFit.fill,
      ),
    );
  }
}
