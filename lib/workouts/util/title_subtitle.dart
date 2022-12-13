import 'package:flutter/material.dart';
import '../../core/theme/styles.dart' as styles;

class TitleSubtitle extends StatelessWidget {
  const TitleSubtitle({Key? key, required this.title, required this.subtitle})
      : super(key: key);
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(),
        Text(title, style: styles.frame.subtitle),
        Text(
          subtitle,
          style: const TextStyle(
              color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
