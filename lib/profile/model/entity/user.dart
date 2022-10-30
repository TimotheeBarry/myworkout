import 'package:myworkout/core/util/functions.dart';
import 'package:time_machine/time_machine.dart';

class User {
  final int? id;
  final String? username;
  final DateTime? birthdate;
  final String? gender;
  final double? height;
  final double? weight;
  final double? bodyfat;
  User({
    this.id,
    this.username,
    this.birthdate,
    this.gender,
    this.height,
    this.weight,
    this.bodyfat,
  });

  Map<String, Object?> toJSON() => {
        UserFields.id: id,
        UserFields.username: username,
        UserFields.birthdate: birthdate?.toIso8601String(),
        UserFields.gender: gender,
        UserFields.height: height,
        UserFields.weight: weight,
        UserFields.bodyfat: bodyfat,
      };

  static User fromJSON(Map<String, Object?> json) => User(
        id: json[UserFields.id] as int?,
        username: json[UserFields.username] as String?,
        birthdate: (json[UserFields.birthdate] != null)
            ? DateTime.parse(json[UserFields.birthdate] as String)
            : null,
        gender: json[UserFields.gender] as String?,
        height: json[UserFields.height] as double?,
        weight: json[UserFields.weight] as double?,
        bodyfat: json[UserFields.bodyfat] as double?,
      );

  User copy({
    int? id,
    String? username,
    DateTime? birthdate,
    String? gender,
    double? height,
    double? weight,
    double? bodyfat,
  }) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        birthdate: birthdate ?? this.birthdate,
        gender: gender ?? this.gender,
        height: height ?? this.height,
        weight: weight ?? this.weight,
        bodyfat: bodyfat ?? this.bodyfat,
      );

  double? bmi() {
    if (weight != null && height != null && height != 0) {
      double bmi = weight! / ((height! / 100) * (height! / 100));
      return roundDecimal(bmi, 1);
    }
    return null;
  }

  int? age() {
    if (birthdate != null) {
      LocalDate today = LocalDate.today();
      LocalDate bdate = LocalDate.dateTime(birthdate!);
      Period difference = today.periodSince(bdate);
      return difference.years;
    }
    return null;
  }
}

class UserFields {
  static final List<String> values = [
    id,
    username,
    birthdate,
    gender,
    height,
    weight,
    bodyfat,
  ];
  static const String id = 'id';
  static const String username = 'username';
  static const String birthdate = 'birthdate';
  static const String gender = 'gender';
  static const String height = 'height';
  static const String weight = 'weight';
  static const String bodyfat = 'bodyfat';
}
