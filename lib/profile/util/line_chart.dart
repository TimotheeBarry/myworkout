import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:charts_flutter/src/text_element.dart' as charts_text;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myworkout/profile/util/profile_chart_data.dart';

class LineChart extends StatefulWidget {
  //size of the widget
  LineChart();
  @override
  State<LineChart> createState() => LineChartState();
}

class LineChartState extends State<LineChart> with TickerProviderStateMixin {
  //final List<Series>? seriesList;
  final GlobalKey _chartKey = GlobalKey();
  DateTime? minDate;
  DateTime? maxDate;
  int? minDate0;
  int? maxDate0;
  double? minY;
  double? maxY;
  Size? size;
  String? interaction; //none, drag ou zoom
  AnimationController? _controller;
  Animation<double>? dxAnimation;
  Animation<double>? dyAnimation;
  var displayDots = true;
  final chartData = generateWeightData();
  @override
  void initState() {
    super.initState();
    reset();
    _controller = AnimationController(
      duration: Duration(milliseconds: 0),
      vsync: this,
    );
    dxAnimation = Tween<double>(begin: 0, end: 0).animate(_controller!);
    dyAnimation = Tween<double>(begin: 0, end: 0).animate(_controller!);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  void reset() {
    minDate = DateTime(DateTime.now().year, DateTime.now().month - 6);
    maxDate = DateTime.now();
    minDate0 = minDate!.millisecondsSinceEpoch;
    maxDate0 = maxDate!.millisecondsSinceEpoch;
    minY = 68;
    maxY = 82;
    size = Size(400, 300);
    interaction = 'none';
  }

  bool checkDrag(
      dx, DateTime minDate, DateTime maxDate, ProfileChartsData chartdata) {
    //var margin = 0.005 *(maxDate.millisecondsSinceEpoch - minDate.millisecondsSinceEpoch);

    if (dx > 0 &&
        minDate.millisecondsSinceEpoch /*+ margin*/ >=
            chartdata.minDateData().date.millisecondsSinceEpoch) {
      return true;
    } else if (dx < 0 &&
        maxDate.millisecondsSinceEpoch /*- margin */ <=
            chartdata.maxDateData().date.millisecondsSinceEpoch) {
      return true;
    }
    return false;
  }

  void drag(double dx, double dy) {
    var YExtent = maxY! - minY!;
    var deltaY = (dy * YExtent / (size!.height - 40));
    var timeExtent =
        maxDate!.millisecondsSinceEpoch - minDate!.millisecondsSinceEpoch;
    var deltaTime = (dx * timeExtent ~/ (size!.width - 20));
    var newMinDate = DateTime.fromMillisecondsSinceEpoch(
        minDate!.millisecondsSinceEpoch - deltaTime);
    var newMaxDate = DateTime.fromMillisecondsSinceEpoch(
        maxDate!.millisecondsSinceEpoch - deltaTime);

    //condition pour pouvoir drag horizontalement (rester dans le domaine)
    setState(() {
      if (checkDrag(dx, newMinDate, newMaxDate, chartData)) {
        minDate = newMinDate;
        maxDate = newMaxDate;
      }
      if (dy != 0) {
        minY = minY! + deltaY;
        maxY = maxY! + deltaY;
      }
    });
  }

  void zoom(ScaleUpdateDetails details) {
    //zoom
    var rho = 1 / (details.horizontalScale);
    var newtmax =
        ((1 + rho) / 2 * maxDate0! + (1 - rho) / 2 * minDate0!).toInt();
    var newtmin =
        ((1 + rho) / 2 * minDate0! + (1 - rho) / 2 * maxDate0!).toInt();
    newtmax = min(newtmax, chartData.maxDateData().date.millisecondsSinceEpoch);
    newtmin = max(newtmin, chartData.minDateData().date.millisecondsSinceEpoch);

    if (newtmax != maxDate!.millisecondsSinceEpoch ||
        newtmin != minDate!.millisecondsSinceEpoch) {
      setState(() {
        minDate = DateTime.fromMillisecondsSinceEpoch(newtmin);
        maxDate = DateTime.fromMillisecondsSinceEpoch(newtmax);
      });
    }
  }

  void dragAnimation(ScaleEndDetails details) {
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
      charts.Series<ProfileChartsSingleData, DateTime>(
        id: 'weight',
        colorFn: (_, __) => charts.MaterialPalette.white,
        domainFn: (ProfileChartsSingleData data, _) => data.date,
        measureFn: (ProfileChartsSingleData data, _) => data.value,
        data: chartData.dataList,
      )
    ];
    final axisColors = charts.Color(a: 191, r: 255, g: 255, b: 255);
    final gridColors = charts.Color(a: 63, r: 255, g: 255, b: 255);

    return GestureDetector(
      onDoubleTap: () {
        //reset
        setState(() {
          reset();
        });
      },
      onScaleStart: (details) {
        if (_controller!.isAnimating) {
          _controller!.reset();
        }
        setState(() {
          size = _chartKey.currentContext!.size;
        });

        //si on commence à zoomer, on garde en mémoire le domaine au start
        if (details.pointerCount == 1) {
          setState(() {
            interaction = 'drag';
          });
        } else if (details.pointerCount == 2) {
          setState(() {
            interaction = 'zoom';
            minDate0 = minDate!.millisecondsSinceEpoch;
            maxDate0 = maxDate!.millisecondsSinceEpoch;
          });
        }
      },
      onScaleUpdate: (details) {
        if (details.pointerCount == 1) {
          drag(details.focalPointDelta.dx, details.focalPointDelta.dy);
        } else if (details.pointerCount == 2) {
          zoom(details);
        }
      },
      onScaleEnd: (details) {
        if (interaction == 'drag') {
          dragAnimation(details);
        }
        setState(() {
          interaction = 'none';
        });
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
                  renderSpec: charts.GridlineRendererSpec(
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
                  renderSpec: charts.GridlineRendererSpec(
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
                  viewport:
                      charts.DateTimeExtents(start: minDate!, end: maxDate!)),

              dateTimeFactory: const charts.LocalDateTimeFactory(),
              animate: false,
            );
          }),
    );
  }
}
