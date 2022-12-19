import 'package:flutter/material.dart';
import 'package:myworkout/exercises/model/entity/exercise.dart';
import 'package:myworkout/exercises/util/exercise_image.dart';
import 'package:myworkout/workouts/model/entity/exercise_set.dart';
import 'package:myworkout/workouts/util/performance_frame.dart';
import 'package:myworkout/workouts/util/set_count.dart';
import 'package:myworkout/workouts/util/title_subtitle.dart';
import 'dart:math';
import '../../core/theme/styles.dart' as styles;

class WorkoutDuringSetView extends StatefulWidget {
  const WorkoutDuringSetView({
    Key? key,
    required this.exercise,
    required this.exerciseSet,
    this.lastExerciseSet,
    this.lastSessionDate,
    required this.currentSet,
    required this.totalSets,
  }) : super(key: key);
  final int currentSet;
  final int totalSets;
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
          styles.form.littleVoidSpace,
          Row(
            children: [
              Expanded(
                child: TitleSubtitle(
                  title: 'Exercice en cours',
                  subtitle: widget.exercise.name ?? "",
                ),
              ),
              SetCount(
                  currentSet: widget.currentSet, totalSets: widget.totalSets)
            ],
          ),
          styles.form.littleVoidSpace,
          ExerciseImage(
            imageId: widget.exercise.imageId,
            size: min(
                MediaQuery.of(context).size.width / 2 - styles.page.marginValue,
                MediaQuery.of(context).size.height / 2 -
                    styles.page.marginValue),
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
