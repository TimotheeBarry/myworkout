import 'package:flutter/material.dart';
import 'package:myworkout/core/util/custom_button.dart';
import 'package:myworkout/workouts/model/entity/workout.dart';
import 'package:myworkout/workouts/model/entity/workout_exercise.dart';
import 'package:myworkout/workouts/model/entity/workout_exercise_session.dart';
import 'package:myworkout/workouts/model/entity/workout_session.dart';
import 'package:myworkout/workouts/util/workout_app_bar.dart';
import 'package:myworkout/workouts/util/workout_session_controller.dart';
import 'package:myworkout/workouts/view/workout_during_rest_view.dart';
import 'package:myworkout/workouts/view/workout_during_set_view.dart';
import '../../core/theme/styles.dart' as styles;

class WorkoutSessionView extends StatefulWidget {
  const WorkoutSessionView(
      {Key? key,
      required this.workout,
      required this.workoutExercises,
      required this.lastWorkoutSession,
      required this.workoutLastSessionList})
      : super(key: key);
  final List<WorkoutExercise> workoutExercises;
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

  void initData() async {
    setState(() {
      sessionController.context = context;
      sessionController.workoutExercises = widget.workoutExercises;
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
            exercise: sessionController.currentExerciseData,
            exerciseSet: sessionController.currentExerciseSet,
            lastExerciseSet: sessionController.lastExerciseSet,
            lastSessionDate: widget.lastWorkoutSession.date,
            currentSet: sessionController.currentSet + 1,
            totalSets: sessionController.exerciseSetsCount,
          )
        : WorkoutDuringRestView(
            nextSet: nextSet,
            exercise: sessionController.currentExerciseData,
            exerciseSet: sessionController.currentExerciseSet,
            nextExerciseSet: sessionController.nextExerciseSet,
            lastNextExerciseSet: sessionController.lastNextExerciseSet,
            lastSessionDate: widget.lastWorkoutSession.date,
            nextExercise: sessionController.nextSetExerciseData,
            savePerformance: sessionController.savePerformance,
            currentSet: sessionController.currentSet + 1,
            totalSets: sessionController.exerciseSetsCount,
          );
  }

  @override
  void initState() {
    initData();
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
                  title: Text('Série terminée', style: styles.button.bigText),
                ))
            : const SizedBox.shrink(),
        body: SingleChildScrollView(
            padding: styles.page.margin,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: buildPage()),
      ),
    );
  }
}
