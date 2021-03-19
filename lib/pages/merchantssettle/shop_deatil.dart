import 'package:star/pages/widget/my_octoimage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:star/global_config.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/pages/merchantssettle/shop_backstage.dart';
import 'package:star/pages/merchantssettle/shop_payment.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';

class ShopDeatilPage extends StatefulWidget {
  ShopDeatilPage(
      {Key key, this.shopId, this.latitude, this.longitude, this.isOwnShop})
      : super(key: key);
  final String title = "商家详情";

  ///商家收款
  var shopId;
  var latitude = '';
  var longitude = '';
  var isOwnShop = false;

  @override
  _ShopDeatilPageState createState() => _ShopDeatilPageState();
}

class _ShopDeatilPageState extends State<ShopDeatilPage> {
  var _latitude;
  var _longitude;
  var _provinceName;
  var _cityName;
  var _shopName = '';

  var _shopImageUrl = '';

  var _location = '';
  var _shopDistance = '';

  var _balance = '';
  var _shopCode = '';
  bool _hasPayPassword = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _initData() async {
    if (CommonUtils.isEmpty(GlobalConfig.prefs.getString("latitude"))) {
      await GlobalConfig.initUserLocationWithPermission(count: 0);
      _latitude = GlobalConfig.prefs.getString("latitude");
      _longitude = GlobalConfig.prefs.getString("longitude");
    } else {
      _latitude = GlobalConfig.prefs.getString("latitude");
      _longitude = GlobalConfig.prefs.getString("longitude");
    }

    var result = await HttpManage.getShopInfo(
        storeId: widget.shopId, latitude: _latitude, longitude: _longitude);
    if (mounted) {
      if (result.status) {
        setState(() {
          _shopName = result.data.storeName;
          _shopImageUrl = result.data.storeImgUrl;
          _shopDistance = result.data.storeDistance;
          _location =
              "${result.data.storeProvince + result.data.storeCity + result.data.storeDistrict + result.data.storeAddr}";
          /*_contactDetails = result.data.storeTel;
            _selectTypeId = result.data.tradeId;
            for (var item in _shopTypeList) {
              if (item.id == _selectTypeId) {
                _shopType = item.name;
                _selectProfitDifference = item.coin;
              }
            }

            _shopDesc = result.data.storeDesc;
            _shopLocation =
                "${result.data.storeProvince + result.data.storeCity + result.data.storeDistrict + result.data.storeAddr}";

            _shopProfitRatio = result.data.storeRatio;
            var ep = double.parse(_shopProfitRatio) -
                double.parse(_selectProfitDifference);
            _estimateProfit = ep.toString();
            _showProfitWarningText = false;
            _storeImg = result.data.storeImg;
            _storeLogo = result.data.storeLogo;
            if (!CommonUtils.isEmpty(result.data.storeLogoUrl)) {
              var netImage = Image.network(
                result.data.storeLogoUrl,
                width: ScreenUtil().setWidth(327),
                height: ScreenUtil().setWidth(327),
                fit: BoxFit.fill,
              );
              images.add(netImage);
            }
            if (!CommonUtils.isEmpty(result.data.storeImgUrl)) {
              var netImage = Image.network(
                result.data.storeImgUrl,
                width: ScreenUtil().setWidth(327),
                height: ScreenUtil().setWidth(327),
                fit: BoxFit.fill,
              );
              images2.add(netImage);
            }
          }*/
        });
      }
    }
    var entityResult = await HttpManage.getShopPayInfo(storeId: widget.shopId);
    if (entityResult.status) {
      if (mounted) {
        setState(() {
//        _payPrice = entityResult.data.payPrice;
//        _oUserInfo = entityResult.data.userInfo;
          _balance = entityResult.data.user.price;
          _hasPayPassword = entityResult.data.user.payPwdFlag;
          _shopName = entityResult.data.store.storeName;
          _shopCode = entityResult.data.store.storeCode;
        });
      }
    }
  }

  var _shopTypeBgColor = Color(0xffFFF0EB);
  var _shopTypeTxtColor = Color(0xffFF8D56);
  var _shopDistanceBgColor = Color(0xffFDF6DF);
  var _shopDistanceTxtColor = Color(0xffEDA703);
  var _shopNameTxtColor = Color(0xff222222);
  var _shopLocationTxtColor = Color(0xff666666);
  var _shopLocationIconUrl =
      "https://alipic.lanhuapp.com/xd7535be55-da9e-45c7-a98d-dc5a3207f662";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(
                color: Color(0xFF222222), fontSize: ScreenUtil().setSp(54)),
          ),
          leading: IconButton(
            icon: Container(
              width: ScreenUtil().setWidth(63),
              height: ScreenUtil().setHeight(63),
              child: Center(
                child: Image.asset(
                  "static/images/icon_ios_back.png",
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
          centerTitle: true,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          color: Colors.white,
          height: double.infinity,
          child: Column(
            children: [
              Flexible(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(30),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: ScreenUtil().setWidth(40),
                          bottom: ScreenUtil().setWidth(40),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            ScreenUtil().setWidth(30),
                          ),
                          child: MyOctoImage(
                            image: "$_shopImageUrl",
                            width: ScreenUtil().setWidth(1065),
                            height: ScreenUtil().setWidth(700),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                                      "$_shopName",
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                              "$_location",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: _shopLocationTxtColor,
                                                fontSize:
                                                    ScreenUtil().setSp(36),
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
                          Center(
                            child: Container(
                              height: ScreenUtil().setWidth(53),
                              width: ScreenUtil().setWidth(1),
                              color: Color(0xff707070),
                              margin: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(48),
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "$_shopDistance km",
                              style: TextStyle(
                                color: Color(0xff666666),
                                fontSize: ScreenUtil().setSp(36),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (widget.isOwnShop) {
                    ///进入商家后台
                    NavigatorUtils.navigatorRouter(
                      context,
                      ShopBackstagePage(
                        shopId: widget.shopId,
                      ),
                    );
                  } else {
                    ///进入支付页面
                    NavigatorUtils.navigatorRouter(
                        context,
                        ShopPaymentPage(
                          shopId: widget.shopId,
                          shopName: _shopName,
                          shopCode: _shopCode,
                          balance: _balance,
                          hasPayPassword: _hasPayPassword,
                        ));
                  }
                },
                child: Container(
                  color: Color(0xffF32E43),
                  height: ScreenUtil().setWidth(160),
                  alignment: Alignment.center,
                  child: Text(
                    "${widget.isOwnShop ? "进入商家后台" : "立即支付"}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(42),
                    ),
                  ),
                ),
              )
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
