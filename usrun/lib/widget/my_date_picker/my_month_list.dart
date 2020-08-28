import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

class MyMonthList extends StatefulWidget {
  final DateTime selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function onChanged;

  MyMonthList({
    @required this.selectedDate,
    @required this.onChanged(datetime),
    @required this.firstDate,
    @required this.lastDate,
  })  : assert(selectedDate != null &&
            onChanged != null &&
            firstDate != null &&
            lastDate != null),
        assert(!firstDate.isAfter(lastDate));

  @override
  _MyMonthListState createState() => _MyMonthListState();
}

class _MyMonthListState extends State<MyMonthList> {
  List<int> _monthList;

  static ItemScrollController _monthScrollController = ItemScrollController();
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

  @override
  void initState() {
    _monthList = _initMonthList();
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollToActiveItemInList());
  }

  List<int> _initMonthList() {
    List<int> list = [];
    for (int i = 1; i <= 12; ++i) {
      list.add(i);
    }
    return list;
  }

  void _scrollToActiveItemInList() {
    _monthScrollController.jumpTo(
      index: widget.selectedDate.month - _monthList[0],
    );
  }

  bool _checkDateTimeBound(DateTime dt) {
    if (dt.isAfter(widget.lastDate)) {
      return false;
    }

    if (dt.isBefore(widget.firstDate)) {
      return false;
    }

    return true;
  }

  Widget _renderMonthList() {
    return ScrollablePositionedList.builder(
      itemCount: _monthList.length,
      itemScrollController: _monthScrollController,
      itemBuilder: (BuildContext ctxt, int index) {
        return GestureDetector(
          onTap: () {
            if (!_checkDateTimeBound(DateTime(widget.selectedDate.year,
                _monthList[index], widget.selectedDate.day))) return;

            if (widget.onChanged != null) {
              widget.onChanged(DateTime(widget.selectedDate.year,
                  _monthList[index], widget.selectedDate.day));
            }
          },
          child: Container(
            height: R.appRatio.appHeight60,
            alignment: Alignment.center,
            child: Text(
              _monthName[index],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: (widget.selectedDate.month == _monthList[index]
                    ? R.appRatio.appFontSize24
                    : R.appRatio.appFontSize16),
                color: (_checkDateTimeBound(DateTime(widget.selectedDate.year,
                        _monthList[index], widget.selectedDate.day))
                    ? (widget.selectedDate.month == _monthList[index]
                        ? R.colors.majorOrange
                        : R.colors.contentText)
                    : R.colors.gray808080),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _renderMonthList();
  }
}
