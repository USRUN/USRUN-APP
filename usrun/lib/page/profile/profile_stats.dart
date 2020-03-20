import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/model/week_date_time.dart'; 
import 'package:usrun/page/profile/profile_stats_day.dart';
import 'package:usrun/page/profile/profile_stats_wmy.dart';
import 'package:usrun/widget/custom_tab_bar.dart';
import 'package:usrun/widget/loading_dot.dart';
import 'package:usrun/widget/my_date_picker/my_date_picker.dart';
import 'package:usrun/widget/my_date_picker/my_month_picker.dart';
import 'package:usrun/widget/my_date_picker/my_week_picker.dart';
import 'package:usrun/widget/my_date_picker/my_year_picker.dart';
import 'package:usrun/widget/ui_button.dart';

class ProfileStats extends StatefulWidget {
  final tabBarItems = [
    {
      "tabName": "DAY",
    },
    {
      "tabName": "WEEK",
    },
    {
      "tabName": "MONTH",
    },
    {
      "tabName": "YEAR",
    }
  ];

  @override
  _ProfileStatsState createState() => _ProfileStatsState();
}

class _ProfileStatsState extends State<ProfileStats> {
  bool _isLoading;
  int _selectedTabIndex;
  DateTime _selectedDay;
  WeekDateTime _selectedWeek;
  DateTime _selectedMonth;
  DateTime _selectedYear;
  String _stringSelectedDate;

  @override
  void initState() {
    _isLoading = true;
    _selectedTabIndex = 0;
    _selectedDay = DateTime.now();
    _initSelectedWeek();
    _selectedMonth = _selectedDay;
    _selectedYear = _selectedDay;
    _stringSelectedDate = formatDate(_selectedDay, [dd, '/', mm, '/', yyyy]);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateLoading());
  }

  void _updateLoading() {
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        _isLoading = !_isLoading;
      });
    });
  }

  void _initSelectedWeek() {
    DateTime current = DateTime.now();
    _selectedWeek = WeekDateTime.getCurrentWeek(current);
  }

  _onSelectItem(int tabIndex) {
    if (_selectedTabIndex == tabIndex) return;
    setState(() {
      _selectedTabIndex = tabIndex;

      switch (tabIndex) {
        case 0: // Day
          _stringSelectedDate =
              formatDate(_selectedDay, [dd, '/', mm, '/', yyyy]);
          break;
        case 1: // Week
          _stringSelectedDate = _selectedWeek.getWeekString();
          break;
        case 2: // Month
          _stringSelectedDate = formatDate(_selectedMonth, [mm, '/', yyyy]);
          break;
        case 3: // Year
          _stringSelectedDate = formatDate(_selectedYear, [yyyy]);
          break;
        default:
          break;
      }
    });
  }

  dynamic _getContentItemWidget(int tabIndex) {
    Widget widget;

    switch (tabIndex) {
      case 0: // Day
        widget = ProfileStatsDay(day: _selectedDay);
        break;
      case 1: // Week
        widget = ProfileStatsWeek(weekDateTime: _selectedWeek);
        break;
      case 2: // Month
        widget = ProfileStatsMonth(dateTime: _selectedMonth);
        break;
      case 3: // Year
        widget = ProfileStatsYear(dateTime: _selectedYear);
        break;
      default:
        widget = ProfileStatsDay(day: _selectedDay);
        break;
    }

    return widget;
  }

  void _pressDateButton() async {
    switch (_selectedTabIndex) {
      case 0: // Day
        {
          final datePick = await showMyDatePicker(
            context: context,
            initialDate: _selectedDay,
            firstDate: R.constants.releasedAppDate,
            lastDate: DateTime.now(),
          );

          if (datePick != null && datePick != _selectedDay) {
            setState(() {
              _selectedDay = datePick;
              _stringSelectedDate =
                  formatDate(datePick, [dd, '/', mm, '/', yyyy]);
            });
          }
        }
        break;
      case 1: // Week
        {
          final datePick = await showMyWeekPicker(
            context: context,
            initialDate: _selectedWeek.getFromDateValue(),
            firstDate: R.constants.releasedAppDate,
            lastDate: DateTime.now(),
          );

          if (datePick != null && datePick != _selectedWeek) {
            setState(() {
              _selectedWeek = datePick;
              _stringSelectedDate = _selectedWeek.getWeekString();
            });
          }
        }
        break;
      case 2: // Month
        {
          final datePick = await showMyMonthPicker(
            context: context,
            initialDate: _selectedMonth,
            firstDate: R.constants.releasedAppDate,
            lastDate: DateTime.now(),
          );

          if (datePick != null && datePick != _selectedMonth) {
            setState(() {
              _selectedMonth = datePick;
              _stringSelectedDate = formatDate(datePick, [mm, '/', yyyy]);
            });
          }
        }
        break;
      case 3: // Year
        {
          final datePick = await showMyYearPicker(
            context: context,
            initialDate: _selectedYear,
            firstDate: R.constants.releasedAppDate,
            lastDate: DateTime.now(),
          );

          if (datePick != null && datePick != _selectedYear) {
            setState(() {
              _selectedYear = datePick;
              _stringSelectedDate = formatDate(datePick, [yyyy]);
            });
          }
        }
        break;
      default:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading
        ? LoadingDotStyle02()
        : Column(
            children: <Widget>[
              CustomTabBarStyle02(
                selectedTabIndex: _selectedTabIndex,
                items: widget.tabBarItems,
                pressTab: _onSelectItem,
              ),
              SizedBox(
                height: R.appRatio.appSpacing25,
              ),
              UIButton(
                color: R.colors.redPink,
                text: _stringSelectedDate,
                textSize: R.appRatio.appFontSize16,
                textColor: Colors.white,
                fontWeight: FontWeight.bold,
                enableShadow: true,
                width: R.appRatio.appWidth200,
                height: R.appRatio.appHeight30,
                radius: 0,
                boxShadow: BoxShadow(
                  blurRadius: 2.0,
                  offset: Offset(1.0, 1.0),
                  color: R.colors.btnShadow,
                ),
                onTap: _pressDateButton,
              ),
              SizedBox(
                height: R.appRatio.appSpacing25,
              ),
              _getContentItemWidget(_selectedTabIndex),
            ],
          ));
  }
}
