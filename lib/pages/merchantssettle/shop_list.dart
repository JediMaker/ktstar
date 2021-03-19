import 'package:star/pages/widget/my_octoimage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:star/generated/json/home_goods_list_entity_helper.dart';
import 'package:star/global_config.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/home_goods_list_entity.dart';
import 'package:star/models/shop_list_entity.dart';
import 'package:star/models/user_info_entity.dart';
import 'package:star/pages/merchantssettle/apply_settle.dart';
import 'package:star/pages/merchantssettle/shop_backstage.dart';
import 'package:star/pages/merchantssettle/shop_deatil.dart';
import 'package:star/pages/merchantssettle/shop_payment.dart';
import 'package:star/pages/widget/no_data.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:gradient_app_bar/gradient_app_bar.dart';

class ShopListPage extends StatefulWidget {
  ShopListPage({Key key}) : super(key: key);
  final String title = "";
  String categoryId;
  String type;

  @override
  _ShopListPageState createState() => _ShopListPageState();
}

class _ShopListPageState extends State<ShopListPage>
    with AutomaticKeepAliveClientMixin {
  //搜索框文字控制器
  TextEditingController _searchController = TextEditingController();

  //搜索框焦点控制器
  var _searchFocusNode = FocusNode();
  int page = 1;
  EasyRefreshController _refreshController;
  bool isFirstLoading = true;
  List<ShopListDataList> shopList = List<ShopListDataList>();

  UserInfoData userInfoData;

  ///商家入驻申请状态
  ///0 未申请
  ///1 审核中
  ///2 通过
  ///3 拒绝
  var applyStatus = '';
  var _btnTxt = '立即加入';
  var _rejectMsg = '';
  var _shopId = '';

  var _shopName = '';
  var _latitude = '';
  var _longitude = '';
  var _cityName = '';

  var _emptyWidget;

  _initData() async {
    await GlobalConfig.initUserLocationWithPermission(count: 0);
    if (mounted) {
      setState(() {
        _latitude = GlobalConfig.prefs.getString("latitude");
        _longitude = GlobalConfig.prefs.getString("longitude");
        _cityName = GlobalConfig.prefs.getString("cityName");
      });
    }
    var result = await HttpManage.getShopList(
        latitude: _latitude,
        longitude: _longitude,
        page: page,
        pageSize: 20,
        shopCity: _cityName,
        storeName: _shopName);
    if (result.status) {
      if (mounted) {
        setState(() {
          if (page == 1) {
            shopList = result.data.xList;
            _refreshController.finishLoad(noMore: false);
          } else {
            if (result == null ||
                result.data == null ||
                result.data.xList == null ||
                result.data.xList.length == 0) {
              //              _refreshController.resetLoadState();
              _refreshController.finishLoad(noMore: true);
            } else {
              shopList += result.data.xList;
            }
          }
          isFirstLoading = false;
          _emptyWidget = buildEmptyWidget();
        });
      }
    } else {
      CommonUtils.showToast(result.errMsg);
    }
  }

  Future initUserInfoData() async {
    userInfoData = GlobalConfig.getUserInfo();
    if (CommonUtils.isEmpty(userInfoData)) {
      var result = await HttpManage.getUserInfo();
      if (result.status) {
        if (mounted) {
          setState(() {
            _shopId = userInfoData.storeId;
            _rejectMsg = userInfoData.storeRejectMsg;
            applyStatus = userInfoData.storeStatus;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _shopId = userInfoData.storeId;
          _rejectMsg = userInfoData.storeRejectMsg;
          applyStatus = userInfoData.storeStatus;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController();
//    _refreshController.finishLoad(noMore: true);

//    initUserInfoData();
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(
          title: buildSearch(),
          titleSpacing: 0,
          elevation: 0,
          brightness: Brightness.light,
          gradient: LinearGradient(colors: [
            Color(0xfff6f6f6),
            Color(0xfff6f6f6),
          ]),
        ),
        body: Container(
            color: Color(0xfff6f6f6),
            child:
                buildEasyRefresh()) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  ///扫一扫
  scan() async {
    /// 调用扫一扫
    var shopId;
    var _balance;
    var _hasPayPassword;
    var _shopName;
    var _shopCode;

    /// 调用扫一扫
    String cameraScanResult = await scanner.scan();
    print("cameraScanResult=$cameraScanResult");
    var scanResult =
        await HttpManage.getScanResultRemote(qrCodeResult: cameraScanResult);
    if (scanResult.status) {
      shopId = scanResult.data.storeId;
      _shopName = scanResult.data.name;
      _shopCode = scanResult.data.code;
    } else {
      CommonUtils.showToast("${scanResult.errMsg}");
      return;
    }
    //  获取店铺支付相关信息
    var entityResult = await HttpManage.getShopPayInfo(storeId: shopId);
    if (entityResult.status) {
      _balance = entityResult.data.user.price;
      _hasPayPassword = entityResult.data.user.payPwdFlag;
      _shopName = entityResult.data.store.storeName;
      _shopCode = entityResult.data.store.storeCode;
    }

    ///进入支付页面
    NavigatorUtils.navigatorRouter(
        context,
        ShopPaymentPage(
          shopId: shopId,
          shopName: _shopName,
          shopCode: _shopCode,
          balance: _balance,
          hasPayPassword: _hasPayPassword,
        ));

    ///
  }

  Widget buildSearch() {
    return Container(
      height: ScreenUtil().setWidth(160),
      color: Color(0xfff6f6f6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Container(
              width: ScreenUtil().setWidth(78),
              height: ScreenUtil().setWidth(78),
              child: Center(
                child: MyOctoImage(
                  image:
                      "https://alipic.lanhuapp.com/xdd9cb322b-189a-465b-a3f4-a28cb52ce22c",
                  width: ScreenUtil().setWidth(78),
                  height: ScreenUtil().setWidth(78),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            onPressed: () async {
              CommonUtils.requestPermission(Permission.camera, scan());
            },
          ),
          Expanded(
            child: Container(
              height: ScreenUtil().setWidth(100),
              margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(20),
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Positioned.fill(
                    left: ScreenUtil().setWidth(0),
                    top: ScreenUtil().setWidth(0),
                    child: Container(
                      height: ScreenUtil().setWidth(100),
                      decoration: BoxDecoration(
                        color: Color(0xffefefef),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            ScreenUtil().setWidth(50),
                          ),
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(
                          left: ScreenUtil().setWidth(20),
                          top: ScreenUtil().setWidth(26),
                          right: ScreenUtil().setWidth(170),
                        ),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          maxLength: 30,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(42),
                          ),
                          onChanged: (value) {
                            if (CommonUtils.isEmpty(value)) {
                              return;
                            }
                            if (mounted) {
                              setState(() {
                                _searchController.text = value;
                              });
                            }
                          },
                          decoration: null,
                          /* inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(10) //限制长度
                                    ],*/
                        ),
                      ),
                    ),
                  ),
                  Positioned.directional(
                    textDirection: TextDirection.rtl,
                    start: 0,
                    bottom: 10,
                    child: Visibility(
                      visible: !CommonUtils.isEmpty(_searchController.text),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          /*padding: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setWidth(20),
                                    ),*/
                          height: ScreenUtil().setWidth(100),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (mounted) {
                                    setState(() {
                                      _searchController.text = "";
                                      _shopName = _searchController.text;
                                      if (CommonUtils.isEmpty(shopList)) {
                                        page = 1;
                                        _initData();
                                      }
                                    });
                                  }
                                },
                                child: Container(
                                  width: ScreenUtil().setWidth(63),
                                  height: ScreenUtil().setWidth(63),
                                  margin: EdgeInsets.only(
                                    top: ScreenUtil().setWidth(50),
                                  ),
                                  child: Icon(
                                    CupertinoIcons.clear,
                                    color: _shopNameTxtColor,
                                    size: ScreenUtil().setWidth(63),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  ///搜索对应商铺列表
                                  ///
                                  if (mounted) {
                                    setState(() {
                                      _shopName = _searchController.text.trim();
                                      page = 1;
                                      _initData();
                                    });
                                  }
                                }, //
                                child: Container(
                                  width: ScreenUtil().setWidth(63),
                                  height: ScreenUtil().setWidth(63),
                                  padding: EdgeInsets.all(
                                    ScreenUtil().setWidth(25),
                                  ),
                                  margin: EdgeInsets.only(
                                    right: ScreenUtil().setWidth(50),
                                    top: ScreenUtil().setWidth(25),
                                  ),
                                  /* child: MyOctoImage(
                                    image:
                                        "https://alipic.lanhuapp.com/xd2b236767-514c-4d43-99aa-48d2b74f46c9",
                                    width: ScreenUtil().setWidth(41),
                                    height: ScreenUtil().setWidth(41),
                                  ),*/
                                  child: Icon(
                                    CupertinoIcons.search,
                                    color: _shopNameTxtColor,
                                    size: ScreenUtil().setWidth(50),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: CommonUtils.isEmpty(_searchController.text),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _searchFocusNode.requestFocus();
                      },
                      child: Container(
                        /*padding: EdgeInsets.symmetric(
                                    vertical: ScreenUtil().setWidth(20),
                                  ),*/
                        height: ScreenUtil().setWidth(100),
                        margin: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(20),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              ScreenUtil().setWidth(50),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MyOctoImage(
                              image:
                                  "https://alipic.lanhuapp.com/xd2b236767-514c-4d43-99aa-48d2b74f46c9",
                              width: ScreenUtil().setWidth(41),
                              height: ScreenUtil().setWidth(41),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(30),
                              ),
                              child: Text(
                                "搜索商家",
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: ScreenUtil().setSp(36),
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
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(20),
              right: ScreenUtil().setWidth(6),
            ),
            child: MyOctoImage(
              image:
                  "https://alipic.lanhuapp.com/xd33803b45-0392-435c-bcb4-1adee00162ed",
              width: ScreenUtil().setWidth(35),
              height: ScreenUtil().setWidth(47),
              fit: BoxFit.fill,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              right: ScreenUtil().setWidth(16),
            ),
            child: Text(
              "${GlobalConfig.prefs.getString("cityName")}",
              style: TextStyle(
                color: Color(0xff222222),
                fontSize: ScreenUtil().setSp(48),
              ),
            ),
          ),
        ],
      ),
    );
  }

  var _shopTypeBgColor = Color(0xffFFF0EB);
  var _shopTypeTxtColor = Color(0xffFF8D56);
  var _shopDistanceBgColor = Color(0xffFDF6DF);
  var _shopDistanceTxtColor = Color(0xffEDA703);
  var _shopNameTxtColor = Color(0xff222222);
  var _shopLocationTxtColor = Color(0xff666666);
  var _shopLocationIconUrl =
      "https://alipic.lanhuapp.com/xd7535be55-da9e-45c7-a98d-dc5a3207f662";

  Widget buildListItem({ShopListDataList item, int index}) {
    String storeId = '';
    String storeUid = '';
    String storeName = '';
    String storeImg = '';
    String storeImgUrl = '';
    String storeLogo = '';
    String storeLogoUrl = '';
    String tradeId = '';
    String tradeName = '';
    String storeDesc = '';
    String storeTel = '';
    String storeLat = '';
    String storeLng = '';
    String storeProvince = '';
    String storeCity = '';
    String storeDistrict = '';
    String storeAddr = '';
    String storeDistance = '';
    String storeRatio = '';
    String storeCode = '';
    String storeStatus = '';
    String storeRejectMsg = '';
    String storeApplyTime = '';
    String storeCheckTime = '';
    String location = '';
    try {
      storeId = item.storeId;
      storeUid = item.storeUid;
      storeName = item.storeName;
      storeImg = item.storeImg;
      storeImgUrl = item.storeImgUrl;
      storeLogo = item.storeLogo;
      storeLogoUrl = item.storeLogoUrl;
      tradeId = item.tradeId;
      tradeName = item.tradeName;
      storeDesc = item.storeDesc;
      storeTel = item.storeTel;
      storeLat = item.storeLat;
      storeLng = item.storeLng;
      storeProvince = item.storeProvince;
      storeCity = item.storeCity;
      storeDistrict = item.storeDistrict;
      storeAddr = item.storeAddr;
      storeDistance = item.storeDistance;
      location = "${storeProvince + storeCity + storeDistrict + storeAddr}";
    } catch (e) {}
    return GestureDetector(
      onTap: () {
//        跳转商家详情
        NavigatorUtils.navigatorRouter(
            context,
            ShopDeatilPage(
              shopId: storeId,
              longitude: _longitude,
              latitude: _latitude,
              isOwnShop: _shopId == storeId, //
            ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            ScreenUtil().setWidth(30),
          ),
        ),
        margin: EdgeInsets.only(
          bottom: ScreenUtil().setWidth(20),
        ),
        padding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setWidth(40),
          horizontal: ScreenUtil().setWidth(30),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: ScreenUtil().setWidth(180),
              height: ScreenUtil().setWidth(180),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  ScreenUtil().setWidth(20),
                ),
                child: MyOctoImage(
                  image: "$storeLogoUrl",
                  width: ScreenUtil().setWidth(180),
                  height: ScreenUtil().setWidth(180),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(23),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        "$storeName",
                        style: TextStyle(
                          color: _shopNameTxtColor,
                          fontSize: ScreenUtil().setSp(48),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setWidth(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(32),
                              vertical: ScreenUtil().setWidth(4),
                            ),
                            decoration: BoxDecoration(
                              color: _shopTypeBgColor,
                              borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(7),
                              ),
                            ),
                            child: Text(
                              "$tradeName",
                              style: TextStyle(
                                color: _shopTypeTxtColor,
                                fontSize: ScreenUtil().setSp(26),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(32),
                              vertical: ScreenUtil().setWidth(4),
                            ),
                            margin: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(10),
                            ),
                            decoration: BoxDecoration(
                              color: _shopDistanceBgColor,
                              borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(7),
                              ),
                            ),
                            child: Text(
                              "$storeDistance km",
                              style: TextStyle(
                                color: _shopDistanceTxtColor,
                                fontSize: ScreenUtil().setSp(26),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              right: ScreenUtil().setWidth(8),
                            ),
                            child: MyOctoImage(
                              image: "$_shopLocationIconUrl",
                              width: ScreenUtil().setWidth(33),
                              height: ScreenUtil().setWidth(42),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                "$location",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: _shopLocationTxtColor,
                                  fontSize: ScreenUtil().setSp(36),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  EasyRefresh buildEasyRefresh() {
    return EasyRefresh.custom(
      topBouncing: false,
      bottomBouncing: false,
      header: MaterialHeader(),
      footer: MaterialFooter(),
      enableControlFinishLoad: true,
      enableControlFinishRefresh: true,
      controller: _refreshController,
      onRefresh: () {
        page = 1;
        _initData();
//        initUserInfoData();
        _refreshController.finishLoad(noMore: false);
      },
      onLoad: () {
        if (!isFirstLoading) {
          page++;
          _initData();
        }
      },
      emptyWidget: _emptyWidget,
      slivers: <Widget>[
        buildCenter(),
      ],
    );
  }

  Widget buildCenter() {
    return SliverToBoxAdapter(
      child: Visibility(
        visible: !CommonUtils.isEmpty(shopList),
        child: Container(
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(30),
            vertical: ScreenUtil().setWidth(40),
          ),
          child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(shopList.length, (index) {
                ShopListDataList dataItem = shopList[index];
                return buildListItem(item: dataItem, index: index);
              })),
//          height: double.infinity,
        ),
      ),
    );
  }

  Widget buildEmptyWidget() {
    return shopList == null || shopList.length == 0
        ? CommonUtils.isEmpty(_shopName)
            ? NoShopData(
                applyStatus: applyStatus,
                shopId: _shopId,
                rejectMsg: _rejectMsg,
              )
            : NoDataPage()
        : null;
  }

  Widget buildNoDataWidget() {
    return SliverToBoxAdapter(
      child: Visibility(
        visible:
            CommonUtils.isEmpty(shopList) && !CommonUtils.isEmpty(_shopName),
        child: NoDataPage(),
      ),
    );
  }

  var _priceColor = const Color(0xffe31735);

  @override
  bool get wantKeepAlive => true;
}
/*
class NoShopData extends StatelessWidget {
  NoShopData({Key key, this.applyStatus, this.shopId, this.rejectMsg})
      : super(key: key);

  ///商家入驻申请状态
  ///0 未申请
  ///1 审核中
  ///2 通过
  ///3 拒绝
  var applyStatus = '';
  var _btnTxt = '立即加入';
  var rejectMsg = '';
  var shopId = '';

  @override
  Widget build(BuildContext context) {
    if (!CommonUtils.isEmpty(applyStatus)) {
      if (applyStatus != "2") {
        _btnTxt = '立即加入';
      } else {
        _btnTxt = '我的商家后台';
      }
    }

    return Center(
      child: Container(
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: SizedBox(),
              flex: 2,
            ),
            Center(
              child: MyOctoImage(
                image:
                    'https://alipic.lanhuapp.com/xda551ee22-8d85-4fb6-990e-4d4695437e05',
                width: ScreenUtil().setWidth(674),
                height: ScreenUtil().setWidth(420),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(30)),
              child: Text(
                '当前城市暂未开通',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(42),
                  color: Colors.grey[400],
                ),
              ),
            ),
            buildJoinButton(context),
            Expanded(
              child: SizedBox(),
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }

  ///提交审核
  Widget buildJoinButton(context) {
    return Visibility(
      visible: !CommonUtils.isEmpty(_btnTxt),
      child: Container(
        alignment: Alignment.center,
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(60)),
        child: GestureDetector(
          onTap: () async {
            if (applyStatus == '2') {
              NavigatorUtils.navigatorRouter(
                context,
                ShopBackstagePage(
                  shopId: shopId,
                ),
              );
            } else {
              await NavigatorUtils.navigatorRouter(
                context,
                ApplySettlePage(
                  applyStatus: applyStatus,
                  rejectMsg: rejectMsg,
                  shopId: shopId,
                ),
              );
            }
            var result = await HttpManage.getUserInfo();
            if (result.status) {
              if (mounted) {
                setState(() {
                  _shopId = userInfoData.storeId;
                  _rejectMsg = userInfoData.storeRejectMsg;
                  applyStatus = userInfoData.storeStatus;
                });
              }
            }
          },
          child: Container(
            height: ScreenUtil().setWidth(140),
            width: ScreenUtil().setWidth(673),
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(60),
              vertical: ScreenUtil().setWidth(60),
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFFF36B2E), Color(0xFFF32E43)]),
                borderRadius: BorderRadius.circular(70)),
            child: Text(
              '$_btnTxt',
              style: TextStyle(
                  color: Colors.white, fontSize: ScreenUtil().setSp(48)),
            ),
          ),
        ),
      ),
    );
  }
}*/

class NoShopData extends StatefulWidget {
  NoShopData({Key key, this.applyStatus, this.shopId, this.rejectMsg})
      : super(key: key);

  ///商家入驻申请状态
  ///0 未申请
  ///1 审核中
  ///2 通过
  ///3 拒绝
  var applyStatus = '';
  var _btnTxt = '立即加入';
  var rejectMsg = '';
  var shopId = '';

  @override
  _NoShopDataState createState() => _NoShopDataState();
}

class _NoShopDataState extends State<NoShopData> {
  ///商家入驻申请状态
  ///0 未申请
  ///1 审核中
  ///2 通过
  ///3 拒绝
  var applyStatus = '';
  var _btnTxt = '立即加入';
  var rejectMsg = '';
  var shopId = '';

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    if (!CommonUtils.isEmpty(applyStatus)) {
      if (applyStatus != "2") {
        _btnTxt = '立即加入';
      } else {
        _btnTxt = '我的商家后台';
      }
    }

    return Center(
      child: Container(
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: SizedBox(),
              flex: 2,
            ),
            Center(
              child: MyOctoImage(
                image:
                    'https://alipic.lanhuapp.com/xda551ee22-8d85-4fb6-990e-4d4695437e05',
                width: ScreenUtil().setWidth(674),
                height: ScreenUtil().setWidth(420),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(30)),
              child: Text(
                '当前城市暂未开通',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(42),
                  color: Colors.grey[400],
                ),
              ),
            ),
            buildJoinButton(context),
            Expanded(
              child: SizedBox(),
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }

  initData() async {
    var result = await HttpManage.getUserInfo();
    if (result.status) {
      if (mounted) {
        setState(() {
          shopId = result.data.storeId;
          rejectMsg = result.data.storeRejectMsg;
          applyStatus = result.data.storeStatus;
        });
      }
    }
  }

  ///提交审核
  Widget buildJoinButton(context) {
    return Visibility(
      visible: !CommonUtils.isEmpty(_btnTxt),
      child: Container(
        alignment: Alignment.center,
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(60)),
        child: GestureDetector(
          onTap: () async {
            if (applyStatus == '2') {
              NavigatorUtils.navigatorRouter(
                context,
                ShopBackstagePage(
                  shopId: shopId,
                ),
              );
            } else {
              await NavigatorUtils.navigatorRouter(
                context,
                ApplySettlePage(
                  applyStatus: applyStatus,
                  rejectMsg: rejectMsg,
                  shopId: shopId,
                ),
              );
              initData();
            }
          },
          child: Container(
            height: ScreenUtil().setWidth(140),
            width: ScreenUtil().setWidth(673),
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(60),
              vertical: ScreenUtil().setWidth(60),
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFFF36B2E), Color(0xFFF32E43)]),
                borderRadius: BorderRadius.circular(70)),
            child: Text(
              '$_btnTxt',
              style: TextStyle(
                  color: Colors.white, fontSize: ScreenUtil().setSp(48)),
            ),
          ),
        ),
      ),
    );
  }
}
