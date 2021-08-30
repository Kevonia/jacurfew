import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:jacurfew/pages/timer.dart';
import 'package:jacurfew/themes/ligth_theme.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  tz.initializeTimeZones();
  runApp(TimerApp());
}

class TimerApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RedSet Couriers',
      theme: CustomTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: TimerPage(
        title: '',
      ),
    );
  }
}
