import 'package:flutter/material.dart';
import 'package:investing/const/color.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class IVShimmer extends StatelessWidget {
  const IVShimmer({
    super.key,
    this.width,
    this.height,
    this.radius = const BorderRadius.all(Radius.circular(16.0)),
    this.background = IVColor.blueGrey,
  });
  final double? width;
  final double? height;
  final BorderRadius radius;
  final Color background;

  factory IVShimmer.listTile() {
    return const IVShimmer(
      width: double.infinity,
      height: kToolbarHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius,
      child: Shimmer(
        child: SizedBox(
          width: width,
          height: height,
        ),
      ),
    );
  }
}
