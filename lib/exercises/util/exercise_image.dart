import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExerciseImage extends StatelessWidget {
  const ExerciseImage({Key? key, this.imageId}) : super(key: key);
  final int? imageId;

  @override
  Widget build(BuildContext context) {
    if (imageId == null) {
      return const SizedBox(
        width: 120,
        child: Placeholder(),
      );
    }
    var id = NumberFormat("0000").format(imageId);

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/png/$id-relaxation.png',
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/png/$id-tension.png',
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
