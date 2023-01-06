import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myworkout/statistics/model/entity/statistics_chart_item.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../core/theme/styles.dart' as styles;

class BarChart extends StatelessWidget {
  BarChart({Key? key, required this.rangeIndex, required this.chartRawData})
      : super(key: key);
  final int rangeIndex;
  final List<StatisticsChartItem> chartRawData;

  // date du jour (à 00:00:00)
  DateTime get now {
    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  //Date mini du jeu de donnée (première séance)
  DateTime get minDate =>
      chartRawData.isNotEmpty ? chartRawData.last.date! : now;

  List<int> get rangeValues =>
      [7, 30, 90, 365, max(7, now.difference(minDate).inDays + 1)];

  //nombre de jours à afficher
  int get nbDays => rangeValues[rangeIndex];

  //pas entre chaque jour (regroupement en jour, semaine mois ou plus selon le nombre de jours)
  int get step {
    if (nbDays < 100) {
      return 1;
    } else if (nbDays < 700) {
      return 7;
    } else if (nbDays < 3000) {
      return 30;
    }
    return 365;
  }

  List<List<StatisticsChartItem>> convertData(
      List<StatisticsChartItem> dataList) {
    Map<int, List<StatisticsChartItem>> groups =
        groupBy(dataList, (obj) => obj.groupId!);
    List<List<StatisticsChartItem>> chartData = [];

    //pour chaque groupe d'exercice (clef = id de l'exercice)
    for (int key in groups.keys) {
      var value = groups[key];
      //initialisation de la liste
      List<StatisticsChartItem> chartDataGroup = [];
      //pour chaque jour de la liste, on regarde s'il y a des données ce jour la. si oui on l'ajoute
      for (var i = 0; i < nbDays; i = i + step) {
        //calcul date du jour - i et ajout à la liste
        final displayedDate = now.subtract(Duration(days: nbDays - i - 1));
        var chartItem = StatisticsChartItem(
            countValue: 0,
            date: displayedDate,
            groupId: key,
            groupName: value![0].groupName);
        //somme les valeurs par step de 7, 30 ou 365 si nécessaire
        for (var j = 0; j < step; j++) {
          final date = now.subtract(Duration(days: nbDays - (i + j) - 1));
          final items =
              value.where((item) => item.date!.isAtSameMomentAs(date));
          for (var item in items) {
            chartItem.countValue = chartItem.countValue! + item.countValue!;
          }
        }

        chartDataGroup.add(chartItem);
      }
      chartData.add(chartDataGroup.map((e) => e).toList());
    }
    return chartData;
  }

  List<StackedColumnSeries<dynamic, dynamic>> buildSeries() {
    final chartData = convertData(chartRawData);

    final stackedColumnSeries = <StackedColumnSeries>[];
    for (var i = 0; i < chartData.length; i++) {
      stackedColumnSeries.add(
        StackedColumnSeries<StatisticsChartItem, DateTime>(
            //animationDuration: 100,
            //animationDelay: 50.0 * i,
            width: .85,
            dataSource: chartData[i],
            xValueMapper: (StatisticsChartItem data, _) => data.date!,
            yValueMapper: (StatisticsChartItem data, _) => data.countValue,
            name: chartData[i].isNotEmpty ? chartData[i][0].groupName : "",
            legendIconType: LegendIconType.rectangle),
      );
    }
    return stackedColumnSeries;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //decoration: styles.frame.boxDecoration,
      child: SfCartesianChart(
        title: ChartTitle(
            text: 'Statistiques de séance',
            alignment: ChartAlignment.center,
            textStyle: styles.frame.subtitle),
        palette: styles.colors.palette,
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          itemPadding: 20,
          textStyle: styles.frame.legend,
          overflowMode: LegendItemOverflowMode.wrap,
        ),
        /*zoomPanBehavior: ZoomPanBehavior(
            enablePanning: true, zoomMode: ZoomMode.x, enablePinching: true),*/
        series: buildSeries(),
        primaryXAxis: DateTimeAxis(
          labelStyle: const TextStyle(color: Colors.white70),
          dateFormat:
              rangeIndex < 3 ? DateFormat('dd MMM') : DateFormat('MMM yy'),
          desiredIntervals: 7,
          majorGridLines: const MajorGridLines(color: Colors.white24),
        ),
        primaryYAxis: NumericAxis(
          labelStyle: const TextStyle(color: Colors.white70),
          majorGridLines: const MajorGridLines(color: Colors.white24),
          title: AxisTitle(
            text: 'Séries',
            textStyle: const TextStyle(color: Colors.white70),
          ),
        ),
        plotAreaBorderColor: Colors.white38,
      ),
    );
  }
}
