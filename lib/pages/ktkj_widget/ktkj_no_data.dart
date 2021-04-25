import 'package:flutter/material.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJNoDataPage extends StatelessWidget {
  Color textColor;

  KTKJNoDataPage({
    Key key,
    this.textColor,
  }) : super(key: key);

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
              style: TextStyle(
                  fontSize: 16.0,
                  color: textColor == null ? Colors.grey[400] : textColor),
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
