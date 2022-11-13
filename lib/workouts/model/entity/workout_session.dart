import 'package:myworkout/workouts/model/entity/workout_exercise_session.dart';

class WorkoutSession {
  final int? id;
  final int? workoutId;
  final String? notes;
  final DateTime? date;
  final List<WorkoutExerciseSession>? workoutExerciseSession;
  WorkoutSession({
    this.id,
    this.workoutId,
    this.notes,
    this.date,
    this.workoutExerciseSession = const [],
  });

  Map<String, Object?> toJSON() => {
        WorkoutSessionFields.id: id,
        WorkoutSessionFields.workoutId: workoutId,
        WorkoutSessionFields.notes: notes,
        WorkoutSessionFields.date: date?.toIso8601String(),
      };

  static WorkoutSession fromJSON(Map<String, Object?> json) =>
      WorkoutSession(
        id: json[WorkoutSessionFields.id] as int,
        workoutId: json[WorkoutSessionFields.workoutId] as int,
        notes: json[WorkoutSessionFields.notes] as String?,
        date: json[WorkoutSessionFields.date] != null
            ? DateTime.tryParse(json[WorkoutSessionFields.date] as String)
            : null,
      );

  WorkoutSession copy({
    int? id,
    int? workoutId,
    String? notes,
    DateTime? date,
    List<WorkoutExerciseSession>? workoutExerciseSession,
  }) =>
      WorkoutSession(
        id: id ?? this.id,
        workoutId: workoutId ?? this.workoutId,
        notes: notes ?? this.notes,
        date: date ?? this.date,
        workoutExerciseSession: workoutExerciseSession ?? this.workoutExerciseSession,
      );
}

class WorkoutSessionFields {
  static const String id = 'id';
  static const String workoutId = 'workout_id';
  static const String notes = 'notes';
  static const String date = 'date';
}
