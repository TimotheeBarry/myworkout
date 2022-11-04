import 'dart:math';

import 'package:myworkout/core/util/functions.dart';

class ExercisePerformance {
  final int? sets;
  final String? reps;
  final String? load;
  final String? restBetween;
  final int? restAfter;
  ExercisePerformance({
    this.sets = 0,
    this.reps = "0",
    this.load = "0",
    this.restBetween = "0",
    this.restAfter = 0,
  });

  bool isIdentical(List<int> list) {
    return list.reduce(min) == list.reduce(max);
  }

  String repsToString() {
    var list = reps!.split('-').map((e) => int.parse(e)).toList();
    if (isIdentical(list)) {
      return '$sets x ${list.first}';
    }
    return reps!;
  }

  String loadToString() {
    var list = load!.split('-').map((e) => int.parse(e)).toList();
    if (isIdentical(list)) {
      return '${list.first} kg';
    }
    return "$load kg";
  }

  String secondsToString(int sec) {
    var hours = getHours(sec);
    var minutes = getMinutes(sec);
    var seconds = getSeconds(sec);
    return "${hours != "00" ? "$hours'" : ""}${minutes != "00" ? "$minutes" : ""}\"$seconds";
  }

  String restToString() {
    var list = restBetween!.split('-').map((e) => int.parse(e)).toList();
    if (isIdentical(list)) {
      return '${secondsToString(list.first)}';
    }
    return restBetween!;
  }
}
