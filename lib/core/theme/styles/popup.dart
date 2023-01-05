import 'package:flutter/material.dart';

class PopUp {
  PopUp();
  Color get backgroundColor => Colors.white;
  Color get textColor => Colors.black38;
  Color get buttonConfirmColor => const Color(0xff242365);
  Color get buttonCancelColor => Colors.black12;
  TextStyle get confirm => const TextStyle(
      fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold);
  TextStyle get cancel =>
      TextStyle(fontSize: 18, color: textColor, fontWeight: FontWeight.bold);
  TextStyle get title => const TextStyle(
      color: Colors.black54, fontSize: 20, fontWeight: FontWeight.bold);
  TextStyle get option =>
      TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w700);
  Divider get divider => Divider(color: Colors.black12, thickness: 1);
}
