import 'dart:async';
import 'dart:io';

//import 'package:amap_flutter_location/amap_flutter_location.dart';
//import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:star/pages/widget/my_octoimage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:star/global_config.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';

class ChoseLocationPage extends StatefulWidget {
  ChoseLocationPage({Key key, this.onChoicePoint}) : super(key: key);
  final String title = "";

  /**
   * 选择点后回调事件
   */
  final Function onChoicePoint;

  @override
  _ChoseLocationPageState createState() => _ChoseLocationPageState();
}

class _ChoseLocationPageState extends State<ChoseLocationPage> {
  //地图控制器
  AmapController _amapController;

  //选择的点
  Marker _markerSelect;

  //搜索出来之后选择的点
  Marker _markerSeached;

  //所在城市
  String city;

//    原文链接：https://blog.csdn.net/weixin_39370093/article/details/104796045
  //搜索框文字控制器
  TextEditingController _searchController;

  Map<String, Object> _locationResult;

  StreamSubscription<Map<String, Object>> _locationListener;
//  AMapFlutterLocation _locationPlugin = new AMapFlutterLocation();

  double _longitude;

  double _latitude;

  /// 当前定位经纬度
  LatLng _localLatLng;
  Location _location;
  List<Map> points = [];
  Map _selectAddressInfo;

  var _selextPoiIndex = 0;

  var _searchFocusNode = FocusNode();

  /* */ /**
         * 根据搜索条件选出想要的点
         */ /*
  Future _openModalBottomSheet() async {
    //收起键盘
    FocusScope.of(context).requestFocus(FocusNode());
    //根据关键字及城市进行搜索
    final poiList = await AmapSearch.instance.searchKeyword(
        */ /*_location.latLng, keyword: */ /*
        _searchController.text,
        pageSize: 45,
        page: 1
        */ /*city: _location.city*/ /*
        );
    */ /*.searchKeyword(
      _serachController.text,
      city: city,
    );*/ /*
    List<Map> points = [];
    //便利拼接信息
    for (var item in poiList) {
      var distance = ' | ';
      var endlat = await item.latLng;
      print(
          "endlatlatitude=${endlat.latitude}&&endlatlongitude=${endlat.longitude}&&locallatitude=${endlat.latitude}&&locallatlongitude=${endlat.longitude}");
      distance = await item.distance.toString() + distance;

      points.add({
        'title': await item.title,
        'addressDetail': distance + await item.adName + await item.address,
        'position': await item.latLng,
        'distance': await item.distance,
        'latitude': endlat.latitude,
        'longitude': endlat.longitude,
        'provinceName': await item.provinceName,
        'cityName': await item.cityName,
        'adName': await item.adName,
        'address': await item.address,
      });
    }
    //弹出底部对话框并等待选择
    final option = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return points.length > 0
              ? ListView.builder(
                  itemCount: points.length,
                  itemBuilder: (BuildContext itemContext, int i) {
                    return ListTile(
                      title: Text(points[i]['title']),
                      subtitle: Text("${points[i]['addressDetail']}"),
                      onTap: () {
                        Navigator.pop(context, points[i]);
                      },
                    );
                  },
                )
              : Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(40),
                  child: Text('暂无数据'));
        });

    if (option != null) {
      LatLng selectlatlng = option['position'];
      //将地图中心点移动到选择的点
//      selectlatlng.latitude, selectlatlng.longitude
      _amapController.setCenterCoordinate(selectlatlng);
      //删除原来地图上搜索出来的点
      if (_markerSeached != null) {
        _markerSeached.remove();
      }
      //将搜索出来的点显示在界面上 --此处不能使用自定义图标的marker，使用会报错，至今也没有解决
      _markerSeached = await _amapController.addMarker(MarkerOption(
        latLng: selectlatlng,
      ));
    }
  }*/

