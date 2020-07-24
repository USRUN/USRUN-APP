import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/page/profile/week_date_time.dart';
import 'package:usrun/widget/my_date_picker/my_horizontal_month_list.dart';
import 'package:usrun/widget/my_date_picker/my_week_list.dart';
import 'package:usrun/widget/my_date_picker/my_year_list.dart';

class _MyWeekPicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  _MyWeekPicker({
    @required this.initialDate,
    @required this.firstDate,
    @required this.lastDate,
  })  : assert(initialDate != null && firstDate != null && lastDate != null),
        assert(!firstDate.isAfter(lastDate));

  @override
  _MyWeekPickerState createState() => _MyWeekPickerState();
}

class _MyWeekPickerState extends State<_MyWeekPicker> {
  WeekDateTime _selectedWeek;
  bool _yearPickerState;

  static double _heightPickerBox =
      (R.appRatio.deviceHeight - (R.appRatio.deviceHeight / 2.36))
          .roundToDouble();

  @override
  void initState() {
    _selectedWeek = WeekDateTime(widget.initialDate, widget.initialDate);
    _yearPickerState = false;
    super.initState();
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  void _handleOk() {
    if (_yearPickerState) {
      _updateYearPickerState();
    } else {
      Navigator.pop(context, _selectedWeek);
    }
  }

  void _updateYearPickerState() {
    if (_yearPickerState) {
      // Change "YearBox" to "WeekBox" => Change height of "YearBox" to "WeekBox"
      _heightPickerBox =
          (R.appRatio.deviceHeight - (R.appRatio.deviceHeight / 2.36))
              .roundToDouble();
    } else {
      // Change "WeekBox" to "YearBox" => Change height of "WeekBox" to "YearBox"
      _heightPickerBox =
          (R.appRatio.deviceHeight - (R.appRatio.deviceHeight / 2.8))
              .roundToDouble();
    }

    setState(() {
      _yearPickerState = !_yearPickerState;
    });
  }

  DateTime _checkDateTimeBound(DateTime dt) {
    if (dt.isAfter(widget.lastDate)) {
      return widget.lastDate;
    }

    if (dt.isBefore(widget.firstDate)) {
      return widget.firstDate;
    }

    return null;
  }

  void _updateSelectedWeek(DateTime fromDateValue) {
    setState(() {
      _selectedWeek = WeekDateTime.getCurrentWeek(fromDateValue);
    });
  }

  void _onMonthChanged(dateTimeValue) {
    _updateSelectedWeek(dateTimeValue);
  }

  void _onYearChanged(dateTimeValue) {
    DateTime checkResult = _checkDateTimeBound(dateTimeValue);

    if (checkResult == null) {
      _updateSelectedWeek(dateTimeValue);
    } else {
      _updateSelectedWeek(checkResult);
    }
  }

  void _onWeekChanged(newWeekValue) {
    setState(() {
      _selectedWeek = newWeekValue;
    });
  }

  Widget _pickerActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FlatButton(
          highlightColor: Colors.transparent,
          splashColor: R.colors.lightBlurMajorOrange,
          child: Text(
            R.strings.cancel,
            style: TextStyle(
              color: R.colors.majorOrange,
              fontSize: R.appRatio.appFontSize18,
            ),
          ),
          onPressed: _handleCancel,
        ),
        FlatButton(
          highlightColor: Colors.transparent,
          splashColor: R.colors.lightBlurMajorOrange,
          child: Text(
            R.strings.ok,
            style: TextStyle(
              color: R.colors.majorOrange,
              fontSize: R.appRatio.appFontSize18,
            ),
          ),
          onPressed: _handleOk,
        ),
      ],
    );
  }

  Widget _renderMonthPicker() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            color: R.colors.majorOrange,
            height: R.appRatio.appHeight80,
            padding: EdgeInsets.only(
              left: R.appRatio.appSpacing15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: (_yearPickerState ? null : _updateYearPickerState),
                  child: Text(
                    _selectedWeek.getFromDateValue().year.toString(),
                    style: TextStyle(
                      color: (_yearPickerState
                          ? Colors.white
                          : Color.fromRGBO(255, 255, 255, 0.8)),
                      fontSize: R.appRatio.appFontSize16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing5,
                ),
                GestureDetector(
                  onTap: (_yearPickerState ? _updateYearPickerState : null),
                  child: Text(
                    R.strings.weekPicker,
                    style: TextStyle(
                      color: (_yearPickerState
                          ? Color.fromRGBO(255, 255, 255, 0.8)
                          : Colors.white),
                      fontSize: R.appRatio.appFontSize18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          (_yearPickerState
              ? Container()
              : MyHorizontalMonthList(
                  lastDate: widget.lastDate,
                  firstDate: widget.firstDate,
                  selectedDate: _selectedWeek.getFromDateValue(),
                  onChanged: _onMonthChanged,
                )),
          Container(
            height: _heightPickerBox,
            child: (_yearPickerState
                ? MyYearList(
                    selectedDate: _selectedWeek.getFromDateValue(),
                    onChanged: _onYearChanged,
                    firstDate: widget.firstDate,
                    lastDate: widget.lastDate)
                : MyWeekList(
                    selectedWeek: _selectedWeek,
                    weekList: WeekDateTime.getWeekListOfMonth(
                        _selectedWeek.getFromDateValue()),
                    onChanged: _onWeekChanged,
                    firstDate: widget.firstDate,
                    lastDate: widget.lastDate,
                  )),
          ),
          _pickerActions(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _renderMonthPicker();
  }
}

Future<WeekDateTime> showMyWeekPicker({
  BuildContext context,
  DateTime initialDate,
  DateTime firstDate,
  DateTime lastDate,
}) async {
  return await showDialog<WeekDateTime>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: _MyWeekPicker(
            firstDate: firstDate,
            initialDate: initialDate,
            lastDate: lastDate,
          ),
        );
      });
}
