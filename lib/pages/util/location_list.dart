import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:luca/pages/util/parallax.dart';

class LocationListItem extends StatelessWidget {
  LocationListItem({
    Key? key,
    required this.imageUrl,
    required this.scrollController, Uint8List? imageBytes,
  }) : super(key: key);

  final String imageUrl;
  final ScrollController scrollController;

  final GlobalKey _backgroundImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return _buildParallaxBackground(context);
  }

  Widget _buildParallaxBackground(BuildContext context) {
    return Flow(
      delegate: ParallaxFlowDelegate(
        scrollable: Scrollable.of(context),
        listItemContext: context,
        backgroundImageKey: _backgroundImageKey,
      ),
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          key: _backgroundImageKey,
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
