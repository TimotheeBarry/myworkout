import 'package:flutter/material.dart';
import 'package:myworkout/exercises/model/entity/exercise.dart';
import 'package:myworkout/workouts/model/dao/workouts_dao.dart';
import 'package:myworkout/workouts/model/entity/exercise_performance.dart';
import 'package:myworkout/workouts/model/entity/exercise_set.dart';
import 'package:myworkout/workouts/model/entity/workout_exercise.dart';
import 'package:myworkout/workouts/model/entity/workout_exercise_session.dart';
import 'package:myworkout/workouts/model/entity/workout_session.dart';

class WorkoutSessionController {
  /*variables pour stocker les données de la séance*/
  WorkoutSession? workoutSession; //infos générale de la session
  List<WorkoutExercise> workoutExercises; //objectifs prédéfinis
  List<WorkoutExerciseSession> workoutExercisesSession =
      []; //performances à entrer au fur et à mesure

  /*variables pour décrire l'avancement de la séance*/
  int currentExercise; //index de l'exercice en cours dans la séance
  List<ExerciseSet> currentExerciseSets;
  int currentSet; //index de la série en cours de l'exercice en cours
  bool setOngoing;
  List<WorkoutExerciseSession> workoutLastSessionList;
  BuildContext? context;

  WorkoutSessionController(
      {this.workoutSession,
      required this.workoutExercises,
      required this.workoutExercisesSession,
      required this.workoutLastSessionList,
      this.currentExercise = 0,
      required this.currentExerciseSets,
      this.currentSet = 0,
      this.setOngoing = true,
      this.context});

  void initSession(workoutId) async {
    /* initialisation de la séance: à appeler au tout début de la séance*/
    var _workoutSession =
        WorkoutSession(workoutId: workoutId, date: DateTime.now());
    var dao = WorkoutsDao();
    var workoutSessionId = await dao.initWorkoutSession(_workoutSession);
    if (workoutSessionId != 0) {
      //si il n'y a aps eu d'erreur lors de la création de la session
      workoutSession = _workoutSession.copy(id: workoutSessionId);
    }
  }

  void goToNextSet() {
    if (setOngoing) {
      /*on passe à la page du timer*/
      setOngoing = false;
    } else {
      /*sauvegarde de la série*/
      if (currentSet == 0) {
        /*création de l'objet WorkoutExerciseSession*/
        var _workoutExerciseSession = WorkoutExerciseSession(
          listIndex: currentExercise,
          workoutSessionId: workoutSession!.id,
          exercise: workoutExercises[currentExercise].exercise,
          exercisePerformanceGoal:
              workoutExercises[currentExercise].exercisePerformance,
          exercisePerformanceDone:
              ExercisePerformance().getFromSets(currentExerciseSets),
        );
        /*sauvegarde en bdd + sauvegarde de l'id*/
        saveAndCreateExercise(_workoutExerciseSession);
      } else {
        /*cas ou on est à une série > 0, donc l'objet WorkoutExerciseSession existe déjà dans la liste*/
        workoutExercisesSession.last = workoutExercisesSession.last.copy(
            exercisePerformanceDone:
                ExercisePerformance().getFromSets(currentExerciseSets));
        updateExercise(workoutExercisesSession.last);
      }
      /*passage à la série/exercice suivant ou fin de la séance*/
      if (currentSet + 1 <
          workoutExercises[currentExercise].exercisePerformance!.sets!) {
        /*on passe à la série suivante du meme exercice*/
        currentSet++;
        setOngoing = true;
      } else if (currentExercise + 1 < workoutExercises.length) {
        /*on passe à l'exercice suivant*/
        currentSet = 0;
        currentExercise++;
        setOngoing = true;
        currentExerciseSets = [];
      } else {
        /*séance terminée*/
        endWorkout();
      }
    }
  }

  // goToNextExercise() {
  //   /* ajout des performances + infos de l'exercice dans la liste*/
  //   var _workoutExerciseSession = WorkoutExerciseSession(
  //     listIndex: currentExercise,
  //     workoutSessionId: workoutSession!.id,
  //     exercise: workoutExercises[currentExercise].exercise,
  //     exercisePerformanceGoal:
  //         workoutExercises[currentExercise].exercisePerformance,
  //     exercisePerformanceDone:
  //         ExercisePerformance().getFromSets(currentExerciseSets),
  //   );
  //   /*ajout dans la liste de la séance*/
  //   workoutExercisesSession.add(
  //     _workoutExerciseSession,
  //   );

