import 'package:flutter/material.dart';
import 'package:myworkout/workouts/model/dao/workouts_dao.dart';
import 'package:myworkout/workouts/model/entity/workout.dart';
import 'package:myworkout/workouts/model/entity/workout_exercise.dart';
import 'package:myworkout/workouts/util/workout_app_bar.dart';
import 'package:myworkout/workouts/view/workout_during_rest_view.dart';
import 'package:myworkout/workouts/view/workout_during_set_view.dart';
import '../../core/theme/styles.dart' as styles;

class WorkoutSessionView extends StatefulWidget {
  const WorkoutSessionView({Key? key, required this.workout}) : super(key: key);
  final Workout workout;

  @override
  State<WorkoutSessionView> createState() => _WorkoutSessionViewState();
}

class _WorkoutSessionViewState extends State<WorkoutSessionView> {
  List<WorkoutExercise> workoutExercises = [];
  int currentExercise = 0; //index de l'exercice en cours dans la séance
  int currentSet = 0; //index de la série en cours de l'exercice en cours
  bool setOngoing = true; //si la série est en cours ou finie

  void nextSet() {
    if (setOngoing) {
      /*on passe à la page du timer*/
      setState(() {
        setOngoing = false;
      });
    } else if (currentSet + 1 <
        workoutExercises[currentExercise].exercisePerformance!.sets!) {
      /*on passe à la série suivante du meme exercice*/
      setState(() {
        currentSet++;
        setOngoing = true;
      });
    } else if (currentExercise + 1 < workoutExercises.length) {
      /*on passe à l'exercice suivant*/
      setState(() {
        currentSet = 0;
        currentExercise++;
        setOngoing = true;
      });
    } else {
      /*séance terminée*/
    }
  }

  void getData() async {
    final dao = WorkoutsDao();
    var _workoutExercises = await dao.getWorkoutSession(widget.workout);
    setState(() {
      workoutExercises = _workoutExercises;
    });
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
        body: SingleChildScrollView(
          child: setOngoing
              ? WorkoutDuringSetView(
                  exercise: workoutExercises[currentExercise].exercise!,
                  exerciseSet: workoutExercises[currentExercise]
                      .getExerciseSets()[currentSet])
              : WorkoutDuringRestView(
                  nextSet: nextSet,
                  exercise: workoutExercises[currentExercise].exercise!,
                  exerciseSet: workoutExercises[currentExercise]
                      .getExerciseSets()[currentSet]),
        ),
      ),
    );
  }
}
