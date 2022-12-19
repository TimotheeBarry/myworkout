import 'package:flutter/material.dart';
import 'package:myworkout/core/util/custom_app_bar.dart';
import 'package:myworkout/core/util/custom_button.dart';
import 'package:myworkout/core/util/edit_images_buttons.dart';
import 'package:myworkout/core/util/input_field.dart';
import 'package:myworkout/workouts/model/dao/workouts_dao.dart';
import 'package:myworkout/workouts/model/entity/workout.dart';
import 'package:myworkout/workouts/model/entity/workout_group.dart';
import '../../core/theme/styles.dart' as styles;

class CreateWorkoutView extends StatefulWidget {
  const CreateWorkoutView({Key? key, this.workout}) : super(key: key);
  final Workout? workout;

  @override
  State<CreateWorkoutView> createState() => _CreateWorkoutViewState();
}

class _CreateWorkoutViewState extends State<CreateWorkoutView> {
  List<WorkoutGroup> workoutGroups = [];
  late bool edit;
  late Workout editedWorkout;

  @override
  void initState() {
    super.initState();
    setState(() {
      edit = widget.workout != null;
      editedWorkout = widget.workout ?? Workout();
    });
    getData();
  }

  void getData() async {
    final workoutsDao = WorkoutsDao();
    List<WorkoutGroup> _workoutGroups = await workoutsDao.getWorkoutGroups();
    setState(() {
      workoutGroups = _workoutGroups;
    });
  }

  Widget buildNameInput() {
    return InputField(
      hintText: 'Name...',
      initialValue: widget.workout?.name ?? "",
      onChanged: (String name) {
        editedWorkout = editedWorkout.copy(name: name);
      },
    );
  }

  Widget buildGroupsSelector() {
    final List<DropdownMenuItem<int>> dropDownItems = workoutGroups.map(
      (group) {
        return DropdownMenuItem<int>(
          alignment: AlignmentDirectional.centerStart,
          value: group.id,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Text(group.name!),
          ),
        );
      },
    ).toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ClipRRect(
          borderRadius: styles.button.borderRadius,
          child: Material(
            child: Ink(
              decoration: BoxDecoration(color: styles.button.backgroundColor),
              child: DropdownButtonHideUnderline(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: styles.button.backgroundColor,
                  ),
                  child: DropdownButton(
                    //isDense: true,
                    items: dropDownItems,
                    value: editedWorkout.groupId,
                    style: styles.button.smallText,
                    onChanged: (int? value) {
                      setState(() {
                        editedWorkout = editedWorkout.copy(groupId: value);
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        ClipRRect(
          borderRadius: styles.button.borderRadius,
          child: Material(
            child: InkWell(
              onTap: () {},
              child: Ink(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(color: styles.button.backgroundColor),
                child: Text('Nouveau Groupe', style: styles.button.smallText),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildDescriptionArea() {
    return InputField(
      maxLines: 7,
      initialValue: widget.workout?.description ?? "",
      hintText: "Description...",
      onChanged: (String description) {
        setState(() {
          editedWorkout = editedWorkout.copy(description: description);
        });
      },
    );
  }

  void saveWorkout() async {
    var workoutsDao = WorkoutsDao();
    if (editedWorkout.name == "") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Veuillez renseigner le nom de la séance"),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } else if (edit) {
      await workoutsDao
          .updateWorkout(editedWorkout)
          .then((_) => Navigator.pop(context, true));
      ;
    } else {
      await workoutsDao
          .createWorkout(editedWorkout)
          .then((_) => Navigator.pop(context, true));
      ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: styles.page.boxDecoration,
      child: Scaffold(
        appBar:
            CustomAppBar(title: edit ? 'Editer la séance' : 'Créer une séance'),
        body: SingleChildScrollView(
          child: Padding(
            padding: styles.page.margin,
            child: Column(
              children: [
                buildNameInput(),
                styles.form.mediumVoidSpace,
                const Placeholder(
                  fallbackHeight: 200,
                ),
                styles.form.mediumVoidSpace,
                EditImagesButtons(edit: edit),
                styles.form.mediumVoidSpace,
                buildGroupsSelector(),
                styles.form.mediumVoidSpace,
                buildDescriptionArea(),
                styles.form.mediumVoidSpace,
                CustomButton(
                  title: Text(
                    edit ? 'Editer' : 'Créer',
                    style: styles.button.bigText,
                  ),
                  onTap: saveWorkout,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
