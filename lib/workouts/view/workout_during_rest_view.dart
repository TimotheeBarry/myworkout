import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myworkout/exercises/model/entity/exercise.dart';
import 'package:myworkout/workouts/model/entity/exercise_set.dart';
import 'package:myworkout/workouts/util/rest_timer.dart';
import '../../core/theme/styles.dart' as styles;

class WorkoutDuringRestView extends StatefulWidget {
  const WorkoutDuringRestView(
      {Key? key,
      required this.exercise,
      required this.exerciseSet,
      required this.nextSet,
      required this.savePerformance})
      : super(key: key);
  final void Function() nextSet;
  final void Function(num, num, num) savePerformance;
  final Exercise exercise;
  final ExerciseSet exerciseSet;
  @override
  State<WorkoutDuringRestView> createState() => _WorkoutDuringRestViewState();
}

class _WorkoutDuringRestViewState extends State<WorkoutDuringRestView> {
  var repsController = TextEditingController();
  var loadController = TextEditingController();

  @override
  void initState() {
    setState(() {
      repsController.text = widget.exerciseSet.reps.toString();
      loadController.text = widget.exerciseSet.load.toString();
    });
    super.initState();
  }

  void updateReps(num value) {
    if (value < 0) {
      return;
    }
    setState(() {
      repsController.text = value.toString();
    });
  }

  void updateLoads(num value) {
    if (value < 0) {
      return;
    }
    if (value % 1 == 0) {
      value = value.toInt();
    }
    setState(() {
      loadController.text = value.toString();
    });
  }

  Widget buildInput({
    TextEditingController? controller,
    List<TextInputFormatter>? inputFormatters,
    String? hintText,
  }) {
    return Expanded(
      flex: 1,
      child: Center(
        child: TextFormField(
          controller: controller,
          style: styles.list.subtitle,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: const EdgeInsets.all(0),
            hintStyle: styles.input.hintStyle,
            enabledBorder: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.white, width: 1),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRepsInput() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Text('Répétitions effectuées', style: styles.frame.subtitle),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_rounded,
                    color: styles.frame.primaryTextColor),
                onPressed: () {
                  updateReps(num.parse(repsController.text) - 1);
                },
              ),
              buildInput(
                controller: repsController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                hintText: '0',
              ),
              IconButton(
                icon: Icon(Icons.add_rounded,
                    color: styles.frame.primaryTextColor),
                onPressed: () =>
                    {updateReps(num.parse(repsController.text) + 1)},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLoadInput() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Text('Charge soulevée', style: styles.frame.subtitle),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_rounded,
                    color: styles.frame.primaryTextColor),
                onPressed: () {
                  updateLoads(num.parse(loadController.text) - .5);
                },
              ),
              buildInput(
                hintText: '0.0',
                controller: loadController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+\.?[0-9]*'))
                ],
              ),
              Text('kg', style: styles.frame.text),
              IconButton(
                icon: Icon(Icons.add_rounded,
                    color: styles.frame.primaryTextColor),
                onPressed: () {
                  updateLoads(num.parse(loadController.text) + .5);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        styles.form.mediumVoidSpace,
        RestTimer(
          onFinish: () async {
            widget.savePerformance(
              num.parse(repsController.text),
              num.parse(loadController.text),
              widget.exerciseSet.rest,
            );
            widget.nextSet();
          },
          initialTime: widget.exerciseSet.rest,
        ),
        styles.form.bigVoidSpace,
        Container(
          decoration: styles.frame.boxDecoration,
          margin: styles.frame.margin,
          child: Column(
            children: [
              buildRepsInput(),
              buildLoadInput(),
            ],
          ),
        ),
      ],
    );
  }
}
