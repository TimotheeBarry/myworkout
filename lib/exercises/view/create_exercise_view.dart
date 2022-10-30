import 'package:flutter/material.dart';
import 'package:myworkout/core/util/custom_app_bar.dart';
import 'package:myworkout/core/util/input_field.dart';
import 'package:myworkout/exercises/model/dao/exercises_dao.dart';
import 'package:myworkout/exercises/model/entity/exercise.dart';
import 'package:myworkout/exercises/model/entity/exercise_group.dart';
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
    setState(() {
      edit = widget.exercise != null;
      editedExercise = widget.exercise ?? Exercise();
    });
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

  Widget buildNameInput({required BuildContext context}) {
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

  Widget buildGroupsSelector({required BuildContext context}) {
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
                      setState(() {
                        editedExercise = editedExercise.copy(groupId: value);
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

  Widget buildDescriptionArea({required BuildContext context}) {
    return InputField(
      maxLines: 7,
      initialValue: widget.exercise?.description ?? "",
      hintText: "Description...",
      onChanged: (String description) {
        setState(() {
          editedExercise = editedExercise.copy(description: description);
        });
      },
    );
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
      ;
    } else {
      await exercisesDao
          .createExercise(editedExercise)
          .then((_) => Navigator.pop(context, true));
      ;
    }
  }

  Widget buildSaveButton({required BuildContext context}) {
    return ClipRRect(
      borderRadius: styles.button.borderRadius,
      child: Material(
        child: InkWell(
          onTap: () {
            saveExercise();
          },
          child: Ink(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
            decoration: BoxDecoration(color: styles.button.backgroundColor),
            child:
                Text(edit ? 'Editer' : 'Créer', style: styles.button.bigText),
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
            title: edit ? 'Editer l\'exercice' : 'Créer un exercice'),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: [
                buildNameInput(context: context),
                const SizedBox(height: 16),
                const Placeholder(
                  fallbackHeight: 200,
                ),
                const SizedBox(height: 16),
                buildImageIcons(),
                const SizedBox(height: 16),
                buildGroupsSelector(context: context),
                const SizedBox(height: 16),
                buildDescriptionArea(context: context),
                const SizedBox(height: 16),
                buildSaveButton(context: context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
