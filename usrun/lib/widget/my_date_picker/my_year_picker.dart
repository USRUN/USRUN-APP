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
  final double _radius = 5.0;
  final double _spacing = 15.0;

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

  Widget _renderYearPicker() {
    return Container(
      child: Column(
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
          Divider(
            color: R.colors.majorOrange,
            thickness: 1.0,
            height: 1,
          ),
          _pickerActions(),
        ],
      ),
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
      child: _renderYearPicker(),
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

Future<DateTime> showMyYearPicker({
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
          child: _MyYearPicker(
            firstDate: firstDate,
            initialDate: initialDate,
            lastDate: lastDate,
          ),
        ),
      );
    },
  );
}
