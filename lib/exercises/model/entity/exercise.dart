class Exercise {
  final int? id;
  final int? groupId;
  final int? imageId;
  final String? name;
  final String? type;
  final String? primer;
  final List<String>? steps;
  final List<String>? tips;
  final bool? stillExists;
  final bool? isLiked;
  final List<String>? primary;
  final List<String>? secondary;
  final List<String>? equipment;
  Exercise({
    this.id,
    this.groupId,
    this.imageId,
    this.name,
    this.type,
    this.primer,
    this.steps,
    this.tips,
    this.primary,
    this.secondary,
    this.equipment,
    this.stillExists = true,
    this.isLiked = false,
  });

  Map<String, Object?> toJSON() => {
        ExerciseFields.id: id,
        ExerciseFields.name: name,
        ExerciseFields.type: type,
        ExerciseFields.imageId: imageId,
        ExerciseFields.groupId: groupId,
        ExerciseFields.steps: steps,
        ExerciseFields.primer: primer,
        ExerciseFields.tips: tips?.join('/').toString(),
        ExerciseFields.primary: primary?.join('/').toString(),
        ExerciseFields.secondary: secondary?.join('/').toString(),
        ExerciseFields.equipment: equipment?.join('/').toString(),
        ExerciseFields.stillExists: stillExists! ? 1 : 0,
        ExerciseFields.isLiked: isLiked! ? 1 : 0,
      };

  static Exercise fromJSON(Map<String, Object?> json) => Exercise(
        id: json[ExerciseFields.id] as int?,
        groupId: json[ExerciseFields.groupId] as int?,
        imageId: json[ExerciseFields.imageId] as int?,
        name: json[ExerciseFields.name] as String?,
        type: json[ExerciseFields.type] as String?,
        primer: json[ExerciseFields.primer] as String?,
        steps: (json[ExerciseFields.steps] as String?)?.split('/').toList(),
        tips: (json[ExerciseFields.tips] as String?)?.split('/').toList(),
        primary: (json[ExerciseFields.primary] as String?)?.split('/').toList(),
        secondary:
            (json[ExerciseFields.secondary] as String?)?.split('/').toList(),
        equipment:
            (json[ExerciseFields.equipment] as String?)?.split('/').toList(),
        stillExists: (json[ExerciseFields.stillExists] == 1),
        isLiked: (json[ExerciseFields.isLiked] == 1),
      );

  Exercise copy({
    int? id,
    int? groupId,
    int? imageId,
    String? type,
    String? name,
    String? primer,
    List<String>? steps,
    List<String>? tips,
    List<String>? primary,
    List<String>? secondary,
    List<String>? equipment,
    bool? stillExists,
    bool? isLiked,
  }) =>
      Exercise(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        imageId: imageId ?? this.imageId,
        groupId: groupId ?? this.groupId,
        primer: primer ?? this.primer,
        steps: steps ?? this.steps,
        tips: tips ?? this.tips,
        primary: primary ?? this.primary,
        secondary: secondary ?? this.secondary,
        equipment: equipment ?? this.equipment,
        stillExists: stillExists ?? this.stillExists,
        isLiked: isLiked ?? this.isLiked,
      );
}

class ExerciseFields {
  static final List<String> values = [
    id,
    name,
    groupId,
    imageId,
    type,
    primer,
    steps,
    tips,
    primary,
    secondary,
    equipment,
    stillExists,
    isLiked
  ];
  static const String id = 'id';
  static const String name = 'name';
  static const String groupId = 'group_id';
  static const String imageId = 'image_id';
  static const String type = 'type';
  static const String primer = 'primer';
  static const String steps = 'description';
  static const String tips = 'tips';
  static const String primary = 'primary';
  static const String secondary = 'secondary';
  static const String equipment = 'equipment';
  static const String stillExists = 'still_exists';
  static const String isLiked = 'is_liked';
}
