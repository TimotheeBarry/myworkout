import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExerciseImage extends StatelessWidget {
  const ExerciseImage({Key? key, this.imageId, this.size = 60})
      : super(key: key);
  final int? imageId;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (imageId == null) {
      return SizedBox(
        width: 2 * size,
        height:size,
        child: const Placeholder(),
      );
    }
    var id = NumberFormat("0000").format(imageId);

    return ClipRRect(
      borderRadius: BorderRadius.circular(4 * size / 60),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/png/$id-relaxation.png',
            height: size,
            width: size,
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/png/$id-tension.png',
            height: size,
            width: size,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
