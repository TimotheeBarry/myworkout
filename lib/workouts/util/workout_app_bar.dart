import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myworkout/workouts/util/global_timer.dart';

class WorkoutAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentSet;
  final void Function() nextSet;
  @override
  Size get preferredSize => const Size.fromHeight(50);
  const WorkoutAppBar(
      {Key? key, required this.currentSet, required this.nextSet})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.arrow_back_ios_rounded)),
          GlobalTimer(),
          IconButton(
              onPressed: nextSet,
              icon: const Icon(Icons.arrow_forward_ios_rounded)),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.edit_note_rounded,
          ),
          onPressed: () {},
        )
      ],
      centerTitle: true,
    );
  }
}
