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
  const ExercisesView({Key? key, required this.updateParent}) : super(key: key);
  //met a jour le widget parent mainPages pour les changements liés à la barre d'édition
  final void Function() updateParent;

  @override
  State<ExercisesView> createState() => ExercisesViewState();
}

class ExercisesViewState extends State<ExercisesView> {
  List<ExerciseGroup> allExerciseGroups = [];
  List<ExerciseGroup> exerciseGroups = [];
  List<int> exercisesSelected = [];
  String searchInput = "";
  bool likedFilterChecked = false;

  @override
  void initState() {
    super.initState();
    synchronize();
  }

  void synchronize() async {
    //synchronise l'affichage avec les données de la db pour tous les exercices
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

  void updateOneExercise(Exercise exercise, Exercise updatedExercise) {
    if (exercise.id != updatedExercise.id) {
      return;
    }
    setState(() {
      //on récupère l'indice de groupe dans la liste des groupes, et celui de l'exercice dans sa liste d'exercise
      var groupIndex =
          exerciseGroups.indexWhere((group) => group.id == exercise.groupId);
      var group = exerciseGroups[groupIndex];
      var exerciseIndex =
          group.exercises!.indexWhere((exo) => exo.id == exercise.id);
      //on récupère la liste d'exercices de ce groupe et on modifie l'exercice à l'indice voulu
      var exercisesList = group.exercises;
      exercisesList!
          .replaceRange(exerciseIndex, exerciseIndex + 1, [updatedExercise]);
      //on update le groupe avec la liste à jour
      exerciseGroups.replaceRange(
          groupIndex, groupIndex + 1, [group.copy(exercises: exercisesList)]);
    });
  }

  void toggleLikeExercise(Exercise exercise) async {
    var exercisesDao = ExercisesDao();
    var updatedExercise = exercise.copy(isLiked: !exercise.isLiked!);
    await exercisesDao.updateExercise(updatedExercise).then((_) {
      //met à jour l'exercice
      updateOneExercise(exercise, updatedExercise);
    });
  }

  void applyFilters(
      {required bool liked, List<String>? equipments, List<String>? type}) {
    setState((() {
      //reset les filtres
      likedFilterChecked = liked;
      exerciseGroups = allExerciseGroups
          .where((exerciseGroup) =>
              exerciseGroup.getFilteredExercises(searchInput).isNotEmpty)
          .toList();
      //applique les nouveaux filtres
      if (liked == true) {
        exerciseGroups = allExerciseGroups
            .where(
                (exerciseGroup) => exerciseGroup.getLikedExercises().isNotEmpty)
            .toList();
        exerciseGroups = exerciseGroups
            .map((exerciseGroup) => exerciseGroup.copy(
                exercises: exerciseGroup.getLikedExercises()))
            .toList();
      }
    }));
  }

  Widget buildGroup(ExerciseGroup exerciseGroup) {
    List<Exercise> exercisesList =
        exerciseGroup.getFilteredExercises(searchInput);

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
                key: ValueKey('${exerciseGroup.id}${searchInput.length > 2}'),
                // leading: const SizedBox(
                //   height: 40,
                //   width: 40,
                //   child: Placeholder(),
                // ),
                initiallyExpanded: searchInput.length > 2,
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
    return Container(
      decoration: styles.list.separator,
      child: CustomListTile(
        title: Text(
          exercise.name ?? "",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: styles.list.subtitle,
        ),
        subtitle: (exercise.primer != null)
            ? Text(
                exercise.primer!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: styles.list.description,
              )
            : null,
        padding: const EdgeInsets.only(left: 8),
        middle: ExerciseImage(imageId: exercise.imageId),
        action: buildAction(exercise: exercise),
        onLongPress: () {
          exercisesSelected.add(exercise.id!);
          widget.updateParent();
        },
        onTap: () {
          /*check ou uncheck workout si en est en édition, sinon on va sur la page edition*/
          if (exercisesSelected.isNotEmpty) {
            if (exercisesSelected.contains(exercise.id)) {
              exercisesSelected.remove(exercise.id);
            } else {
              exercisesSelected.add(exercise.id!);
            }
            widget.updateParent();
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
    );
  }

  Widget buildAction({required Exercise exercise}) {
    if (exercisesSelected.isNotEmpty) {
      return CustomCheckBox(
          value: exercisesSelected.contains(exercise.id),
          onChanged: (value) {
            if (value!) {
              exercisesSelected.add(exercise.id!);
            } else {
              exercisesSelected.remove(exercise.id!);
            }
            widget.updateParent();
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
    return WillPopScope(
      onWillPop: () async {
        exercisesSelected = [];
        widget.updateParent();
        return false;
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 54),
            child: SingleChildScrollView(
              padding: styles.page.margin,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
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
            child: SearchBar(
              onChanged: search,
              onTapFilter: () {
                //unfocus la barre de recherche si jamais on était dessus pour pas rouvrir le clavier
                FocusManager.instance.primaryFocus?.unfocus();
                //ouvre le popup des filtres avec une animation
                Navigator.of(context).push(
                  HeroDialogRoute(builder: (context) {
                    return FilterPopUp(
                        applyFilters: applyFilters,
                        likedFilterChecked: likedFilterChecked);
                  }),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
