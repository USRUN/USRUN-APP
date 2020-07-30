import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/widget/my_date_picker/my_year_list.dart';

class _MyYearPicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  _MyYearPicker({
    @required this.initialDate,
    @required this.firstDate,
    @required this.lastDate,
  })  : assert(initialDate != null && firstDate != null && lastDate != null),
        assert(!firstDate.isAfter(lastDate));

  @override
  _MyYearPickerState createState() => _MyYearPickerState();
}

class _MyYearPickerState extends State<_MyYearPicker> {
  DateTime _selectedDate;

  static double _heightPickerBox =
      (R.appRatio.deviceHeight - (R.appRatio.deviceHeight / 3.0))
          .roundToDouble();

  @override
  void initState() {
    _selectedDate = widget.initialDate;
    super.initState();
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  void _handleOk() {
    Navigator.pop(context, _selectedDate);
  }

  void _onChanged(value) {
    if (!mounted) return;
    setState(() {
      _selectedDate = value;
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

  Widget _renderYearPicker() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            color: R.colors.majorOrange,
            height: R.appRatio.appHeight60,
            alignment: Alignment.center,
            child: Text(
              R.strings.yearPicker,
              style: TextStyle(
                color: Colors.white,
                fontSize: R.appRatio.appFontSize18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: _heightPickerBox,
            child: MyYearList(
              selectedDate: _selectedDate,
              onChanged: _onChanged,
              firstDate: widget.firstDate,
              lastDate: widget.lastDate,
            ),
          ),
          _pickerActions(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _renderYearPicker();
  }
}

Future<DateTime> showMyYearPicker({
  @required BuildContext context,
  @required DateTime initialDate,
  @required DateTime firstDate,
  @required DateTime lastDate,
}) async {
  return await showDialog<DateTime>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: _MyYearPicker(
            firstDate: firstDate,
            initialDate: initialDate,
            lastDate: lastDate,
          ),
        );
      });
}
