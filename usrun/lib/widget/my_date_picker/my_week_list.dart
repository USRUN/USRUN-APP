import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:usrun/page/profile/week_date_time.dart';

class MyWeekList extends StatefulWidget {
  final WeekDateTime selectedWeek;
  final List<WeekDateTime> weekList;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function onChanged;

  MyWeekList({
    @required this.selectedWeek,
    @required this.weekList,
    @required this.onChanged(datetime),
    @required this.firstDate,
    @required this.lastDate,
  })  : assert(selectedWeek != null &&
            weekList != null &&
            onChanged != null &&
            firstDate != null &&
            lastDate != null),
        assert(!firstDate.isAfter(lastDate));

  @override
  _MyWeekListState createState() => _MyWeekListState();
}

class _MyWeekListState extends State<MyWeekList> {
  int _posWeekInList;

  static ItemScrollController _weekScrollController = ItemScrollController();

  @override
  void initState() {
    _posWeekInList =
        WeekDateTime.getWeekOrder(widget.selectedWeek.getFromDateValue());
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollToActiveItemInList());
  }

  void _scrollToActiveItemInList() {
    _weekScrollController.jumpTo(
      index: _posWeekInList,
    );
  }

  void _updatePosWeekInList(index) {
    if (!mounted) return;
    setState(() {
      _posWeekInList = index;
    });
  }

  bool _isSuitableWeekRange(WeekDateTime week) {
    if ((week.getFromDateValue().isBefore(widget.firstDate) &&
            week.getToDateValue().isBefore(widget.firstDate)) ||
        (week.getFromDateValue().isAfter(widget.lastDate) &&
            week.getToDateValue().isAfter(widget.lastDate))) {
      return false;
    }

    return true;
  }

  Widget _renderMonthList() {
    return ScrollablePositionedList.builder(
      itemCount: widget.weekList.length,
      itemScrollController: _weekScrollController,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            if (!_isSuitableWeekRange(widget.weekList[index])) return;

            if (widget.onChanged != null) {
              widget.onChanged(widget.weekList[index]);
            }

            _updatePosWeekInList(index);
          },
          child: Container(
            height: R.appRatio.appHeight60,
            alignment: Alignment.center,
            child: Text(
              widget.weekList[index].getWeekString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: (_posWeekInList == index
                    ? R.appRatio.appFontSize24
                    : R.appRatio.appFontSize16),
                color: (_isSuitableWeekRange(widget.weekList[index])
                    ? (_posWeekInList == index
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
