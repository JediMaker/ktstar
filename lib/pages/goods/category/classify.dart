import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:star/global_config.dart';
import 'package:star/http/http_manage.dart';
import 'package:star/models/category_bean_entity.dart';
import 'package:star/pages/goods/goods_list.dart';
import 'package:star/utils/common_utils.dart';
import 'package:star/utils/navigator_utils.dart';

// ignore: must_be_immutable
class ClassifyListPage extends StatefulWidget {
  @override
  _ClassifyListPageState createState() => _ClassifyListPageState();
}

class _ClassifyListPageState extends State<ClassifyListPage>
    with AutomaticKeepAliveClientMixin {
  List<CategoryBeanData> leftListData;
  List<CategoryBeanData> rightListData;

  Future _initData(id) async {
    List<CategoryBeanData> categoryList = await HttpManage.getCategoryList(id);
    if (mounted) {
      setState(() {
        try {
          leftListData = categoryList;
          rightListData = leftListData[selectedIndex].children;
        } catch (e) {}
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initData(0);
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!CommonUtils.isEmpty(rightListData)) {
      } else {
        _initData(0);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '商品分类',
          style: TextStyle(
              color: Color(0xFF222222), fontSize: ScreenUtil().setSp(54)),
        ),
        /*leading: IconButton(
          icon: Image.asset(
            "static/images/icon_ios_back.png",
            width: ScreenUtil().setWidth(36),
            height: ScreenUtil().setHeight(63),
            fit: BoxFit.fill,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),*/
        centerTitle: true,
        backgroundColor: GlobalConfig.taskNomalHeadColor,
        elevation: 0,
      ),
      body: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(270),
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                CategoryBeanData category;
                if (leftListData != null) {
                  category = leftListData[index];
                }
                var _selected = index == selectedIndex ? true : false;
                return Container(
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(
                      color: Color(0xffefefef),
                      width: ScreenUtil().setWidth(1),
                    ),
                  )),
                  child: ListTile(
                    selected: _selected,
                    selectedTileColor: Colors.white,
                    title: Center(
                      child: Text(
                        category == null ? '' : category.name,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(38),
                          color: _selected ? Colors.red : Color(0xff222222),
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        rightListData = leftListData[index].children;
                      });
                    },
                  ),
                );
              },
              itemCount: leftListData == null ? 0 : leftListData.length,
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 8, left: 8),
              child: buildRightClassfyGridView(),
//                  child:Text('hhh'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRightClassfyGridView() {
    return EasyRefresh.custom(
      emptyWidget: rightListData != null
          ? null
          : Container(
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: SizedBox(),
                    flex: 2,
                  ),
                  SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: Image.asset('static/images/c_defull_null.png'),
                  ),
                  Text(
                    '暂无数据',
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[400]),
                  ),
                  Expanded(
                    child: SizedBox(),
                    flex: 3,
                  ),
                ],
              ),
            ),
      onRefresh: () {
        _initData(0);
      },
      header: MaterialHeader(),
      slivers: <Widget>[
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              // 左右间隔
              crossAxisSpacing: 8,
              // 上下间隔
              mainAxisSpacing: 8,
              childAspectRatio: 3 / 4),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              CategoryBeanData category;
              if (rightListData != null) {
                category = rightListData[index];
              }
              return GestureDetector(
                onTap: () {
                  if (category != null) {
                    NavigatorUtils.navigatorRouter(
                        context,
                        GoodsListPage(
                          categoryId: category.id,
                          title: category.name,
                        ));
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: category.imgUrl == null
                            ? 'https://www.elegantthemes.com/blog/wp-content/uploads/2020/02/000-404.png'
                            : category.imgUrl,
                        /* imageUrl:
                            "https://www.elegantthemes.com/blog/wp-content/uploads/2020/02/000-404.png",*/
                        width: ScreenUtil().setWidth(270),
                        height: ScreenUtil().setWidth(270),
//            placeholder: (context, url) => new CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(38),
                          color: Color(0xff222222),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            childCount: rightListData == null ? 0 : rightListData.length,
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