  /**
   * 根据搜索条件选出想要的点
   */
  Future _searchPoiListWithKeyWords() async {
    _selextPoiIndex = -1;
    //收起键盘
//    FocusScope.of(context).requestFocus(FocusNode());
    //根据关键字及城市进行搜索
    final poiList = await AmapSearch.instance.searchKeyword(
        /*_location.latLng, keyword: */
        _searchController.text,
        pageSize: 45,
        page: 1
        /*city: _location.city*/
        );
    /*.searchKeyword(
      _serachController.text,
      city: city,
    );*/
    points = [];
    //便利拼接信息
    for (var item in poiList) {
      var distance = ' | ';
      var endlat = await item.latLng;
      print(
          "endlatlatitude=${endlat.latitude}&&endlatlongitude=${endlat.longitude}&&locallatitude=${_localLatLng.latitude}&&locallatlongitude=${_localLatLng.longitude}");
      var distanceDouble =
          await AmapService.instance.calculateDistance(endlat, _localLatLng);
      if (distanceDouble > 1000) {
        distance = 'km | ';
        distanceDouble = distanceDouble / 1000;
        distance = distanceDouble.toStringAsFixed(1) + distance;
      } else {
        distance = '米 | ';
        distance = distanceDouble.toStringAsFixed(0) + distance;
      }
      /*double latitude;
      double longitude;*/
      points.add({
        'title': await item.title,
        'addressDetail': distance +
            await item.provinceName +
            await item.cityName +
            await item.adName +
            await item.address,
        'position': await item.latLng,
        'distance': distance,
        'latitude': endlat.latitude,
        'longitude': endlat.longitude,
        'provinceName': await item.provinceName,
        'cityName': await item.cityName,
        'adName': await item.adName,
        'address': await item.address,
      });
    }
    if (mounted) {
      setState(() {
        points = points;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    /// 动态申请定位权限
    /* requestPermission();

    ///iOS 获取native精度类型
    if (Platform.isIOS) {
      requestAccuracyAuthorization();
    }*/
//    _startLocation();

    ///注册定位结果监听
    /*_locationListener = _locationPlugin
        .onLocationChanged()
        .listen((Map<String, Object> result) {
      setState(() {
        _locationResult = result;
        if (_locationResult != null) {
          _locationResult.forEach((key, value) {
            print("$key: $value");
            if (key == "latitude") {
              _latitude = value;
            }
            if (key == "longitude") {
              _longitude = value;
            }
          });
          if (!CommonUtils.isEmpty(_latitude) &&
              !CommonUtils.isEmpty(_longitude)) {
            _localLatLng = LatLng(_latitude, _longitude);
            if (!CommonUtils.isEmpty(_localLatLng)) {
              _searchPoiListWithLatLng(_localLatLng);
            }
          }
          if (!CommonUtils.isEmpty(_localLatLng)) {
            _stopLocation();
          }
        }
      });
    });*/ //latitude Standard
  }

  ///经纬度搜索周边列表
  _searchPoiListWithLatLng(LatLng latLng) async {
    _selextPoiIndex = 0;
    print("_searchPoiListWithLatLng");
    //根据关键字及城市进行搜索
    var poiList = await AmapSearch.instance.searchAround(
        /*_location.latLng, keyword: */
        latLng,
        pageSize: 45,
        page: 1
        /*city: _location.city*/
        );
    points = [];
    //便利拼接信息
    for (var item in poiList) {
      var distance = '米 | ';
      var endlat = await item.latLng;
      print(
          "endlatlatitude=${endlat.latitude}&&endlatlongitude=${endlat.longitude}&&locallatitude=${_localLatLng.latitude}&&locallatlongitude=${_localLatLng.longitude}");
      var distanceDouble =
          await AmapService.instance.calculateDistance(endlat, _localLatLng);
      if (distanceDouble > 1000) {
        distance = 'km | ';
        distanceDouble = distanceDouble / 1000;
        distance = distanceDouble.toStringAsFixed(1) + distance;
      } else {
        distance = '米 | ';
        distance = distanceDouble.toStringAsFixed(0) + distance;
      }

      points.add({
        'title': await item.title,
        'addressDetail': distance +
            await item.provinceName +
            await item.cityName +
            await item.adName +
            await item.address,
        'position': await item.latLng,
        'distance': distance,
        'latitude': endlat.latitude,
        'longitude': endlat.longitude,
        'provinceName': await item.provinceName,
        'cityName': await item.cityName,
        'adName': await item.adName,
        'address': await item.address,
      });
    }
    if (mounted) {
      setState(() {
        points = points;
        _selectAddressInfo = points[_selextPoiIndex];
      });
    }
    /*.searchKeyword(
      _serachController.text,
      city: city,
    );*/
  }

  ///搜索结果列表
  Widget buildPoiListWidget() {
    return points.length > 0
        ? Flexible(
            child: Container(
              child: ListView.builder(
                itemCount: points.length,
                itemBuilder: (BuildContext itemContext, int i) {
                  return ListTile(
                    title: Text(
                      points[i]['title'],
                      style: TextStyle(
                        fontSize: ScreenUtil().setWidth(48),
                        color: Color(0xff222222),
                      ),
                    ),
                    subtitle: Text(
                      "${points[i]['addressDetail']}",
                      style: TextStyle(
                        fontSize: ScreenUtil().setWidth(32),
                        color: Color(0xffAFAFAF),
                      ),
                    ),
                    trailing: MyOctoImage(
                      image:
                          "${_selextPoiIndex == i ? "https://alipic.lanhuapp.com/xd1cbf866e-022f-4f79-b1a6-a26ab6e30113" : "as"}",
                      width: ScreenUtil().setWidth(67),
                      height: ScreenUtil().setWidth(48),
                      fit: BoxFit.fill,
                    ),
                    onTap: () async {
                      setState(() {
                        _selextPoiIndex = i;
                        _selectAddressInfo = points[_selextPoiIndex];
                      });
                      var option = points[i];
                      if (option != null) {
                        LatLng selectlatlng = points[i]['position'];
                        //将地图中心点移动到选择的点
//      selectlatlng.latitude, selectlatlng.longitude
                        _amapController.setCenterCoordinate(selectlatlng);

                        //移除原来的点
                        if (_markerSelect != null) {
                          _markerSelect.remove();
                        }
                        //删除原来地图上搜索出来的点
                        if (_markerSeached != null) {
                          _markerSeached.remove();
                        }
                        //将搜索出来的点显示在界面上 --此处不能使用自定义图标的marker，使用会报错，至今也没有解决
                        _markerSeached =
                            await _amapController.addMarker(MarkerOption(
                                latLng: selectlatlng,
                                // 自定义定位图标
                                iconProvider: Image.network(
                                  "https://alipic.lanhuapp.com/xd9ea8dd44-bf59-442a-9732-a64780e5b868",
                                  width: ScreenUtil().setWidth(47),
                                  height: ScreenUtil().setWidth(72),
                                  fit: BoxFit.fitWidth,
                                ).image,
                                anchorV: 0.7,
                                anchorU: 0.5));
                      }
                    },
                  );
                },
              ),
            ),
          )
        : Flexible(
            child: Center(
                child: Container(
                    alignment: Alignment.center, child: Text('无搜索结果'))),
          );
  }

  @override
  void dispose() {
    super.dispose();

    ///移除定位监听
    if (null != _locationListener) {
      _locationListener.cancel();
    }

    /* ///销毁定位
    if (null != _locationPlugin) {
      _locationPlugin.destroy();
    }*/
    _searchFocusNode.dispose();
    _searchController.dispose();
  }
/*
  ///设置定位参数
  void _setLocationOption() {
    if (null != _locationPlugin) {
      AMapLocationOption locationOption = new AMapLocationOption();

      ///是否单次定位
      locationOption.onceLocation = false;

      ///是否需要返回逆地理信息
      locationOption.needAddress = true;

      ///逆地理信息的语言类型
      locationOption.geoLanguage = GeoLanguage.DEFAULT;

      locationOption.desiredLocationAccuracyAuthorizationMode =
          AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;

      locationOption.fullAccuracyPurposeKey = "AMapLocationScene";

      ///设置Android端连续定位的定位间隔
      locationOption.locationInterval = 2000;

      ///设置Android端的定位模式<br>
      ///可选值：<br>
      ///<li>[AMapLocationMode.Battery_Saving]</li>
      ///<li>[AMapLocationMode.Device_Sensors]</li>
      ///<li>[AMapLocationMode.Hight_Accuracy]</li>
      locationOption.locationMode = AMapLocationMode.Hight_Accuracy;

      ///设置iOS端的定位最小更新距离<br>
      locationOption.distanceFilter = -1;

      ///设置iOS端期望的定位精度
      /// 可选值：<br>
      /// <li>[DesiredAccuracy.Best] 最高精度</li>
      /// <li>[DesiredAccuracy.BestForNavigation] 适用于导航场景的高精度 </li>
      /// <li>[DesiredAccuracy.NearestTenMeters] 10米 </li>
      /// <li>[DesiredAccuracy.Kilometer] 1000米</li>
      /// <li>[DesiredAccuracy.ThreeKilometers] 3000米</li>
      locationOption.desiredAccuracy = DesiredAccuracy.Best;

      ///设置iOS端是否允许系统暂停定位
      locationOption.pausesLocationUpdatesAutomatically = false;

      ///将定位参数设置给定位插件
      _locationPlugin.setLocationOption(locationOption);
    }
  }

  ///开始定位
  void _startLocation() {
    if (null != _locationPlugin) {
      ///开始定位之前设置定位参数
      _setLocationOption();
      _locationPlugin.startLocation();
    }
  }

  ///停止定位
  void _stopLocation() {
    if (null != _locationPlugin) {
      _locationPlugin.stopLocation();
    }
  }*/

  /*Container _createButtonContainer() {
    return new Container(
        alignment: Alignment.center,
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(
              onPressed: _startLocation,
              child: new Text('开始定位'),
              color: Colors.blue,
              textColor: Colors.white,
            ),
            new Container(width: 20.0),
            new RaisedButton(
              onPressed: _stopLocation,
              child: new Text('停止定位'),
              color: Colors.blue,
              textColor: Colors.white,
            )
          ],
        ));
  }*/

  Widget _resultWidget(key, value) {
    return new Container(
      child: new Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            alignment: Alignment.centerRight,
            width: 100.0,
            child: new Text('$key :'),
          ),
          new Container(width: 5.0),
          new Flexible(child: new Text('$value', softWrap: true)),
        ],
      ),
    );
  }

