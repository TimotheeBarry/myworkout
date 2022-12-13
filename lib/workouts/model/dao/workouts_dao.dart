import 'package:myworkout/core/services/database_provider.dart';
import 'package:myworkout/workouts/model/entity/workout.dart';
import 'package:myworkout/workouts/model/entity/workout_exercise.dart';
import 'package:myworkout/workouts/model/entity/workout_exercise_session.dart';
import 'package:myworkout/workouts/model/entity/workout_group.dart';
import 'package:myworkout/workouts/model/entity/workout_session.dart';

class WorkoutsDao {
  final dbProvider = DatabaseProvider.dbProvider;

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

  Future<List<WorkoutExercise>> getWorkoutSessionGoals(Workout workout) async {
    var db = await dbProvider.db;

    var query = '''
SELECT 
  workout_exercise_goals.id,
  workout_exercise_goals.workout_id,
  workout_exercise_goals.exercise_id,
  workout_exercise_goals.list_index,
  workout_exercise_goals.sets,
  workout_exercise_goals.reps,
  workout_exercise_goals.loads,
  workout_exercise_goals.rests,
  exercises.name,
  exercises.description,
  exercises.image_id
FROM workout_exercise_goals 
JOIN exercises ON workout_exercise_goals.exercise_id = exercises.id
WHERE workout_id = ${workout.id}
ORDER BY list_index;
''';
    var result = await db!.rawQuery(query);

    List<WorkoutExercise> workoutExercises = result.isNotEmpty
        ? result.map((item) => WorkoutExercise.fromJSON(item)).toList()
        : [];
    return workoutExercises;
  }

  Future updateWorkoutExerciseGoal(WorkoutExercise workoutExercise) async {
    var db = await dbProvider.db;

    return await db!.update(
      'workout_exercise_goals',
      workoutExercise.toJSON(),
      where: '${WorkoutExerciseFields.id} =  ?',
      whereArgs: [workoutExercise.id],
    );
  }

  Future createWorkoutExerciseGoal(WorkoutExercise workoutExercise) async {
    var db = await dbProvider.db;

    return await db!.insert(
      'workout_exercise_goals',
      workoutExercise.toJSON(),
    );
  }

  Future updateWorkoutSessionGoals(
      Workout workout, List<WorkoutExercise> workoutExercises) async {
    var db = await dbProvider.db;
    //on supprime la session existante et on ajoute la nouvelle, mise a jour.
    await db!.delete(
      'workout_exercise_goals',
      where: 'workout_id = ?',
      whereArgs: [workout.id],
    );
    for (var workoutExercise in workoutExercises) {
      await createWorkoutExerciseGoal(workoutExercise);
    }
  }

  Future<List<WorkoutExerciseSession>> getWorkoutSession(
      int workoutSessionId) async {
    var db = await dbProvider.db;

    var query = '''
SELECT 
  workout_exercise_session.id,
  workout_exercise_session.workout_session_id,
  workout_exercise_session.exercise_id,
  workout_exercise_session.list_index,
  workout_exercise_session.sets_goal,
  workout_exercise_session.reps_goal,
  workout_exercise_session.loads_goal,
  workout_exercise_session.rests_goal,
  workout_exercise_session.sets_done,
  workout_exercise_session.reps_done,
  workout_exercise_session.loads_done,
  workout_exercise_session.rests_done,
  workout_exercise_session.note,
  exercises.name,
  exercises.description,
  exercises.image_id
FROM workout_exercise_session 
JOIN exercises ON workout_exercise_session.exercise_id = exercises.id
WHERE workout_session_id = $workoutSessionId
ORDER BY list_index;
''';
    var result = await db!.rawQuery(query);

    List<WorkoutExerciseSession> workoutExerciseSession = result.isNotEmpty
        ? result.map((item) => WorkoutExerciseSession.fromJSON(item)).toList()
        : [];
    return workoutExerciseSession;
  }

  Future initWorkoutSession(WorkoutSession workoutSession) async {
    var db = await dbProvider.db;
    return await db!.insert('workout_session', workoutSession.toJSON());
  }

  Future<void> createWorkoutExerciseSession(
    WorkoutExerciseSession workoutExerciseSession,
  ) async {
    var db = await dbProvider.db;

    await db!.insert(
      'workout_exercise_session',
      workoutExerciseSession.toJSON(),
    );
  }

  Future<WorkoutSession> getLastWorkoutSession(int workoutId) async {
    var db = await dbProvider.db;

    var query =
        'SELECT id, date, notes, workout_id FROM workout_session WHERE workout_id = $workoutId ORDER BY date DESC LIMIT 1;';
    var result = await db!.rawQuery(query);
    WorkoutSession workoutSession = result.isNotEmpty
        ? WorkoutSession.fromJSON(result[0])
        : WorkoutSession(id: 0); 
   
    return workoutSession;
  }
}
