import 'package:flutter/material.dart';
import '../../core/theme/styles.dart' as styles;

class SetCount extends StatelessWidget {
  const SetCount({Key? key, required this.currentSet, required this.totalSets})
      : super(key: key);
  final int currentSet;
  final int totalSets;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(
      '$currentSet/$totalSets',
      style: styles.frame.subtitle,
    ));
  }
}
