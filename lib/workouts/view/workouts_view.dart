import 'package:flutter/material.dart';
import 'package:myworkout/workouts/model/dao/workouts_dao.dart';
import 'package:myworkout/workouts/model/entity/workout.dart';
import 'package:myworkout/workouts/model/entity/workout_group.dart';
import '../../core/theme/styles.dart' as styles;

class WorkoutsView extends StatefulWidget {
  const WorkoutsView({Key? key}) : super(key: key);

  @override
  State<WorkoutsView> createState() => _WorkoutsViewState();
}

class _WorkoutsViewState extends State<WorkoutsView> {
  List<WorkoutGroup> workoutGroups = [];
  List<Workout> workouts = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
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
              
              onLongPress: () {},
              onTap: () {}),
        ));
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