  final option = MyLocationOption(
    // 是否显示
    show: true,

    //定位模式
    myLocationType: MyLocationType.Follow,

    // 定位间隔
    interval: Duration.zero,

    // 精度圈边框颜色
    strokeColor: Colors.transparent,
    //精度圈边框宽度
    strokeWidth: 2,

    // 精度圈填充色
    fillColor: Colors.transparent,
// 自定义定位图标
    iconProvider: Image.network(
      "https://alipic.lanhuapp.com/xd9ea8dd44-bf59-442a-9732-a64780e5b868",
      width: ScreenUtil().setWidth(47),
      height: ScreenUtil().setWidth(72),
      fit: BoxFit.fitWidth,
    ).image,
    anchorU: 0.0,
    // 锚点u
    anchorV: 0.0, // 锚点v
  );

/*///
  ///
  //    作者：小山包
  //    链接：https://juejin.cn/post/6885138651215298568
  //    来源：掘金
  //    著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
*/
  Widget createAMap() {
    return KeyboardDismissOnTap(
      child: Scaffold(
        body: Stack(
          children: [
            AmapView(
              mapType: MapType.Standard,
              showZoomControl: true,
              tilt: 30,
              zoomGesturesEnabled: true,
//            centerCoordinate: LatLng(_latitude, _longitude),
              zoomLevel: 17,
              // 标记 (可选)
              markers: <MarkerOption>[],
              maskDelay: Duration(milliseconds: 500),
              // 地图创建完成回调 (可选)
              onMapCreated: (controller) async {
                _amapController = controller;
                if (CommonUtils.isEmpty(
                    GlobalConfig.prefs.getString("latitude"))) {
                  await GlobalConfig.initUserLocationWithPermission(count: 0);
                } else {
                  _latitude =
                      double.parse(GlobalConfig.prefs.getString("latitude"));
                  _longitude =
                      double.parse(GlobalConfig.prefs.getString("longitude"));
                }
                //获取所在城市
                var location = await AmapLocation.instance.fetchLocation();
                /* if (mounted) {
                  setState(() {
                    _location = location;
                    city = _location.city;
                  });
                }*/
                _localLatLng = LatLng(_latitude, _longitude);
                _searchPoiListWithLatLng(_localLatLng);
                //显示自己的定位
                await controller.showMyLocation(MyLocationOption(
                  show: true,
                  iconProvider: Image.network(
                    "https://alipic.lanhuapp.com/xd9ea8dd44-bf59-442a-9732-a64780e5b868",
                    width: ScreenUtil().setWidth(47),
                    height: ScreenUtil().setWidth(72),
                    fit: BoxFit.fitWidth,
                  ).image,
                ));

//              _controller.showMyLocation(option);
              },
              // 标识点击回调 (可选)
              onMarkerClicked: (Marker marker) async {
                if (_markerSeached == null) {
                  return;
                }
                //获取点击点的位置
                var location = await marker.location;
                var lon = location.longitude;
                var lat = location.latitude;
                //获取搜索点的位置
                var slocation = await _markerSeached.location;
                var slon = slocation.longitude;
                var slat = slocation.latitude;
                //比较位置
                if (lon == slon && lat == slat) {
                  //移除原来的点
                  if (_markerSeached != null) {
                    _markerSeached.remove();
                  }
                  if (_markerSelect != null) {
                    _markerSelect.remove();
                  }
                  //画上新的点
                  _markerSelect = await _amapController.addMarker(MarkerOption(
                      latLng: location,
                      // 自定义定位图标
                      iconProvider: Image.network(
                        "https://alipic.lanhuapp.com/xd9ea8dd44-bf59-442a-9732-a64780e5b868",
                        width: ScreenUtil().setWidth(47),
                        height: ScreenUtil().setWidth(72),
                        fit: BoxFit.fitWidth,
                      ).image,
                      anchorV: 0.7,
                      anchorU: 0.5));
                }
              },
              // 地图点击回调 (可选)
              onMapClicked: (LatLng coord) async {
                if (_amapController != null) {
                  //移除原来的点
                  if (_markerSelect != null) {
                    _markerSelect.remove();
                  }
                  if (_markerSeached != null) {
                    _markerSeached.remove();
                  }
                  /*if (mounted) {
                    setState(() {
                      _latitude = coord.latitude;
                      _longitude = coord.longitude;
                      _searchPoiListWithLatLng(coord);
                    });
                  }*/
                  _searchPoiListWithLatLng(coord);

                  _amapController.setCenterCoordinate(coord);
                  //画上新的点
                  _markerSelect = await _amapController.addMarker(MarkerOption(
                      latLng: coord,
                      // 自定义定位图标
                      iconProvider: Image.network(
                        "https://alipic.lanhuapp.com/xd9ea8dd44-bf59-442a-9732-a64780e5b868",
                        width: ScreenUtil().setWidth(47),
                        height: ScreenUtil().setWidth(72),
                        fit: BoxFit.fitWidth,
                      ).image,
                      anchorV: 0.7,
                      anchorU: 0.5));
                  widget.onChoicePoint(coord);
                }
              },
            ),
            SafeArea(
              child: Stack(
                children: [
                  Opacity(
                    opacity: 0.31,
                    child: Container(
                      height: ScreenUtil().setWidth(307),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xff000000),
                            Color(0xff000000),
                            Colors.white,
                          ],
                        ),
                      ),
                      child: Column(
                        children: [],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "取消",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(48),
                                ),
                              )),
                          Expanded(child: Text("")),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop(_selectAddressInfo);
                            },
                            color: Color(0xffF32E43),
                            textColor: Colors.white,
                            child: Container(
                              height: ScreenUtil().setWidth(96),
                              width: ScreenUtil().setWidth(200),
                              child: Text(
                                '确定',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(48),
                                ),
                              ),
                              alignment: Alignment.center,
                            ),
                            shape: StadiumBorder(
                              side: BorderSide(
                                width: 0,
                                color: Color(0xffF32E43),
                                // style: BorderStyle.solid,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  if (CommonUtils.isEmpty(_localLatLng)) {
                    return;
                  }
                  _amapController.setCenterCoordinate(_localLatLng);
                  _searchPoiListWithLatLng(_localLatLng);
                },
                child: MyOctoImage(
                  image:
                      "https://alipic.lanhuapp.com/xd13751b8a-64b6-4400-b34d-5dc34299199a",
                  width: ScreenUtil().setWidth(167),
                  height: ScreenUtil().setWidth(167),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
//              margin: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  children: [
                    Container(
                      height: ScreenUtil().setWidth(160),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setWidth(20),
                                ),
                                height: ScreenUtil().setWidth(112),
                                width: MediaQuery.of(context).size.width -
                                    ScreenUtil().setWidth(80),
                                decoration: BoxDecoration(
                                  color: Color(0xfff6f6f6),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      ScreenUtil().setWidth(10),
                                    ),
                                  ),
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  focusNode: _searchFocusNode,
                                  onChanged: (value) {
                                    if (CommonUtils.isEmpty(value)) {
                                      _searchPoiListWithLatLng(_localLatLng);
                                      return;
                                    }
                                    _searchPoiListWithKeyWords();
                                  },
                                  decoration:
                                      InputDecoration(border: InputBorder.none),
                                  /* inputFormatters: <TextInputFormatter>[
                                    LengthLimitingTextInputFormatter(10) //限制长度
                                  ],*/
                                ),
                              ),
                              Visibility(
                                visible:
                                    CommonUtils.isEmpty(_searchController.text),
                                child: GestureDetector(
                                  onTap: () {
                                    _searchFocusNode.requestFocus();
                                  },
                                  child: Container(
                                    /*padding: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setWidth(20),
                                    ),*/
                                    height: ScreenUtil().setWidth(112),
                                    width: MediaQuery.of(context).size.width -
                                        ScreenUtil().setWidth(80),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          ScreenUtil().setWidth(10),
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        MyOctoImage(
                                          image:
                                              "https://alipic.lanhuapp.com/xd4f7f5e7c-1e62-449a-8967-33ff98c352b5",
                                          width: ScreenUtil().setWidth(41),
                                          height: ScreenUtil().setWidth(41),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal:
                                                ScreenUtil().setWidth(30),
                                          ),
                                          child: Text(
                                            "搜索地点",
                                            style: TextStyle(
                                              color: Color(0xffafafaf),
                                              fontSize: ScreenUtil().setSp(48),
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
                          /*IconButton(
                              icon: Icon(Icons.search), onPressed: _searchPoiList)*/
                        ],
                      ),
                    ),
                    buildPoiListWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /* List<Widget> widgets = new List();
//    widgets.add(_createButtonContainer());

    if (_locationResult != null) {
      _locationResult.forEach((key, value) {
        print("$key: $value");
        widgets.add(_resultWidget(key, value));
      });
    }*/

    ///使用默认属性创建一个地图M

    /*   return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: map,
    );*/
    return createAMap();
//    return SafeArea(
//        child: Scaffold(
//            body: Center(
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        mainAxisSize: MainAxisSize.min,
//        children: widgets,
//      ),
//    ) // This trailing comma makes auto-formatting nicer for build methods.
//            ));
  }

  /* ///获取iOS native的accuracyAuthorization类型
  void requestAccuracyAuthorization() async {
    AMapAccuracyAuthorization currentAccuracyAuthorization =
        await _locationPlugin.getSystemAccuracyAuthorization();
    if (currentAccuracyAuthorization ==
        AMapAccuracyAuthorization.AMapAccuracyAuthorizationFullAccuracy) {
      print("精确定位类型");
    } else if (currentAccuracyAuthorization ==
        AMapAccuracyAuthorization.AMapAccuracyAuthorizationReducedAccuracy) {
      print("模糊定位类型");
    } else {
      print("未知定位类型");
    }
  }*/

  /// 动态申请定位权限
  void requestPermission() async {
    // 申请权限
    bool hasLocationPermission = await requestLocationPermission();
    if (hasLocationPermission) {
      print("定位权限申请通过");
    } else {
      print("定位权限申请不通过");
    }
  }

  /// 申请定位权限
  /// 授予定位权限返回true， 否则返回false
  Future<bool> requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }
}
