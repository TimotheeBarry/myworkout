import 'package:myworkout/core/services/database_provider.dart';
import 'package:myworkout/workouts/model/entity/workout.dart';
import 'package:myworkout/workouts/model/entity/workout_group.dart';

class WorkoutsDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<List<WorkoutGroup>> getWorkoutGroups() async {
    var db = await dbProvider.db;
    List<Map> list =
        await db!.rawQuery('SELECT * FROM workout_groups ORDER BY name');
    List<WorkoutGroup> workoutGroups = [];
    for (int i = 0; i < list.length; i++) {
      workoutGroups.add(WorkoutGroup(
        id: list[i]["id"],
        name: list[i]["name"],
      ));
    }
    return workoutGroups;
  }

  Future<List<Workout>> getWorkouts() async {
    var db = await dbProvider.db;
    List<Map> list = await db!.rawQuery('SELECT * FROM workouts ORDER BY name');
    List<Workout> workouts = [];
    for (int i = 0; i < list.length; i++) {
      workouts.add(Workout(
        id: list[i]["id"],
        groupId: list[i]["group_id"],
        name: list[i]["name"],
        description: list[i]["description"],
      ));
    }
    return workouts;
  }

  Future<List<Workout>> getWorkoutsByGroup(groupId) async {
    var db = await dbProvider.db;
    List<Map> list = await db!.rawQuery(
        'SELECT * FROM workouts WHERE group_id=$groupId ORDER BY name');
    List<Workout> workouts = [];
    for (int i = 0; i < list.length; i++) {
      workouts.add(Workout(
        id: list[i]["id"],
        groupId: list[i]["group_id"],
        name: list[i]["name"],
        description: list[i]["description"],
      ));
    }
    return workouts;
  }
}
