import 'package:myworkout/exercises/model/entity/exercise.dart';

class ExerciseSet {
  final num reps;
  final num load;
  final num rest;

  ExerciseSet({
    this.reps = 0,
    this.load = 0,
    this.rest = 0,
  });
}
