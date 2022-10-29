import 'package:flutter/material.dart';

const Color textColor = Colors.white;

class Frame {
  Frame();

  EdgeInsets get margin => const EdgeInsets.all(10);
  BoxDecoration get boxDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0x20ffffff),
      );
  Color get color => textColor;
  TextStyle get title => const TextStyle(
        color: textColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );
  TextStyle get subtitle => const TextStyle(
        color: textColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
  TextStyle get text => const TextStyle(
        color: textColor,
        fontSize: 16,
      );
}
