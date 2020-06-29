import 'package:date_format/date_format.dart';

class WeekDateTime {
  DateTime _fromDate;
  DateTime _toDate;

  WeekDateTime(DateTime _fromDate, DateTime _toDate) {
    if (_fromDate == null || _toDate == null) {
      _fromDate = DateTime.now();
      _toDate = DateTime.now();
    }

    this._fromDate = _fromDate;
    this._toDate = _toDate;
  }

  void setFromDateValue(DateTime _fromDate) {
    this._fromDate = _fromDate;
  }

  void setToDateValue(DateTime _toDate) {
    this._toDate = _toDate;
  }

  DateTime getFromDateValue() {
    return this._fromDate;
  }

  DateTime getToDateValue() {
    return this._toDate;
  }

  String getWeekString({
    hasTimeInString: false,
  }) {
    if (hasTimeInString == null) {
      hasTimeInString = false;
    }

    String fromDateStr = "";
    String toDateStr = "";

    if (hasTimeInString) {
      fromDateStr =
          formatDate(_fromDate, [dd, '/', mm, '/', yyyy, ", ", HH, ':', nn]);
      toDateStr =
          formatDate(_toDate, [dd, '/', mm, '/', yyyy, ", ", HH, ':', nn]);
    } else {
      fromDateStr = formatDate(_fromDate, [dd, '/', mm]);
      toDateStr = formatDate(_toDate, [dd, '/', mm, ", ", yyyy]);
    }

    return fromDateStr + " - " + toDateStr;
  }

  static List<WeekDateTime> getWeekListOfMonth(DateTime dt) {
    int month = dt.month;
    int year = dt.year;

    DateTime lastDayOfMonth = new DateTime(year, month + 1, 0);

    List<WeekDateTime> list = [];
    list.add(WeekDateTime(DateTime(year, month, 1), DateTime(year, month, 7)));
    list.add(WeekDateTime(DateTime(year, month, 8), DateTime(year, month, 14)));
    list.add(
        WeekDateTime(DateTime(year, month, 15), DateTime(year, month, 21)));
    list.add(WeekDateTime(
        DateTime(year, month, 22), DateTime(year, month, lastDayOfMonth.day)));

    return list;
  }

  static int getWeekOrder(DateTime dt) {
    int day = dt.day;

    // Week 1
    if (day <= 7) return 0;
    // Week 2
    if (day <= 14) return 1;
    // Week 3
    if (day <= 21) return 2;

    // Week 4
    return 3;
  }

  static WeekDateTime getCurrentWeek(DateTime dt) {
    int day = dt.day;
    int month = dt.month;
    int year = dt.year;

    DateTime lastDayOfMonth = new DateTime(year, month + 1, 0);

    if (day <= 7)
      return WeekDateTime(DateTime(year, month, 1), DateTime(year, month, 7));
    if (day <= 14)
      return WeekDateTime(DateTime(year, month, 8), DateTime(year, month, 14));
    if (day <= 21)
      return WeekDateTime(DateTime(year, month, 15), DateTime(year, month, 21));

    return WeekDateTime(
        DateTime(year, month, 22), DateTime(year, month, lastDayOfMonth.day));
  }
}
