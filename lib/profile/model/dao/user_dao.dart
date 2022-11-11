import 'package:myworkout/core/services/database_provider.dart';
import 'package:myworkout/profile/model/entity/user.dart';
import 'package:myworkout/profile/model/entity/user_measurements.dart';
import 'package:myworkout/profile/model/entity/user_statistic.dart';

class UserDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<User> getUser() async {
    /* récupérer les données de l'utilisateur*/
    var db = await dbProvider.db;
    final result = await db!.query(
      'user',
      columns: UserFields.values,
      where: '${UserFields.id} =  ?',
      whereArgs: [1],
    );
    if (result.isNotEmpty) {
      return User.fromJSON(result.first);
    } else {
      throw Exception('User don\'t exists');
    }
  }

  Future<UserMeasurements> getLatestUserMeasurements() async {
    /* récupérer les données de l'utilisateur*/
    var db = await dbProvider.db;
    final result = await db!.rawQuery('SELECT * from latest_measurements_view');

    UserMeasurements? userMeasurements = result.isNotEmpty
        ? result.map((item) => UserMeasurements.fromJSON(item)).toList().first
        : UserMeasurements();
    return userMeasurements;
  }

  Future<int> updateUser(User user) async {
    /*mettre à jour les données d'un workout*/
    var db = await dbProvider.db;
    return await db!.update(
      'user',
      user.toJSON(),
      where: '${UserFields.id} =  ?',
      whereArgs: [user.id],
    );
  }

  Future<void> saveUserMeasurements(
      UserMeasurements userMeasurements, DateTime date) async {
    /* sauvegarder les nouvelles mensurations d'un user */
    var db = await dbProvider.db;
    var dateString = date.toIso8601String();
    userMeasurements.toJSON().forEach((key, value) async {
      if (value != null) {
        await db!.rawInsert(
            'INSERT into user_statistics (type,value,date) VALUES (\'$key\',$value,\'$dateString\');');
      }
    });
  }

  Future<List<UserStatistic>> getUserStatistics(int userId, String type) async {
    var db = await dbProvider.db;
    final result = await db!.rawQuery(
        'SELECT date, value FROM user_statistics WHERE user_id = ? and type = ? ORDER BY date;',
        [userId, type]);
    List<UserStatistic> userStatistics = result.isNotEmpty
        ? result.map((item) => UserStatistic.fromJSON(item)).toList()
        : [];
    return userStatistics;
  }
}
