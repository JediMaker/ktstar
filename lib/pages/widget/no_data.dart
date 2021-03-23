import 'package:flutter/material.dart';

class KeTaoFeaturedNoDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
    );
  }
}
