import 'package:flutter/material.dart';
import 'package:star/models/user_info_entity.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/http/http_manage.dart';
import '../../global_config.dart';
import 'package:star/pages/task/task_mine.dart';
import 'package:star/pages/shareholders/micro_mine.dart';

class KeTaoFeaturedMinePagePage extends StatefulWidget {
  KeTaoFeaturedMinePagePage({Key key}) : super(key: key);
  final String title = "";

  @override
  _MinePagePageState createState() => _MinePagePageState();
}

class _MinePagePageState extends State<KeTaoFeaturedMinePagePage> {
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
            rootView = KeTaoFeaturedTaskMinePage();
          } else {
            rootView = KeTaoFeaturedMicroMinePage(
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
      if (KeTaoFeaturedCommonUtils.isEmpty(userInfoData.isPartner)) {
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
                rootView = KeTaoFeaturedTaskMinePage();
              } else {
                rootView = KeTaoFeaturedMicroMinePage(
                );
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
    var title = '我的';
    rootView = KeTaoFeaturedMicroMinePage(
//      title: title,
    );
    return rootView;
  }
}
