import 'package:flutter/material.dart';
import '../../core/theme/styles.dart' as styles;

class CustomFloatingButton extends StatelessWidget {
  final void Function() onPressed;
  CustomFloatingButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    //exercice ou séance
    return FloatingActionButton(
      onPressed: onPressed, //buttonAction,
      backgroundColor: styles.button.backgroundColor,
      foregroundColor: styles.button.foregroundColor,
      child: const Icon(Icons.add),
    );
  }
}
