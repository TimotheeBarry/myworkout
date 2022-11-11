class UserStatistic {
  final DateTime? date;
  final num? value;
  UserStatistic({this.date, this.value});

  static UserStatistic fromJSON(Map<String, Object?> json) => UserStatistic(
        date: (json[UserStatisticsFields.date] != null)
            ? DateTime.parse(json[UserStatisticsFields.date] as String)
            : null,
        value: json[UserStatisticsFields.value] as num?,
      );
}

class UserStatisticsFields {
  static const String date = 'date';
  static const String value = 'value';
}
