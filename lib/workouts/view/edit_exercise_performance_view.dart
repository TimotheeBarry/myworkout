import 'package:flutter/material.dart' hide ReorderableList;
import 'package:flutter/services.dart';
import 'package:myworkout/core/util/custom_app_bar.dart';
import 'package:myworkout/core/util/custom_check_box.dart';
import 'package:myworkout/exercises/util/exercise_image.dart';
import 'package:myworkout/workouts/model/dao/workouts_dao.dart';
import 'package:myworkout/workouts/model/entity/exercise_performance.dart';
import 'package:myworkout/workouts/model/entity/exercise_set.dart';
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
  final TextEditingController setsController = TextEditingController();
  List<TextEditingController> repsController = [];
  List<TextEditingController> loadsController = [];
  List<TextEditingController> restsController = [];

  bool identicalReps = true;
  bool identicalLoads = true;
  bool identicalRests = true;

  @override
  void initState() {
    /*initialisation de tous les controlleurs*/
    var exercisePerformance = widget.workoutExercise.exercisePerformance!;
    var exerciseSets = exercisePerformance.getPerformances();

    setState(() {
      /* init les booléens identical*/
      identicalReps = exercisePerformance.identicalReps();
      identicalLoads = exercisePerformance.identicalLoads();
      identicalRests = exercisePerformance.identicalRests();
      /*init les controlleurs*/
      setsController.text = exercisePerformance.sets.toString();
      setsController.addListener(() {
        if (setsController.text != '' && int.parse(setsController.text) < 1) {
          setState(() => setsController.text = '1');
        } else if (int.parse(setsController.text) > 99) {
          setState(() => setsController.text = '99');
        }
      });
      for (var i = 0; i < exercisePerformance.sets!; i++) {
        repsController
            .add(TextEditingController(text: exerciseSets[i].reps.toString()));
        loadsController
            .add(TextEditingController(text: exerciseSets[i].load.toString()));
        restsController
            .add(TextEditingController(text: exerciseSets[i].rest.toString()));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    /*on dispose tous les controlleurs*/
    var sets = int.parse(setsController.text);
    setsController.dispose();
    for (var i = 0; i < sets; i++) {
      repsController[i].dispose();
      loadsController[i].dispose();
      restsController[i].dispose();
    }
    super.dispose();
  }

  void addControllers(List<TextEditingController> controllerList, number) {
    for (var i = 0; i < number; i++) {
      controllerList.add(TextEditingController(text: controllerList[0].text));
    }
  }

  void updateSets(int value) {
    if (value > 0 && value < 100) {
      setState(() {
        setsController.text = value.toString();

        /*add or remove reps controllers*/
        if (repsController.length > value) {
          repsController = repsController.sublist(0, value);
        } else if (repsController.length < value) {
          addControllers(repsController, value - repsController.length);
        }
        /*add or remove loads controllers*/
        if (loadsController.length > value) {
          loadsController = loadsController.sublist(0, value);
        } else if (loadsController.length < value) {
          addControllers(loadsController, value - loadsController.length);
        }
        /*add or remove sets controllers*/
        if (restsController.length > value) {
          restsController = restsController.sublist(0, value);
        } else if (restsController.length < value) {
          addControllers(restsController, value - restsController.length);
        }
      });
    }
  }

  void updateReps(num value, int index) {
    if (value < 0) {
      return;
    }
    if (identicalReps) {
      setState(() {
        for (var i = 0; i < repsController.length; i++) {
          repsController[i].text = value.toString();
        }
      });
    } else {
      setState(() {
        repsController[index].text = value.toString();
      });
    }
  }

  void updateLoads(num value, int index) {
    if (value < 0) {
      return;
    }
    if (value % 1 == 0) {
      value = value.toInt();
    }
    if (identicalLoads) {
      setState(() {
        for (var i = 0; i < repsController.length; i++) {
          loadsController[i].text = value.toString();
        }
      });
    } else {
      setState(() {
        loadsController[index].text = value.toString();
      });
    }
  }

  Future<void> saveData() async {
    List<ExerciseSet> exerciseSets = [];
    for (var i = 0; i < int.parse(setsController.text); i++) {
      exerciseSets.add(
        ExerciseSet(
          reps: identicalReps
              ? num.parse(repsController[0].text)
              : num.parse(repsController[i].text),
          rest: identicalRests
              ? num.parse(restsController[0].text)
              : num.parse(restsController[i].text),
          load: identicalLoads
              ? num.parse(loadsController[0].text)
              : num.parse(loadsController[i].text),
        ),
      );
    }

    final dao = WorkoutsDao();
    await dao.updateWorkoutExerciseGoal(widget.workoutExercise.copy(
        exercisePerformance: ExercisePerformance().getFromSets(exerciseSets)));
  }

  Widget buildInput({
    TextEditingController? controller,
    List<TextInputFormatter>? inputFormatters,
    Function(String?)? onChanged,
    String? hintText,
  }) {
    return Expanded(
      flex: 1,
      child: Center(
        child: TextFormField(
          controller: controller,
          onChanged: onChanged,
          style: styles.list.subtitle,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hintText,
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
    );
  }

  Widget buildSetsInput() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Text('Nombre de séries', style: styles.frame.subtitle),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_rounded,
                    color: styles.frame.primaryTextColor),
                onPressed: () =>
                    {updateSets(int.parse(setsController.text) - 1)},
              ),
              buildInput(
                controller: setsController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                hintText: '0',
              ),
              IconButton(
                  icon: Icon(Icons.add_rounded,
                      color: styles.frame.primaryTextColor),
                  onPressed: () =>
                      {updateSets(int.parse(setsController.text) + 1)}),
            ],
          )
        ],
      ),
    );
  }

  Widget buildRepsInput() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Text('Nombre de répétitions', style: styles.frame.subtitle),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Séries identiques', style: styles.frame.bigText),
              CustomCheckBox(
                value: identicalReps,
                onChanged: (_) {
                  setState(() {
                    identicalReps = !identicalReps;
                  });
                },
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: identicalReps ? 1 : int.parse(setsController.text),
            itemBuilder: (context, index) => Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove_rounded,
                      color: styles.frame.primaryTextColor),
                  onPressed: () {
                    updateReps(
                        num.parse(repsController[index].text) - 1, index);
                  },
                ),
                buildInput(
                  controller: repsController[index],
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  hintText: '0',
                ),
                IconButton(
                  icon: Icon(Icons.add_rounded,
                      color: styles.frame.primaryTextColor),
                  onPressed: () => {
                    updateReps(num.parse(repsController[index].text) + 1, index)
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoadsInput() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Text('Charge à soulever', style: styles.frame.subtitle),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Charges identiques', style: styles.frame.bigText),
              CustomCheckBox(
                value: identicalLoads,
                onChanged: (_) {
                  setState(() {
                    identicalLoads = !identicalLoads;
                  });
                },
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: identicalLoads ? 1 : int.parse(setsController.text),
            itemBuilder: (context, index) => Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove_rounded,
                      color: styles.frame.primaryTextColor),
                  onPressed: () {
                    updateLoads(
                        num.parse(loadsController[index].text) - .5, index);
                  },
                ),
                buildInput(
                  hintText: '0.0',
                  controller: loadsController[index],
                ),
                Text('kg', style: styles.frame.text),
                IconButton(
                  icon: Icon(Icons.add_rounded,
                      color: styles.frame.primaryTextColor),
                  onPressed: () {
                    updateLoads(
                        num.parse(loadsController[index].text) + .5, index);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        saveData();
        return true;
      },
      child: Container(
        decoration: styles.page.boxDecoration,
        child: Scaffold(
          appBar: const CustomAppBar(
            title: 'Editer les performances',
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ExerciseImage(
                    imageId: widget.workoutExercise.exercise?.imageId),
                Text(widget.workoutExercise.exercise?.name ?? "",
                    style: styles.frame.title),
                Column(
                  children: [
                    Container(
                      decoration: styles.frame.boxDecoration,
                      margin: styles.frame.margin,
                      child: buildSetsInput(),
                    ),
                    Container(
                      decoration: styles.frame.boxDecoration,
                      margin: styles.frame.margin,
                      child: buildRepsInput(),
                    ),
                    Container(
                      decoration: styles.frame.boxDecoration,
                      margin: styles.frame.margin,
                      child: buildLoadsInput(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
