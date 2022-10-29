import 'package:myworkout/core/services/database_provider.dart';
import 'package:myworkout/exercises/model/entity/exercise.dart';
import 'package:myworkout/exercises/model/entity/exercise_group.dart';

class ExercisesDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<List<ExerciseGroup>> getExerciseGroups() async {
    var db = await dbProvider.db;
    List<Map> list = await db!.rawQuery('SELECT * FROM exercise_groups ORDER BY name');
    List<ExerciseGroup> exerciseGroups = [];
    for (int i = 0; i < list.length; i++) {
      exerciseGroups.add(ExerciseGroup(
        id: list[i]["id"],
        name: list[i]["name"],
      ));
    }
    return exerciseGroups;
  }

  Future<List<Exercise>> getExercises() async {
    var db = await dbProvider.db;
    List<Map> list =
        await db!.rawQuery('SELECT * FROM exercises ORDER BY name');
    List<Exercise> exercises = [];
    for (int i = 0; i < list.length; i++) {
      exercises.add(Exercise(
        id: list[i]["id"],
        groupId: list[i]["group_id"],
        name: list[i]["name"],
        description: list[i]["description"],
      ));
    }
    return exercises;
  }

  Future<List<Exercise>> getExercisesByGroup(groupId) async {
    var db = await dbProvider.db;
    List<Map> list =
        await db!.rawQuery('SELECT * FROM exercises WHERE group_id=$groupId ORDER BY name');
    List<Exercise> exercises = [];
    for (int i = 0; i < list.length; i++) {
      exercises.add(Exercise(
        id: list[i]["id"],
        groupId: list[i]["group_id"],
        name: list[i]["name"],
        description: list[i]["description"],
      ));
    }
    return exercises;
  }
}
