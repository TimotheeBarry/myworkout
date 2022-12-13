import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myworkout/core/util/button_transparent.dart';
import '../../core/theme/styles.dart' as styles;

class NextExerciseButtons extends StatelessWidget {
  const NextExerciseButtons(
      {Key? key,
      required this.onTapNext,
      required this.onTapChange,
      required this.onTapReplace,
      this.shorter = false})
      : super(key: key);
  final void Function() onTapNext;
  final void Function() onTapChange;
  final void Function() onTapReplace;
  final bool shorter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ButtonTransparent(
            title: Text(!shorter ? 'Passer cet exercice' : 'Passer',
                style: styles.frame.bigText),
            onTap: onTapNext,
            icon: FaIcon(FontAwesomeIcons.forward,
                color: styles.frame.primaryTextColor)),
        styles.form.tinyVoidSpace,
        ButtonTransparent(
            title: Text(!shorter ? 'Changer avec un autre exercice' : 'Changer',
                style: styles.frame.bigText),
            onTap: onTapChange,
            icon: FaIcon(FontAwesomeIcons.arrowsRotate,
                color: styles.frame.primaryTextColor)),
        styles.form.tinyVoidSpace,
        ButtonTransparent(
            title: Text(
                !shorter ? 'Remplacer par un exercice similaire' : 'Remplacer',
                style: styles.frame.bigText),
            onTap: onTapReplace,
            icon: FaIcon(FontAwesomeIcons.dumbbell,
                color: styles.frame.primaryTextColor)),
      ],
    );
  }
}
