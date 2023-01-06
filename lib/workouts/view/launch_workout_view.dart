import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myworkout/core/util/custom_app_bar.dart';
import 'package:myworkout/core/util/custom_button.dart';
import 'package:myworkout/exercises/util/exercise_image.dart';
import 'package:myworkout/workouts/model/dao/workouts_dao.dart';
import 'package:myworkout/workouts/model/entity/exercise_set.dart';
import 'package:myworkout/workouts/model/entity/workout.dart';
import 'package:myworkout/workouts/model/entity/workout_exercise.dart';
import 'package:myworkout/workouts/model/entity/workout_exercise_session.dart';
import 'package:myworkout/workouts/model/entity/workout_session.dart';
import 'package:myworkout/workouts/util/next_exercise_buttons.dart';
import 'package:myworkout/workouts/util/performance_frame.dart';
import 'package:myworkout/workouts/util/title_subtitle.dart';
import 'package:myworkout/workouts/view/workout_session_view.dart';
import 'dart:math';
import '../../core/theme/styles.dart' as styles;

class LaunchWorkoutView extends StatefulWidget {
  const LaunchWorkoutView({Key? key, required this.workout}) : super(key: key);
  final Workout workout;
  @override
  State<LaunchWorkoutView> createState() => LaunchWorkoutViewState();
}

class LaunchWorkoutViewState extends State<LaunchWorkoutView> {
  List<WorkoutExercise> workoutExercises = [];
  late WorkoutSession lastWorkoutSession = WorkoutSession(id: 0);
  List<WorkoutExerciseSession> workoutLastSessionList = [];
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    var dao = WorkoutsDao();
    var _workoutExercises = await dao.getWorkoutSessionGoals(widget.workout);
    lastWorkoutSession = await dao.getLastWorkoutSession(widget.workout.id!);
    if (lastWorkoutSession.id != 0) {
      workoutLastSessionList =
          await dao.getWorkoutSession(lastWorkoutSession.id!);
    }
    setState(() {
      workoutExercises = _workoutExercises
          .map((workoutExercise) =>
              workoutExercise.copy(key: ValueKey(workoutExercise.listIndex)))
          .toList();
    });
  }

  void passExercise() {
    if (workoutExercises.length > 1) {
      setState(() {
        workoutExercises.removeAt(0);
      });
    }
  }

  ExerciseSet? getLastExerciseFirstSet() {
    var list = workoutLastSessionList.where((exerciseSession) =>
        exerciseSession.exercise!.id == workoutExercises[0].exercise!.id);
    var exercise = list.isNotEmpty ? list.first : null;
    if (exercise == null) {
      return null;
    }
    var exerciseSetsList =
        exercise.getExerciseSets(exercise.exercisePerformanceDone!);
    return exerciseSetsList.isNotEmpty ? exerciseSetsList.first : null;
  }

  @override
  Widget build(BuildContext context) {
    ExerciseSet exerciseTarget = workoutExercises.isNotEmpty
        ? workoutExercises[0].exercisePerformance!.getPerformances()[0]
        : ExerciseSet();
    ExerciseSet? exerciseLastPerformance =
        workoutLastSessionList.isNotEmpty ? getLastExerciseFirstSet() : null;
    return Container(
      decoration: styles.page.boxDecoration,
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.workout.name ?? "",
          subtitle: lastWorkoutSession.date != null
              ? 'Dernière séance: ${DateFormat('dd/MM/yyyy').format(lastWorkoutSession.date!)}'
              : null,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit_note_rounded),
            )
          ],
        ),
        bottomNavigationBar: SizedBox(
            height: 64,
            child: CustomButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WorkoutSessionView(
                            workout: widget.workout,
                            workoutExercises: workoutExercises,
                            lastWorkoutSession: lastWorkoutSession,
                            workoutLastSessionList: workoutLastSessionList,
                          )),
                );
              },
              title: Text('Démarrer la séance', style: styles.button.bigText),
            )),
        body: SingleChildScrollView(
          padding: styles.page.margin,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: Column(
            children: [
              styles.form.littleVoidSpace,
              TitleSubtitle(
                title: 'Premier exercice',
                subtitle: workoutExercises.isNotEmpty
                    ? workoutExercises[0].exercise!.name!
                    : "",
              ),
              styles.form.littleVoidSpace,
              ExerciseImage(
                imageId: workoutExercises.isNotEmpty
                    ? workoutExercises[0].exercise!.imageId
                    : null,
                size: min(
                    MediaQuery.of(context).size.width / 2 -
                        styles.page.marginValue,
                    MediaQuery.of(context).size.height / 2 -
                        styles.page.marginValue),
              ),
              styles.form.mediumVoidSpace,
              PerformanceFrame(
                exerciseTarget: exerciseTarget,
                exerciseLastPerformance: exerciseLastPerformance,
                date: lastWorkoutSession.date,
              ),
              styles.form.littleVoidSpace,
              NextExerciseButtons(
                onTapNext: passExercise,
                onTapChange: () {},
                onTapReplace: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
