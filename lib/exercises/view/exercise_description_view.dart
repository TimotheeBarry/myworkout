import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myworkout/core/util/custom_app_bar.dart';
import 'package:myworkout/exercises/model/dao/exercises_dao.dart';
import 'package:myworkout/exercises/model/entity/exercise.dart';
import 'package:myworkout/exercises/model/entity/exercise_group.dart';
import 'package:myworkout/exercises/util/exercise_image.dart';
import 'package:myworkout/exercises/view/create_exercise_view.dart';
import '../../core/theme/styles.dart' as styles;

class ExerciseDescriptionView extends StatefulWidget {
  const ExerciseDescriptionView({Key? key, required this.exerciseId})
      : super(key: key);
  final int exerciseId;

  @override
  State<ExerciseDescriptionView> createState() =>
      _ExerciseDescriptionViewState();
}

class _ExerciseDescriptionViewState extends State<ExerciseDescriptionView> {
  List<ExerciseGroup> exerciseGroups = [];
  late Exercise exercise = Exercise();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final exercisesDao = ExercisesDao();
    List<ExerciseGroup> _exerciseGroups =
        await exercisesDao.getExerciseGroups();
    Exercise _exercise = await exercisesDao.getExercise(widget.exerciseId);
    setState(() {
      exerciseGroups = _exerciseGroups;
      exercise = _exercise;
    });
  }

  Widget buildTitle() {
    return Container(
      child: Text(
        exercise.name ?? "",
        style: styles.frame.title,
      ),
    );
  }

  Widget buildDescriptionFrame() {
    return Container(
      child: Material(
        color: Colors.transparent,
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: styles.frame.boxDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text('Description', style: styles.frame.subtitle)),
              styles.form.littleVoidSpace,
              exercise.primer != null
                  ? Text(exercise.primer!, style: styles.frame.text)
                  : const SizedBox.shrink(),
              exercise.steps != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: exercise.steps
                              ?.map((step) => Text('\u2022  $step',
                                  style: styles.frame.text))
                              .toList() ??
                          [])
                  : const SizedBox.shrink(),
              exercise.tips != null
                  ? Column(
                      children: exercise.tips
                              ?.map(
                                  (tip) => Text(tip, style: styles.frame.text))
                              .toList() ??
                          [])
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAdvancedInfoCell(String title, List<String>? items) {
    List<Widget>? _items = items
        ?.map((item) => Text(
            (items.length > 1)
                ? '\u2022 ${toBeginningOfSentenceCase(item)!}'
                : toBeginningOfSentenceCase(item)!,
            style: styles.frame.bigText))
        .toList();
    return Expanded(
      child: Container(
        decoration: styles.frame.boxDecoration,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(title, style: styles.frame.subtitle),
            styles.form.littleVoidSpace,
            _items != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _items)
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  buildAdvancedInfosFrames() {
    return Container(
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                buildAdvancedInfoCell('Principal', exercise.primary),
                const SizedBox(width: 8),
                buildAdvancedInfoCell('Secondaire', exercise.secondary),
              ],
            ),
          ),
          styles.form.littleVoidSpace,
          IntrinsicHeight(
            child: Row(
              children: [
                buildAdvancedInfoCell(
                    'Type', exercise.type != null ? [exercise.type!] : null),
                const SizedBox(width: 8),
                buildAdvancedInfoCell('Equipement', exercise.equipment),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: styles.page.boxDecoration,
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Informations',
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateExerciseView(
                              exercise: exercise,
                            ))).then(
                  (_) {
                    getData();
                  },
                );
              },
              icon: const Icon(Icons.edit_note_rounded),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: styles.page.margin,
          child: Column(
            children: [
              styles.form.littleVoidSpace,
              buildTitle(),
              styles.form.littleVoidSpace,
              Hero(
                tag: exercise.imageId ?? 0,
                child: ExerciseImage(
                  imageId: exercise.imageId,
                  size: min(
                      MediaQuery.of(context).size.width / 2 -
                          styles.page.marginValue,
                      MediaQuery.of(context).size.height / 2 -
                          styles.page.marginValue),
                ),
              ),
              styles.form.littleVoidSpace,
              buildAdvancedInfosFrames(),
              styles.form.littleVoidSpace,
              buildDescriptionFrame(),
            ],
          ),
        ),
      ),
    );
  }
}
