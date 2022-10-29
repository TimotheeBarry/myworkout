class Exercise {
  final int id;
  final int groupId;
  final String? name;
  final String? description;
  Exercise({
    required this.id,
    required this.groupId,
    this.name,
    this.description,
  });
}
