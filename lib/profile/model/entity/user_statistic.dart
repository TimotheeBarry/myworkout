class UserStatistic {
  final int? id;
  final int? userId;
  final DateTime? date;
  final String? type;
  final double? value;

  UserStatistic({
    this.id,
    this.userId,
    this.date,
    this.type,
    this.value,
  });

  Map<String, Object?> toJSON() => {
        UserStatisticFields.id: id,
        UserStatisticFields.userId: userId,
        UserStatisticFields.date: date?.toIso8601String(),
        UserStatisticFields.type: type,
        UserStatisticFields.value: value,
      };

  static UserStatistic fromJSON(Map<String, Object?> json) => UserStatistic(
        id: json[UserStatisticFields.id] as int?,
        userId: json[UserStatisticFields.userId] as int?,
        date: (json[UserStatisticFields.date] != null)
            ? DateTime.parse(json[UserStatisticFields.date] as String)
            : null,
        type: json[UserStatisticFields.type] as String?,
        value: json[UserStatisticFields.value] as double?,
      );

  UserStatistic copy({
    int? id,
    int? userId,
    DateTime? date,
    String? type,
    double? value,
  }) =>
      UserStatistic(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        date: date ?? this.date,
        type: type ?? this.type,
        value: value ?? this.value,
      );
}

class UserStatisticFields {
  static final List<String> values = [
    id,
    userId,
    date,
    type,
    value,
  ];
  static const String id = 'id';
  static const String userId = 'user_id';
  static const String date = 'date';
  static const String type = 'type';
  static const String value = 'value';
}
