import 'package:flutter/material.dart';
import 'package:myworkout/exercises/model/entity/exercise.dart';
import 'package:myworkout/exercises/util/exercise_image_big.dart';
import 'package:myworkout/workouts/model/entity/exercise_set.dart';
import '../../core/theme/styles.dart' as styles;

class WorkoutDuringSetView extends StatefulWidget {
  const WorkoutDuringSetView(
      {Key? key, required this.exercise, required this.exerciseSet})
      : super(key: key);
  final Exercise exercise;
  final ExerciseSet exerciseSet;
  @override
  State<WorkoutDuringSetView> createState() => _WorkoutDuringSetViewState();
}

class _WorkoutDuringSetViewState extends State<WorkoutDuringSetView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ExerciseImageBig(imageId: widget.exercise.imageId),
          Container(
            margin: styles.frame.margin,
            decoration: styles.frame.boxDecoration,
            child: Column(children: []),
          ),
        ],
      ),
    );
  }
}
