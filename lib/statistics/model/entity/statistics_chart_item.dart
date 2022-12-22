class StatisticsChartItem {
  DateTime? date;
  int? groupId;
  String? groupName;
  int? countValue;
  StatisticsChartItem({
    this.date,
    this.groupId,
    this.groupName,
    this.countValue,
  });

  static StatisticsChartItem fromJSON(Map<String, Object?> json) =>
      StatisticsChartItem(
          groupId: json['id'] as int?,
          groupName: json['name'] as String?,
          date: json['date'] != null
              ? DateTime.tryParse((json['date'] as String).substring(0, 10))
              : null,
          countValue: json['count'] as int?);

  Map<String, Object?> toJson() => {
        'id': groupId,
        'name': groupName,
        'date': date?.toIso8601String(),
        'count': countValue,
      };
}
