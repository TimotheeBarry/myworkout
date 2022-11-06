import 'package:myworkout/exercises/model/entity/exercise.dart';

class ExerciseSet {
  final int reps;
  final int load;
  final int rest;

  ExerciseSet({
    required this.reps,
    required this.load,
    required this.rest,
  });
}
