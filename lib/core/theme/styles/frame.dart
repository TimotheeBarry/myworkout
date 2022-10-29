import 'package:flutter/material.dart';

class Frame {
  Frame();

  EdgeInsets get margin => const EdgeInsets.all(10);
  BoxDecoration get boxDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0x20ffffff),
      );
  Color get primaryTextColor => Colors.white;
  Color get secondaryTextColor => Colors.grey[400]!;
  TextStyle get title => TextStyle(
        color: primaryTextColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );
  TextStyle get subtitle => TextStyle(
        color: primaryTextColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
  TextStyle get text => TextStyle(
        color: primaryTextColor,
        fontSize: 16,
      );
}
