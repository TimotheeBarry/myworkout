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
    return Center(
      child: Text(exercise.name ?? "", style: styles.frame.title),
    );
  }

  Widget buildDescriptionFrame() {
    return Container(
      margin: styles.frame.margin,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: styles.frame.boxDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(),
              Text('Description:', style: styles.frame.subtitle),
              styles.form.littleVoidSpace,
              Text(
                exercise.description ??
                    '''Lie on a flat bench with your feet flat on the floor, keep your back flat on the bench.,
      Grasp the bar a little wider than shoulder width apart.,
      Raise the barbell above your body and move it over the middle of your chest, this is your starting position.,
      Lower the bar down so it just touches your chest.,
      Raise the bar till your arms are fully extended and your elbows are locked.,
      Return to starting position.''',
                style: styles.list.description,
              )
            ],
          ),
        ),
      ),
    );
  }

  buildAdvancedInfoCell(String title, List<String> items) {
    List<Widget> _items =
        items.map((item) => Text(item, style: styles.frame.bigText)).toList();
    return Container(
      margin: const EdgeInsets.all(12),
      child: Column(
        children: [
          Text(title, style: styles.frame.subtitle),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: _items)
        ],
      ),
    );
  }

  buildAdvancedInfosFrame() {
    return Container(
      margin: styles.frame.margin,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: styles.frame.boxDecoration,
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.top,
            children: [
              TableRow(
                children: [
                  buildAdvancedInfoCell('Principal', ['Pectoraux']),
                  buildAdvancedInfoCell('Secondaire', ['Epaules', 'Triceps']),
                ],
              ),
              TableRow(
                children: [
                  buildAdvancedInfoCell('Type', ['Poly-articulaire']),
                  buildAdvancedInfoCell('Equipement', ['Banc']),
                ],
              )
            ],
          ),
        ),
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
          child: Column(
            children: [
              Hero(
                tag: exercise.imageId ?? 0,
                child: ExerciseImage(imageId: exercise.imageId, size: 180),
              ),
              styles.form.mediumVoidSpace,
              buildTitle(),
              styles.form.littleVoidSpace,
              buildAdvancedInfosFrame(),
              buildDescriptionFrame(),
            ],
          ),
        ),
      ),
    );
  }
}
