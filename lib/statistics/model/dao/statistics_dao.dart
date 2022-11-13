import 'package:myworkout/core/services/database_provider.dart';
import 'package:myworkout/statistics/model/entity/statistic_item.dart';

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
}
