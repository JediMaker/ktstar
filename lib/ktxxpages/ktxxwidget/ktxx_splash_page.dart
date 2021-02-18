import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:star/ktxxpages/ktxxtask/ktxx_task_index.dart';
import 'package:star/ktxxutils/ktxx_navigator_utils.dart';

class KeTaoFeaturedSplashPage extends StatefulWidget {
  @override
  _KeTaoFeaturedSplashPageState createState() => _KeTaoFeaturedSplashPageState();
}

class _KeTaoFeaturedSplashPageState extends State<KeTaoFeaturedSplashPage> {
  @override
  void initState() {
    super.initState();

    /// 延时跳转
    Future.delayed(Duration(seconds: 3), _toAppPage);
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
