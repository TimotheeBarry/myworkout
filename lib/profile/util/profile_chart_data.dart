import 'dart:math';

class ProfileChartsSingleData {
  //final String dateIndex;
  final DateTime date;
  final double value;
  ProfileChartsSingleData({required this.value, required this.date});
}

class ProfileChartsData {
  final List<ProfileChartsSingleData> dataList;
  ProfileChartsData({required this.dataList});

  ProfileChartsSingleData minDateData(){
    return dataList.first;
  }
  ProfileChartsSingleData maxDateData(){
    return dataList.last;
  }
}

ProfileChartsData generateWeightData() {
  Random random = Random();
  final List<ProfileChartsSingleData> dataValues = [];
  for (var i = 0; i < 50; i++) {
    var randomDate = randomDateTime(2020, 2022);
    dataValues.add(ProfileChartsSingleData(
        value: 70 + random.nextInt(10).toDouble(), date: randomDate));
  }
  return ProfileChartsData(dataList: sortListByDate(dataValues));
}

DateTime randomDateTime(int yearMin, int yearMax) {
  Random random = Random();
  List<int> daysByMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  int year = yearMin + random.nextInt(1 + yearMax - yearMin);
  int month = 1 + random.nextInt(12);
  int day = 1 + random.nextInt(daysByMonth[month - 1]);

  return DateTime(year, month, day);
}

List<ProfileChartsSingleData> sortListByDate(
    List<ProfileChartsSingleData> dataValues) {
  List<ProfileChartsSingleData> sortedDataValues = [];
  var n = dataValues.length;
  var dateMax = 2*DateTime.now().millisecondsSinceEpoch;
  for (var i = 0; i < n; i++) {
    var minDateIndex = 0;
    var minDate = dateMax;
    for (var i = 0; i < dataValues.length; i++) {
      var date = dataValues[i].date.millisecondsSinceEpoch;
      if (date < minDate) {
        minDate = date;
        minDateIndex = i;
      }
    }
    sortedDataValues.add(dataValues[minDateIndex]);
    dataValues.removeAt(minDateIndex);
  }
  return sortedDataValues;
}
