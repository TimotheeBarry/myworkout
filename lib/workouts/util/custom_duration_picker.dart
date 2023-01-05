import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/styles.dart' as styles;

class CustomDurationPicker {
  CustomDurationPicker();

  List<dynamic> pickerData = [
    List.generate(60, (index) => index),
    List.generate(12, (index) => 5 * index),
  ];

  showPicker(
      {required BuildContext context,
      required void Function(num) onConfirm,
      int? initialTime}) {
    Picker(
        adapter:
            PickerDataAdapter<String>(pickerdata: pickerData, isArray: true),
        hideHeader: false,
        /*title:  Text(
          "Durée",
          textAlign: TextAlign.center,
          style: styles.frame.title,
        ),*/
        title: Center(
            child: Padding(padding:EdgeInsets.all(8),child: FaIcon(FontAwesomeIcons.stopwatch,
                size: 36, color: styles.frame.primaryTextColor))),
        cancelTextStyle: TextStyle(fontSize: 18, color: Colors.white70),
        confirmTextStyle: TextStyle(fontSize: 18, color: Colors.white70),
        textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: styles.frame.primaryTextColor),
        delimiter: [
          PickerDelimiter(column: 0, child: SizedBox(width: 16)),
          PickerDelimiter(
            column: 2,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text('min', style: styles.frame.bigText),
              ),
            ),
          ),
          PickerDelimiter(
            column: 4,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  's',
                  style: styles.frame.bigText,
                ),
              ),
            ),
          ),
          PickerDelimiter(column: 5, child: SizedBox(width: 16)),
        ],
        diameterRatio: 3,
        height: 240,
        itemExtent: 60,
        looping: true,
        selecteds: initialTime != null
            ? [initialTime ~/ 60, (initialTime % 60) ~/ 5]
            : null,
        confirmText: 'Confirmer',
        cancelText: 'Annuler',
        squeeze: 1,
        backgroundColor: Colors.transparent,
        containerColor: Colors.transparent,
        headerColor: Colors.white24,
        onConfirm: (Picker picker, List value) {
          //print(value.toString());
          //print(picker.getSelectedValues());
          var values = picker.getSelectedValues();
          var time = 60 * num.parse(values[0]) + num.parse(values[1]);
          //print(time);
          onConfirm(time);
        }).showModal(context, backgroundColor: Color.fromARGB(206, 11, 10, 40));
  }
}
