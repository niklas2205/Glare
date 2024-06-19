import 'package:flutter/material.dart';

class PaddingUtils {
  static EdgeInsets dynamicPadding(BuildContext context, {double horizontal = 0, double vertical = 0}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Adjust padding based on screen size or other logic
    final double paddingHorizontal = screenWidth * (horizontal / 100);
    final double paddingVertical = screenHeight * (vertical / 100);

    return EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical);
  }
}
