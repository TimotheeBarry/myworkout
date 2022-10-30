import 'package:myworkout/core/services/database_provider.dart';
import 'package:myworkout/profile/model/entity/user.dart';
import 'package:myworkout/workouts/model/entity/workout.dart';
import 'package:myworkout/workouts/model/entity/workout_group.dart';

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
}
