import 'package:myworkout/core/services/database_provider.dart';
import 'package:myworkout/workouts/model/entity/workout.dart';
import 'package:myworkout/workouts/model/entity/workout_group.dart';

class WorkoutsDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<Workout> getWorkout(id) async {
    /* récupérer un workout par son id*/
    var db = await dbProvider.db;
    final result = await db!.query(
      'workouts',
      columns: WorkoutFields.values,
      where: '${WorkoutFields.id} =  ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Workout.fromJSON(result.first);
    } else {
      throw Exception('Workout: ID $id not found');
    }
  }

  Future<List<WorkoutGroup>> getWorkoutGroups() async {
    /*récupérer les données de tous les groupes*/
    var db = await dbProvider.db;
    
    var workouts = await getWorkouts();

    var result = await db!.query(
      'workout_groups',
      columns: WorkoutGroupFields.values,
    );

    List<WorkoutGroup> workoutGroups = result.isNotEmpty
        ? result.map((item) => WorkoutGroup.fromJSON(item)).toList()
        : [];
    return workoutGroups
        .map((workoutGroup) => workoutGroup.copy(
            workouts: workouts
                .where((workout) => workout.groupId == workoutGroup.id)
                .toList()))
        .toList();
    ;
  }

  Future<List<Workout>> getWorkouts() async {
    /*récupérer les données de tous les workouts*/
    var db = await dbProvider.db;
    List<Map<String, dynamic>> result;

    result = await db!.query('workouts', columns: WorkoutFields.values);

    List<Workout> workouts = result.isNotEmpty
        ? result.map((item) => Workout.fromJSON(item)).toList()
        : [];
    return workouts;
  }

  Future<Workout> createWorkout(Workout workout) async {
    /*creer un nouveau workout*/
    var db = await dbProvider.db;
    final id =
        await db!.insert('workouts', workout.toJSON()).then((value) => null);
    return workout.copy(id: id);
  }

  Future<WorkoutGroup> createWorkoutgroup(WorkoutGroup workoutGroup) async {
    /*creer un nouveau groupe*/
    var db = await dbProvider.db;
    final id = await db!.insert('workout_groups', workoutGroup.toJSON());
    return workoutGroup.copy(id: id);
  }

  Future<int> updateWorkout(Workout workout) async {
    /*mettre à jour les données d'un workout*/
    var db = await dbProvider.db;
    return await db!.update(
      'workouts',
      workout.toJSON(),
      where: '${WorkoutFields.id} =  ?',
      whereArgs: [workout.id],
    );
  }

  Future<int> updateWorkoutGroup(WorkoutGroup workoutGroup) async {
    /*mettre à jour les données d'un groupe*/
    var db = await dbProvider.db;
    return await db!.update(
      'workout_groups',
      workoutGroup.toJSON(),
      where: '${WorkoutGroupFields.id} =  ?',
      whereArgs: [workoutGroup.id],
    );
  }
}
