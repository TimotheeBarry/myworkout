import 'package:flutter/material.dart';

const darkBlue = [Color(0xff242365), Color(0xff0B0A28)];

class Page {
  Page();
  BoxDecoration get boxDecoration => const BoxDecoration(
        gradient: LinearGradient(
            colors: darkBlue,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      );
  EdgeInsets margin = EdgeInsets.symmetric(horizontal: 10);
}
