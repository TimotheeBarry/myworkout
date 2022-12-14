import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myworkout/core/util/custom_check_box.dart';
import 'package:myworkout/core/util/custom_list_tile.dart';
import 'package:myworkout/workouts/model/dao/workouts_dao.dart';
import 'package:myworkout/workouts/model/entity/workout.dart';
import 'package:myworkout/workouts/model/entity/workout_group.dart';
import 'package:myworkout/workouts/view/edit_workout_view.dart';
import 'package:myworkout/workouts/view/launch_workout_view.dart';
import '../../core/theme/styles.dart' as styles;

class WorkoutsView extends StatefulWidget {
  const WorkoutsView({Key? key, required this.updateParent}) : super(key: key);
  final void Function() updateParent;
  @override
  State<WorkoutsView> createState() => WorkoutsViewState();
}

class WorkoutsViewState extends State<WorkoutsView> {
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
      margin: styles.list.marginV,
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
    return Container(
      decoration: styles.list.separator,
      child: CustomListTile(
          title: Text(
            workout.name ?? "",
            style: styles.list.subtitle,
          ),
          subtitle: workout.lastSessionDate != null
              ? Text('Dernière séance: ${DateFormat('dd/MM/yyyy').format(workout.lastSessionDate!)}',
                  style: styles.list.description)
              : const SizedBox.shrink(),
          action: buildAction(context: context, workout: workout),
          padding: const EdgeInsets.only(left: 12),
          onLongPress: () {
            /*ajout de la séance dans la liste des séances sélectionnées*/

            workoutsSelected.add(workout.id!);
            widget.updateParent();
          },
          onTap: () {
            /*check ou uncheck workout si en est en édition, sinon on va sur la page edition*/
            if (workoutsSelected.isNotEmpty) {
              if (workoutsSelected.contains(workout.id)) {
                workoutsSelected.remove(workout.id);
              } else {
                workoutsSelected.add(workout.id!);
              }
              widget.updateParent();
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditWorkoutView(workout: workout)),
              );
            }
          }),
    );
  }

  Widget buildAction(
      {required BuildContext context, required Workout workout}) {
    if (workoutsSelected.isNotEmpty) {
      return CustomCheckBox(
          value: workoutsSelected.contains(workout.id),
          onChanged: (value) {
            if (value!) {
              workoutsSelected.add(workout.id!);
            } else {
              workoutsSelected.remove(workout.id);
            }
            widget.updateParent();
          });
    } else {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final dao = WorkoutsDao();
            var workoutExercises = await dao.getWorkoutSessionGoals(workout);
            if (workoutExercises.isNotEmpty) {
              //si la séance est vide on ne peut pas aller dessus
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LaunchWorkoutView(workout: workout)),
              );
            }
          },
          child: Ink(
            padding: const EdgeInsets.all(13),
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
    return WillPopScope(
      onWillPop: () async {
        workoutsSelected = [];
        widget.updateParent();
        return false;
      },
      child: ListView.builder(
        padding: styles.page.margin,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
        shrinkWrap: true,
        itemCount: workoutGroups.length,
        itemBuilder: (context, i) {
          return buildGroup(context, workoutGroups[i]);
        },
      ),
    );
  }
}
