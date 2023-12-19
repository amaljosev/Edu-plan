import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final Color baseColor;
  final Color highlightColor;
  final ShapeBorder shapeBorder;
  final bool isRound;
  const ShimmerWidget.rectangular(
      {super.key,
      this.width = double.infinity,
      required this.height,
      required this.baseColor,
      required this.highlightColor,
      this.shapeBorder = const RoundedRectangleBorder(),
      required this.isRound});
  const ShimmerWidget.circular(
      {super.key,
      this.width = double.infinity,
      required this.height,
      required this.baseColor,
      required this.highlightColor,
      this.shapeBorder = const CircleBorder(),
      required this.isRound});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      direction: ShimmerDirection.ttb,
      child: isRound
          ? const CircleAvatar(
              radius: 40,
            )
          : Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              width: width,
              height: height,
            ));
}
