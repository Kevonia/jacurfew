import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:jacurfew/models/time.dart';
import 'package:jacurfew/services/notification_service.dart';
import 'package:jacurfew/themes/colors.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';

class TimerPage extends StatefulWidget {
  TimerPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  static final DateTime now = DateTime.now();
  static final DateFormat monthNameformatter = DateFormat('MMMM');
  static final DateFormat dateformatter = DateFormat('MMMM dd, yyyy');

  static final DateFormat Timeformatter = DateFormat('hh:mm aaa');

  static final DateTime cufrewStartDate = DateTime(2021, 8, 28, 6, 0, 0);
  static final DateTime cufrewEndDate = DateTime(2021, 09, 1, 5, 0, 0);
  int hoursBetweenDays = 0;
  var time = TimeCalculator();
  final String formatted = monthNameformatter.format(now);
  String cufrewStartDateformatted = dateformatter.format(cufrewStartDate);
  String cufrewEndDateformatted = dateformatter.format(cufrewEndDate);

  String cufrewStartTimeformatted = Timeformatter.format(cufrewEndDate);

  String cufrewEndTimeformatted = Timeformatter.format(cufrewEndDate);

  int maxseconds = 0;
  int seconds = 0;
  Duration duration = Duration(hours: 0);
  Timer? timer;

  bool countDown = true;
  bool showdays = false;
  @override
  void initState() {
    super.initState();

    reset();
    startTimer();
    notificationInit();
  }

  void notificationInit() {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings(
        '@mipmap/ic_launcher'); // <- default icon name is @mipmap/ic_launcher
    var initializationSettingsIOS =
        IOSInitializationSettings(onDidReceiveLocalNotification: null);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: null);
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void toggleTimerformat() {
    setState(() => showdays = !showdays);
  }

  void addTime() {
    final addSeconds = countDown ? -1 : 1;
    setState(() {
      final diffinseconds = duration.inSeconds + addSeconds;
      if (diffinseconds < 0) {
        timer?.cancel();
      } else {
        seconds--;

        if (seconds == 7200) {
          NotificationService.showNotifications(
            title: 'Cufrew Reminder',
            body: "Cufrew Start in 2 hours",
            payload: 'Cufrew.Reminder',
          );
        }

        duration = Duration(seconds: diffinseconds);
      }
    });
  }

  void reset() {
    if (countDown) {
      seconds = time.secondsBetween(now, cufrewEndDate);
      maxseconds = time.secondsBetween(cufrewStartDate, cufrewEndDate);
      setState(() => duration = Duration(seconds: seconds));
    } else {
      setState(() => duration = Duration());
    }
  }

  Widget _buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final days = twoDigits(duration.inDays);
    final hours = twoDigits(duration.inHours);
    final hours_12 = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Visibility(
          visible: !showdays,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$hours:', style: Theme.of(context).textTheme.headline2),
              Text('$minutes:', style: Theme.of(context).textTheme.headline2),
              Text('$seconds', style: Theme.of(context).textTheme.headline2),
            ],
          )),
      Visibility(
          visible: showdays,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$days:', style: Theme.of(context).textTheme.headline2),
              Text('$hours_12:', style: Theme.of(context).textTheme.headline2),
              Text('$minutes', style: Theme.of(context).textTheme.headline2),
            ],
          ))
    ]);
  }

  Widget _buildTimer() {
    return Stack(
      fit: StackFit.expand,
      children: [
        InkWell(
          onTap: () {
            toggleTimerformat();
            NotificationService.showScheduleNotifications(
                title: 'Cufrew Reminder',
                body: "Cufrew Start in 2 hours",
                payload: 'Cufrew.Reminder',
                scheduleDate: now.add(Duration(seconds: 12)));
          },
          child: CircularPercentIndicator(
            radius: MediaQuery.of(context).size.width / 1.3,
            lineWidth: 25.0,
            animation: false,
            backgroundColor: CustomColors.progessbarColor,
            percent: 1 - seconds / maxseconds,
            center: _buildTime(),
            progressColor: CustomColors.stockColor,
            circularStrokeCap: CircularStrokeCap.round,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            height: height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(formatted.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyText1),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Container(
                          height: height * 0.15,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Cufew starts at',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                '$cufrewStartDateformatted',
                                style: Theme.of(context).textTheme.headline1,
                              ),
                              Text(
                                '$cufrewStartTimeformatted',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ],
                          )),
                      Container(
                        height: height * 0.5,
                        child: _buildTimer(),
                      ),
                      Container(
                          height: height * 0.15,
                          child: Column(
                            children: [
                              Text(
                                'and ends at',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                '$cufrewEndDateformatted',
                                style: Theme.of(context).textTheme.headline1,
                              ),
                              Text(
                                '$cufrewEndTimeformatted',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ],
                          )),
                    ],
                  ),
                )
              ],
            )));
  }
}
