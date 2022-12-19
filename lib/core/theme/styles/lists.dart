import 'package:flutter/material.dart';

class Lists {
  Lists();
  EdgeInsets get margin =>
      const EdgeInsets.symmetric(vertical: 2, horizontal: 10);
  EdgeInsets get marginV => const EdgeInsets.symmetric(vertical: 2);
  BorderRadius get borderRadius => BorderRadius.circular(16);
  Color get backgroundColor => Colors.white12;
  TextStyle get title => const TextStyle(
      color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);
  TextStyle get subtitle => const TextStyle(color: Colors.white, fontSize: 18);
  TextStyle get description =>
      const TextStyle(color: Colors.white60, fontSize: 14);
  BoxDecoration get separator => BoxDecoration(
          border: Border(
        top: BorderSide(
          width: 1,
          color: backgroundColor,
        ),
      ));
}
