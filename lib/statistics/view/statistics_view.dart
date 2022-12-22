import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myworkout/core/util/custom_list_tile.dart';
import 'package:myworkout/core/util/functions.dart';
import 'package:myworkout/statistics/model/dao/statistics_dao.dart';
import 'package:myworkout/statistics/model/entity/statistic_item.dart';
import 'package:myworkout/statistics/model/entity/statistics_chart_item.dart';
import 'package:myworkout/statistics/util/bar_chart.dart';
import 'package:myworkout/statistics/util/chart_options.dart';
import 'package:myworkout/statistics/view/workout_statistics_view.dart';
import '../../core/theme/styles.dart' as styles;

class StatisticsView extends StatefulWidget {
  const StatisticsView({Key? key}) : super(key: key);

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  var statisticsList = [];
  List<StatisticsChartItem> chartRawData = [];
  int rangeIndex = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    var dao = StatisticsDao();
    var _chartRawData = await dao.getSetsForChart(minDate: null);
    var _statisticsList = await dao.getStatisticsList();
    setState(
      () {
        statisticsList = _statisticsList;
        chartRawData = _chartRawData;
      },
    );
  }

  void setRangeIndex(index) {
    setState(() {
      rangeIndex = index;
    });
  }

  /*DateTime? getMinDate() {
    if (widget.rangeIndex > 3) {
      return null;
    }
    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: rangeValues[widget.rangeIndex]! - 1));
  }*/

  Widget buildListItem(BuildContext context, StatisticItem statisticItem) {
    return Container(
      margin: styles.list.margin,
      decoration: styles.frame.boxDecoration,
      child: ClipRRect(
        borderRadius: styles.list.borderRadius,
        child: CustomListTile(
          title:
              Text(statisticItem.workout?.name ?? '', style: styles.list.title),
          subtitle: Text(statisticItem.workoutGroup?.name ?? '',
              style: styles.list.description),
          middle: Column(children: [
            Text(getWeekDay(statisticItem.date!.weekday),
                style: styles.list.description),
            Text(DateFormat('dd/MM/yyyy').format(statisticItem.date!),
                style: styles.list.description),
            Text(DateFormat('HH:mm').format(statisticItem.date!),
                style: styles.list.description),
          ]),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) =>
                    WorkoutStatisticsView(statisticItem: statisticItem))));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ChartOptions(
            rangeIndex: rangeIndex,
            setRangeIndex: setRangeIndex,
          ),
          BarChart(rangeIndex: rangeIndex, chartRawData : chartRawData),
          ListView.builder(
              itemCount: statisticsList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) =>
                  buildListItem(context, statisticsList[index])),
        ],
      ),
    );
  }
}
