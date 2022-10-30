import 'package:flutter/material.dart';

class Frame {
  Frame();

  Color get primaryTextColor => Colors.white;
  Color get secondaryTextColor => Colors.grey[400]!;
  Color get backgroundColor => const Color(0x20ffffff);

  EdgeInsets get margin => const EdgeInsets.all(10);
  BoxDecoration get boxDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: backgroundColor,
      );

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
        fontSize: 14,
      );
  TextStyle get smallText => TextStyle(
        color: primaryTextColor,
        fontSize: 12,
      );
  TextStyle get legend => TextStyle(
        color: secondaryTextColor,
        fontSize: 10,
      );
}
