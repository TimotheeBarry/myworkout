import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myworkout/core/util/button_transparent.dart';
import 'package:myworkout/exercises/model/entity/exercise.dart';
import 'package:myworkout/exercises/util/exercise_image.dart';
import 'package:myworkout/workouts/model/entity/exercise_set.dart';
import 'package:myworkout/workouts/util/next_exercise_buttons.dart';
import 'package:myworkout/workouts/util/performance_frame.dart';
import 'package:myworkout/workouts/util/rest_timer.dart';
import 'package:myworkout/workouts/util/set_count.dart';
import 'package:myworkout/workouts/util/title_subtitle.dart';
import '../../core/theme/styles.dart' as styles;

class WorkoutDuringRestView extends StatefulWidget {
  const WorkoutDuringRestView({
    Key? key,
    required this.exercise,
    required this.exerciseSet,
    required this.nextSet,
    required this.savePerformance,
    required this.currentSet,
    required this.totalSets,
    this.nextExerciseSet,
    this.lastNextExerciseSet,
    this.lastSessionDate,
    this.nextExercise,
  }) : super(key: key);
  final void Function() nextSet;
  final void Function(num, num, num) savePerformance;
  final Exercise exercise;
  final ExerciseSet exerciseSet;
  final int currentSet;
  final int totalSets;
  final DateTime? lastSessionDate;
  final Exercise? nextExercise;
  final ExerciseSet? lastNextExerciseSet;
  final ExerciseSet? nextExerciseSet;

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
          style: styles.frame.title,
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
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          FaIcon(FontAwesomeIcons.rotateLeft,
              color: styles.frame.primaryTextColor, size: 32),
          const SizedBox(width: 16),
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
            icon: Icon(Icons.add_rounded, color: styles.frame.primaryTextColor),
            onPressed: () => {updateReps(num.parse(repsController.text) + 1)},
          ),
        ],
      ),
    );
  }

  Widget buildLoadInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          FaIcon(FontAwesomeIcons.weightHanging,
              color: styles.frame.primaryTextColor, size: 32),
          const SizedBox(width: 16),
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
            icon: Icon(Icons.add_rounded, color: styles.frame.primaryTextColor),
            onPressed: () {
              updateLoads(num.parse(loadController.text) + .5);
            },
          ),
        ],
      ),
    );
  }

  Widget buildEditPerformanceFrame() {
    return Container(
      decoration: styles.frame.boxDecoration,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Center(
            child: Text(
              'Editer les performances',
              style: TextStyle(
                color: styles.frame.primaryTextColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          buildRepsInput(),
          buildLoadInput(),
        ],
      ),
    );
  }

  /*Widget buildSetsButtonRow() {
    return Row(
      children: [
        Expanded(
          child: ButtonTransparent(
              title: Text('Retirer série', style: styles.frame.bigText),
              icon: Icon(Icons.remove, color: styles.frame.primaryTextColor),
              onTap: () {}),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: ButtonTransparent(
              title: Text('Ajouter série', style: styles.frame.bigText),
              icon: Icon(Icons.add, color: styles.frame.primaryTextColor),
              onTap: () {}),
        )
      ],
    );
  }*/

  Widget buildImageAndButtonRow() {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: styles.frame.borderRadius,
            child: Container(
              color: Colors.white,
              child: Center(
                child: ExerciseImage(
                    imageId: widget.nextExercise!.imageId, size: 100),
              ),
            ),
          ),
          const SizedBox(width: 8),
          (widget.nextExercise != null && widget.currentSet == widget.totalSets)
              ? Expanded(
                  child: NextExerciseButtons(
                  onTapNext: () {},
                  onTapChange: () {},
                  onTapReplace: () {},
                  shorter: true,
                ))
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        styles.form.littleVoidSpace,
        Row(
          children: [
            Expanded(
              child: TitleSubtitle(
                title: 'Exercice en cours',
                subtitle: widget.exercise.name ?? "",
              ),
            ),
            SetCount(currentSet: widget.currentSet, totalSets: widget.totalSets)
          ],
        ),
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
        styles.form.mediumVoidSpace,
        buildEditPerformanceFrame(),
        /*styles.form.littleVoidSpace,
        buildSetsButtonRow(),*/
        styles.form.mediumVoidSpace,
        (widget.nextExercise != null && widget.nextExerciseSet != null)
            ? Column(
                children: [
                  TitleSubtitle(
                    title: 'Prochaine série',
                    subtitle: widget.nextExercise!.name ?? "",
                  ),
                  styles.form.littleVoidSpace,
                  buildImageAndButtonRow(),
                  styles.form.littleVoidSpace,
                  PerformanceFrame(
                    exerciseTarget: widget.nextExerciseSet!,
                    exerciseLastPerformance: widget.lastNextExerciseSet,
                    date: widget.lastSessionDate,
                  ),
                ],
              )
            : const SizedBox.shrink(),
        styles.form.mediumVoidSpace,
      ],
    );
  }
}
