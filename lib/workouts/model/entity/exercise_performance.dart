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
    if (list.length > 1) {
      list = list.sublist(0, list.length - 1);
    }
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

  

  String restToString() {
    var list = rests!.split('-').map((e) => num.parse(e)).toList();
    var restAfter = list.last;
    list = list.sublist(0, list.length - 1);
    if (list.isEmpty) {
      return secondsToString(restAfter.toInt());
    }
    if (list.reduce(min) == list.reduce(max)) {
      return '${secondsToString(list.first.toInt())} | ${secondsToString(restAfter.toInt())}';
    }
    return '${list.map((e) => secondsToString(e.toInt())).join(' | ')} | ${secondsToString(restAfter.toInt())}';
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
