import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:myworkout/profile/model/dao/user_dao.dart';
import 'package:myworkout/profile/model/entity/user.dart';
import 'package:myworkout/profile/model/entity/user_statistic.dart';

class LineChart extends StatefulWidget {
  LineChart({
    Key? key,
    required this.user,
    required this.type,
    required this.data,
    this.title,
  }) : super(key: key);
  final String type; //weight, ...
  final String? title;
  final User user;
  final List<UserStatistic> data;
  @override
  State<LineChart> createState() => LineChartState();
}

class LineChartState extends State<LineChart> with TickerProviderStateMixin {
  //final List<Series>? seriesList;
  final GlobalKey _chartKey = GlobalKey();

  DateTime maxDate = DateTime.now();
  late DateTime minDate;

  int? dateLeft;
  int? dateRight;
  int? dateLeft0;
  int? dateRight0;

  double? minY0;
  double? maxY0;
  double? minY;
  double? maxY;

  Size? size;
  String? interaction; //none, drag ou zoom
  AnimationController? _controller;
  Animation<double>? dxAnimation;
  Animation<double>? dyAnimation;
  var displayDots = true;
  List<UserStatistic> userStatistics = [];
  //final chartData = generateWeightData();

  @override
  void initState() {
    super.initState();
    setState(() {
      //userStatistics = widget.data;
      resetGraph();
      _controller = AnimationController(
        duration: const Duration(milliseconds: 0),
        vsync: this,
      );
      dxAnimation = Tween<double>(begin: 0, end: 0).animate(_controller!);
      dyAnimation = Tween<double>(begin: 0, end: 0).animate(_controller!);
      getData();
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  void getData() async {
    final dao = UserDao();
    var _userStatistics =
        await dao.getUserStatistics(widget.user.id!, widget.type);
    setState(() {
      userStatistics = _userStatistics;
      resetGraph();
    });
  }

  void resetGraph() {
    dateRight = maxDate.millisecondsSinceEpoch;
    if (userStatistics.isEmpty) {
      minDate = maxDate.subtract(const Duration(days: 1));
      dateLeft = minDate.millisecondsSinceEpoch;
      minY = 0;
      maxY = 1;
    } else if (userStatistics.length == 1) {
      minDate = userStatistics[0].date!.subtract(const Duration(days: 1));
      dateLeft = minDate.millisecondsSinceEpoch;
      minY = userStatistics[0].value! - 1;
      maxY = userStatistics[0].value! + 1;
    } else {
      minDate = userStatistics[0].date!.subtract(const Duration(days: 1));

      dateLeft = maxDate.difference(minDate).inDays > 180
          ? maxDate.subtract(const Duration(days: 180)).millisecondsSinceEpoch
          : minDate.millisecondsSinceEpoch;

      final values = userStatistics.map((e) => e.value!).toList();
      minY = values.reduce(min).toDouble() - 1;
      maxY = values.reduce(max).toDouble() + 1;
    }
    minY0 = minY;
    maxY0 = maxY;
    dateLeft0 = dateLeft!;
    dateRight0 = dateRight!;
    size = const Size(400, 300);
    interaction = 'none';
  }

  bool checkDrag(dx, int newDateLeft, int newDateRight) {
    if (dx > 0) {
      return newDateLeft >= minDate.millisecondsSinceEpoch;
    } else if (dx < 0) {
      return newDateRight <= maxDate.millisecondsSinceEpoch;
    }
    return false;
  }

  void drag(double dx, double dy) {
    if (userStatistics.length < 2) {
      return;
    }
    var YExtent = maxY! - minY!;
    var deltaY = (dy * YExtent / (size!.height - 40));
    var timeExtent = dateRight! - dateLeft!;
    var deltaTime = (dx * timeExtent ~/ (size!.width - 20));
    var newdateLeft = dateLeft! - deltaTime;
    var newdateRight = dateRight! - deltaTime;

    //condition pour pouvoir drag horizontalement (rester dans le domaine)
    setState(() {
      if (checkDrag(dx, newdateLeft, newdateRight)) {
        dateLeft = newdateLeft;
        dateRight = newdateRight;
      }
      if (dy != 0) {
        minY = minY! + deltaY;
        maxY = maxY! + deltaY;
      }
    });
  }

  void zoom(ScaleUpdateDetails details) {
    if (userStatistics.length < 2) {
      return;
    }
    //zoom
    if (details.verticalHorizontalRatio > 1) {
      /*zoom vertical*/
      var rho = 1 / (details.verticalScale);
      var newYmax = ((1 + rho) / 2 * maxY0! + (1 - rho) / 2 * minY0!);
      var newYmin = ((1 + rho) / 2 * minY0! + (1 - rho) / 2 * maxY0!);

      if (newYmax != maxY || newYmin != minY) {
        setState(() {
          maxY = newYmax;
          minY = newYmin;
        });
      }
    } else {
      /* zoom horizontal*/
      var rho = 1 / (details.horizontalScale);
      var newtmax =
          ((1 + rho) / 2 * dateRight0! + (1 - rho) / 2 * dateLeft0!).toInt();
      var newtmin =
          ((1 + rho) / 2 * dateLeft0! + (1 - rho) / 2 * dateRight0!).toInt();
      newtmax = min(
          newtmax,
          userStatistics[userStatistics.length - 1]
              .date!
              .millisecondsSinceEpoch);
      newtmin = max(newtmin, userStatistics[0].date!.millisecondsSinceEpoch);

      if (newtmax != dateRight || newtmin != dateLeft) {
        setState(() {
          dateLeft = newtmin;
          dateRight = newtmax;
        });
      }
    }
  }

  Future<void> dragAnimation(ScaleEndDetails details) async {
    var delta = details.velocity.pixelsPerSecond.distance;

    var duration = 15 * sqrt(delta);

    var dx = details.velocity.pixelsPerSecond.dx / 60;
    var dy = details.velocity.pixelsPerSecond.dy / 60;
    _controller = AnimationController(
      duration: Duration(milliseconds: duration.toInt()),
      vsync: this,
    );

    dxAnimation = Tween<double>(begin: dx, end: 0).animate(
        CurvedAnimation(parent: _controller!, curve: Curves.easeInOutSine));

    dyAnimation = Tween<double>(begin: dy, end: 0).animate(
        CurvedAnimation(parent: _controller!, curve: Curves.easeInOutSine));

    _controller!.addListener(() {
      drag(dxAnimation!.value, dyAnimation!.value);
    });
    _controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    final series = [
      charts.Series<UserStatistic, DateTime>(
        id: 'weight',
        colorFn: (_, __) => charts.MaterialPalette.white,
        domainFn: (UserStatistic data, _) => data.date!,
        measureFn: (UserStatistic data, _) => data.value,
        data: userStatistics,
      )
    ];
    const axisColors = charts.Color(a: 191, r: 255, g: 255, b: 255);
    const gridColors = charts.Color(a: 63, r: 255, g: 255, b: 255);

    return GestureDetector(
      onDoubleTap: () {
        //reset
        setState(() {
          resetGraph();
        });
      },
      onScaleStart: (details) {
        if (_controller?.isAnimating ?? false) {
          _controller?.reset();
        }
        size = _chartKey.currentContext!.size;

        //si on commence à zoomer, on garde en mémoire le domaine au start
        if (details.pointerCount == 1) {
          interaction = 'drag';
        } else if (details.pointerCount == 2) {
          interaction = 'zoom';
          dateLeft0 = dateLeft!;
          dateRight0 = dateRight!;
          minY0 = minY;
          maxY0 = maxY;
        }
      },
      onScaleUpdate: (details) {
        if (details.pointerCount == 1) {
          drag(details.focalPointDelta.dx, details.focalPointDelta.dy);
        } else if (details.pointerCount == 2) {
          zoom(details);
        }
      },
      onScaleEnd: (details) async {
        if (interaction == 'drag') {
          await dragAnimation(details).then((_) => interaction = 'none');
        } else {
          interaction = 'none';
        }
      },
      child: AnimatedBuilder(
          key: _chartKey,
          animation: _controller!,
          builder: (context, _) {
            return charts.TimeSeriesChart(
              series,
              defaultRenderer: charts.LineRendererConfig(
                  includeArea: true,
                  includeLine: true,
                  includePoints: displayDots,
                  strokeWidthPx: 1,
                  radiusPx: 4),
              behaviors: [
                //charts.SeriesLegend(),
                charts.LinePointHighlighter(
                  showHorizontalFollowLine:
                      charts.LinePointHighlighterFollowLineType.nearest,
                  showVerticalFollowLine:
                      charts.LinePointHighlighterFollowLineType.nearest,
                  drawFollowLinesAcrossChart: true,
                  symbolRenderer: charts.CircleSymbolRenderer(),
                ),
              ],
              //axe vertical
              primaryMeasureAxis: charts.NumericAxisSpec(
                  showAxisLine: true,
                  renderSpec: const charts.GridlineRendererSpec(
                    lineStyle: charts.LineStyleSpec(
                      color: gridColors,
                    ),
                    labelStyle: charts.TextStyleSpec(color: axisColors),
                    axisLineStyle:
                        charts.LineStyleSpec(color: gridColors, thickness: 1),
                  ),
                  tickProviderSpec: const charts.BasicNumericTickProviderSpec(
                      desiredTickCount: 12, zeroBound: false),
                  viewport: charts.NumericExtents(minY!, maxY!)),
              //axe horizontal
              domainAxis: charts.DateTimeAxisSpec(
                  showAxisLine: true,
                  renderSpec: const charts.GridlineRendererSpec(
                    lineStyle: charts.LineStyleSpec(
                      color: gridColors,
                    ),
                    labelStyle: charts.TextStyleSpec(color: axisColors),
                    labelOffsetFromAxisPx: 4,
                    axisLineStyle:
                        charts.LineStyleSpec(color: gridColors, thickness: 1),
                  ),
                  tickProviderSpec: const charts.AutoDateTimeTickProviderSpec(
                      includeTime: true),
                  tickFormatterSpec: const charts.AutoDateTimeTickFormatterSpec(
                    day: charts.TimeFormatterSpec(
                        format: 'MMMd', transitionFormat: 'MMMd'),
                    month: charts.TimeFormatterSpec(
                        format: 'yMMM', transitionFormat: 'yMMM'),
                    year: charts.TimeFormatterSpec(
                        format: 'yMMM', transitionFormat: 'yMMM'),
                  ),
                  viewport: charts.DateTimeExtents(
                      start: DateTime.fromMillisecondsSinceEpoch(dateLeft!),
                      end: DateTime.fromMillisecondsSinceEpoch(dateRight!))),

              dateTimeFactory: const charts.LocalDateTimeFactory(),
              animate: false,
            );
          }),
    );
  }
}
