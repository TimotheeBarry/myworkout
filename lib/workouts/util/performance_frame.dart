import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:myworkout/core/util/functions.dart';
import 'package:myworkout/workouts/model/entity/exercise_set.dart';
import '../../core/theme/styles.dart' as styles;

class PerformanceFrame extends StatelessWidget {
  const PerformanceFrame(
      {Key? key,
      required this.exerciseTarget,
      this.date,
      this.exerciseLastPerformance})
      : super(key: key);
  final DateTime? date;
  final ExerciseSet exerciseTarget;
  final ExerciseSet? exerciseLastPerformance;
  final double iconSize = 36;

  Widget buildFrame(bool isCurrent) {
    final title = isCurrent ? 'Objectifs' : 'Dernière séance';
    final decoration =
        isCurrent ? styles.frame.boxDecoration : styles.frame.darkBoxDecoration;
    final exerciseSet = isCurrent ? exerciseTarget : exerciseLastPerformance!;
    final textColor = isCurrent
        ? styles.frame.primaryTextColor
        : Color.fromRGBO(255, 255, 255, 0.8);
    return Expanded(
      child: Container(
        decoration: decoration,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                isCurrent
                    ? const SizedBox(height: 12)
                    : Text(DateFormat('dd/MM/yyyy').format(date!),
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        )),
              ],
            ),
            styles.form.littleVoidSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.arrowRotateLeft,
                      color: textColor,
                      size: iconSize,
                    ),
                    const SizedBox(width: 8),
                    Text('${exerciseSet.reps.toString()} reps',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ))
                  ],
                ),
                styles.form.littleVoidSpace,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(FontAwesomeIcons.weightHanging,
                        color: textColor, size: iconSize),
                    const SizedBox(width: 8),
                    Text('${exerciseSet.load.toString()} kg',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ))
                  ],
                ),
              ],
            ),
            styles.form.littleVoidSpace,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              buildFrame(true),
              exerciseLastPerformance != null
                  ? const SizedBox(width: 8)
                  : const SizedBox.shrink(),
              exerciseLastPerformance != null
                  ? buildFrame(false)
                  : const SizedBox.shrink()
            ],
          ),
        ),
        styles.form.littleVoidSpace,
        Container(
          decoration: styles.frame.boxDecoration,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.stopwatch,
                  color: styles.frame.primaryTextColor, size: iconSize),
              const SizedBox(width: 8),
              Text(secondsToString(exerciseTarget.rest),
                  style: TextStyle(
                    color: styles.frame.primaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
