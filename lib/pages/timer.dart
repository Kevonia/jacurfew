import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:jacurfew/models/curfew_dates.dart';
import 'package:jacurfew/models/time.dart';
import 'package:jacurfew/services/firebase_service.dart';
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

  Color barcolor = CustomColors.progessbarColor;
  Color progessbarColor = CustomColors.strokeColor;

  DateTime cufrewStartDate = DateTime(2021, 1, 1, 0, 0, 0);
  DateTime cufrewEndDate = DateTime(2021, 12, 30, 0, 0, 0);
  int hoursBetweenDays = 0;
  var time = TimeCalculator();

  FireBase firebase = new FireBase();
  final String formatted = monthNameformatter.format(now);
  String cufrewStartDateformatted = '';
  String cufrewEndDateformatted = '';

  String cufrewStartTimeformatted = '';

  String cufrewEndTimeformatted = '';

  int maxseconds = 0;
  int seconds = 0;
  Duration duration = Duration(hours: 0);
  Timer? timer;

  bool isCurfewTime = false;
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
    final addSeconds = -1;
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
    firebase.getMessageQuery().once().then((DataSnapshot snapshot) {
      final json = snapshot.value as Map<dynamic, dynamic>;
      json.forEach((key, value) {
        final curfewDates = CurfewDates.fromJson(value);

        setState(() {
          cufrewStartDate = curfewDates.cufrewStartDate;
          cufrewEndDate = curfewDates.cufrewEndDate;

          int diffInSeconds =
              time.secondsBetween(now, curfewDates.cufrewStartDate);

          if (diffInSeconds < 0) {
            isCurfewTime = true;
            barcolor = CustomColors.curfew_progessbarColor;
            progessbarColor = CustomColors.curfew_strokeColor;
            cufrewStartDateformatted =
                dateformatter.format(curfewDates.cufrewStartDate);
            cufrewEndDateformatted =
                dateformatter.format(curfewDates.cufrewEndDate);

            cufrewStartTimeformatted =
                Timeformatter.format(curfewDates.cufrewStartDate);

            cufrewEndTimeformatted =
                Timeformatter.format(curfewDates.cufrewEndDate);

            seconds = time.secondsBetween(now, curfewDates.cufrewEndDate);

            maxseconds = time.secondsBetween(
                curfewDates.cufrewStartDate, curfewDates.cufrewEndDate);
          } else {
            isCurfewTime = false;
            barcolor = CustomColors.progessbarColor;
            progessbarColor = CustomColors.strokeColor;
            cufrewStartDateformatted =
                dateformatter.format(curfewDates.cufrewStartDate);
            cufrewEndDateformatted =
                dateformatter.format(curfewDates.cufrewEndDate);

            cufrewStartTimeformatted =
                Timeformatter.format(curfewDates.cufrewStartDate);

            cufrewEndTimeformatted =
                Timeformatter.format(curfewDates.cufrewEndDate);

            seconds = time.secondsBetween(now, curfewDates.cufrewStartDate);

            maxseconds = time.secondsBetween(
                curfewDates.previousEndDate, curfewDates.cufrewStartDate);
          }

          duration = Duration(seconds: seconds);
        });
      });
    });
  }

  Widget _buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final days = twoDigits(duration.inDays);
    final hours = twoDigits(duration.inHours);
    final hours_12 = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final format = showdays ? 'day/hour/minute' : 'hour/minute/second';
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
          )),
      Text('$format', style: Theme.of(context).textTheme.bodyText2),
    ]);
  }

  Widget _buildTimer() {
    double test = 1 - seconds / maxseconds;
    return Stack(
      fit: StackFit.expand,
      children: [
        InkWell(
          onTap: () {
            toggleTimerformat();
          },
          child: CircularPercentIndicator(
            radius: MediaQuery.of(context).size.width / 1.3,
            lineWidth: 25.0,
            animation: false,
            backgroundColor: barcolor,
            percent: 1 - seconds / maxseconds,
            center: _buildTime(),
            progressColor: progessbarColor,
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
