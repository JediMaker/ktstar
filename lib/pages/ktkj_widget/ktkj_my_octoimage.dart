import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:octo_image/octo_image.dart';
import 'package:star/pages/ktkj_widget/ktkj_my_octoimage.dart';
import 'package:star/pages/widget/network_image.dart' as network;
import 'package:star/utils/ktkj_common_utils.dart';

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class KTKJMyOctoImage extends StatefulWidget {
  KTKJMyOctoImage(
      {Key key,
      this.image,
      this.imageBuilder,
      this.placeholderBuilder,
      this.progressIndicatorBuilder,
      this.errorBuilder,
      this.placeholderFadeInDuration,
      this.fadeOutDuration,
      this.fadeOutCurve,
      this.fadeInDuration,
      this.fadeInCurve,
      this.width,
      this.height,
      this.fit,
      this.alignment,
      this.repeat,
      this.matchTextDirection,
      this.color,
      this.colorBlendMode,
      this.filterQuality,
      this.gaplessPlayback,
      this.placeholder})
      : super(key: key);
  final String title = "";

  /// The image that should be shown.
  final String image;

  /// Optional builder to further customize the display of the image.
  final OctoImageBuilder imageBuilder;

  /// Widget displayed while the target [imageUrl] is loading.
  final OctoPlaceholderBuilder placeholderBuilder;

  /// Widget displayed while the target [imageUrl] is loading.
  final OctoProgressIndicatorBuilder progressIndicatorBuilder;

  /// Widget displayed while the target [imageUrl] failed loading.
  final OctoErrorBuilder errorBuilder;

  /// The duration of the fade-in animation for the [placeholderBuilder].
  final Duration placeholderFadeInDuration;

  /// The duration of the fade-out animation for the [placeholderBuilder].
  final Duration fadeOutDuration;

  /// The curve of the fade-out animation for the [placeholderBuilder].
  final Curve fadeOutCurve;

  /// The duration of the fade-in animation for the [imageUrl].
  final Duration fadeInDuration;

  /// The curve of the fade-in animation for the [imageUrl].
  final Curve fadeInCurve;

  /// If non-null, require the image to have this width.
  ///
  /// If null, the image will pick a size that best preserves its intrinsic
  /// aspect ratio. This may result in a sudden change if the size of the
  /// placeholder widget does not match that of the target image. The size is
  /// also affected by the scale factor.
  final double width;

  /// If non-null, require the image to have this height.
  ///
  /// If null, the image will pick a size that best preserves its intrinsic
  /// aspect ratio. This may result in a sudden change if the size of the
  /// placeholder widget does not match that of the target image. The size is
  /// also affected by the scale factor.
  final double height;

  /// How to inscribe the image into the space allocated during layout.
  ///
  /// The default varies based on the other fields. See the discussion at
  /// [paintImage].
  final BoxFit fit;

  /// How to align the image within its bounds.
  ///
  /// The alignment aligns the given position in the image to the given position
  /// in the layout bounds. For example, a [Alignment] alignment of (-1.0,
  /// -1.0) aligns the image to the top-left corner of its layout bounds, while
  /// a [Alignment] alignment of (1.0, 1.0) aligns the bottom right of the
  /// image with the bottom right corner of its layout bounds. Similarly, an
  /// alignment of (0.0, 1.0) aligns the bottom middle of the image with the
  /// middle of the bottom edge of its layout bounds.
  ///
  /// If the [alignment] is [TextDirection]-dependent (i.e. if it is a
  /// [AlignmentDirectional]), then an ambient [Directionality] widget
  /// must be in scope.
  ///
  /// Defaults to [Alignment.center].
  ///
  /// See also:
  ///
  ///  * [Alignment], a class with convenient constants typically used to
  ///    specify an [AlignmentGeometry].
  ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
  ///    relative to text direction.
  final AlignmentGeometry alignment;

  /// How to paint any portions of the layout bounds not covered by the image.
  final ImageRepeat repeat;

  /// Whether to paint the image in the direction of the [TextDirection].
  ///
  /// If this is true, then in [TextDirection.ltr] contexts, the image will be
  /// drawn with its origin in the top left (the "normal" painting direction for
  /// children); and in [TextDirection.rtl] contexts, the image will be drawn
  /// with a scaling factor of -1 in the horizontal direction so that the origin
  /// is in the top right.
  ///
  /// This is occasionally used with children in right-to-left environments, for
  /// children that were designed for left-to-right locales. Be careful, when
  /// using this, to not flip children with integral shadows, text, or other
  /// effects that will look incorrect when flipped.
  ///
  /// If this is true, there must be an ambient [Directionality] widget in
  /// scope.
  final bool matchTextDirection;

  /// If non-null, this color is blended with each image pixel using
  /// [colorBlendMode].
  final Color color;

  /// Used to combine [color] with this image.
  ///
  /// The default is [BlendMode.srcIn]. In terms of the blend mode, [color] is
  /// the source and this image is the destination.
  ///
  /// See also:
  ///
  ///  * [BlendMode], which includes an illustration of the effect of each
  ///  blend mode.
  final BlendMode colorBlendMode;

  /// Target the interpolation quality for image scaling.
  ///
  /// If not given a value, defaults to FilterQuality.low.
  final FilterQuality filterQuality;

  /// Whether to continue showing the old image (true), or briefly show the
  /// placeholder (false), when the image provider changes.
  final bool gaplessPlayback;

  final PlaceholderWidgetBuilder placeholder;

  @override
  _MyOctoImageState createState() => _MyOctoImageState();
}

// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
class _MyOctoImageState extends State<KTKJMyOctoImage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    if (KTKJCommonUtils.isEmpty(widget.image)) {
//      return null;
//    }
    return RepaintBoundary(
      child: OctoImage(
//      image: network.NetworkImage(widget.image),
        image: CachedNetworkImageProvider(widget.image),
        width: widget.width,
        height: widget.height,
        imageBuilder: widget.imageBuilder,
        placeholderBuilder: widget.placeholderBuilder != null
            ? widget.placeholderBuilder
            : null,
        //
        progressIndicatorBuilder: widget.progressIndicatorBuilder,
        fadeInCurve: widget.fadeInCurve,
        fadeInDuration: widget.fadeInDuration,
        placeholderFadeInDuration: widget.placeholderFadeInDuration,
        alignment: widget.alignment,
        errorBuilder: widget.errorBuilder != null ? widget.errorBuilder : null,
        fit: widget.fit,
        repeat: widget.repeat,
        color: widget.color,
        colorBlendMode: widget.colorBlendMode,
        matchTextDirection: widget.matchTextDirection,
        filterQuality: widget.filterQuality,
      ),
    );
  }
}
