import 'package:flutter/material.dart';

class Button {
  Button();

  Color get backgroundColor => Colors.grey[300]!;
  Color get foregroundColor => Colors.black;

  BorderRadius get borderRadius => BorderRadius.circular(12);

  TextStyle get bigText => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: foregroundColor,
      );
  TextStyle get mediumText => TextStyle(
        fontSize: 18,
        color: foregroundColor,
      );
  TextStyle get smallText => TextStyle(
        fontSize: 16,
        color: foregroundColor,
      );
}
