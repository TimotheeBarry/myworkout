import 'package:flutter/material.dart';
import 'package:myworkout/core/services/database_provider.dart';
import 'package:myworkout/exercises/model/dao/exercises_dao.dart';
import 'package:myworkout/exercises/model/entity/exercise.dart';
import 'package:myworkout/exercises/model/entity/exercise_group.dart';
import 'package:myworkout/exercises/view/create_exercise_view.dart';
import '../../core/theme/styles.dart' as styles;
import '../../core/util/search_bar.dart';

class ExercisesView extends StatefulWidget {
  const ExercisesView({Key? key}) : super(key: key);

  @override
  State<ExercisesView> createState() => _ExercisesViewState();
}

class _ExercisesViewState extends State<ExercisesView> {
  List<ExerciseGroup> allExerciseGroups = [];
  List<ExerciseGroup> filteredExerciseGroups = [];
  List<Exercise> allExercises = [];
  List<Exercise> filteredExercises = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final exercisesDao = ExercisesDao();
    List<ExerciseGroup> _exerciseGroups =
        await exercisesDao.getExerciseGroups();
    List<Exercise> _exercises = await exercisesDao.getExercises();
    setState(() {
      allExercises = _exercises;
      filteredExercises = _exercises;
      allExerciseGroups = _exerciseGroups;
      filteredExerciseGroups = _exerciseGroups
          .where((exerciseGroup) =>
              getExercisesFromGroup(exerciseGroup.id).length > 0)
          .toList();
    });
  }

  List<Exercise> getExercisesFromGroup(groupId) {
    return filteredExercises
        .where((exercise) => exercise.groupId == groupId)
        .toList();
  }

  void search(String input) {
    setState(() {
      filteredExercises = allExercises
          .where((exercise) =>
              exercise.name!.toLowerCase().contains(input.toLowerCase()))
          .toList();
      filteredExerciseGroups = allExerciseGroups
          .where((exerciseGroup) =>
              getExercisesFromGroup(exerciseGroup.id).length > 0)
          .toList();
    });
  }

  Widget buildGroup(BuildContext context, ExerciseGroup exerciseGroup) {
    List<Exercise> exercisesList = getExercisesFromGroup(exerciseGroup.id);

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
                leading: const SizedBox(
                  height: 40,
                  width: 40,
                  child: Placeholder(),
                ),
                title: Text(exerciseGroup.name ?? "", style: styles.list.title),
                trailing: Text(exercisesList.length.toString(),
                    style: styles.list.title),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: exercisesList.length,
                    itemBuilder: (context, i) {
                      return buildExercise(context, exercisesList[i]);
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

  Widget buildExercise(BuildContext context, Exercise exercise) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        decoration: styles.list.separator,
        child: ListTile(
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(
                  width: 80,
                  child: Placeholder(),
                ),
              ],
            ),
            title: Text(
              exercise.name ?? "",
              style: styles.list.subtitle,
            ),
            subtitle: Text(
              exercise.description ?? "blabla bla bla blabla blablabla",
              style: styles.list.description,
            ),
            isThreeLine: true,
            onLongPress: () {},
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateExerciseView(exercise: exercise),
                ),
              );
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SearchBar(onChanged: search),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredExerciseGroups.length,
            itemBuilder: (context, i) {
              return buildGroup(context, filteredExerciseGroups[i]);
            },
          )
        ],
      ),
    );
  }
}
