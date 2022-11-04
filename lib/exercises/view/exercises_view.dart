import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:myworkout/core/util/custom_list_tile.dart';
import 'package:myworkout/exercises/model/dao/exercises_dao.dart';
import 'package:myworkout/exercises/model/entity/exercise.dart';
import 'package:myworkout/exercises/model/entity/exercise_group.dart';
import 'package:myworkout/exercises/view/create_exercise_view.dart';
import 'package:myworkout/exercises/view/exercise_description_view.dart';
import '../../core/theme/styles.dart' as styles;
import '../../core/util/search_bar.dart';

class ExercisesView extends StatefulWidget {
  const ExercisesView({Key? key}) : super(key: key);

  @override
  State<ExercisesView> createState() => ExercisesViewState();
}

class ExercisesViewState extends State<ExercisesView> {
  List<ExerciseGroup> allExerciseGroups = [];
  List<ExerciseGroup> exerciseGroups = [];
  List<int> exercisesSelected = [];
  String searchInput = "";
  final formatter = NumberFormat("0000");

  @override
  void initState() {
    super.initState();
    synchronize();
  }

  void synchronize() async {
    final exercisesDao = ExercisesDao();
    List<ExerciseGroup> _exerciseGroups =
        await exercisesDao.getExerciseGroups();
    setState(() {
      allExerciseGroups = _exerciseGroups;
      exerciseGroups = allExerciseGroups
          .where((exerciseGroup) =>
              exerciseGroup.getFilteredExercises(searchInput).isNotEmpty)
          .toList();
    });
  }

  void search(String input) async {
    setState(() {
      searchInput = input;
      exerciseGroups = allExerciseGroups
          .where((exerciseGroup) =>
              exerciseGroup.getFilteredExercises(input).isNotEmpty)
          .toList();
    });
  }

  void toggleLikeExercise(Exercise exercise) async {
    var exercisesDao = ExercisesDao();
    await exercisesDao
        .updateExercise(exercise.copy(isLiked: !exercise.isLiked!))
        .then((_) {
      synchronize();
    });
  }

  Widget buildGroup(BuildContext context, ExerciseGroup exerciseGroup) {
    List<Exercise> exercisesList =
        exerciseGroup.getFilteredExercises(searchInput);

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
                key: ValueKey('${exerciseGroup.id}${searchInput.isNotEmpty}'),
                leading: const SizedBox(
                  height: 40,
                  width: 40,
                  child: Placeholder(),
                ),
                initiallyExpanded: searchInput.isNotEmpty,
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
        child: CustomListTile(
          title: Text(
            exercise.name ?? "",
            style: styles.list.subtitle,
          ),
          subtitle: Text(
            exercise.description ??
                "${"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat".substring(0, 50)}...",
            style: styles.list.description,
            overflow: TextOverflow.clip,
          ),
          padding: const EdgeInsets.only(left: 8),
          middle: buildExerciceImage(exercise.imageId),
          action: buildAction(context: context, exercise: exercise),
          onLongPress: () {
            setState(() {
              exercisesSelected.add(exercise.id!);
            });
          },
          onTap: () {
            /*check ou uncheck workout si en est en édition, sinon on va sur la page edition*/
            if (exercisesSelected.isNotEmpty) {
              if (exercisesSelected.contains(exercise.id)) {
                setState(() {
                  exercisesSelected.remove(exercise.id);
                });
              } else {
                setState(() {
                  exercisesSelected.add(exercise.id!);
                });
              }
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExerciseDescriptionView(exercise: exercise),
                ),
              ).then((_) => synchronize());
            }
          },
        ),
      ),
    );
  }

  Widget buildExerciceImage(int? imageId) {
    if (imageId == null) {
      return const SizedBox(
        width: 120,
        child: Placeholder(),
      );
    }
    var id = formatter.format(imageId);

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/png/$id-relaxation.png',
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/png/$id-tension.png',
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Widget buildAction(
      {required BuildContext context, required Exercise exercise}) {
    if (exercisesSelected.isNotEmpty) {
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
              value: exercisesSelected.contains(exercise.id),
              onChanged: (value) {
                if (value!) {
                  setState(() {
                    exercisesSelected.add(exercise.id!);
                  });
                } else {
                  setState(() {
                    exercisesSelected.remove(exercise.id!);
                  });
                }
              }),
        ),
      );
    } else {
      return IconButton(
        icon: FaIcon(
          exercise.isLiked!
              ? FontAwesomeIcons.solidHeart
              : FontAwesomeIcons.heart,
          size: 20,
          color: styles.frame.primaryTextColor,
        ),
        onPressed: () => toggleLikeExercise(exercise),
      );
    }
  }

  Widget buildFilterButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Ink(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Row(children: [
              Icon(Icons.filter_list_rounded,
                  color: styles.frame.primaryTextColor),
              SizedBox(width: 4),
              Text('Filtrer', style: styles.frame.subtitle)
            ]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 54),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: exerciseGroups.length,
                  itemBuilder: (context, i) {
                    return buildGroup(context, exerciseGroups[i]);
                  },
                ),
                //espace vide pour pouvoir scroller au dessus du floating action button
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
        Container(
          margin: styles.page.margin,
          child: Row(
            children: [
              Expanded(
                child: SearchBar(onChanged: search),
              ),
              buildFilterButton()
            ],
          ),
        )
      ],
    );
  }
}
