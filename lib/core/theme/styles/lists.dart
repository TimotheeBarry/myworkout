import 'package:flutter/material.dart';

class Lists {
  Lists();
  EdgeInsets get margin => const EdgeInsets.symmetric(vertical: 2, horizontal: 10);
  BorderRadius get borderRadius => BorderRadius.circular(16);
  Color get backgroundColor => const Color(0x47000000);
  TextStyle get title => const TextStyle(color: Colors.white, fontSize: 18);
  TextStyle get subtitle => const TextStyle(color: Colors.white, fontSize: 16);
  TextStyle get description => const TextStyle(color: Colors.grey, fontSize: 14);
}
