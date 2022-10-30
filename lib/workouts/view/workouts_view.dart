import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  late List<WorkoutGroup> workoutGroups = []; //liste des groupes de workout
  late List<Workout> workouts = []; //liste des workouts
  late List<int> workoutsSelected =
      []; // =liste des id workout sélectionné (long press)

  @override
  void initState() {
    super.initState();
    synchronize();
  }

  void synchronize() async {
    final workoutsDao = WorkoutsDao();
    List<WorkoutGroup> _workoutGroups = await workoutsDao.getWorkoutGroups();
    List<Workout> _workouts = await workoutsDao.getWorkouts();
    setState(() {
      workouts = _workouts;
      workoutGroups = _workoutGroups;
    });
  }

  List<Workout> getWorkoutsFromGroup(groupId) {
    return workouts.where((workout) => workout.groupId == groupId).toList();
  }

  Widget buildGroup(BuildContext context, WorkoutGroup workoutGroup) {
    List<Workout> workoutsList = getWorkoutsFromGroup(workoutGroup.id);
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
          child: ListTile(
              title: Text(
                workout.name ?? "",
                style: styles.list.subtitle,
              ),
              trailing: buildAction(context: context, itemId: workout.id!),
              onLongPress: () {
                /*ajout de la séance dans la liste des séances sélectionnées*/
                setState(() {
                  workoutsSelected.add(workout.id!);
                  print(workoutsSelected);
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
                        workout: workout,
                      ),
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
        child: Checkbox(
            activeColor: Theme.of(context).primaryColor,
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
      );
    } else {
      return IconButton(
        icon: FaIcon(FontAwesomeIcons.play,
            color: styles.frame.primaryTextColor),
        onPressed: () {},
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
