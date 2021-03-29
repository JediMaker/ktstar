import 'package:star/pages/ktkj_widget/ktkj_my_octoimage.dart';
import 'package:flutter/material.dart';
import 'package:star/pages/ktkj_task/ktkj_task_index.dart';
import 'package:star/utils/ktkj_navigator_utils.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJSplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _SplashPageState extends State<KTKJSplashPage> {
  @override
  void initState() {
    super.initState();

    /// 延时跳转
    Future.delayed(Duration(seconds: 3), _toAppPage);
  }

  _toAppPage() {
    KTKJNavigatorUtils.navigatorRouterAndRemoveUntil(
        context, KTKJTaskIndexPage());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      /*child: KTKJMyOctoImage(
        image:
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
