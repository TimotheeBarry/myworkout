import 'package:flutter/material.dart';
import 'package:myworkout/statistics/util/bar_chart.dart';
import 'package:myworkout/statistics/util/chart_options.dart';
import '../../core/theme/styles.dart' as styles;

class StatisticsView extends StatelessWidget {
  StatisticsView({Key? key}) : super(key: key);
  @override
  Widget buildListItem(BuildContext context, int i) {
    return Container(
      margin: styles.list.margin,
      child: ClipRRect(
        borderRadius: styles.list.borderRadius,
        child: Material(
          color: styles.frame.backgroundColor,
          child: Ink(
            child: ListTile(
              title: Text('Séance $i', style: styles.list.title),
              onTap: (){},
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const ChartOptions(),
          const SizedBox(height: 1),
          BarChart(),
          const SizedBox(height: 12),
          ListView.builder(
              itemCount: 20,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) => buildListItem(context, i)),
        ],
      ),
    );
  }
}
