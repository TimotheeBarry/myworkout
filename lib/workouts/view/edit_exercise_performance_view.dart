import 'package:flutter/material.dart' hide ReorderableList;
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myworkout/core/util/button_transparent.dart';
import 'package:myworkout/core/util/custom_app_bar.dart';
import 'package:myworkout/core/util/custom_button.dart';
import 'package:myworkout/core/util/custom_check_box.dart';
import 'package:myworkout/core/util/functions.dart';
import 'package:myworkout/exercises/util/exercise_image.dart';
import 'package:myworkout/workouts/model/dao/workouts_dao.dart';
import 'package:myworkout/workouts/model/entity/exercise_performance.dart';
import 'package:myworkout/workouts/model/entity/exercise_set.dart';
import 'package:myworkout/workouts/model/entity/workout_exercise.dart';
import 'package:myworkout/workouts/util/custom_duration_picker.dart';
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
  List<num> restsController = [];

  bool identicalReps = true;
  bool identicalLoads = true;
  bool identicalRests = true;

  @override
  void initState() {
    /*initialisation de tous les controlleurs*/
    var exercisePerformance = widget.workoutExercise.exercisePerformance!;
    var exerciseSets = exercisePerformance.getPerformances();

    /* init les booléens identical*/
    identicalReps = exercisePerformance.identicalReps();
    identicalLoads = exercisePerformance.identicalLoads();
    identicalRests = exercisePerformance.identicalRests();
    /*init les controlleurs*/
    setsController.text = exercisePerformance.sets.toString();
    setsController.addListener(() {
      //validateur du controlleur des sets (entre 1 et 99)
      setState(() {
        if (setsController.text != '' && int.parse(setsController.text) < 1) {
          setsController.text = '1';
        } else if (int.parse(setsController.text) > 99) {
          setsController.text = '99';
        }
        updateRepsRestLoadControllers(int.tryParse(setsController.text));
      });
    });
    for (var i = 0; i < exercisePerformance.sets!; i++) {
      repsController
          .add(TextEditingController(text: exerciseSets[i].reps.toString()));
      loadsController
          .add(TextEditingController(text: exerciseSets[i].load.toString()));
      restsController.add((i == 0)
          ? exerciseSets[exercisePerformance.sets! - 1].rest
          : exerciseSets[i - 1].rest); //1er de la liste = repos apres series
    }

    super.initState();
  }

  @override
  void dispose() {
    /*on dispose tous les controlleurs*/
    var sets = int.tryParse(setsController.text) ?? 1;
    setsController.dispose();
    for (var i = 0; i < sets; i++) {
      repsController[i].dispose();
      loadsController[i].dispose();
    }
    super.dispose();
  }

  void addControllers(List<TextEditingController> controllerList, number) {
    for (var i = 0; i < number; i++) {
      controllerList.add(TextEditingController(text: controllerList[0].text));
      controllerList[i].addListener(() {
        if (controllerList[i].text != '' &&
            int.parse(controllerList[i].text) < 0) {
          controllerList[i].text = '0';
        }
      });
    }
  }

  void updateSets(int? value) {
    if (value == null) {
      return;
    }
    setState(() {
      if (value > 0 && value < 100) {
        setsController.text = value.toString();
        updateRepsRestLoadControllers(value);
      }
    });
  }

  void updateRepsRestLoadControllers(int? value) {
    if (value == null) {
      return;
    }
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
    /*add or remove rests controllers*/
    if (restsController.length > value) {
      restsController = restsController.sublist(0, value);
    } else if (restsController.length < value) {
      //indice 0 -> apres les series, >=1 -> entre les series
      restsController.add(
          restsController.length > 1 ? restsController[1] : restsController[0]);
    }
  }

  void updateReps(num value, int index) {
    if (value < 0) {
      return;
    }
    if (identicalReps) {
      for (var i = 0; i < repsController.length; i++) {
        repsController[i].text = value.toString();
      }
    } else {
      repsController[index].text = value.toString();
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
      for (var i = 0; i < loadsController.length; i++) {
        loadsController[i].text = value.toString();
      }
    } else {
      loadsController[index].text = value.toString();
    }
  }

  Future<void> saveData() async {
    List<ExerciseSet> exerciseSets = [];
    var sets = int.tryParse(setsController.text) ?? repsController.length;

    for (var i = 0; i < sets; i++) {
      exerciseSets.add(
        ExerciseSet(
          reps: identicalReps
              ? num.parse(repsController[0].text)
              : num.parse(repsController[i].text),
          rest: () {
            if (i == sets - 1) {
              //derniere valeur = 1er de la liste (temps apres series)
              return restsController[0];
            } else if (identicalRests && sets > 1) {
              //si identique, temps = 1er de la liste des temps entre les series (ie indice 1)
              return restsController[1];
            }
            //sinon indice i+1
            return restsController[i + 1];
          }(),
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

  Widget buildSetsInput() {
    return Container(
      decoration: styles.frame.boxDecoration,
      margin: styles.frame.margin,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Text('Nombre de séries', style: styles.frame.subtitle),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_rounded,
                    color: styles.frame.primaryTextColor),
                onPressed: () => {
                  updateSets(int.tryParse(setsController.text) != null
                      ? int.parse(setsController.text) - 1
                      : null)
                },
              ),
              buildInput(
                controller: setsController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                hintText: '0',
              ),
              IconButton(
                  icon: Icon(Icons.add_rounded,
                      color: styles.frame.primaryTextColor),
                  onPressed: () => {
                        updateSets(int.tryParse(setsController.text) != null
                            ? int.parse(setsController.text) + 1
                            : null)
                      }),
            ],
          )
        ],
      ),
    );
  }

  Widget buildRepsInput() {
    return Container(
      decoration: styles.frame.boxDecoration,
      margin: styles.frame.margin,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
            //si le nombre de sets est vide, on met 1 par défaut
            itemCount: (identicalReps || setsController.text == '')
                ? 1
                : int.parse(setsController.text),
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
                Text('reps', style: styles.frame.text),
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
      decoration: styles.frame.boxDecoration,
      margin: styles.frame.margin,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
            //si le nombre de sets est vide, on met 1 par défaut
            itemCount: (identicalLoads || setsController.text == '')
                ? 1
                : int.parse(setsController.text),
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
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^[0-9]+\.?[0-9]*'))
                  ],
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
          ),
        ],
      ),
    );
  }

  Widget buildTime(int index) {
    var minutes = getMinutes(restsController[index]);
    var seconds = getSeconds(restsController[index]);
    return Center(
        child: ButtonTransparent(
            expand: false,
            title: Text(
              '$minutes " $seconds',
              style: styles.frame.title,
              textAlign: TextAlign.center,
            ),
            icon: FaIcon(FontAwesomeIcons.stopwatch,
                color: styles.frame.primaryTextColor),
            onTap: () {
              var picker = CustomDurationPicker();
              picker.showPicker(
                  context: context,
                  initialTime: restsController[index].toInt(),
                  onConfirm: (time) {
                    setState(() {
                      restsController[index] = time;
                    });
                  });
            }));
  }

  Widget buildRestsBetweenInput() {
    if (setsController.text == '1') {
      return const SizedBox.shrink();
    }
    return Container(
      decoration: styles.frame.boxDecoration,
      margin: styles.frame.margin,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Text('Repos entre les séries', style: styles.frame.subtitle),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Repos identiques', style: styles.frame.bigText),
              CustomCheckBox(
                value: identicalRests,
                onChanged: (_) {
                  setState(() {
                    identicalRests = !identicalRests;
                  });
                },
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            //si le nombre de sets est vide, on met 1 par défaut
            itemCount: (setsController.text == '' || setsController.text == '1')
                ? 0
                : (identicalRests ? 1 : int.parse(setsController.text) - 1),
            itemBuilder: (context, index) => buildTime(index + 1),
          ),
        ],
      ),
    );
  }

  Widget buildRestAfterInput() {
    return Container(
      decoration: styles.frame.boxDecoration,
      margin: styles.frame.margin,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Text(
              setsController.text == '1'
                  ? 'Repos après la série'
                  : 'Repos après les séries',
              style: styles.frame.subtitle),
          styles.form.littleVoidSpace,
          buildTime(0)
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
                styles.form.littleVoidSpace,
                Text(widget.workoutExercise.exercise?.name ?? "",
                    style: styles.frame.title),
                styles.form.littleVoidSpace,
                ExerciseImage(
                  imageId: widget.workoutExercise.exercise?.imageId,
                  size: 120,
                ),
                styles.form.littleVoidSpace,
                Column(
                  children: [
                    buildSetsInput(),
                    buildRepsInput(),
                    buildLoadsInput(),
                    buildRestsBetweenInput(),
                    buildRestAfterInput()
                  ],
                ),
                styles.form.mediumVoidSpace
              ],
            ),
          ),
        ),
      ),
    );
  }
}
