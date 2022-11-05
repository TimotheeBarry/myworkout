import 'package:flutter/material.dart';
import 'package:myworkout/exercises/model/entity/exercise.dart';
import 'package:myworkout/workouts/model/entity/exercise_performance.dart';

class WorkoutExercise {
  final int? id;
  final int? workoutId;
  final Exercise? exercise;
  final ExercisePerformance? exercisePerformance;
  final int? listIndex;
  final Key? key;

  WorkoutExercise({
    this.id,
    this.workoutId,
    this.exercise,
    this.exercisePerformance,
    this.listIndex,
    this.key,
  });

  WorkoutExercise copy({
    int? id,
    int? workoutId,
    Exercise? exercise,
    ExercisePerformance? exercisePerformance,
    int? listIndex,
    Key? key,
  }) =>
      WorkoutExercise(
          id: id ?? this.id,
          workoutId: workoutId ?? workoutId,
          exercise: exercise ?? this.exercise,
          exercisePerformance: exercisePerformance ?? this.exercisePerformance,
          listIndex: listIndex ?? this.listIndex,
          key: key ?? this.key);

  static WorkoutExercise fromJSON(Map<String, Object?> json) => WorkoutExercise(
        id: json[WorkoutExerciseFields.id] as int?,
        workoutId: json[WorkoutExerciseFields.workoutId] as int?,
        listIndex: json[WorkoutExerciseFields.listIndex] as int?,
        exercise: Exercise(
          id: json[WorkoutExerciseFields.exerciseId] as int?,
          name: json[ExerciseFields.name] as String?,
          description: json[ExerciseFields.description] as String?,
          imageId: json[ExerciseFields.imageId] as int?,
        ),
        exercisePerformance: ExercisePerformance(
          sets: json[WorkoutExerciseFields.sets] as int?,
          reps: json[WorkoutExerciseFields.reps] as String?,
          load: json[WorkoutExerciseFields.load] as String?,
          restBetween: json[WorkoutExerciseFields.restBetween] as String?,
          restAfter: json[WorkoutExerciseFields.restAfter] as int?,
        ),
      );

  Map<String, Object?> toJSON() => {
        WorkoutExerciseFields.listIndex: listIndex,
        WorkoutExerciseFields.workoutId: workoutId,
        WorkoutExerciseFields.exerciseId: exercise?.id,
        WorkoutExerciseFields.sets: exercisePerformance?.sets,
        WorkoutExerciseFields.reps: exercisePerformance?.reps,
        WorkoutExerciseFields.load: exercisePerformance?.load,
        WorkoutExerciseFields.restBetween: exercisePerformance?.restBetween,
        WorkoutExerciseFields.restAfter: exercisePerformance?.restAfter,
      };
}

class WorkoutExerciseFields {
  static const String id = 'id';
  static const String exerciseId = 'exercise_id';
  static const String workoutId = 'workout_id';
  static const String listIndex = 'list_index';
  static const String sets = 'sets';
  static const String reps = 'reps';
  static const String load = 'load';
  static const String restBetween = 'rest_between';
  static const String restAfter = 'rest_after';
}
