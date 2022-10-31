import 'package:myworkout/core/util/functions.dart';
import 'package:myworkout/profile/model/entity/user_statistic.dart';
import 'package:time_machine/time_machine.dart';

class UserMeasurements {
  final UserStatistic? height;
  final UserStatistic? weight;
  final UserStatistic? bodyfat;
  final UserStatistic? neck;
  final UserStatistic? shoulders;
  final UserStatistic? chest;
  final UserStatistic? bicepsL;
  final UserStatistic? bicepsR;
  final UserStatistic? forearmL;
  final UserStatistic? forearmR;
  final UserStatistic? wristL;
  final UserStatistic? wristR;
  final UserStatistic? waist;
  final UserStatistic? hips;
  final UserStatistic? thighL;
  final UserStatistic? thighR;
  final UserStatistic? calveL;
  final UserStatistic? calveR;
  final UserStatistic? ankleL;
  final UserStatistic? ankleR;
  UserMeasurements({
    this.height,
    this.weight,
    this.bodyfat,
    this.neck,
    this.shoulders,
    this.chest,
    this.bicepsL,
    this.bicepsR,
    this.forearmL,
    this.forearmR,
    this.wristL,
    this.wristR,
    this.waist,
    this.hips,
    this.thighL,
    this.thighR,
    this.calveL,
    this.calveR,
    this.ankleL,
    this.ankleR,
  });

  UserMeasurements copy({
    UserStatistic? height,
    UserStatistic? weight,
    UserStatistic? bodyfat,
    UserStatistic? neck,
    UserStatistic? shoulders,
    UserStatistic? chest,
    UserStatistic? bicepsL,
    UserStatistic? bicepsR,
    UserStatistic? forearmL,
    UserStatistic? forearmR,
    UserStatistic? wristL,
    UserStatistic? wristR,
    UserStatistic? waist,
    UserStatistic? hips,
    UserStatistic? thighL,
    UserStatistic? thighR,
    UserStatistic? calveL,
    UserStatistic? calveR,
    UserStatistic? ankleL,
    UserStatistic? ankleR,
  }) =>
      UserMeasurements(
        height: height ?? this.height,
        weight: weight ?? this.weight,
        bodyfat: bodyfat ?? this.bodyfat,
        neck: neck ?? this.neck,
        shoulders: shoulders ?? this.shoulders,
        chest: chest ?? this.chest,
        bicepsL: bicepsL ?? this.bicepsL,
        bicepsR: bicepsR ?? this.bicepsR,
        forearmL: forearmL ?? this.forearmL,
        forearmR: forearmR ?? this.forearmR,
        wristL: wristL ?? this.wristL,
        wristR: wristR ?? this.wristR,
        waist: waist ?? this.waist,
        hips: hips ?? this.hips,
        thighL: thighL ?? this.thighL,
        thighR: thighR ?? this.thighR,
        calveL: calveL ?? this.calveL,
        calveR: calveR ?? this.calveR,
        ankleL: ankleL ?? this.ankleL,
        ankleR: ankleR ?? this.ankleR,
      );

  double? bmi() {
    if (weight != null && height != null && height != 0) {
      double bmi =
          weight!.value! / ((height!.value! / 100) * (height!.value! / 100));
      return roundDecimal(bmi, 1);
    }
    return null;
  }

 
}

class UserMeasurementsFields {
  
  static final List<String> values = [
    height,
    weight,
    bodyfat,
    neck,
    shoulders,
    chest,
    bicepsL,
    bicepsR,
    forearmL,
    forearmR,
    wristL,
    wristR,
    waist,
    hips,
    thighL,
    thighR,
    calveL,
    calveR,
    ankleL,
    ankleR,
  ];

  static const String height = 'height';
  static const String weight = 'weight';
  static const String bodyfat = 'bodyfat';
  static const String neck = 'neck';
  static const String shoulders = 'shoulders';
  static const String chest = 'chest';
  static const String bicepsL = 'biceps_l';
  static const String bicepsR = 'biceps_r';
  static const String forearmL = 'forearm_l';
  static const String forearmR = 'forearm_r';
  static const String wristL = 'wrist_l';
  static const String wristR = 'wrist_r';
  static const String waist = 'waist';
  static const String hips = 'hips';
  static const String thighL = 'thigh_l';
  static const String thighR = 'thigh_r';
  static const String calveL = 'calve_l';
  static const String calveR = 'calve_r';
  static const String ankleL = 'ankle_l';
  static const String ankleR = 'ankle_r';
}
