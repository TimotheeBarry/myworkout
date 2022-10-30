import 'dart:math';

//arrondi val avec n decimales
double roundDecimal(double val, int n) {
  num mod = pow(10.0, n);
  return ((val * mod).round().toDouble() / mod);
}

String getSeconds(int seconds) {
  //nombre de secondes (entre 0 et 59)
  var sec = ((seconds % 3600) % 60).toString();
  if (sec.length == 1) {
    sec = '0$sec';
  }
  return sec;
}

String getMinutes(int seconds) {
  //nombre de minutes (entre 0 et 59)
  var minutes = ((seconds % 3600) ~/ 60).toString();
  if (minutes.length == 1) {
    minutes = '0$minutes';
  }
  return minutes;
}

String getHours(int seconds) {
  //nombre d'heures
  var hours = (seconds ~/ 3600).toString();
  if (hours.length == 1) {
    hours = '0$hours';
  }
  return hours;
}
