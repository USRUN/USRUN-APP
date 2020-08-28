import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

class MyYearList extends StatefulWidget {
  final DateTime selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function onChanged;

  MyYearList({
    @required this.selectedDate,
    @required this.onChanged(datetime),
    @required this.firstDate,
    @required this.lastDate,
  })  : assert(selectedDate != null && onChanged != null && firstDate != null && lastDate != null),
        assert(!firstDate.isAfter(lastDate));

  @override
  _MyYearListState createState() => _MyYearListState();
}

class _MyYearListState extends State<MyYearList> {
  List<int> _yearList;

  static ItemScrollController _scrollController = ItemScrollController();

  @override
  void initState() {
    _yearList = _initYearList(widget.firstDate.year, widget.lastDate.year);
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollToActiveItemInList());
  }

  List<int> _initYearList(int start, int end) {
    List<int> list = [];
    for (int i = start; i <= end; ++i) {
      list.add(i);
    }
    return list;
  }

  void _scrollToActiveItemInList() {
    _scrollController.jumpTo(
      index: widget.selectedDate.year - _yearList[0],
    );
  }

  Widget _renderYearList() {
    return ScrollablePositionedList.builder(
      itemCount: _yearList.length,
      itemScrollController: _scrollController,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            if (widget.onChanged != null) {
              widget.onChanged(DateTime(_yearList[index],
                  widget.selectedDate.month, widget.selectedDate.day));
            }
          },
          child: Container(
            height: R.appRatio.appHeight60,
            alignment: Alignment.center,
            child: Text(
              _yearList[index].toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: (widget.selectedDate.year == _yearList[index]
                    ? R.appRatio.appFontSize24
                    : R.appRatio.appFontSize16),
                color: (widget.selectedDate.year == _yearList[index]
                    ? R.colors.majorOrange
                    : R.colors.contentText),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _renderYearList();
  }
}
