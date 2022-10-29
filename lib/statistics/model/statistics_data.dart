import 'dart:math';

class WorkoutStatisticData {
  final String date;
  final List<num> categoryValues;
  WorkoutStatisticData({required this.date, required this.categoryValues});
}

List<WorkoutStatisticData> generateChartData({required int number}) {
  Random random = Random();
  final List<WorkoutStatisticData> listData = [];
  for (var i = 0; i < number; i++) {
    bool notToday =
        random.nextDouble() < 1 / 4; //simule un jour sans entrenainement
    var date = "${i + 1}";
    listData.add(
      notToday
          ? WorkoutStatisticData(date: date, categoryValues: [0, 0, 0, 0, 0])
          : WorkoutStatisticData(
              date: date,
              categoryValues: [
                (random.nextDouble() < 1 / 3)
                    ? 8 + (random.nextInt(8))
                    : 0, //un nombre entre 8 et 16 avec 1 chance sur 3.
                (random.nextDouble() < 1 / 3) ? 8 + (random.nextInt(8)) : 0,
                (random.nextDouble() < 1 / 3) ? 8 + (random.nextInt(8)) : 0,
                (random.nextDouble() < 1 / 3) ? 8 + (random.nextInt(8)) : 0,
                (random.nextDouble() < 1 / 3) ? 8 + (random.nextInt(8)) : 0,
              ],
            ),
    );
  }
  return listData;
}

List<WorkoutStatisticData> averageData(
    {required List<WorkoutStatisticData> rawData,
    int startIndex = 0,
    int step = 1}) {
  startIndex = (startIndex < 0) ? 0 : startIndex;
  List<String> newDates = [];
  List<WorkoutStatisticData> newValues = [];
  var nbCategories = rawData[0].categoryValues.length;
  for (var i = startIndex; i < rawData.length; i = i + step) {
    List<num> averageValues = List.filled(nbCategories, 0.0);
    for (var categoryIndex = 0; categoryIndex < nbCategories; categoryIndex++) {
      int nb_days = 0;
      for (var j = 0; (j < step && i + j < rawData.length); j++) {
        nb_days++;
        averageValues[categoryIndex] +=
            rawData[i + j].categoryValues[categoryIndex];
      }
      averageValues[categoryIndex] = (nb_days > 0)
          ? (averageValues[categoryIndex] / nb_days)
          : 0; //moyenne sur le nombre de jours
    }
    newValues.add(WorkoutStatisticData(
        categoryValues: averageValues, date: rawData[i].date));
  }
  return newValues;
}
