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

    /*
      + Style 01:
    */
    // if (hasTimeInString) {
    //   fromDateStr =
    //       formatDate(_fromDate, [dd, '/', mm, '/', yyyy, ", ", HH, ':', nn]);
    //   toDateStr =
    //       formatDate(_toDate, [dd, '/', mm, '/', yyyy, ", ", HH, ':', nn]);
    // } else {
    //   fromDateStr = formatDate(_fromDate, [dd, '/', mm, '/', yyyy]);
    //   toDateStr = formatDate(_toDate, [dd, '/', mm, '/', yyyy]);
    // }

    /*
      + Style 02:
    */
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

  List<WeekDateTime> generateWeekListOfMonth() {
    int month = this._fromDate.month;
    int year = this._fromDate.year;

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

  int getCurrentWeekOrder() {
    // This function will return week 1, 2, 3 or 4.
    int day = this._fromDate.day;
    if (day <= 7) return 1;
    if (day <= 14) return 2;
    if (day <= 21) return 3;
    return 4;
  }


  /*
    + Static function
  */
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

  /*
    + Static function
  */
  static int getWeekOrder(DateTime dt) {
    // This function will return week 1, 2, 3 or 4.
    int day = dt.day;
    if (day <= 7) return 1;
    if (day <= 14) return 2;
    if (day <= 21) return 3;
    return 4;
  }
}
