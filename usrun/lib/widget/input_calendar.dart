import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:date_format/date_format.dart';
import 'package:usrun/widget/my_date_picker/my_date_picker.dart';

class InputCalendar extends StatefulWidget {
  final String labelTitle;
  final bool enableLabelShadow;
  final bool enableFullWidth;
  final Function getDOBFunc;
  final String defaultDay;

  InputCalendar({
    Key key,
    this.labelTitle = "",
    this.defaultDay = 'dd/MM/yyyy',
    this.enableLabelShadow = false,
    this.enableFullWidth = true,
    this.getDOBFunc,
  }) : super(key: key);

  @override
  _InputCalendarState createState() => new _InputCalendarState();
}

class _InputCalendarState extends State<InputCalendar> {
  String _birthday;
  DateTime _dateTime;

  @override
  void initState() {
    _birthday = widget.defaultDay;
    _dateTime = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: (widget.labelTitle.length == 0
                  ? null
                  : Text(
                      widget.labelTitle,
                      style: (widget.enableLabelShadow
                          ? R.styles.shadowLabelStyle
                          : R.styles.labelStyle),
                    )),
            ),
            GestureDetector(
                child: Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
                  width: (widget.enableFullWidth
                      ? R.appRatio.appWidth381
                      : R.appRatio.appWidth181),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: R.colors.majorOrange,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Text(
                    _birthday,
                    style: TextStyle(
                      fontSize: R.appRatio.appFontSize18,
                      color: R.colors.contentText,
                    ),
                  ),
                ),
                onTap: () async {
                  final DateTime today = new DateTime.now();
                  final datePick = await showMyDatePicker(
                      context: context,
                      initialDate: today,
                      firstDate: new DateTime(1900),
                      lastDate: today);

                  if (datePick != null && datePick != _dateTime) {
                    String temp =
                        formatDate(datePick, [dd, '/', mm, '/', yyyy]);

                    if (widget.getDOBFunc != null) {
                      widget.getDOBFunc(datePick);
                    }

                    setState(() {
                      _dateTime = datePick;
                      _birthday = temp;
                    });
                  }
                }),
          ]),
    );
  }
}
