import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';

class MyHorizontalMonthList extends StatefulWidget {
  final DateTime selectedDate;
  final DateTime lastDate;
  final DateTime firstDate;
  final Function onChanged;

  MyHorizontalMonthList({
    @required this.selectedDate,
    @required this.lastDate,
    @required this.firstDate,
    @required this.onChanged(datetime),
  })  : assert(selectedDate != null &&
            onChanged != null &&
            firstDate != null &&
            lastDate != null),
        assert(!firstDate.isAfter(lastDate));

  @override
  _MyHorizontalMonthListState createState() => _MyHorizontalMonthListState();
}

class _MyHorizontalMonthListState extends State<MyHorizontalMonthList> {
  static List<String> _monthName = [
    R.strings.january,
    R.strings.february,
    R.strings.march,
    R.strings.april,
    R.strings.may,
    R.strings.june,
    R.strings.july,
    R.strings.august,
    R.strings.september,
    R.strings.october,
    R.strings.november,
    R.strings.december,
  ];

  bool _isSuitableMonthYear(int month, int year) {
    if (month > 12 || month < 1) return false;
    if ((year >= widget.lastDate.year && month > widget.lastDate.month) ||
        (year <= widget.firstDate.year && month < widget.firstDate.month)) {
      return false;
    }

    return true;
  }

  void _increaseMonth() {
    int day = widget.selectedDate.day;
    int month = widget.selectedDate.month;
    int year = widget.selectedDate.year;

    if (_isSuitableMonthYear(month + 1, year)) {
      month += 1;
      widget.onChanged(DateTime(year, month, day));
    }
  }

  void _decreaseMonth() {
    int day = widget.selectedDate.day;
    int month = widget.selectedDate.month;
    int year = widget.selectedDate.year;

    if (_isSuitableMonthYear(month - 1, year)) {
      month -= 1;
      widget.onChanged(DateTime(year, month, day));
    }
  }

  Widget _renderHorizontalMonthList() {
    return Container(
      height: R.appRatio.appHeight50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Decrease month
          SizedBox(
            width: R.appRatio.appWidth40,
            child: FlatButton(
              textColor: Colors.white,
              splashColor: R.colors.lightBlurMajorOrange,
              padding: EdgeInsets.all(0),
              onPressed: _decreaseMonth,
              child: Icon(
                Icons.chevron_left,
                color: (widget.selectedDate.month == 1 ||
                        (widget.selectedDate.month == widget.firstDate.month &&
                            widget.selectedDate.year == widget.firstDate.year)
                    ? R.colors.gray808080
                    : R.colors.contentText),
                size: R.appRatio.appIconSize25,
              ),
            ),
          ),
          // Month content
          Text(
            _monthName[widget.selectedDate.month - 1],
            style: TextStyle(
              color: R.colors.majorOrange,
              fontSize: R.appRatio.appFontSize18,
            ),
          ),
          // Increase month
          SizedBox(
            width: R.appRatio.appWidth40,
            child: FlatButton(
              textColor: Colors.white,
              splashColor: R.colors.lightBlurMajorOrange,
              padding: EdgeInsets.all(0),
              onPressed: _increaseMonth,
              child: Icon(
                Icons.chevron_right,
                color: (widget.selectedDate.month == 12 ||
                        (widget.selectedDate.month == widget.lastDate.month &&
                            widget.selectedDate.year == widget.lastDate.year)
                    ? R.colors.gray808080
                    : R.colors.contentText),
                size: R.appRatio.appIconSize25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _renderHorizontalMonthList();
  }
}
