import 'package:intl/intl.dart';
import 'package:myworkout/core/services/database_provider.dart';
import 'package:myworkout/statistics/model/entity/statistic_item.dart';
import 'package:myworkout/statistics/model/entity/statistics_chart_item.dart';

class StatisticsDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<List<StatisticItem>> getStatisticsList() async {
    var db = await dbProvider.db;

    var query = '''
SELECT 
  workout_session.id,
  workout_session.date,
  workout_session.workout_id,
  workouts.name as workout_name,
  workouts.group_id,
  workout_groups.name as group_name

FROM workout_session
JOIN workouts ON workout_session.workout_id = workouts.id
JOIN workout_groups ON workouts.group_id = workout_groups.id
ORDER BY date DESC;
''';
    var result = await db!.rawQuery(query);

    List<StatisticItem> statisticItem = result.isNotEmpty
        ? result.map((item) => StatisticItem.fromJSON(item)).toList()
        : [];
    return statisticItem;
  }

  Future<List<StatisticsChartItem>> getSetsForChart({DateTime? minDate}) async {
    var db = await dbProvider.db;
    var dateString =
        minDate != null ? DateFormat('yyyy-MM-dd').format(minDate) : null;
    var query = '''
SELECT 
exercise_groups.id,
exercise_groups.name,
workout_session.date,
sum(workout_exercise_session.sets_done) as count
FROM workout_exercise_session
INNER JOIN exercises ON exercises.id = workout_exercise_session.exercise_id
INNER JOIN exercise_groups ON exercise_groups.id = exercises.group_id
INNER JOIN workout_session ON workout_session.id = workout_exercise_session.workout_session_id
${dateString != null ? "WHERE workout_session.date >= '$dateString'" : ""}
GROUP BY workout_session.date,exercise_groups.id
ORDER BY workout_session.date desc
;
''';
    var result = await db!.rawQuery(query);
    List<StatisticsChartItem> statisticsChartItem = result.isNotEmpty
        ? result.map((item) => StatisticsChartItem.fromJSON(item)).toList()
        : [];
    return statisticsChartItem;
  }
}
