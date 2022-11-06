import 'package:flutter/material.dart';
import 'package:myworkout/exercises/model/entity/exercise.dart';
import 'package:myworkout/workouts/model/entity/exercise_set.dart';
import 'package:myworkout/workouts/util/rest_timer.dart';

class WorkoutDuringRestView extends StatefulWidget {
  const WorkoutDuringRestView(
      {Key? key,
      required this.exercise,
      required this.exerciseSet,
      required this.nextSet})
      : super(key: key);
  final void Function() nextSet;
  final Exercise exercise;
  final ExerciseSet exerciseSet;
  @override
  State<WorkoutDuringRestView> createState() => _WorkoutDuringRestViewState();
}

class _WorkoutDuringRestViewState extends State<WorkoutDuringRestView> {
  @override
  Widget build(BuildContext context) {
    return RestTimer(
      nextSet: widget.nextSet,
    );
  }
}
