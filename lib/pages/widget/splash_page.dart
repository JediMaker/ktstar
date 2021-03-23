import 'package:star/pages/widget/my_octoimage.dart';
import 'package:flutter/material.dart';
import 'package:star/pages/task/task_index.dart';
import 'package:star/utils/navigator_utils.dart';

class KeTaoFeaturedSplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<KeTaoFeaturedSplashPage> {
  @override
  void initState() {
    super.initState();

    /// 延时跳转
    Future.delayed(Duration(seconds: 3), _toAppPage);
  }

  _toAppPage() {
    KeTaoFeaturedNavigatorUtils.navigatorRouterAndRemoveUntil(
        context, KeTaoFeaturedTaskIndexPage());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      /*child: KeTaoFeaturedMyOctoImage(
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
