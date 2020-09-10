import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:star/pages/login/login.dart';
import 'package:star/pages/task/task_open_diamond.dart';
import 'package:star/utils/common_utils.dart';

class TaskMinePage extends StatefulWidget {
  TaskMinePage({Key key}) : super(key: key);
  final String title = "我的";

  @override
  _TaskMinePageState createState() => _TaskMinePageState();
}

class _TaskMinePageState extends State<TaskMinePage> {
  var headUrl;
  var nickName;
  var dialogNickName;
  var dialogPhoneNumber;
  var phoneNumber;
  var taskReward;
  var withDrawn;
  bool isDiamonVip = false;

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
    return Scaffold(
        appBar: GradientAppBar(
          gradient: LinearGradient(colors: [
            Color(0xFFFC767E),
            Color(0xFFFD9245),
          ]),
          title: Text("我的"),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                buildTopLayout(),
                Stack(
                  children: <Widget>[
                    buildCardInfo(),
                    buildBanner(context),
                  ],
                ),
              ],
            ),
            Card(
              shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text(
                            "时间",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xFF999999), fontSize: 12),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text(
                            "金额",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xFF999999), fontSize: 12),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text(
                            "说明",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xFF999999), fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 200,
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                        color: Color(0xFFEFEFEF),
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Text(
                                  "2020-01-32",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFF222222), fontSize: 12),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Text(
                                  "1元",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFF222222), fontSize: 12),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Text(
                                  "每天任务完成",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFF222222), fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: 10,
                    ),
                  )
                ],
              ),
            ),
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  GestureDetector buildBanner(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return TaskOpenDiamondPage();
        }));
      },
      child: Visibility(
        visible: !isDiamonVip,
        child: Container(
          width: double.maxFinite,
          margin: EdgeInsets.only(
            top: 70,
          ),
          child: Image.asset(
            "static/images/task_vip_banner.png",
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget buildCardInfo() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            height: 46,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color(0xFFFC767E),
              Color(0xFFFD9245),
            ])),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Container(
              height: 82,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "任务奖励金",
                          style:
                              TextStyle(color: Color(0xFF222222), fontSize: 14),
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Text(
                          "${taskReward == null ? '¥ 0' : '¥ $taskReward'}",
                          style: TextStyle(
                              color: Color(0xFF222222),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "已提现",
                          style:
                              TextStyle(color: Color(0xFF222222), fontSize: 14),
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Text(
                          "${withDrawn == null ? '¥ 0' : '¥ $withDrawn'}",
                          style: TextStyle(
                              color: Color(0xFF222222),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
          )
        ],
      ),
    );
  }

  Widget buildTopLayout() {
    return Container(
        height: 100,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xFFFC767E),
          Color(0xFFFD9245),
        ])),
        child: Column(
          children: <Widget>[
            Visibility(
              visible: false,
              child: Container(
                  alignment: Alignment.center,
                  height: 56,
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text("${widget.title}",
                      style: TextStyle(
                          color: Colors.white, fontSize: 20, letterSpacing: 1))),
            ),
            buildHeadLayout(),
          ],
        ));
  }

  Widget buildHeadLayout() {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    height: 46,
                    decoration: BoxDecoration(
                        color: Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.all(Radius.circular(46))),
                    child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(fontSize: 14),
                        textInputAction: TextInputAction.send,
                        decoration: new InputDecoration(
                          hintText: '昵称：',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 15.0),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(46)),
                              // 边框默认色
                              borderSide:
                                  const BorderSide(color: Colors.transparent)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(46)),
                              borderSide:
                                  const BorderSide(color: Colors.transparent)
                              // 聚焦之后的边框色
                              ),
                        ),
                        onChanged: (value) {
                          dialogNickName = value;
                        }),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    height: 46,
                    decoration: BoxDecoration(
                        color: Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.all(Radius.circular(46))),
                    child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(fontSize: 14),
                        textInputAction: TextInputAction.send,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          hintText: '手机号：',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 15.0),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(46)),
                              // 边框默认色
                              borderSide:
                                  const BorderSide(color: Colors.transparent)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(46)),
                              borderSide:
                                  const BorderSide(color: Colors.transparent)
                              // 聚焦之后的边框色
                              ),
                        ),
                        onChanged: (value) {
                          dialogPhoneNumber = value;
                        }),
                  ),
                  Container(
                    height: 1,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFFEFEFEF),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              child: Text(
                                "取消",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0xFF222222)),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          color: Color(0xFFEFEFEF),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: GestureDetector(
                            onTap: () {
                              //todo 修改昵称以及手机号
                              if (CommonUtils.isEmpty(dialogNickName) ||
                                  CommonUtils.isEmpty(dialogPhoneNumber)) {
                                Fluttertoast.showToast(
                                    msg: "请检查填写的信息是否完整！",
                                    textColor: Colors.white,
                                    backgroundColor: Colors.grey);
                                return;
                              }
                              if (!CommonUtils.isPhoneLegal(phoneNumber)) {
                                CommonUtils.showSimplePromptDialog(
                                    context, "温馨提示", "请输入正确的手机号");
                                return;
                              }
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "确定",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0xFF3668F2)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            });
      },
      child: ListTile(
        leading: headUrl == null
            ? Image.asset(
                "static/images/task_default_head.png",
                width: 60,
                height: 60,
              )
            : ClipOval(
                child: CachedNetworkImage(
                  imageUrl: headUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
        title: Text(
          "${nickName == null ? '昵称' : nickName}",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          "${phoneNumber == null ? '请绑定您的手机号' : phoneNumber}",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        trailing: GestureDetector(
          onTap: () {
            //todo 提现到微信
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return LoginPage();
            }));
          },
          child: Container(
            width: 60,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(24)),
                border: Border.all(color: Colors.white, width: 0.5)),
            child: Text(
              "去提现",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}
