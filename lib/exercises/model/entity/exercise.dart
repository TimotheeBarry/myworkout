class Exercise {
  final int? id;
  final int? groupId;
  final String? name;
  final String? description;
  final bool? stillExists;
  final bool? isLiked;
  Exercise({
    this.id,
    this.groupId = 1,
    this.name = "",
    this.description = "",
    this.stillExists = true,
    this.isLiked = false,
  });

  Map<String, Object?> toJSON() => {
        ExerciseFields.id: id,
        ExerciseFields.name: name,
        ExerciseFields.groupId: groupId,
        ExerciseFields.description: description,
        ExerciseFields.stillExists: stillExists! ? 1 : 0,
        ExerciseFields.isLiked: isLiked! ? 1 : 0,
      };

  static Exercise fromJSON(Map<String, Object?> json) => Exercise(
        id: json[ExerciseFields.id] as int,
        groupId: json[ExerciseFields.groupId] as int,
        name: json[ExerciseFields.name] as String?,
        description: json[ExerciseFields.description] as String?,
        stillExists: (json[ExerciseFields.stillExists] == 1),
        isLiked: (json[ExerciseFields.isLiked] == 1),
      );

  Exercise copy({
    int? id,
    int? groupId,
    String? name,
    String? description,
    bool? stillExists,
    bool? isLiked,
  }) =>
      Exercise(
        id: id ?? this.id,
        name: name ?? this.name,
        groupId: groupId ?? this.groupId,
        description: description ?? this.description,
        stillExists: stillExists ?? this.stillExists,
        isLiked: isLiked ?? this.isLiked,
      );
}

class ExerciseFields {
  static final List<String> values = [
    id,
    name,
    groupId,
    description,
    stillExists,
    isLiked
  ];
  static const String id = 'id';
  static const String name = 'name';
  static const String groupId = 'group_id';
  static const String description = 'description';
  static const String stillExists = 'still_exists';
  static const String isLiked = 'is_liked';
}
