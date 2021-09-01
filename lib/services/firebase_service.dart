import 'package:firebase_database/firebase_database.dart';
import 'package:jacurfew/models/curfew_dates.dart';

class FireBase {
  final DatabaseReference _dateRef =
      FirebaseDatabase.instance.reference().child('curfewDates');

  void saveDates() {
    _dateRef.push().set({
      'sreachdate': DateTime.now().toString(),
      'iscufrew': false,
      'cufrewStartDate': DateTime(2021, 09, 1, 19, 0, 0).toString(),
      'cufrewEndDate': DateTime(2021, 09, 2, 5, 0, 0).toString(),
    });
  }

  Query getMessageQuery() {
    return _dateRef;
  }
}
