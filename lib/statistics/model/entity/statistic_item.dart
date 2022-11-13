import 'package:myworkout/workouts/model/entity/workout.dart';
import 'package:myworkout/workouts/model/entity/workout_group.dart';
import 'package:myworkout/workouts/model/entity/workout_session.dart';

class StatisticItem {
  final int? id;
  final Workout? workout;
  final WorkoutGroup? workoutGroup;
  final DateTime? date;

  StatisticItem({
    this.date,
    this.id,
    this.workout,
    this.workoutGroup,
  });

  static StatisticItem fromJSON(Map<String, Object?> json) => StatisticItem(
        id: json[WorkoutSessionFields.id] as int?,
        workout: Workout(
          id: json[WorkoutSessionFields.workoutId] as int?,
          name: json['workout_name'] as String?,
        ),
        workoutGroup: WorkoutGroup(
          id: json[WorkoutFields.groupId] as int?,
          name: json['group_name'] as String?,
        ),
        date: json[WorkoutSessionFields.date] != null
            ? DateTime.tryParse(json[WorkoutSessionFields.date] as String)
            : null,
      );
}