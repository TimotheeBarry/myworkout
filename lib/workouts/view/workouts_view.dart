import 'package:flutter/material.dart';
import '../../core/theme/styles.dart' as styles;

class WorkoutsView extends StatelessWidget {
  WorkoutsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        margin: styles.frame.margin,
        decoration: styles.frame.boxDecoration,
        child: const Center(
          child: Text(
            'Workouts',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
