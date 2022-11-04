import 'package:flutter/material.dart';
import 'package:myworkout/core/util/custom_list_tile.dart';
import 'package:myworkout/statistics/util/bar_chart.dart';
import 'package:myworkout/statistics/util/chart_options.dart';
import '../../core/theme/styles.dart' as styles;

class StatisticsView extends StatelessWidget {
  StatisticsView({Key? key}) : super(key: key);
  @override
  Widget buildListItem(BuildContext context, int i) {
    return Container(
      margin: styles.list.margin,
      decoration: styles.frame.boxDecoration,
      child: ClipRRect(
        borderRadius: styles.list.borderRadius,
        child: CustomListTile(
          title: Text('Séance $i', style: styles.list.title),
          subtitle: Text('Push Pull Legs',
              style: styles.list.description),
          middle: Column(children: [
            Text('Mercredi', style: styles.list.description),
            Text('02/11/2022', style: styles.list.description),
            Text('12h01', style: styles.list.description),
          ]),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          onTap: () {},
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const ChartOptions(),
          BarChart(),
          ListView.builder(
              itemCount: 25,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) => buildListItem(context, i)),
        ],
      ),
    );
  }
}
