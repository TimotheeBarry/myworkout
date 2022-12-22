class Workout {
  final int? id;
  final int? groupId;
  final String? name;
  final String? description;
  final bool stillExists;
  final DateTime? lastSessionDate;
  Workout(
      {this.id,
      this.groupId = 1,
      this.name = "",
      this.description = "",
      this.stillExists = true,
      this.lastSessionDate});

  Map<String, Object?> toJSON() => {
        WorkoutFields.id: id,
        WorkoutFields.name: name,
        WorkoutFields.groupId: groupId,
        WorkoutFields.description: description,
        WorkoutFields.stillExists: stillExists ? 1 : 0,
      };

  static Workout fromJSON(Map<String, Object?> json) => Workout(
        id: json[WorkoutFields.id] as int,
        groupId: json[WorkoutFields.groupId] as int,
        name: json[WorkoutFields.name] as String?,
        description: json[WorkoutFields.description] as String?,
        stillExists: (json[WorkoutFields.stillExists] == 1),
        lastSessionDate: json[WorkoutFields.lastSessionDate] != null
            ? DateTime.tryParse(json[WorkoutFields.lastSessionDate] as String)
            : null,
      );

  Workout copy({
    int? id,
    int? groupId,
    String? name,
    String? description,
    bool? stillExists,
  }) =>
      Workout(
          id: id ?? this.id,
          name: name ?? this.name,
          groupId: groupId ?? this.groupId,
          description: description ?? this.description,
          stillExists: stillExists ?? this.stillExists,
          lastSessionDate: lastSessionDate);
}

class WorkoutFields {
  static final List<String> values = [
    id,
    name,
    groupId,
    description,
    stillExists,
  ];
  static const String id = 'id';
  static const String name = 'name';
  static const String groupId = 'group_id';
  static const String description = 'description';
  static const String stillExists = 'still_exists';
  static const String lastSessionDate = 'last_date';
}
