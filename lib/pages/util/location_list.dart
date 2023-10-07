import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:luca/pages/util/parallax.dart';

class LocationListItem extends StatelessWidget {
  LocationListItem({
    Key? key,
    required this.imageUrl,
    required this.scrollController,
    Uint8List? imageBytes,
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
          fadeInDuration: const Duration(milliseconds: 0),
          fadeOutDuration: const Duration(milliseconds: 0),
          imageUrl: imageUrl,
          key: _backgroundImageKey,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildPlaceholder(),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Builder(builder: (context) {
      return Center(
        child: LoadingAnimationWidget.fallingDot(
          size: 35,
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    });
  }
}
