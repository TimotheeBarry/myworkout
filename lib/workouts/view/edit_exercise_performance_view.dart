import 'package:flutter/material.dart' hide ReorderableList;
import 'package:myworkout/core/util/custom_app_bar.dart';
import 'package:myworkout/exercises/util/exercise_image.dart';
import 'package:myworkout/exercises/util/exercise_image_big.dart';
import 'package:myworkout/workouts/model/entity/exercise_performance.dart';
import 'package:myworkout/workouts/model/entity/workout_exercise.dart';
import '../../core/theme/styles.dart' as styles;

class EditExercisePerformanceView extends StatefulWidget {
  const EditExercisePerformanceView({Key? key, required this.workoutExercise})
      : super(key: key);

  final WorkoutExercise workoutExercise;

  @override
  _EditExercisePerformanceViewState createState() =>
      _EditExercisePerformanceViewState();
}

class _EditExercisePerformanceViewState
    extends State<EditExercisePerformanceView> {
  late ExercisePerformance exercisePerformance;
  @override
  void initState() {
    setState(() =>
        exercisePerformance = widget.workoutExercise.exercisePerformance!);
    super.initState();
  }

  Widget buildInputPerformance({
    required String title,
    int? initialValue,
    String? unit,
    required void Function(int) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Text(title, style: styles.frame.subtitle),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_rounded,
                    color: styles.frame.primaryTextColor),
                onPressed: () => onChanged(initialValue! - 1),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: TextFormField(
                    onChanged: (value) => onChanged(int.parse(value)),
                    initialValue: initialValue != null ? '$initialValue' : null,
                    style: styles.list.subtitle,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '0',
                      contentPadding: EdgeInsets.all(0),
                      hintStyle: styles.input.hintStyle,
                      enabledBorder: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.white, width: 1),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_rounded,
                    color: styles.frame.primaryTextColor),
                onPressed: () => onChanged(initialValue! + 1),
              ),
            ],
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
        appBar: const CustomAppBar(
          title: 'Editer les performances',
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            ExerciseImageBig(imageId: widget.workoutExercise.exercise?.imageId),
            Container(
                decoration: styles.frame.boxDecoration,
                margin: styles.frame.margin,
                child: Column(
                  children: [
                    buildInputPerformance(
                      title: 'Nombre de séries',
                      initialValue: exercisePerformance.sets,
                      onChanged: (value) {
                        setState(() {
                          exercisePerformance.sets = value;
                        });
                      },
                    ),
                    buildInputPerformance(
                      title: 'Nombre de répétitions',
                      onChanged: (value) {},
                    ),
                    buildInputPerformance(
                      title: 'Charge à soulever',
                      onChanged: (value) {},
                    ),
                    buildInputPerformance(
                      title: 'Temps de repos entre les séries',
                      onChanged: (value) {},
                    ),
                    buildInputPerformance(
                      title: 'Temps de repos après les séries',
                      onChanged: (value) {},
                    ),
                  ],
                )),
          ]),
        ),
      ),
    );
  }
}
