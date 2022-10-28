import 'package:flutter/material.dart';

class Frame {
  Frame();
  EdgeInsets margin = EdgeInsets.all(10);
  BoxDecoration get boxDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0x47000000),
      );
}
