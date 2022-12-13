import 'package:flutter/material.dart';
import 'package:myworkout/core/util/custom_button.dart';
import 'package:myworkout/exercises/model/entity/exercise.dart';
import 'package:myworkout/workouts/model/dao/workouts_dao.dart';
import 'package:myworkout/workouts/model/entity/exercise_performance.dart';
import 'package:myworkout/workouts/model/entity/exercise_set.dart';
import 'package:myworkout/workouts/model/entity/workout.dart';
import 'package:myworkout/workouts/model/entity/workout_exercise.dart';
import 'package:myworkout/workouts/model/entity/workout_exercise_session.dart';
import 'package:myworkout/workouts/model/entity/workout_session.dart';
import 'package:myworkout/workouts/util/workout_app_bar.dart';
import 'package:myworkout/workouts/view/workout_during_rest_view.dart';
import 'package:myworkout/workouts/view/workout_during_set_view.dart';
import '../../core/theme/styles.dart' as styles;

class WorkoutSessionView extends StatefulWidget {
  const WorkoutSessionView(
      {Key? key,
      required this.workout,
      required this.lastWorkoutSession,
      required this.workoutLastSessionList})
      : super(key: key);
  final Workout workout;
  final WorkoutSession lastWorkoutSession;
  final List<WorkoutExerciseSession> workoutLastSessionList;

  @override
  State<WorkoutSessionView> createState() => _WorkoutSessionViewState();
}

class _WorkoutSessionViewState extends State<WorkoutSessionView> {
  WorkoutSessionController sessionController = WorkoutSessionController(
    workoutExercises: [],
    workoutExercisesSession: [],
    currentExerciseSets: [],
    workoutLastSessionList: [],
  );

  void getData() async {
    final dao = WorkoutsDao();
    var _workoutExercises = await dao.getWorkoutSessionGoals(widget.workout);
    setState(() {
      sessionController.workoutExercises = _workoutExercises;
      sessionController.workoutLastSessionList = widget.workoutLastSessionList;
      sessionController.initSession(widget.workout.id);
    });
  }

  void nextSet() async {
    setState(() => sessionController.goToNextSet());
  }

  Widget buildPage() {
    if (sessionController.workoutExercises.isEmpty) {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }

    return sessionController.setOngoing
        ? WorkoutDuringSetView(
            exercise: sessionController.getCurrentExercise(),
            exerciseSet: sessionController.getCurrentExerciseSet(),
            lastExerciseSet: sessionController.getLastExerciseSet(),
            lastSessionDate: widget.lastWorkoutSession.date,
          )
        : WorkoutDuringRestView(
            nextSet: nextSet,
            exercise: sessionController.getCurrentExercise(),
            exerciseSet: sessionController.getCurrentExerciseSet(),
            savePerformance: sessionController.savePerformance,
          );
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: styles.page.boxDecoration,
      child: Scaffold(
        appBar: WorkoutAppBar(currentSet: 0, nextSet: nextSet),
        bottomNavigationBar: sessionController.setOngoing
            ? SizedBox(
                height: 64,
                child: CustomButton(
                  onTap: nextSet,
                  title: Text('Série terminée',
                      style: styles.button.mediumText),
                ))
            : const SizedBox.shrink(),
        body: SingleChildScrollView(
            padding: styles.page.margin, child: buildPage()),
      ),
    );
  }
}

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

  WorkoutSessionController(
      {this.workoutSession,
      required this.workoutExercises,
      required this.workoutExercisesSession,
      required this.workoutLastSessionList,
      this.currentExercise = 0,
      required this.currentExerciseSets,
      this.currentSet = 0,
      this.setOngoing = true});

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

  goToNextSet() {
    if (setOngoing) {
      /*on passe à la page du timer*/
      setOngoing = false;
    } else if (currentSet + 1 <
        workoutExercises[currentExercise].exercisePerformance!.sets!) {
      /*on passe à la série suivante du meme exercice*/
      currentSet++;
      setOngoing = true;
    } else if (currentExercise + 1 < workoutExercises.length) {
      /*on passe à l'exercice suivant*/
      goToNextExercise();
    } else {
      /*séance terminée*/
      endWorkout();
    }
  }

  goToNextExercise() {
    /* ajout des performances + infos de l'exercice dans la liste*/
    var _workoutExerciseSession = WorkoutExerciseSession(
      listIndex: currentExercise,
      workoutSessionId: workoutSession!.id,
      exercise: workoutExercises[currentExercise].exercise,
      exercisePerformanceGoal:
          workoutExercises[currentExercise].exercisePerformance,
      exercisePerformanceDone:
          ExercisePerformance().getFromSets(currentExerciseSets),
    );
    /*ajout dans la liste de la séance*/
    workoutExercisesSession.add(
      _workoutExerciseSession,
    );

    /*passage a l'exo suivant*/
    currentSet = 0;
    currentExercise++;
    setOngoing = true;
    currentExerciseSets = [];

    /*ajout en bdd*/
    saveExercise(_workoutExerciseSession);
  }

  void saveExercise(exercise) async {
    var dao = WorkoutsDao();
    dao.createWorkoutExerciseSession(exercise);
  }

  void savePerformance(num reps, num load, num rest) {
    currentExerciseSets.add(ExerciseSet(reps: reps, load: load, rest: rest));
  }

  ExerciseSet getCurrentExerciseSet() {
    return workoutExercises[currentExercise].getExerciseSets()[currentSet];
  }

  ExerciseSet? getLastExerciseSet() {
    var list = workoutLastSessionList.where((exerciseSession) =>
        exerciseSession.exercise!.id == getCurrentExercise().id);
    var exercise = list.isNotEmpty ? list.first : null;
    if (exercise == null) {
      return null;
    }
    var exerciseSetsList =
        exercise.getExerciseSets(exercise.exercisePerformanceDone!);
    return exerciseSetsList.length > currentSet
        ? exerciseSetsList[currentSet]
        : null;
  }

  Exercise getCurrentExercise() {
    return workoutExercises[currentExercise].exercise!;
  }

  void endWorkout() {}
}
