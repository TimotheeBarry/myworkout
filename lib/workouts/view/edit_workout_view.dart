import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myworkout/core/util/custom_app_bar.dart';
import 'package:myworkout/exercises/model/entity/exercise.dart';
import 'package:myworkout/workouts/model/entity/workout.dart';
import 'package:myworkout/workouts/util/workout_list_item.dart';
import 'package:myworkout/workouts/view/create_workout_view.dart';
import '../../core/theme/styles.dart' as styles;

class EditWorkoutView extends StatefulWidget {
  const EditWorkoutView({Key? key, required this.workout}) : super(key: key);
  final Workout workout;
  @override
  State<EditWorkoutView> createState() => _EditWorkoutViewState();
}

class _EditWorkoutViewState extends State<EditWorkoutView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: styles.page.boxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(title: 'Editer la séance', actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateWorkoutView(
                              workout: widget.workout,
                            )));
              },
              icon: Icon(Icons.edit_note_rounded))
        ]),
        body: ReorderableListView.builder(
          padding: const EdgeInsets.all(2),
          itemCount: 5,
          onReorder: (oldIndex, newIndex) {},
          itemBuilder: (context, index) {
            return WorkoutListItem(key: ValueKey(index), index: index);
          },
        ),
      ),
    );
  }
}
