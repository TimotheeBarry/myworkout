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

  Future<UserMeasurements> getUserMeasurements() async {
    /* récupérer les données de l'utilisateur*/
    const userId = 1;

    var height = await getLastStatistic(userId, UserMeasurementsFields.height);
    var weight = await getLastStatistic(userId, UserMeasurementsFields.weight);
    var bodyfat =
        await getLastStatistic(userId, UserMeasurementsFields.bodyfat);
    var neck = await getLastStatistic(userId, UserMeasurementsFields.neck);
    var chest = await getLastStatistic(userId, UserMeasurementsFields.chest);
    var shoulders =
        await getLastStatistic(userId, UserMeasurementsFields.shoulders);
    var bicepsL =
        await getLastStatistic(userId, UserMeasurementsFields.bicepsL);
    var bicepsR =
        await getLastStatistic(userId, UserMeasurementsFields.bicepsR);
    var forearmL =
        await getLastStatistic(userId, UserMeasurementsFields.forearmL);
    var forearmR =
        await getLastStatistic(userId, UserMeasurementsFields.forearmR);
    var wristL = await getLastStatistic(userId, UserMeasurementsFields.wristL);
    var wristR = await getLastStatistic(userId, UserMeasurementsFields.wristR);
    var waist = await getLastStatistic(userId, UserMeasurementsFields.waist);
    var hips = await getLastStatistic(userId, UserMeasurementsFields.hips);
    var thighL = await getLastStatistic(userId, UserMeasurementsFields.thighL);
    var thighR = await getLastStatistic(userId, UserMeasurementsFields.thighR);
    var calveL = await getLastStatistic(userId, UserMeasurementsFields.calveL);
    var calveR = await getLastStatistic(userId, UserMeasurementsFields.calveR);
    var ankleL = await getLastStatistic(userId, UserMeasurementsFields.ankleL);
    var ankleR = await getLastStatistic(userId, UserMeasurementsFields.ankleR);

    return UserMeasurements(
      height: height,
      weight: weight,
      bodyfat: bodyfat,
      neck: neck,
      shoulders: shoulders,
      chest: chest,
      bicepsL: bicepsL,
      bicepsR: bicepsR,
      forearmL: forearmL,
      forearmR: forearmR,
      wristL: wristL,
      wristR: wristR,
      waist: waist,
      hips: hips,
      thighL: thighL,
      thighR: thighR,
      calveL: calveL,
      calveR: calveR,
      ankleL: ankleL,
      ankleR: ankleR,
    );
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

  Future<UserStatistic?> getLastStatistic(userId, type) async {
    /* récupérer les dernières statistiques de l'utilisateur du type 'type'*/

    var db = await dbProvider.db;
    final result = await db!.query('user_statistics',
        columns: UserStatisticFields.values,
        where:
            '${UserStatisticFields.userId} =  ? AND ${UserStatisticFields.type} = ?',
        whereArgs: [userId, type],
        orderBy: 'date',
        limit: 1);

    UserStatistic? userStatistics = result.isNotEmpty
        ? result.map((item) => UserStatistic.fromJSON(item)).toList().first
        : null;
    return userStatistics;
  }
}
