import 'package:flutter/material.dart';
import 'package:myworkout/exercises/model/entity/exercise.dart';
import 'package:myworkout/exercises/util/exercise_image.dart';
import 'package:myworkout/workouts/model/entity/exercise_set.dart';
import 'package:myworkout/workouts/util/performance_frame.dart';
import 'package:myworkout/workouts/util/title_subtitle.dart';
import '../../core/theme/styles.dart' as styles;

class WorkoutDuringSetView extends StatefulWidget {
  const WorkoutDuringSetView({
    Key? key,
    required this.exercise,
    required this.exerciseSet,
    this.lastExerciseSet,
    this.lastSessionDate,
  }) : super(key: key);
  final Exercise exercise;
  final ExerciseSet exerciseSet;
  final ExerciseSet? lastExerciseSet;
  final DateTime? lastSessionDate;

  @override
  State<WorkoutDuringSetView> createState() => _WorkoutDuringSetViewState();
}

class _WorkoutDuringSetViewState extends State<WorkoutDuringSetView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TitleSubtitle(
            title: 'Exercice en cours',
            subtitle: widget.exercise.name ?? "",
          ),
          styles.form.littleVoidSpace,
          ExerciseImage(
            imageId: widget.exercise.imageId,
            size: 180,
          ),
          styles.form.mediumVoidSpace,
          PerformanceFrame(
            exerciseTarget: widget.exerciseSet,
            exerciseLastPerformance: widget.lastExerciseSet,
            date: widget.lastSessionDate,
          ),
        ],
      ),
    );
  }
}
