import 'package:flutter/material.dart';

class Frame {
  Frame();

  Color get primaryTextColor => Colors.white;
  Color get secondaryTextColor => Colors.white54;
  Color get backgroundColor => Colors.white12;
  Color get darkBackgroundColor => Colors.black26;

  EdgeInsets get margin =>
      const EdgeInsets.symmetric(horizontal: 10, vertical: 4);
  BorderRadius get borderRadius => BorderRadius.circular(16);

  BoxDecoration get boxDecoration => BoxDecoration(
        borderRadius: borderRadius,
        color: backgroundColor,
      );

  BoxDecoration get darkBoxDecoration => BoxDecoration(
        borderRadius: borderRadius,
        color: darkBackgroundColor,
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
  TextStyle get bigText => TextStyle(
        color: primaryTextColor,
        fontSize: 16,
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

  Divider get divider => Divider(color: Colors.white54, thickness: 1);
}
