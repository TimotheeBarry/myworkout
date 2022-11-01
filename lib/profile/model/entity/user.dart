import 'package:myworkout/core/util/functions.dart';
import 'package:time_machine/time_machine.dart';

class User {
  int? id;
  String? username;
  DateTime? birthdate;
  String? gender;

  User({
    this.id,
    this.username,
    this.birthdate,
    this.gender,
  });

  Map<String, Object?> toJSON() => {
        UserFields.id: id,
        UserFields.username: username,
        UserFields.birthdate: birthdate?.toIso8601String(),
        UserFields.gender: gender,
      };

  static User fromJSON(Map<String, Object?> json) => User(
        id: json[UserFields.id] as int?,
        username: json[UserFields.username] as String?,
        birthdate: (json[UserFields.birthdate] != null)
            ? DateTime.parse(json[UserFields.birthdate] as String)
            : null,
        gender: json[UserFields.gender] as String?,
      );

  User copy({
    int? id,
    String? username,
    DateTime? birthdate,
    String? gender,
  }) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        birthdate: birthdate ?? this.birthdate,
        gender: gender ?? this.gender,
      );

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
  ];
  static const String id = 'id';
  static const String username = 'username';
  static const String birthdate = 'birthdate';
  static const String gender = 'gender';
}
