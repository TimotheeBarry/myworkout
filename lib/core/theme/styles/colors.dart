import 'package:flutter/material.dart';

class ColorStyle {
  Color get maroon => const Color(0xff800000);
  Color get brown => const Color(0xff9a6324);
  Color get olive => const Color(0xff808000);
  Color get teal => const Color(0xff469990);
  Color get navy => const Color(0xff000075);
  Color get red => const Color(0xffe6194B);
  Color get orange => const Color(0xfff58231);
  Color get yellow => const Color(0xffffe119);
  Color get lime => const Color(0xffbfef45);
  Color get green => const Color(0xff3cb44b);
  Color get cyan => const Color(0xff42d4f4);
  Color get blue => const Color(0xff4363d8);
  Color get purple => const Color(0xff911eb4);
  Color get magenta => const Color(0xfff032e6);
  Color get grey => const Color(0xffa9a9a9);
  Color get pink => const Color(0xfffabed4);
  Color get apricot => const Color(0xffffd8b1);
  Color get beige => const Color(0xfffffac8);
  Color get mint => const Color(0xffaaffc3);
  Color get lavender => const Color(0xffdcbeff);

  List<Color> get palette => [
        red,
        green,
        yellow,
        blue,
        orange,
        purple,
        cyan,
        magenta,
        lime,
        pink,
        teal,
        lavender,
        brown,
        beige,
        maroon,
        mint,
        olive,
        apricot,
        navy,
        grey,
        Colors.white,
        Colors.black
      ];
}
