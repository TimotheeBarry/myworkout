import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myworkout/core/util/custom_list_tile.dart';
import 'package:myworkout/workouts/model/dao/workouts_dao.dart';
import 'package:myworkout/workouts/model/entity/workout.dart';
import 'package:myworkout/workouts/model/entity/workout_group.dart';
import 'package:myworkout/workouts/view/edit_workout_view.dart';
import '../../core/theme/styles.dart' as styles;

class WorkoutsView extends StatefulWidget {
  const WorkoutsView({Key? key}) : super(key: key);

  @override
  State<WorkoutsView> createState() => _WorkoutsViewState();
}

class _WorkoutsViewState extends State<WorkoutsView> {
  List<WorkoutGroup> workoutGroups = []; //liste des groupes de workout
  List<int> workoutsSelected =
      []; // =liste des id workout sélectionné (long press)

  @override
  void initState() {
    super.initState();
    synchronize();
  }

  void synchronize() async {
    final workoutsDao = WorkoutsDao();
    List<WorkoutGroup> _workoutGroups = await workoutsDao.getWorkoutGroups();
    setState(() {
      workoutGroups = _workoutGroups;
    });
  }

  Widget buildGroup(BuildContext context, WorkoutGroup workoutGroup) {
    List<Workout> workoutsList = workoutGroup.workouts!;
    return Container(
      margin: styles.list.margin,
      child: ClipRRect(
        borderRadius: styles.list.borderRadius,
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: styles.frame.boxDecoration,
            child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text(workoutGroup.name ?? "", style: styles.list.title),
                trailing: Text(workoutsList.length.toString(),
                    style: styles.list.title),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: workoutsList.length,
                    itemBuilder: (_, i) {
                      return buildWorkout(context, workoutsList[i]);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildWorkout(BuildContext context, Workout workout) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Container(
          decoration: styles.list.separator,
          child: CustomListTile(
              title: Text(
                workout.name ?? "",
                style: styles.list.subtitle,
              ),
              subtitle: Text('Dernière séance: 03/11/2022 (1h06)',
                  style: styles.list.description),
              action: buildAction(context: context, itemId: workout.id!),
              padding: const EdgeInsets.only(left: 12),
              onLongPress: () {
                /*ajout de la séance dans la liste des séances sélectionnées*/
                setState(() {
                  workoutsSelected.add(workout.id!);
                });
              },
              onTap: () {
                /*check ou uncheck workout si en est en édition, sinon on va sur la page edition*/
                if (workoutsSelected.isNotEmpty) {
                  if (workoutsSelected.contains(workout.id)) {
                    setState(() {
                      workoutsSelected.remove(workout.id);
                    });
                  } else {
                    setState(() {
                      workoutsSelected.add(workout.id!);
                    });
                  }
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditWorkoutView(
                            workout:
                                workout) /*EditWorkoutView(
                        workout: workout,
                      ),*/
                        ),
                  );
                }
              }),
        ));
  }

  Widget buildAction({required BuildContext context, required int itemId}) {
    if (workoutsSelected.isNotEmpty) {
      return Transform.scale(
        scale: 1.2,
        child: Theme(
          data: ThemeData(unselectedWidgetColor: styles.frame.primaryTextColor),
          child: Checkbox(
              activeColor: styles.button.backgroundColor,
              checkColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              value: workoutsSelected.contains(itemId),
              onChanged: (value) {
                if (value!) {
                  setState(() {
                    workoutsSelected.add(itemId);
                  });
                } else {
                  setState(() {
                    workoutsSelected.remove(itemId);
                  });
                }
              }),
        ),
      );
    } else {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Ink(
            padding: EdgeInsets.all(13),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  width: 1,
                  color: styles.list.backgroundColor,
                ),
              ),
            ),
            child: Icon(
              Icons.play_arrow_rounded,
              color: styles.frame.primaryTextColor,
              size: 30,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: workoutGroups.length,
      itemBuilder: (context, i) {
        return buildGroup(context, workoutGroups[i]);
      },
    );
  }
}
