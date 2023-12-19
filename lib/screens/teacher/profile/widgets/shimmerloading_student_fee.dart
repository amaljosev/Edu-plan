import 'package:flutter/material.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingForStudentFee extends StatelessWidget {
  const ShimmerLoadingForStudentFee({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100, 
        width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0),
                child: Shimmer.fromColors(
                  baseColor: appbarColor,
                  highlightColor: Colors.white,
                  child: Container(
                    width: 50,
                    height: 20,
                    color: Colors.purple.shade50,
                  ),
                ),
              ),
              subtitle: Shimmer.fromColors(
                baseColor: appbarColor,
                highlightColor: Colors.white,
                child: Container(
                  width: 50,
                  height: 20,
                  color: Colors.purple.shade50,
                ),
              ),
            ),
          ],
        ),
      );
  }
}
