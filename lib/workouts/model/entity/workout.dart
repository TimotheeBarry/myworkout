class Workout {
  final int id;
  final int groupId;
  final String? name;
  final String? description;
  Workout({
    required this.id,
    required this.groupId,
    this.name,
    this.description,
  });
}
