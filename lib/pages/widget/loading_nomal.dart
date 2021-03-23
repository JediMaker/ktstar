import 'package:flutter/material.dart';

class KeTaoFeaturedLoadingWidgetNomal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
