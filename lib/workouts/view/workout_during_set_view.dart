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
  Widget buildPerformanceGoalFrame() {
    return Container(
      margin: styles.frame.margin,
      decoration: styles.frame.boxDecoration,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(children: [
          Center(child: Text('Objectifs', style: styles.frame.title)),
          styles.form.littleVoidSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${widget.exerciseSet.reps} reps',
                  style: styles.frame.bigText),
              Text('${widget.exerciseSet.load} kg',
                  style: styles.frame.bigText),
            ],
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ExerciseImageBig(imageId: widget.exercise.imageId),
          buildPerformanceGoalFrame(),
        ],
      ),
    );
  }
}