  //   /*passage a l'exo suivant*/
  //   currentSet = 0;
  //   currentExercise++;
  //   setOngoing = true;
  //   currentExerciseSets = [];

  //   /*ajout en bdd*/
  //   saveExercise(_workoutExerciseSession);
  // }

  Future<void> saveAndCreateExercise(WorkoutExerciseSession exercise) async {
    var dao = WorkoutsDao();
    var id = await dao.createWorkoutExerciseSession(exercise);
    /*ajout de l'objet avec son id dans la liste de la séance*/
    return workoutExercisesSession.add(exercise.copy(id: id));
  }

  Future<void> updateExercise(WorkoutExerciseSession exercise) async {
    var dao = WorkoutsDao();
    return dao.updateWorkoutExerciseSession(exercise);
  }

  void savePerformance(num reps, num load, num rest) {
    currentExerciseSets.add(ExerciseSet(reps: reps, load: load, rest: rest));
  }

  ExerciseSet get currentExerciseSet {
    //obtenir les objectifs série en cours (reps, load, rest)
    return workoutExercises[currentExercise].getExerciseSets()[currentSet];
  }

  ExerciseSet? get lastExerciseSet {
    //obtenir les performances de la série en cours de la dernière séance s'il y en a
    var list = workoutLastSessionList
        .where((exerciseSession) =>
            exerciseSession.exercise!.id == currentExerciseData.id)
        .toList();
    if (list.isEmpty) {
      return null;
    }
    var exercise = list.first;
    var exerciseSetsList =
        exercise.getExerciseSets(exercise.exercisePerformanceDone!);
    return exerciseSetsList.length > currentSet
        ? exerciseSetsList[currentSet]
        : null;
  }

  Exercise get currentExerciseData {
    //obtenir les infos de l'exercice en cours
    return workoutExercises[currentExercise].exercise!;
  }

  Exercise? get nextSetExerciseData {
    //obtenir les infos de l'exercice de la prochaine série
    var nextExercise = nextExerciseIndex;
    return nextExercise != null
        ? workoutExercises[nextExercise].exercise!
        : null;
  }

  int get exerciseSetsCount {
    //obtenir le nombre de série d'un exercice
    return workoutExercises[currentExercise].getExerciseSets().length;
  }

  int? get nextSetIndex {
    //obtenir l'indice de la prochaine série (ou null)
    int nextSet;
    if (currentSet + 1 <
        workoutExercises[currentExercise].exercisePerformance!.sets!) {
      nextSet = currentSet + 1;
    } else if (currentExercise + 1 < workoutExercises.length) {
      nextSet = 0;
    } else {
      return null;
    }
    return nextSet;
  }

  int? get nextExerciseIndex {
    //obtneir l'indice du prochain exercice (ou null)
    int nextExercise;
    if (currentSet + 1 <
        workoutExercises[currentExercise].exercisePerformance!.sets!) {
      nextExercise = currentExercise;
    } else if (currentExercise + 1 < workoutExercises.length) {
      nextExercise = currentExercise + 1;
    } else {
      return null;
    }
    return nextExercise;
  }

  ExerciseSet? get nextExerciseSet {
    //obtenir les objectifs de la prochaine série (s'il y a une)
    var nextSet = nextSetIndex;
    var nextExercise = nextExerciseIndex;
    if (nextSet != null && nextExercise != null) {
      return workoutExercises[nextExercise].getExerciseSets()[nextSet];
    }
    return null;
  }

  ExerciseSet? get lastNextExerciseSet {
    //obtenir les performances de la prochaine série au cours de la dernière séance
    var nextExercise = nextSetExerciseData;
    var nextSet = nextSetIndex;
    if (nextExercise == null || nextSet == null) {
      return null;
    }
    var list = workoutLastSessionList.where(
        (exerciseSession) => exerciseSession.exercise!.id == nextExercise.id);
    if (list.isEmpty) {
      return null;
    }
    var exercise = list.first;
    var exerciseSetsList =
        exercise.getExerciseSets(exercise.exercisePerformanceDone!);
    return exerciseSetsList.length > nextSet ? exerciseSetsList[nextSet] : null;
  }

  void endWorkout() {
    try {
      Navigator.pop(context!);
      Navigator.pop(context!);
    } catch (error) {
      print(error);
    }
  }
}
