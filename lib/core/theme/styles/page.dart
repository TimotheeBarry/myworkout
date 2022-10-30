import 'package:flutter/material.dart';

class Page {
  Page();
  List<Color> get darkBlue =>
      [const Color(0xff242365), const Color(0xff0B0A28)];

  BoxDecoration get boxDecoration => BoxDecoration(
        gradient: LinearGradient(
            colors: darkBlue,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      );
  EdgeInsets margin = EdgeInsets.symmetric(horizontal: 10);
}
