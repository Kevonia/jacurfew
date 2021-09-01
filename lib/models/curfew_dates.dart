class CurfewDates {
  final DateTime cufrewEndDate;
  final DateTime cufrewStartDate;
  final bool iscufrew;
  final DateTime searchDate;
  final DateTime previousEndDate;
  CurfewDates(this.cufrewEndDate, this.cufrewStartDate, this.iscufrew,
      this.searchDate, this.previousEndDate);

  CurfewDates.fromJson(Map<dynamic, dynamic> json)
      : cufrewEndDate = DateTime.parse(json['cufrewEndDate'] as String),
        cufrewStartDate = DateTime.parse(json['cufrewStartDate'] as String),
        iscufrew = json['iscufrew'],
        searchDate = DateTime.parse(json['sreachdate'] as String),
        previousEndDate = DateTime.parse(json['previousEndDate'] as String);

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'cufrewEndDate': cufrewEndDate.toString(),
        'cufrewStartDate': cufrewStartDate.toString(),
        'iscufrew': iscufrew,
        'searchDate': searchDate.toString(),
        'previousEndDate': previousEndDate.toString(),
      };
}
