import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myworkout/core/util/custom_app_bar.dart';
import 'package:myworkout/core/util/custom_button.dart';
import 'package:myworkout/core/util/input_field.dart';
import 'package:myworkout/exercises/model/dao/exercises_dao.dart';
import 'package:myworkout/exercises/model/entity/exercise.dart';
import 'package:myworkout/exercises/model/entity/exercise_group.dart';
import 'package:myworkout/exercises/util/exercise_image.dart';
import '../../core/theme/styles.dart' as styles;

class CreateExerciseView extends StatefulWidget {
  const CreateExerciseView({Key? key, this.exercise}) : super(key: key);
  final Exercise? exercise;

  @override
  State<CreateExerciseView> createState() => _CreateExerciseViewState();
}

class _CreateExerciseViewState extends State<CreateExerciseView> {
  List<ExerciseGroup> exerciseGroups = [];
  late bool edit;
  late Exercise editedExercise;

  @override
  void initState() {
    super.initState();
    edit = widget.exercise != null;
    editedExercise = widget.exercise ?? Exercise();
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

  void saveExercise() async {
    var exercisesDao = ExercisesDao();
    if (editedExercise.name == "") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Veuillez renseigner le nom de l'exercice."),
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
      await exercisesDao
          .updateExercise(editedExercise)
          .then((_) => Navigator.pop(context, true));
    } else {
      await exercisesDao
          .createExercise(editedExercise)
          .then((_) => Navigator.pop(context, true));
    }
  }

  Widget buildNameInput() {
    return InputField(
      hintText: 'Name...',
      initialValue: widget.exercise?.name ?? "",
      onChanged: (String name) {
        editedExercise = editedExercise.copy(name: name);
      },
    );
  }

  Widget buildImageIcons() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: edit
            ? [
                IconButton(
                  icon: Icon(Icons.image,
                      size: 40, color: styles.frame.primaryTextColor),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                ),
                IconButton(
                  icon: Icon(Icons.photo_camera,
                      size: 40, color: styles.frame.primaryTextColor),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                ),
                IconButton(
                  icon: Icon(Icons.delete,
                      size: 40, color: styles.frame.primaryTextColor),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                ),
              ]
            : [
                IconButton(
                  icon: Icon(Icons.image,
                      size: 40, color: styles.frame.primaryTextColor),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                ),
                IconButton(
                  icon: Icon(Icons.photo_camera,
                      size: 40, color: styles.frame.primaryTextColor),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                ),
              ]);
  }

  Widget buildGroupsSelector() {
    final List<DropdownMenuItem<int>> dropDownItems = exerciseGroups.map(
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
                    value: editedExercise.groupId,
                    style: styles.button.smallText,
                    onChanged: (int? value) {
                      editedExercise = editedExercise.copy(groupId: value);
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
      initialValue: widget.exercise?.description ?? "",
      hintText: "Description...",
      onChanged: (String description) {
        editedExercise = editedExercise.copy(description: description);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: styles.page.boxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
            title: edit ? 'Editer l\'exercice' : 'Créer un exercice'),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                buildNameInput(),
                styles.form.mediumVoidSpace,
                Hero(
                  tag: widget.exercise?.imageId ?? 0,
                  child: ExerciseImage(
                    imageId: widget.exercise?.imageId,
                    size: 180,
                  ),
                ),
                styles.form.mediumVoidSpace,
                buildImageIcons(),
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
                  onTap: saveExercise,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
