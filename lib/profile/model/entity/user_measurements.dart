import 'package:myworkout/core/util/functions.dart';

class UserMeasurements {
  double? height;
  double? weight;
  double? bodyfat;
  double? neck;
  double? shoulders;
  double? chest;
  double? bicepsL;
  double? bicepsR;
  double? forearmL;
  double? forearmR;
  double? wristL;
  double? wristR;
  double? waist;
  double? hips;
  double? thighL;
  double? thighR;
  double? calveL;
  double? calveR;
  double? ankleL;
  double? ankleR;
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

  static UserMeasurements fromJSON(Map<String, Object?> json) =>
      UserMeasurements(
        height: json[UserMeasurementsFields.height] as double?,
        weight: json[UserMeasurementsFields.weight] as double?,
        bodyfat: json[UserMeasurementsFields.bodyfat] as double?,
        neck: json[UserMeasurementsFields.neck] as double?,
        shoulders: json[UserMeasurementsFields.shoulders] as double?,
        chest: json[UserMeasurementsFields.chest] as double?,
        bicepsL: json[UserMeasurementsFields.bicepsL] as double?,
        bicepsR: json[UserMeasurementsFields.bicepsR] as double?,
        forearmL: json[UserMeasurementsFields.forearmL] as double?,
        forearmR: json[UserMeasurementsFields.forearmR] as double?,
        wristL: json[UserMeasurementsFields.wristL] as double?,
        wristR: json[UserMeasurementsFields.wristR] as double?,
        waist: json[UserMeasurementsFields.waist] as double?,
        hips: json[UserMeasurementsFields.hips] as double?,
        thighL: json[UserMeasurementsFields.thighL] as double?,
        thighR: json[UserMeasurementsFields.thighR] as double?,
        calveL: json[UserMeasurementsFields.calveL] as double?,
        calveR: json[UserMeasurementsFields.calveR] as double?,
        ankleL: json[UserMeasurementsFields.ankleL] as double?,
        ankleR: json[UserMeasurementsFields.ankleR] as double?,
      );

  Map<String, Object?> toJSON() => {
        UserMeasurementsFields.height: height,
        UserMeasurementsFields.weight: weight,
        UserMeasurementsFields.bodyfat: bodyfat,
        UserMeasurementsFields.neck: neck,
        UserMeasurementsFields.shoulders: shoulders,
        UserMeasurementsFields.chest: chest,
        UserMeasurementsFields.bicepsL: bicepsL,
        UserMeasurementsFields.bicepsR: bicepsR,
        UserMeasurementsFields.forearmL: forearmL,
        UserMeasurementsFields.forearmR: forearmR,
        UserMeasurementsFields.wristL: wristL,
        UserMeasurementsFields.wristR: wristR,
        UserMeasurementsFields.waist: waist,
        UserMeasurementsFields.hips: hips,
        UserMeasurementsFields.thighL: thighL,
        UserMeasurementsFields.thighR: thighR,
        UserMeasurementsFields.calveL: calveL,
        UserMeasurementsFields.calveR: calveR,
        UserMeasurementsFields.ankleL: ankleL,
        UserMeasurementsFields.ankleR: ankleR,
      };

  UserMeasurements copy({
    double? height,
    double? weight,
    double? bodyfat,
    double? neck,
    double? shoulders,
    double? chest,
    double? bicepsL,
    double? bicepsR,
    double? forearmL,
    double? forearmR,
    double? wristL,
    double? wristR,
    double? waist,
    double? hips,
    double? thighL,
    double? thighR,
    double? calveL,
    double? calveR,
    double? ankleL,
    double? ankleR,
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
      double bmi = weight! / ((height! / 100) * (height! / 100));
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
