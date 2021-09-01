import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:jacurfew/pages/timer.dart';
import 'package:jacurfew/themes/ligth_theme.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  runApp(TimerApp());
}

class TimerApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RedSet Couriers',
      theme: CustomTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _fbApp,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            print(' You have an error! ${snapshot.error.toString()}');
            return Text('Something went Wrong!');
          } else if (snapshot.hasData) {
            return TimerPage(title: '');
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
