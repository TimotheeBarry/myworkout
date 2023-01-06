import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myworkout/core/util/custom_app_bar.dart';
import 'package:myworkout/exercises/util/exercise_image.dart';
import 'package:myworkout/statistics/model/entity/statistic_item.dart';
import 'package:myworkout/workouts/model/dao/workouts_dao.dart';
import 'package:myworkout/workouts/model/entity/workout_exercise_session.dart';

import '../../core/theme/styles.dart' as styles;

class WorkoutStatisticsView extends StatefulWidget {
  const WorkoutStatisticsView({Key? key, required this.statisticItem})
      : super(key: key);
  final StatisticItem statisticItem;

  @override
  State<WorkoutStatisticsView> createState() => _WorkoutStatisticsViewState();
}

class _WorkoutStatisticsViewState extends State<WorkoutStatisticsView> {
  List<WorkoutExerciseSession> workoutSessionList = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final dao = WorkoutsDao();
    var _workoutSessionList =
        await dao.getWorkoutSession(widget.statisticItem.id!);
    setState(() {
      workoutSessionList = _workoutSessionList;
    });
  }

  Widget buildItemPerformance(WorkoutExerciseSession workoutExercise) {
    return Expanded(
      child: Column(
        children: [
          Row(children: [
            FaIcon(FontAwesomeIcons.arrowRotateLeft,
                size: 14, color: styles.frame.primaryTextColor),
            const SizedBox(width: 8),
            Text(workoutExercise.exercisePerformanceDone!.repsToString(),
                style: styles.frame.text)
          ]),
          Row(children: [
            FaIcon(FontAwesomeIcons.weightHanging,
                size: 14, color: styles.frame.primaryTextColor),
            const SizedBox(width: 8),
            Text(workoutExercise.exercisePerformanceDone!.loadToString(),
                style: styles.frame.text)
          ]),
          Row(children: [
            FaIcon(FontAwesomeIcons.stopwatch,
                size: 14, color: styles.frame.primaryTextColor),
            const SizedBox(width: 9),
            Text(workoutExercise.exercisePerformanceDone!.restToString(),
                style: styles.frame.text)
          ]),
        ],
      ),
    );
  }

  Widget buildItem(
    WorkoutExerciseSession workoutExercise,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      child: ClipRRect(
        borderRadius: styles.frame.borderRadius,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Ink(
              decoration: styles.frame.boxDecoration,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(workoutExercise.exercise?.name ?? "",
                            style: styles.frame.subtitle),
                        styles.form.littleVoidSpace,
                        Row(
                          children: [
                            buildItemPerformance(workoutExercise),
                            ExerciseImage(
                                imageId: workoutExercise.exercise!.imageId),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: styles.page.boxDecoration,
      child: Scaffold(
          appBar: const CustomAppBar(title: 'Statistiques de séance'),
          body: ListView.builder(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: workoutSessionList.length,
              itemBuilder: (context, index) {
                return buildItem(workoutSessionList[index]);
              })),
    );
  }
}
