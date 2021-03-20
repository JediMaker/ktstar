import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:star/generated/json/home_goods_list_entity_helper.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/home_goods_list_entity.dart';
import 'package:star/pages/goods/goods_detail.dart';
import 'package:star/pages/widget/PriceText.dart';
import 'package:star/pages/widget/my_octoimage.dart';
import 'package:star/pages/widget/no_data.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class NewcomersGoodsListPage extends StatefulWidget {
  NewcomersGoodsListPage({Key key}) : super(key: key);
  final String title = "新人专享";

  @override
  _NewcomersGoodsListPageState createState() => _NewcomersGoodsListPageState();
}

class _NewcomersGoodsListPageState extends State<NewcomersGoodsListPage>
    with AutomaticKeepAliveClientMixin {
  int page = 1;
  EasyRefreshController _refreshController;
  bool isFirstLoading = true;
  List<HomeGoodsListGoodsList> goodsList = List<HomeGoodsListGoodsList>();

  _initData() async {
    var result = await HttpManage.getGoodsList(
        type: "new", page: page, pageSize: 20, firstId: '');
    if (result.status) {
      HomeGoodsListEntity entity = HomeGoodsListEntity();
      homeGoodsListEntityFromJson(entity, result.data);
      if (mounted) {
        setState(() {
          if (page == 1) {
            goodsList = entity.goodsList;
            _refreshController.finishLoad(noMore: false);
          } else {
            if (result == null ||
                result.data == null ||
                entity.goodsList == null ||
                entity.goodsList.length == 0) {
              //              _refreshController.resetLoadState();
              _refreshController.finishLoad(noMore: true);
            } else {
              goodsList += entity.goodsList;
            }
          }
          isFirstLoading = false;
        });
      }
    } else {
      CommonUtils.showToast(result.errMsg);
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController();
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  var bgTitleColor = Color(0xffFF4F69);
  var bgContentColor = Color(0xffF02341);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text(
          widget.title,
          style:
              TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(54)),
        ),
        leading: Visibility(
          child: IconButton(
            icon: Container(
              width: ScreenUtil().setWidth(63),
              height: ScreenUtil().setHeight(63),
              child: Center(
                child: Image.asset(
                  "static/images/icon_ios_back_white.png",
                  width: ScreenUtil().setWidth(36),
                  height: ScreenUtil().setHeight(63),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        centerTitle: true,
        brightness: Brightness.dark,
        gradient: LinearGradient(colors: [
          bgTitleColor,
          bgTitleColor,
        ]),
        elevation: 0,
      ),
      body:
          buildEasyRefresh(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  EasyRefresh buildEasyRefresh() {
    return EasyRefresh.custom(
      topBouncing: false,
      bottomBouncing: false,
      header: MaterialHeader(),
      footer: CustomFooter(
//          triggerDistance: ScreenUtil().setWidth(180),
          completeDuration: Duration(seconds: 1),
          footerBuilder: (context,
              loadState,
              pulledExtent,
              loadTriggerPullDistance,
              loadIndicatorExtent,
              axisDirection,
              float,
              completeDuration,
              enableInfiniteLoad,
              success,
              noMore) {
            return Stack(
              children: <Widget>[
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Visibility(
                    visible: noMore,
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: ScreenUtil().setWidth(30),
                          bottom: ScreenUtil().setWidth(30),
                        ),
                        child: Text(
                          "~我是有底线的~",
                          style: TextStyle(
                            color: Color(0xff666666),
                            fontSize: ScreenUtil().setSp(32),
                          ),
                        ),
                      ),
                    ),
                  ),
//                  child: Container(
//                    width: 30.0,
//                    height: 30.0,
//                    /* child: SpinKitCircle(
//                            color: GlobalConfig.colorPrimary,
//                            size: 30.0,
//                          ),*/
//                  ),
                ),
              ],
            );
          }),
      enableControlFinishLoad: true,
      enableControlFinishRefresh: true,
      controller: _refreshController,
      onRefresh: () {
        page = 1;
        _initData();
        _refreshController.finishLoad(noMore: false);
      },
      onLoad: () {
        if (!isFirstLoading) {
          page++;
          _initData();
        }
      },
      emptyWidget:
          goodsList == null || goodsList.length == 0 ? NoDataPage() : null,
      slivers: <Widget>[buildCenter()],
    );
  }

  Widget buildCenter() {
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          color: bgContentColor,
          child: Column(
            children: [
              MyOctoImage(
                image:
                    "https://alipic.lanhuapp.com/xd7aa56361-a9bf-46d9-b2f6-8eba2b6848ee",
                fit: BoxFit.fill,
                width: ScreenUtil().setWidth(1127),
                height: ScreenUtil().setWidth(634),
//                                color: Color(0xffce0100),
              ),
              Container(
                width: double.maxFinite,
                color: bgContentColor,
                constraints: BoxConstraints(
                  minHeight: ScreenUtil().setWidth(1527),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(30),
                ),
//          height: double.infinity,
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setWidth(30),
                        ),
                        child: Text(
                          "所有专区商品奖励20%的分红体验金，体验股东身份，消费就是赚钱",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(30),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    new StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
                      itemCount: goodsList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        HomeGoodsListGoodsList item;
                        try {
                          item = goodsList[index];
                        } catch (e) {}
                        return productItem(item: item);
                      },
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                      mainAxisSpacing: ScreenUtil().setWidth(30),
                      crossAxisSpacing: ScreenUtil().setWidth(30),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  var _priceColor = const Color(0xffe31735);

  Widget productItem({HomeGoodsListGoodsList item}) {
    String id = '';
    String goodsName = '';
    String goodsImg = '';
    String originalPrice = '';
    String salePrice = '';
    double topMargin = 0;
    String profit = '分红金￥0';
    try {
      id = item.id;
      goodsName = item.goodsName;
      goodsImg = item.goodsImg;
      originalPrice = item.originalPrice;
      salePrice = item.salePrice;
      profit = '分红金￥${(item.btPrice)}';
      /*  if (goodsName.length < 8) {
        topMargin = ScreenUtil().setHeight(70);
      } else {
        topMargin = ScreenUtil().setHeight(10);
      }*/
    } catch (e) {}

    return GestureDetector(
      onTap: () {
//        launchWeChatMiniProgram(username: "gh_8ae370170974");
        NavigatorUtils.navigatorRouter(
            context,
            GoodsDetailPage(
              productId: id,
            ));
      },
      child: Container(
//            color: Colors.blue ,商学院
          width: ScreenUtil().setWidth(523),
//          margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
          /*constraints: BoxConstraints(
            minHeight: ScreenUtil().setHeight(560),
          ),*/
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
          ),
          child: Padding(
//                  padding: const EdgeInsets.only(left: 4,right: 4,top: 4,bottom: 4),
            padding: const EdgeInsets.all(0),
//            child: InkWell(
//              splashColor: Colors.yellow,

//        onDoubleTap: () => showSnackBar(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
//                        fit: StackFit.expand,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(30)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(ScreenUtil().setWidth(30)),
                      topLeft: Radius.circular(ScreenUtil().setWidth(30)),
                    ),
                    child: MyOctoImage(
                      fadeInDuration: Duration(milliseconds: 0),
                      fadeOutDuration: Duration(milliseconds: 0),
                      height: ScreenUtil().setWidth(523),
                      width: ScreenUtil().setWidth(523),
                      fit: BoxFit.fill,
                      image: "$goodsImg",
                    ),
                  ),
                ),

//                          SizedBox(
//                            height: 10,
//                          ),
                Container(
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20),
                    right: ScreenUtil().setWidth(20),
                    top: ScreenUtil().setHeight(16),
                  ),
                  child: Text(
                    "$goodsName",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(38),
                      color: Color(0xff222222),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(8),
                    right: ScreenUtil().setWidth(8),
                    top: ScreenUtil().setWidth(8),
                    bottom: ScreenUtil().setWidth(8),
                  ),
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20),
                    right: ScreenUtil().setWidth(20),
                    top: ScreenUtil().setWidth(8),
                    bottom: ScreenUtil().setWidth(8),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffFFDDDC),
                    borderRadius: BorderRadius.circular(
                      ScreenUtil().setWidth(10),
                    ),
                  ),
                  child: Text(
                    "$profit",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      color: Color(0xffF93736),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: topMargin),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 5,
                      ),
                      PriceText(
                        text: '$salePrice',
                        textColor: _priceColor,
                        fontSize: ScreenUtil().setSp(32),
                        fontBigSize: ScreenUtil().setSp(42),
//                          '27.5',
                        /*style: TextStyle(
                          fontSize: ScreenUtil().setSp(42),
                          color: _priceColor,
                          fontWeight: FontWeight.bold,
                        ),*/
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(20),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: ScreenUtil().setHeight(0)),
                          child: Visibility(
                            visible: salePrice != originalPrice,
                            child: Text(
                              "￥$originalPrice",
                              overflow: TextOverflow.ellipsis,
//                            '${0}人评价',
//                            '23234人评价',
//                          product
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: ScreenUtil().setSp(32),
                                  color: Color(0xFF979896)),
                            ),
                          ),
                        ),
                      ),
                      /* Icon(
                          Icons.more_horiz,
                          size: 15,
                          color: Color(0xFF979896),
                        ),*/
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                )
//                          descStack(product),
//                          ratingStack(product.rating),
//                          Container( child: imageStack(product.image),),
              ],
            ),
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
