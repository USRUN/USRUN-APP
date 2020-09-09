import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/widget/my_date_picker/flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

class _MyDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  _MyDatePicker({
    @required this.initialDate,
    @required this.firstDate,
    @required this.lastDate,
  })  : assert(initialDate != null && firstDate != null && lastDate != null),
        assert(!firstDate.isAfter(lastDate));

  @override
  _MyDatePickerState createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<_MyDatePicker> {
  final double _radius = 5.0;
  final double _spacing = 15.0;

  DateTime _selectedDate;

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

  void _onChanged(value, intResultList) {
    /*
      + intResultList = [int yearIndexResult, int monthIndexResult, int dayIndexResult]
      + But it isn't necessary to use.
    */
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
            R.strings.cancel.toUpperCase(),
            style: TextStyle(
              color: R.colors.majorOrange,
              fontSize: R.appRatio.appFontSize16,
            ),
          ),
          onPressed: _handleCancel,
        ),
        FlatButton(
          highlightColor: Colors.transparent,
          splashColor: R.colors.lightBlurMajorOrange,
          child: Text(
            R.strings.ok.toUpperCase(),
            style: TextStyle(
              color: R.colors.majorOrange,
              fontSize: R.appRatio.appFontSize16,
            ),
          ),
          onPressed: _handleOk,
        ),
      ],
    );
  }

  Widget _renderDatePicker() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_radius),
              topRight: Radius.circular(_radius),
            ),
            color: R.colors.majorOrange,
          ),
          height: R.appRatio.appHeight60,
          alignment: Alignment.center,
          child: Text(
            R.strings.datePicker,
            style: TextStyle(
              color: Colors.white,
              fontSize: R.appRatio.appFontSize18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          alignment: Alignment.topCenter,
          child: DatePickerWidget(
            null,
            minDateTime: widget.firstDate,
            maxDateTime: widget.lastDate,
            dateFormat: 'yyyy-MMMM-dd',
            initialDateTime: widget.initialDate,
            pickerTheme: DateTimePickerTheme(
              showTitle: false,
              itemTextStyle: null,
              pickerHeight: R.appRatio.appHeight250,
              backgroundColor: R.colors.dialogBackground,
            ),
            onChange: _onChanged,
          ),
        ),
        Divider(
          color: R.colors.majorOrange,
          thickness: 1.0,
          height: 1,
        ),
        _pickerActions(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildElement = Container(
      constraints: BoxConstraints(
        maxWidth: R.appRatio.appWidth320,
      ),
      margin: EdgeInsets.only(
        left: _spacing,
        right: _spacing,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(_radius)),
        color: R.colors.dialogBackground,
      ),
      child: _renderDatePicker(),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
      child: _buildElement,
      onNotification: (overScroll) {
        overScroll.disallowGlow();
        return false;
      },
    );
  }
}

Future<DateTime> showMyDatePicker({
  @required BuildContext context,
  @required DateTime initialDate,
  @required DateTime firstDate,
  @required DateTime lastDate,
}) async {
  return await showGeneralDialog(
    context: context,
    barrierLabel: "Label",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 300),
    transitionBuilder: (context, anim1, anim2, child) {
      return ScaleTransition(
        scale: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: anim1,
            curve: Curves.fastOutSlowIn,
          ),
        ),
        child: child,
      );
    },
    pageBuilder: (context, anim1, anim2) {
      return Material(
        type: MaterialType.transparency,
        child: Align(
          alignment: Alignment.center,
          child: _MyDatePicker(
            firstDate: firstDate,
            initialDate: initialDate,
            lastDate: lastDate,
          ),
        ),
      );
    },
  );
}
