import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/styles.dart' as styles;

class ExerciseImageBig extends StatelessWidget {
  const ExerciseImageBig({Key? key, this.imageId}) : super(key: key);
  final int? imageId;
  @override
  Widget build(BuildContext context) {
    if (imageId == null) {
      return const Placeholder(
        fallbackHeight: 180,
      );
    }
    final formatter = NumberFormat("0000");
    var id = formatter.format(imageId);

    return ClipRRect(
      borderRadius: styles.frame.borderRadius,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/png/$id-relaxation.png',
            height: 180,
            width: 180,
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/png/$id-tension.png',
            height: 180,
            width: 180,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
