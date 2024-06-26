
import 'package:flutter/material.dart';


class LimeShimmer extends StatelessWidget {
  final double height;
  final double width;
  final double? borderRadius;
  final double? right;
  final double? left;
  final double? bottom;
  final double? top;

  const LimeShimmer({
    required this.width,
    required this.height,
    this.borderRadius,
    this.right,
    this.left,
    this.bottom,
    this.top,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: right ?? 0,
        left: left ?? 0,
        bottom: bottom ?? 0,
        top: top ?? 0,
      ),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 121, 117, 117),
          borderRadius: BorderRadius.circular(
            borderRadius ??10,
          ),
        ),
      ),
    );
  }
}
