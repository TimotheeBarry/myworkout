import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
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
        title: const Text("Durée", textAlign: TextAlign.center),
        delimiter: [
          PickerDelimiter(column: 0, child: SizedBox(width: 16)),
          PickerDelimiter(
            column: 2,
            child: const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text('min'),
              ),
            ),
          ),
          PickerDelimiter(
            column: 4,
            child: const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text('s'),
              ),
            ),
          ),
          PickerDelimiter(column: 5, child: SizedBox(width: 16)),
        ],
        diameterRatio: 3,
        backgroundColor: Colors.white,
        height: 200,
        itemExtent: 60,
        looping: true,
        selecteds:
            initialTime != null ? [initialTime ~/ 60, (initialTime % 60)~/5] : null,
        confirmText: 'Confirmer',
        cancelText: 'Annuler',
        squeeze: 1,
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
          var values = picker.getSelectedValues();
          var time = 60 * num.parse(values[0]) + num.parse(values[1]);
          print(time);
          onConfirm(time);
        }).showModal(
      context,
      backgroundColor: Colors.white,
    );
  }
}
