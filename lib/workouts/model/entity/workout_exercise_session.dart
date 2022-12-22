import 'package:myworkout/exercises/model/entity/exercise.dart';
import 'package:myworkout/workouts/model/entity/exercise_performance.dart';
import 'package:myworkout/workouts/model/entity/exercise_set.dart';

class WorkoutExerciseSession {
  final int? id;
  final int? workoutSessionId;
  final Exercise? exercise;
  final String? note;
  final ExercisePerformance? exercisePerformanceGoal;
  final ExercisePerformance? exercisePerformanceDone;
  final int? listIndex;

  WorkoutExerciseSession({
    this.id,
    this.workoutSessionId,
    this.exercise,
    this.note,
    this.exercisePerformanceGoal,
    this.exercisePerformanceDone,
    this.listIndex,
  });

  WorkoutExerciseSession copy({
    int? id,
    int? workoutSessionId,
    Exercise? exercise,
    ExercisePerformance? exercisePerformanceGoal,
    ExercisePerformance? exercisePerformanceDone,
    int? listIndex,
    String? note,
  }) =>
      WorkoutExerciseSession(
        id: id ?? this.id,
        workoutSessionId: workoutSessionId ?? this.workoutSessionId,
        exercise: exercise ?? this.exercise,
        exercisePerformanceGoal:
            exercisePerformanceGoal ?? this.exercisePerformanceGoal,
        exercisePerformanceDone:
            exercisePerformanceDone ?? this.exercisePerformanceDone,
        listIndex: listIndex ?? this.listIndex,
        note: note ?? this.note,
      );

  static WorkoutExerciseSession fromJSON(Map<String, Object?> json) =>
      WorkoutExerciseSession(
        id: json[WorkoutExerciseSessionFields.id] as int?,
        workoutSessionId:
            json[WorkoutExerciseSessionFields.workoutSessionId] as int?,
        listIndex: json[WorkoutExerciseSessionFields.listIndex] as int?,
        note: json[WorkoutExerciseSessionFields.note] as String?,
        exercise: Exercise(
          id: json[WorkoutExerciseSessionFields.exerciseId] as int?,
          name: json[ExerciseFields.name] as String?,
          imageId: json[ExerciseFields.imageId] as int?,
        ),
        exercisePerformanceGoal: ExercisePerformance(
          sets: json[WorkoutExerciseSessionFields.setsGoal] as int?,
          reps: json[WorkoutExerciseSessionFields.repsGoal] as String?,
          loads: json[WorkoutExerciseSessionFields.loadsGoal] as String?,
          rests: json[WorkoutExerciseSessionFields.restsGoal] as String?,
        ),
        exercisePerformanceDone: ExercisePerformance(
          sets: json[WorkoutExerciseSessionFields.setsDone] as int?,
          reps: json[WorkoutExerciseSessionFields.repsDone] as String?,
          loads: json[WorkoutExerciseSessionFields.loadsDone] as String?,
          rests: json[WorkoutExerciseSessionFields.restsDone] as String?,
        ),
      );

  Map<String, Object?> toJSON() => {
        WorkoutExerciseSessionFields.listIndex: listIndex,
        WorkoutExerciseSessionFields.workoutSessionId: workoutSessionId,
        WorkoutExerciseSessionFields.exerciseId: exercise?.id,
        WorkoutExerciseSessionFields.note: note,
        WorkoutExerciseSessionFields.setsGoal: exercisePerformanceGoal?.sets,
        WorkoutExerciseSessionFields.repsGoal: exercisePerformanceGoal?.reps,
        WorkoutExerciseSessionFields.loadsGoal:
            exercisePerformanceGoal?.loads,
        WorkoutExerciseSessionFields.restsGoal:
            exercisePerformanceGoal?.rests,
        WorkoutExerciseSessionFields.setsDone: exercisePerformanceDone?.sets,
        WorkoutExerciseSessionFields.repsDone: exercisePerformanceDone?.reps,
        WorkoutExerciseSessionFields.loadsDone:
            exercisePerformanceDone?.loads,
        WorkoutExerciseSessionFields.restsDone:
            exercisePerformanceDone?.rests,
      };

  List<ExerciseSet> getExerciseSets(ExercisePerformance exercisePerformance) {
    var repsList =
        exercisePerformance.reps!.split('-').map((e) => int.parse(e)).toList();
    var loadList =
        exercisePerformance.loads!.split('-').map((e) => num.parse(e)).toList();
    var restList =
        exercisePerformance.rests!.split('-').map((e) => int.parse(e)).toList();
    List<ExerciseSet> exerciseSets = [];
    for (var i = 0; i < exercisePerformance.sets!; i++) {
      exerciseSets.add(
          ExerciseSet(reps: repsList[i], load: loadList[i], rest: restList[i]));
    }
    return exerciseSets;
  }
}

class WorkoutExerciseSessionFields {
  static const String id = 'id';
  static const String exerciseId = 'exercise_id';
  static const String workoutSessionId = 'workout_session_id';
  static const String listIndex = 'list_index';
  static const String note = 'note';

  static const String setsGoal = 'sets_goal';
  static const String repsGoal = 'reps_goal';
  static const String loadsGoal = 'loads_goal';
  static const String restsGoal = 'rests_goal';

  static const String setsDone = 'sets_done';
  static const String repsDone = 'reps_done';
  static const String loadsDone = 'loads_done';
  static const String restsDone = 'rests_done';
}
