import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ExerciseImage extends StatelessWidget {
  const ExerciseImage({Key? key, this.imageId, this.size = 60})
      : super(key: key);
  final int? imageId;
  final double size;

  Widget getAssetImage(String path) {
    try {
      rootBundle.load(path);
      return Image.asset(path, height: size, width: size, fit: BoxFit.contain);
    } catch (_) {
      return SizedBox(height: size, width: size); // Return this widget
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageId == null) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(4 * size / 60),
          child: Container(
              color: Colors.white,
              child: SizedBox(
                  width: 2 * size,
                  height: size,
                  child: Center(
                    child: FaIcon(FontAwesomeIcons.image,
                        color: Colors.black38, size: size / 1.5),
                  )
                  //child: const Placeholder(),
                  )));
    }
    var id = NumberFormat("0000").format(imageId);

    return ClipRRect(
      borderRadius: BorderRadius.circular(4 * size / 60),
      child: Container(
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            getAssetImage('assets/images/png/$id-relaxation.png'),
            getAssetImage('assets/images/png/$id-tension.png'),
          ],
        ),
      ),
    );
  }
}
