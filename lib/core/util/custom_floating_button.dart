import 'package:flutter/material.dart';

class CustomFloatingButton extends StatelessWidget {
  final openView;
  CustomFloatingButton({this.openView});

  @override
  Widget build(BuildContext context) {
    //exercice ou séance

    return FloatingActionButton(
      onPressed: () => {}, //buttonAction,
      child: const Icon(Icons.add),
      backgroundColor: const Color(0xa0ffffff),
      foregroundColor: Colors.black,
    );
  }
}
