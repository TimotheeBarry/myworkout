class ExerciseGroup {
  final int? id;
  final String? name;
  final bool stillExists;
  ExerciseGroup({
    this.id,
    this.name = "",
    this.stillExists = true,
  });

  Map<String, Object?> toJSON() => {
        ExerciseGroupFields.id: id,
        ExerciseGroupFields.name: name,
        ExerciseGroupFields.stillExists: stillExists ? 1 : 0,
      };

  static ExerciseGroup fromJSON(Map<String, Object?> json) => ExerciseGroup(
        id: json[ExerciseGroupFields.id] as int,
        name: json[ExerciseGroupFields.name] as String?,
        stillExists: (json[ExerciseGroupFields.stillExists] == 1),
      );

  ExerciseGroup copy({int? id, String? name, bool? stillExists}) =>
      ExerciseGroup(
          id: id ?? this.id,
          name: name ?? this.name,
          stillExists: stillExists ?? this.stillExists);
}

class ExerciseGroupFields {
  static final List<String> values = [
    id,
    name,
    stillExists,
  ];
  static const String id = 'id';
  static const String name = 'name';
  static const String stillExists = 'still_exists';
}
