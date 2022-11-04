import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myworkout/core/util/custom_app_bar.dart';
import 'package:myworkout/exercises/model/dao/exercises_dao.dart';
import 'package:myworkout/exercises/model/entity/exercise.dart';
import 'package:myworkout/exercises/model/entity/exercise_group.dart';
import 'package:myworkout/exercises/view/create_exercise_view.dart';
import '../../core/theme/styles.dart' as styles;

class ExerciseDescriptionView extends StatefulWidget {
  const ExerciseDescriptionView({Key? key, required this.exercise})
      : super(key: key);
  final Exercise exercise;

  @override
  State<ExerciseDescriptionView> createState() =>
      _ExerciseDescriptionViewState();
}

class _ExerciseDescriptionViewState extends State<ExerciseDescriptionView> {
  List<ExerciseGroup> exerciseGroups = [];

  @override
  void initState() {
    super.initState();
    setState(() {});
    getData();
  }

  void getData() async {
    final exercisesDao = ExercisesDao();
    List<ExerciseGroup> _exerciseGroups =
        await exercisesDao.getExerciseGroups();
    setState(() {
      exerciseGroups = _exerciseGroups;
    });
  }

  Widget buildExerciceImage() {
    if (widget.exercise.imageId == null) {
      return const Placeholder(
        fallbackHeight: 180,
      );
    }
    final formatter = NumberFormat("0000");
    var id = formatter.format(widget.exercise.imageId);

    return ClipRRect(
      borderRadius: styles.frame.borderRadius,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/png/$id-relaxation.png',
            height: 180,
            width: 180,
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/png/$id-tension.png',
            height: 180,
            width: 180,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Widget buildTitle() {
    return Center(
      child: Text(widget.exercise.name ?? "", style: styles.frame.title),
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
                widget.exercise.description ??
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

  buildAdvancedInfosFrame() {
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
              Text('Type:', style: styles.frame.subtitle),
              styles.form.littleVoidSpace,
              Text('Poly-articulaire', style: styles.frame.bigText),
              styles.form.mediumVoidSpace,
              Text('Groupe musculaire primaire:', style: styles.frame.subtitle),
              styles.form.littleVoidSpace,
              Text('Pectoraux', style: styles.frame.bigText),
              styles.form.mediumVoidSpace,
              Text('Groupe(s) musculaire(s) secondaire(s):',
                  style: styles.frame.subtitle),
              styles.form.littleVoidSpace,
              Text('Epaules', style: styles.frame.bigText),
              Text('Triceps', style: styles.frame.bigText),
              styles.form.mediumVoidSpace,
              Text('Equipement(s):', style: styles.frame.subtitle),
              styles.form.littleVoidSpace,
              Text('Banc', style: styles.frame.bigText),
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
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: 'Informations',
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateExerciseView(
                              exercise: widget.exercise,
                            )));
              },
              icon: const Icon(Icons.edit_note_rounded),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildTitle(),
              styles.form.littleVoidSpace,
              buildExerciceImage(),
              buildDescriptionFrame(),
              buildAdvancedInfosFrame()
            ],
          ),
        ),
      ),
    );
  }
}
