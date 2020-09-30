import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:star/utils/utils.dart';

import '../../global_config.dart';

class InvitationPosterPage extends StatefulWidget {
  InvitationPosterPage({Key key}) : super(key: key);
  final String title = "邀请好友";

  @override
  _InvitationPosterPageState createState() => _InvitationPosterPageState();
}

class _InvitationPosterPageState extends State<InvitationPosterPage> {
  var bannerList = [
    "https://alipic.lanhuapp.com/xd3fcd5d5d-1a92-4581-9108-d0e37df3b07a",
    "https://alipic.lanhuapp.com/xdd1598cdc-57cf-42c2-a5e6-5fc63407c9eb",
    "https://alipic.lanhuapp.com/xd1bf21073-256d-4846-afa3-bb61fd0b9aae",
  ];
  var bannerIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.title,
              style: TextStyle(
                  color: Color(0xFF222222), fontSize: ScreenUtil().setSp(54)),
            ),
            brightness: Brightness.dark,
            leading: IconButton(
              icon: Image.asset(
                "static/images/icon_ios_back.png",
                width: ScreenUtil().setWidth(36),
                height: ScreenUtil().setHeight(63),
                fit: BoxFit.fill,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            centerTitle: true,
            backgroundColor: GlobalConfig.taskNomalHeadColor,
            elevation: 0,
          ),
          body: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: ScreenUtil().setWidth(927),
                  child: Image.asset(
                    "static/images/invite_bg_bottom.png",
                    height: ScreenUtil().setWidth(927),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setWidth(32),
                ),
                child: Column(
                  children: <Widget>[
                    Flexible(
                        fit: FlexFit.tight, flex: 9, child: buildBannerLayout()),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 2,
                      child: Container(
                        alignment: Alignment.center,
                        child: Container(
                          width: ScreenUtil().setWidth(793),
                          height: ScreenUtil().setHeight(126),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                                Radius.circular(ScreenUtil().setWidth(30))),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(
                                          "static/images/icon_share.png",
                                          width: ScreenUtil().setWidth(45),
                                          height: ScreenUtil().setWidth(45),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(26),
                                        ),
                                        Text(
                                          "分享链接",
                                          style: TextStyle(
//                                          color: Color(0xFFF93736),
                                            fontSize: ScreenUtil().setSp(42),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 1,
//                              color: Colors.red,
                                margin: EdgeInsets.symmetric(
                                    vertical: ScreenUtil().setHeight(30)),
                                color: Color(0xFFd1d1d1),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(
                                          "static/images/icon_download.png",
                                          width: ScreenUtil().setWidth(46),
                                          height: ScreenUtil().setHeight(43),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(26),
                                        ),
                                        Text(
                                          "保存图片",
                                          style: TextStyle(
//                                        color: Colors.white,
                                            fontSize: ScreenUtil().setSp(42),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ) // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }

  Widget buildBannerLayout() {
    return Container(
      height: ScreenUtil().setHeight(623),
      width: double.maxFinite,
//      width: ScreenUtil().setWidth(1125),
      /*  decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),*/
      child: Swiper(
        itemCount: bannerList == null ? 0 : bannerList.length,
//        key: GlobalKey(),
        /*itemWidth: ScreenUtil().setWidth(1125),
        itemHeight: ScreenUtil().setHeight(623),
        transformer: ScaleAndFadeTransformer(scale: 0, fade: 0),*/
        //bannerList == null ? 0 : bannerList.length,
        autoplay: false,
        viewportFraction: 0.75,
        scale: 0.9,
//          indicatorLayout: PageIndicatorLayout.COLOR,
        onIndexChanged: (index) {
          if (mounted) {
            setState(() {
              bannerIndex = index;
            });
          }
        },
        /*pagination: SwiperPagination(
            builder: DotSwiperPaginationBuilder(
                //自定义指示器颜色
                color: Colors.white,
                size: 8.0,
                activeColor: GlobalConfig.taskHeadColor,
                activeSize: 10.0)),*/
        itemBuilder: (context, index) {
          var bannerData = bannerList[index];
          return GestureDetector(
            onTap: () {},
            child: ClipRRect(
              borderRadius:
                  BorderRadius.all(Radius.circular(ScreenUtil().setWidth(30))),
              child: CachedNetworkImage(
                imageUrl: bannerData,
                height: ScreenUtil().setHeight(623),
//              width: ScreenUtil().setWidth(1125),
                fit: BoxFit.fill,
              ),
            ),
          );
        },
      ),
    );
  }
}
