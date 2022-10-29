import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../core/theme/styles.dart' as styles;

import '../model/statistics_data.dart';

class BarChart extends StatelessWidget {
  BarChart({Key? key}) : super(key: key);

  List<WorkoutStatisticData> chartData = generateChartData(number: 30);
  final legendName = <String>['Chest', 'Back', 'Triceps', 'Biceps', 'Legs'];

  buildSeries() {
    final stackedColumnSeries = <StackedColumnSeries>[];

    for (var i = 0; i < 5; i++) {
      stackedColumnSeries.add(
        StackedColumnSeries<WorkoutStatisticData, String>(
            animationDuration: 600,
            animationDelay: 50.0 * i,
            width: .7,
            dataSource: chartData,
            xValueMapper: (WorkoutStatisticData data, _) => data.date,
            yValueMapper: (WorkoutStatisticData data, _) =>
                data.categoryValues[i],
            name: legendName[i],
            legendIconType: LegendIconType.diamond),
      );
    }
    return stackedColumnSeries;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: styles.frame.boxDecoration,
      child: SfCartesianChart(
        title: ChartTitle(
            text: 'Statistiques de séance',
            alignment: ChartAlignment.center,
            textStyle: styles.frame.subtitle),
        legend: Legend(isVisible: true, position: LegendPosition.bottom,textStyle: styles.frame.text),
        series: buildSeries(),
        primaryXAxis: CategoryAxis(),
      ),
    );
  }
}
