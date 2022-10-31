import 'package:myworkout/workouts/model/entity/workout.dart';

class WorkoutGroup {
  final int? id;
  final String? name;
  final bool stillExists;
  final List<Workout>? workouts;
  WorkoutGroup({
    this.id,
    this.name = "",
    this.stillExists = true,
    this.workouts = const [],
  });

  Map<String, Object?> toJSON() => {
        WorkoutGroupFields.id: id,
        WorkoutGroupFields.name: name,
        WorkoutGroupFields.stillExists: stillExists ? 1 : 0,
      };

  static WorkoutGroup fromJSON(Map<String, Object?> json) => WorkoutGroup(
        id: json[WorkoutGroupFields.id] as int,
        name: json[WorkoutGroupFields.name] as String?,
        stillExists: (json[WorkoutGroupFields.stillExists] == 1),
      );

  WorkoutGroup copy({
    int? id,
    String? name,
    bool? stillExists,
    List<Workout>? workouts,
  }) =>
      WorkoutGroup(
        id: id ?? this.id,
        name: name ?? this.name,
        stillExists: stillExists ?? this.stillExists,
        workouts: workouts ?? this.workouts,
      );
}

class WorkoutGroupFields {
  static final List<String> values = [
    id,
    name,
    stillExists,
  ];
  static const String id = 'id';
  static const String name = 'name';
  static const String stillExists = 'still_exists';
}
