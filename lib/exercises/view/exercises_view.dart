import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myworkout/core/util/custom_check_box.dart';
import 'package:myworkout/core/util/custom_list_tile.dart';
import 'package:myworkout/exercises/model/dao/exercises_dao.dart';
import 'package:myworkout/exercises/model/entity/exercise.dart';
import 'package:myworkout/exercises/model/entity/exercise_group.dart';
import 'package:myworkout/exercises/util/exercise_image.dart';
import 'package:myworkout/exercises/util/filter_pop_up.dart';
import 'package:myworkout/core/util/hero_dialog_route.dart';
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

  Widget buildGroup(ExerciseGroup exerciseGroup) {
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
                      return buildExercise(exercisesList[i]);
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

  Widget buildExercise(Exercise exercise) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          exercisesSelected = [];
        });
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
          middle: ExerciseImage(imageId: exercise.imageId),
          action: buildAction(exercise: exercise),
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
                  builder: (context) =>
                      ExerciseDescriptionView(exerciseId: exercise.id!),
                ),
              ).then((_) => synchronize());
            }
          },
        ),
      ),
    );
  }

  Widget buildAction({required Exercise exercise}) {
    if (exercisesSelected.isNotEmpty) {
      return CustomCheckBox(
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
          });
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
                    return buildGroup(exerciseGroups[i]);
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
          child: Container(
              margin: styles.page.margin,
              child: SearchBar(
                onChanged: search,
                onTapFilter: () {
                  //unfocus la barre de recherche si jamais on était dessus pour pas rouvrir le clavier
                  FocusManager.instance.primaryFocus?.unfocus();
                  //ouvre le popup des filtres avec une animation
                  Navigator.of(context).push(
                    HeroDialogRoute(builder: (context) {
                      return const FilterPopUp();
                    }),
                  );
                },
              )),
        )
      ],
    );
  }
}
