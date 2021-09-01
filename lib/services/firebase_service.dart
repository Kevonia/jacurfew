import 'package:firebase_database/firebase_database.dart';

class FireBase {
  final DatabaseReference _dateRef =
      FirebaseDatabase.instance.reference().child('curfewDates');

  void saveDates() {
    _dateRef.push().set({
      'sreachdate': DateTime.now().toString(),
      'islockeddown': true,
      'cufrewStartDate': DateTime(2021, 8, 28, 6, 0, 0).toString(),
      'cufrewEndDate': DateTime(2021, 09, 1, 5, 0, 0).toString(),
    });
  }

  Query getMessageQuery() {
    return _dateRef;
  }
}
