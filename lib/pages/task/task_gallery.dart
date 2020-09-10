import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../global_config.dart';

class TaskGalleryPage extends StatefulWidget {
  TaskGalleryPage({Key key, this.galleryItems, this.index = 0})
      : super(key: key);
  final String title = "";
  var galleryItems;
  int index;

  @override
  _TaskGalleryPageState createState() => _TaskGalleryPageState();
}

class _TaskGalleryPageState extends State<TaskGalleryPage> {
  PageController pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.index);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
    return PhotoViewGalleryPageOptions(
      onTapDown: (
        BuildContext context,
        TapDownDetails details,
        PhotoViewControllerValue controllerValue,
      ) {
        Navigator.of(context).pop();
      },
      imageProvider: Image.network(widget.galleryItems[index]).image,
      initialScale: PhotoViewComputedScale.contained * 1,
//          heroAttributes: HeroAttributes(tag: galleryItems[index].id),
    );
      },
      itemCount: widget.galleryItems.length,
      loadingBuilder: (context, event) => Center(
    child: Container(
      width: 20.0,
      height: 20.0,
      child: CircularProgressIndicator(
        value: event == null
            ? 0
            : event.cumulativeBytesLoaded / event.expectedTotalBytes,
      ),
    ),
      ),
//      backgroundDecoration: widget.backgroundDecoration,
      pageController: pageController,
      onPageChanged: onPageChanged,
    )));
  }

  void onPageChanged(int index) {}
}
