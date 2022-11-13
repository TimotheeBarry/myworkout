import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:myworkout/core/util/functions.dart';
import '../../core/theme/styles.dart' as styles;

class RestTimer extends StatefulWidget {
  const RestTimer({Key? key, required this.onFinish, required this.initialTime})
      : super(key: key);
  final void Function() onFinish;
  final num initialTime;

  @override
  State<RestTimer> createState() => _RestTimerState();
}

class _RestTimerState extends State<RestTimer> {
  late num maxSeconds;
  late num seconds;
  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() => seconds--);
      } else {
        stopTimer();
        widget.onFinish();
      }
    });
  }

  void stopTimer() {
    timer!.cancel();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    maxSeconds = widget.initialTime;
    seconds = widget.initialTime;
    startTimer();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  Widget buildTime() {
    if (seconds < 60) {
      return Text(
        '$seconds',
        style: TextStyle(fontSize: 52, color: styles.frame.primaryTextColor),
      );
    } else if (seconds < 3600) {
      var sec = getSeconds(seconds);
      var minutes = getMinutes(seconds);
      return Text(
        '$minutes:$sec',
        style: TextStyle(fontSize: 44, color: styles.frame.primaryTextColor),
      );
    } else {
      var sec = getSeconds(seconds);
      var minutes = getMinutes(seconds);
      var hours = getHours(seconds);
      return Text(
        '$hours:$minutes:$sec',
        style: TextStyle(fontSize: 38, color: styles.frame.primaryTextColor),
      );
    }
  }

  Widget buildTimer() {
    return SizedBox(
        height: 150,
        width: 150,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: maxSeconds > 0 ? seconds / maxSeconds : 1,
              valueColor: AlwaysStoppedAnimation(Colors.white),
              backgroundColor: Colors.white24,
              strokeWidth: 4,
            ),
            Positioned(top: 12, left: 0, right: 0, child: buildPlayButton()),
            Center(child: buildTime()),
          ],
        ));
  }

  Widget buildPlayButton() {
    final isRunning = timer == null ? false : timer!.isActive;
    final icon = isRunning
        ? Icon(
            Icons.pause_rounded,
            size: 32,
            color: styles.frame.primaryTextColor,
          )
        : Icon(
            Icons.play_arrow_rounded,
            size: 32,
            color: styles.frame.primaryTextColor,
          );
    final action = isRunning ? stopTimer : startTimer;

    return IconButton(
        onPressed: () {
          action();
        },
        icon: icon);
  }

  Widget addTime(int sec) {
    return IconButton(
      onPressed: () {
        setState(() {
          seconds = seconds + sec;
          if (seconds > maxSeconds) {
            maxSeconds = seconds;
          }
        });
      },
      icon: Icon(Icons.add_circle_outline_rounded,
          size: 32, color: styles.frame.primaryTextColor),
    );
  }

  Widget removeTime(int sec) {
    return IconButton(
      onPressed: () {
        setState(() {
          if (seconds == maxSeconds) {
            maxSeconds = max(0, seconds - sec);
          }
          seconds = max(0, seconds - sec);
        });
      },
      icon: Icon(Icons.remove_circle_outline_rounded,
          size: 32, color: styles.frame.primaryTextColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: styles.frame.primaryTextColor),
        ),
        removeTime(10),
        const SizedBox(width: 8),
        buildTimer(),
        const SizedBox(width: 8),
        addTime(10),
        IconButton(
          onPressed: widget.onFinish,
          icon: Icon(Icons.arrow_forward_ios_rounded,
              color: styles.frame.primaryTextColor),
        ),
      ],
    );
  }
}
