import 'package:flutter/cupertino.dart';
import 'package:myworkout/core/services/database_provider.dart';
import 'package:myworkout/exercises/model/entity/exercise.dart';
import 'package:myworkout/exercises/model/entity/exercise_group.dart';

class ExercisesDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<Exercise> getExercise(id) async {
    /* récupérer un exercice par son id*/
    var db = await dbProvider.db;
    final result = await db!.query(
      'exercises',
      columns: ExerciseFields.values,
      where: '${ExerciseFields.id} =  ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Exercise.fromJSON(result.first);
    } else {
      throw Exception('Exercise: ID $id not found');
    }
  }

  Future<List<ExerciseGroup>> getExerciseGroups() async {
    /*récupérer les données de tous les groupes*/
    var db = await dbProvider.db;
    List<Map<String, dynamic>> result;

    result =
        await db!.query('exercise_groups', columns: ExerciseGroupFields.values);

    List<ExerciseGroup> exerciseGroups = result.isNotEmpty
        ? result.map((item) => ExerciseGroup.fromJSON(item)).toList()
        : [];
    return exerciseGroups;
  }

  Future<List<Exercise>> getExercises() async {
    /*récupérer les données de tous les exercices*/
    var db = await dbProvider.db;
    List<Map<String, dynamic>> result;

    result = await db!.query('exercises', columns: ExerciseFields.values);

    List<Exercise> exercises = result.isNotEmpty
        ? result.map((item) => Exercise.fromJSON(item)).toList()
        : [];
    return exercises;
  }

  Future<Exercise> createExercise(Exercise exercise) async {
    /*creer un nouvel exercice*/
    var db = await dbProvider.db;
    final id = await db!.insert('exercises', exercise.toJSON()).then((value) => null);
    return exercise.copy(id: id);
  }

  Future<ExerciseGroup> createExercisegroup(ExerciseGroup exerciseGroup) async {
    /*creer un nouveau groupe*/
    var db = await dbProvider.db;
    final id = await db!.insert('exercise_groups', exerciseGroup.toJSON());
    return exerciseGroup.copy(id: id);
  }

  Future<int> updateExercise(Exercise exercise) async {
    /*mettre à jour les données d'un exercice*/
    var db = await dbProvider.db;
    return await db!.update(
      'exercises',
      exercise.toJSON(),
      where: '${ExerciseFields.id} =  ?',
      whereArgs: [exercise.id],
    );
  }

  Future<int> updateExerciseGroup(ExerciseGroup exerciseGroup) async {
    /*mettre à jour les données d'un groupe*/
    var db = await dbProvider.db;
    return await db!.update(
      'exercise_groups',
      exerciseGroup.toJSON(),
      where: '${ExerciseGroupFields.id} =  ?',
      whereArgs: [exerciseGroup.id],
    );
  }
}
