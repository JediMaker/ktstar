library flutter_jd_address_selector;

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:ui' as ui show window;

import 'package:star/http/http_manage.dart';
import 'package:star/models/region_data_entity.dart';

class KeTaoFeaturedJDAddressDialog extends StatefulWidget {
  final String title;
  final Function(String province, String city, String county, int provinceId,
      int cityId, int countyId) onSelected;

  final Color unselectedColor;
  final Color selectedColor;

  final double itemTextFontSize;

  final TextStyle titleTextStyle;

  KeTaoFeaturedJDAddressDialog(
      {Key key,
      @required this.onSelected,
      this.title,
      this.unselectedColor: Colors.grey,
      this.selectedColor: Colors.blue,
      this.itemTextFontSize: 14.0,
      this.titleTextStyle: const TextStyle(
          fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold)})
      : super(key: key);

  @override
  createState() => _JDAddressDialogState();
}

class _JDAddressDialogState extends State<KeTaoFeaturedJDAddressDialog>
    with TickerProviderStateMixin {
  int _index = 0;

  TabController _tabController;
  ScrollController _controller;

  /// TabBar不能动态加载，所以初始化3个，其中两个文字置空，点击事件拦截住。
  List<Tab> myTabs = <Tab>[Tab(text: '请选择'), Tab(text: ''), Tab(text: '')];

  List<RegionDataData> provinces = [];
  List<RegionDataData> cities = [];
  List<RegionDataData> counties = [];

  /// 当前列表数据
  List<RegionDataData> mList = [];

  /// 三级联动选择的position
  var _positions = [0, 0, 0];

  double itemHeight = 48.0;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();

    _tabController = TabController(vsync: this, length: myTabs.length);
    _initData("1", "");
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: Container(
            height:
                MediaQueryData.fromWindow(ui.window).size.height * 9.0 / 16.0,
            child: Column(children: <Widget>[
              Stack(children: <Widget>[
                Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child:
                        Text("${widget.title}", style: widget.titleTextStyle)),
                Positioned(
                    right: 0,
                    child: IconButton(
                        icon: Icon(Icons.close, size: 22),
                        onPressed: () => Navigator.maybePop(context)))
              ]),
              _line,
              Container(
                  color: Colors.white,
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      onTap: (index) {
                        if (myTabs[index].text.isEmpty) {
                          _tabController.animateTo(_index);
                          return;
                        }
                        switch (index) {
                          case 0:
                            mList = provinces;
                            break;
                          case 1:
                            mList = cities;
                            /*   mList =
                                cities = provinces[_positions[0]]['cityList'];*/
                            break;
                          case 2:
                            mList = counties;
                            /* mList =
                                counties = cities[_positions[1]]['countyList'];*/
                            break;
                        }
                        setState(() {
                          _index = index;
                          _controller.animateTo(_positions[_index] * itemHeight,
                              duration: Duration(milliseconds: 10),
                              curve: Curves.ease);
                        });
                      },
                      indicatorSize: TabBarIndicatorSize.label,
                      unselectedLabelColor: Colors.black,
                      labelColor: widget.selectedColor,
                      indicatorColor: widget.selectedColor,
                      tabs: myTabs)),
              _line,
              Expanded(
                  child: provinces.length > 0
                      ? _buildListView()
                      : CupertinoActivityIndicator(animating: false))
            ])));
  }

  void _initData(status, pid) async {
    ///
    var resultData = await HttpManage.getAddressAreaList();
    if (resultData.status) {
      provinces = resultData.data;
      setState(() => mList = provinces);
    }

    /*  rootBundle
        .loadString(
            'packages/fluttereshop/assets/chinese_cities.json')
        .then((value) {
      provinces = json.decode(value);

      setState(() => mList = provinces);
    });
*/
    setState(() {});
  }

  Widget _buildListView() {
    //todo 根据接口数据类型进行修改
    return ListView.builder(
        controller: _controller,
        itemBuilder: (context, index) => InkWell(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                height: itemHeight,
                alignment: Alignment.centerLeft,
                child: Row(children: <Widget>[
                  Text(mList[index].value,
                      style: TextStyle(
                          fontSize: widget.itemTextFontSize,
                          color: mList[index].value == myTabs[_index].text
                              ? widget.selectedColor
                              : widget.unselectedColor)),
                  SizedBox(height: 8),
                  Offstage(
                      offstage: mList[index].value != myTabs[_index].text,
                      child: Icon(Icons.check,
                          size: 16.0, color: widget.selectedColor))
                ])),
            onTap: () {
              myTabs[_index] = Tab(text: mList[index].value);
              _positions[_index] = index;
              _index++;
              switch (_index) {
                case 1:
//                  _initData("2", mList[index].pid);
                  for (var item in provinces) {
                    if (item.id == mList[index].id) {
                      cities = item.children;
                    }
                  }
                  setState(() => mList = cities);
                  myTabs[1] = Tab(text: "请选择");
                  myTabs[2] = Tab(text: "");
                  break;
                case 2:
//                  _initData("3", mList[index].pid);
                  for (var item in cities) {
                    if (item.id == mList[index].id) {
                      counties = item.children;
                    }
                  }
                  setState(() => mList = counties);
                  myTabs[2] = Tab(text: "请选择");
                  break;
                case 3:
                  _index = 2;

                  widget.onSelected(
                      provinces[_positions[0]].value,
                      cities[_positions[1]].value,
                      counties[_positions[2]].value,
                      provinces[_positions[0]].id,
                      cities[_positions[1]].id,
                      counties[_positions[2]].id);
                  Navigator.maybePop(context);
                  break;
              }
              setState(() {});
              _controller.animateTo(0.0,
                  duration: Duration(milliseconds: 100), curve: Curves.ease);
              _tabController.animateTo(_index);
            }),
        itemCount: mList.length);
  }

  Widget _line = Container(height: 0.6, color: Color(0xFFEEEEEE));
}
