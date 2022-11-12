import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide ReorderableList;
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myworkout/core/util/custom_app_bar.dart';
import 'package:myworkout/core/util/custom_check_box.dart';
import 'package:myworkout/core/util/custom_floating_button.dart';
import 'package:myworkout/core/util/edition_bar.dart';
import 'package:myworkout/exercises/util/exercise_image.dart';
import 'package:myworkout/workouts/model/dao/workouts_dao.dart';
import 'package:myworkout/workouts/model/entity/workout.dart';
import 'package:myworkout/workouts/model/entity/workout_exercise.dart';
import 'package:myworkout/workouts/view/create_workout_view.dart';
import 'package:myworkout/workouts/view/edit_exercise_performance_view.dart';
import 'package:myworkout/workouts/view/select_exercises_view.dart';
import '../../core/theme/styles.dart' as styles;

class EditWorkoutView extends StatefulWidget {
  const EditWorkoutView({Key? key, required this.workout}) : super(key: key);

  final Workout workout;

  @override
  _EditWorkoutViewState createState() => _EditWorkoutViewState();
}

class _EditWorkoutViewState extends State<EditWorkoutView> {
  List<WorkoutExercise> workoutExercises = [];
  List<int> selectedExercises = []; //exercices selectionnés par un longPress
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final dao = WorkoutsDao();
    var _workoutExercises = await dao.getWorkoutSession(widget.workout);
    setState(() {
      workoutExercises = _workoutExercises
          .map((workoutExercise) =>
              workoutExercise.copy(key: ValueKey(workoutExercise.listIndex)))
          .toList();
    });
  }

  Future<void> saveData() async {
    //on met à jour les valeurs de listIndex des éléments de la liste pour la BDD
    workoutExercises =
        workoutExercises.mapIndexed((i, w) => w.copy(listIndex: i)).toList();
    //on met à jour la liste en bdd.
    final dao = WorkoutsDao();
    await dao.updateWorkoutSessionGoals(widget.workout, workoutExercises);
  }

  void removeSelectedExercises() async {
    setState(() {
      for (var id in selectedExercises) {
        workoutExercises.removeWhere((item) => item.id == id);
      }
      selectedExercises = [];
    });
    await saveData().then((_) => getData());
  }

  // Returns index of item with given key
  int _indexOfKey(Key key) {
    return workoutExercises
        .indexWhere((WorkoutExercise item) => item.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);
    final draggedItem = workoutExercises[draggingIndex];
    setState(() {
      debugPrint("Reordering $item -> $newPosition");
      workoutExercises.removeAt(draggingIndex);
      workoutExercises.insert(newPositionIndex, draggedItem);
    });
    return true;
  }

  void _reorderDone(Key item) async {
    await saveData().then((_) => getData());
  }

  Widget buildItemAction(WorkoutExercise workoutExercise) {
    if (selectedExercises.isEmpty) {
      /*affiche le drag handle*/
      return ReorderableListener(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: const Center(
            child: Icon(Icons.reorder, color: Colors.white54),
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: CustomCheckBox(
            value: selectedExercises.contains(workoutExercise.id),
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedExercises.add(workoutExercise.id!);
                });
              } else {
                setState(() {
                  selectedExercises.remove(workoutExercise.id);
                });
              }
            }),
      );
    }
  }

  Widget buildItemPerformance(WorkoutExercise workoutExercise) {
    return Expanded(
      child: Column(
        children: [
          Row(children: [
            FaIcon(FontAwesomeIcons.chartLine,
                size: 12, color: styles.frame.primaryTextColor),
            const SizedBox(width: 8),
            Text(workoutExercise.exercisePerformance!.repsToString(),
                style: styles.frame.text)
          ]),
          Row(children: [
            FaIcon(FontAwesomeIcons.weightHanging,
                size: 12, color: styles.frame.primaryTextColor),
            const SizedBox(width: 8),
            Text(workoutExercise.exercisePerformance!.loadToString(),
                style: styles.frame.text)
          ]),
          Row(children: [
            FaIcon(FontAwesomeIcons.hourglass,
                size: 12, color: styles.frame.primaryTextColor),
            const SizedBox(width: 11),
            Text(workoutExercise.exercisePerformance!.restToString(),
                style: styles.frame.text)
          ]),
        ],
      ),
    );
  }

  Widget buildItem(
      {Key? key,
      required WorkoutExercise workoutExercise,
      required bool isFirst,
      required bool isLast}) {
    BoxDecoration? decoration;
    return ReorderableItem(
        key: workoutExercise.key!, //
        childBuilder: (context, state) {
          if (state == ReorderableItemState.dragProxy ||
              state == ReorderableItemState.dragProxyFinished) {
            decoration = BoxDecoration(
                borderRadius: styles.frame.borderRadius,
                color: Colors.white30,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26, spreadRadius: 4, blurRadius: 8)
                ]);
          } else {
            decoration = state == ReorderableItemState.placeholder
                ? null
                : styles.frame.boxDecoration;
          }
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            child: ClipRRect(
              borderRadius: styles.frame.borderRadius,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    /*check ou uncheck item si en est en édition, sinon on va sur la page d'edition des objectifs*/
                    if (selectedExercises.isNotEmpty) {
                      if (selectedExercises.contains(workoutExercise.id)) {
                        setState(() {
                          selectedExercises.remove(workoutExercise.id);
                        });
                      } else {
                        setState(() {
                          selectedExercises.add(workoutExercise.id!);
                        });
                      }
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditExercisePerformanceView(
                              workoutExercise: workoutExercise),
                        ),
                      ).then((_) => getData());
                    }
                  },
                  onLongPress: () {
                    setState(() {
                      selectedExercises.add(workoutExercise.id!);
                    });
                  },
                  child: Ink(
                    decoration: decoration,
                    padding:
                        const EdgeInsets.only(top: 12, bottom: 12, left: 16),
                    child: Opacity(
                      // hide content for placeholder
                      opacity:
                          state == ReorderableItemState.placeholder ? 0.0 : 1.0,
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
                                        imageId:
                                            workoutExercise.exercise!.imageId),
                                  ],
                                )
                              ],
                            ),
                          ),
                          buildItemAction(workoutExercise),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /*si on est en train de selectionner les exercices, on les deselectionne, 
        sinon sauvegarde en bdd puis navigator.pop classique*/

        if (selectedExercises.isEmpty) {
          return true;
        }
        setState(() {
          selectedExercises = [];
        });
        return false;
      },
      child: Container(
        decoration: styles.page.boxDecoration,
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'Editer la séance',
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateWorkoutView(
                                workout: widget.workout,
                              )));
                },
                icon: const Icon(Icons.edit_note_rounded),
              )
            ],
          ),
          floatingActionButton: CustomFloatingButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectExercisesView(
                  workoutId: widget.workout.id!,
                  workoutExerciseListLength: workoutExercises.length,
                ),
              ),
            ).then((_) => getData()),
          ),
          bottomNavigationBar: selectedExercises.isNotEmpty
              ? EditionBar(
                  numberSelected: selectedExercises.length,
                  onCopy: () {},
                  onDelete: () {
                    removeSelectedExercises();
                  },
                )
              : null,
          body: ReorderableList(
            onReorder: _reorderCallback,
            onReorderDone: _reorderDone,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: workoutExercises.length,
                    itemBuilder: (context, index) {
                      return buildItem(
                        workoutExercise: workoutExercises[index],
                        // first and last attributes affect border drawn during dragging
                        isFirst: index == 0,
                        isLast: index == workoutExercises.length - 1,
                      );
                    },
                  ),
                  //espace vide pour pouvoir scroller au dessus du floating action button
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
