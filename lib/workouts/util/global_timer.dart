import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class GlobalTimer extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => GlobalTimer(),
      ),
    );
  }

  @override
  _State createState() => _State();
}

class _State extends State<GlobalTimer> {
  final _isHours = false;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    /*onChange: (value) => print('onChange $value'),
    onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    onChangeRawMinute: (value) => print('onChangeRawMinute $value'),*/
    onStop: () {
      print('onStop');
    },
    onEnded: () {
      print('onEnded');
     
    },
  );

  @override
  void initState() {
    super.initState();
    /*_stopWatchTimer.rawTime.listen((value) =>
        print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
    _stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    _stopWatchTimer.records.listen((value) => print('records $value'));
    _stopWatchTimer.fetchStop.listen((value) => print('stop from stream'));
    _stopWatchTimer.fetchEnded.listen((value) => print('ended from stream'));*/
    _stopWatchTimer.onExecute
        .add(StopWatchExecute.start); //lance direct le chrono

    /// Can be set preset time. This case is "00:01.23".
    // _stopWatchTimer.setPresetTime(mSec: 1234);
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 40,
      child: StreamBuilder<int>(
        stream: _stopWatchTimer.rawTime,
        initialData: _stopWatchTimer.rawTime.value,
        builder: (context, snap) {
          final value = snap.data!;
          final displayTime = StopWatchTimer.getDisplayTime(value,
              hours: value >= StopWatchTimer.getMilliSecFromHour(1), milliSecond: false);
          return Center(
              child: Text(
            displayTime,
            style: const TextStyle(
                fontSize: 22,
                fontFamily: 'Helvetica',
                fontWeight: FontWeight.bold),
          ));
        },
      ),
    );
  }
}
