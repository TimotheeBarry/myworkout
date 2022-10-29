import 'package:flutter/material.dart';
import 'package:myworkout/statistics/util/bar_chart.dart';
import '../../core/theme/styles.dart' as styles;

class StatisticsView extends StatelessWidget {
  StatisticsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BarChart(),
        ],
      ),
    );
  }
}
