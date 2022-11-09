import 'dart:math';

import 'package:myworkout/core/util/functions.dart';
import 'package:myworkout/workouts/model/entity/exercise_set.dart';

class ExercisePerformance {
  int? sets;
  String? reps;
  String? loads;
  String? rests;
  ExercisePerformance({
    this.sets = 1,
    this.reps = "0",
    this.loads = "0",
    this.rests = "0",
  });
  
  bool identicalReps() {
    var list = reps!.split('-').map((e) => num.parse(e)).toList();
    return (list.reduce(min) == list.reduce(max));
  }

  bool identicalLoads() {
    var list = loads!.split('-').map((e) => num.parse(e)).toList();
    return (list.reduce(min) == list.reduce(max));
  }

  bool identicalRests() {
    var list = rests!.split('-').map((e) => num.parse(e)).toList();
    return (list.reduce(min) == list.reduce(max));
  }

  String repsToString() {
    var list = reps!.split('-').map((e) => num.parse(e)).toList();
    if (list.reduce(min) == list.reduce(max)) {
      return '$sets x ${list.first}';
    }
    return reps!;
  }

  String loadToString() {
    var list = loads!.split('-').map((e) => num.parse(e)).toList();
    if (list.reduce(min) == list.reduce(max)) {
      return '${list.first} kg';
    }
    return "$loads kg";
  }

  String secondsToString(int sec) {
    var minutes = getMinutes(sec);
    var seconds = getSeconds(sec);
    return "${minutes != "00" ? "$minutes" : ""}\"$seconds";
  }

  String restToString() {
    var list = rests!.split('-').map((e) => num.parse(e)).toList();
    if (list.reduce(min) == list.reduce(max)) {
      return secondsToString(list.first.toInt());
    }
    return rests!;
  }

  ExercisePerformance getFromSets(List<ExerciseSet> exerciseSets) {
    sets = exerciseSets.length;
    reps = exerciseSets.map((e) => e.reps).toList().join('-');
    loads = exerciseSets.map((e) => e.load).toList().join('-');
    rests = exerciseSets.map((e) => e.rest).toList().join('-');
    return ExercisePerformance(
      sets: sets,
      reps: reps,
      loads: loads,
      rests: rests,
    );
  }

  List<ExerciseSet> getPerformances() {
    List<ExerciseSet> list = [];
    var repList = reps!.split('-').map((e) => num.parse(e)).toList();
    var loadList = loads!.split('-').map((e) => num.parse(e)).toList();
    var restList = rests!.split('-').map((e) => num.parse(e)).toList();
    for (var i = 0; i < sets!; i++) {
      list.add(
          ExerciseSet(reps: repList[i], load: loadList[i], rest: restList[i]));
    }
    return list;
  }
}
