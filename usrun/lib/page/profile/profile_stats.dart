import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/format_profile_stats.dart';
import 'package:usrun/page/profile/profile_stats_day.dart';
import 'package:usrun/page/profile/profile_stats_wmy.dart';
import 'package:usrun/page/profile/week_date_time.dart';
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
      "tabName": R.strings.day,
    },
    {
      "tabName": R.strings.week,
    },
    {
      "tabName": R.strings.month,
    },
    {
      "tabName": R.strings.year,
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

  List _profileStatsDayList;

  List _statsSectionItems;
  List _chartItems;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _selectedTabIndex = 0;
    _selectedDay = DateTime.now();
    _initSelectedWeek();
    _selectedMonth = _selectedDay;
    _selectedYear = _selectedDay;
    _stringSelectedDate = formatDate(_selectedDay, [dd, '/', mm, '/', yyyy]);

    _profileStatsDayList = List();

    _statsSectionItems = List();
    _chartItems = List();

    WidgetsBinding.instance.addPostFrameCallback((_) => _getProfileStatsData());
  }

  void _getProfileStatsData() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    // Day
    if (_selectedTabIndex == 0) {
      DateTime fromTime = DateTime(
          _selectedDay.year, _selectedDay.month, _selectedDay.day, 0, 0, 0);
      DateTime toTime = DateTime(
          _selectedDay.year, _selectedDay.month, _selectedDay.day, 23, 59, 59);

      await UserManager.getUserActivityByTimeWithSum(fromTime, toTime)
          .then((value) {
        if (!mounted) return;
        var newValue = FormatProfileStats.formatDayObject(value);
        setState(() {
          _profileStatsDayList = newValue;
          _isLoading = !_isLoading;
        });
      });
    }
    // Week - Month - Year
    else {
      DateTime chartFromTime,
          chartToTime,
          statsSectionFromTime,
          statsSectionToTime;

      switch (_selectedTabIndex) {
        case 1: // Week
          DateTime weekFromDate = _selectedWeek.getFromDateValue();
          DateTime weekToDate = _selectedWeek.getToDateValue();

          chartFromTime = DateTime(
              weekFromDate.year, weekFromDate.month, weekFromDate.day, 0, 0, 0);
          chartToTime = DateTime(weekFromDate.year, weekFromDate.month,
              weekFromDate.day, 23, 59, 59);

          statsSectionFromTime = DateTime(
              weekFromDate.year, weekFromDate.month, weekFromDate.day, 0, 0, 0);
          statsSectionToTime = DateTime(
              weekToDate.year, weekToDate.month, weekToDate.day, 23, 59, 59);
          break;
        case 2: // Month
          WeekDateTime weekOfMonth =
              WeekDateTime.getCurrentWeek(_selectedMonth);
          DateTime weekFromDate = weekOfMonth.getFromDateValue();
          DateTime weekToDate = weekOfMonth.getToDateValue();

          chartFromTime = DateTime(
              weekFromDate.year, weekFromDate.month, weekFromDate.day, 0, 0, 0);
          chartToTime = DateTime(
              weekToDate.year, weekToDate.month, weekToDate.day, 23, 59, 59);

          DateTime lastDayOfMonth =
              DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
          statsSectionFromTime =
              DateTime(_selectedMonth.year, _selectedMonth.month, 1, 0, 0, 0);
          statsSectionToTime = DateTime(_selectedMonth.year,
              _selectedMonth.month, lastDayOfMonth.day, 23, 59, 59);
          break;
        case 3: // Year
          DateTime lastDayOfMonth =
              DateTime(_selectedYear.year, _selectedYear.month + 1, 0);
          chartFromTime =
              DateTime(_selectedYear.year, _selectedYear.month, 1, 0, 0, 0);
          chartToTime = DateTime(_selectedYear.year, _selectedYear.month,
              lastDayOfMonth.day, 23, 59, 59);

          statsSectionFromTime = DateTime(_selectedYear.year, 1, 1, 0, 0, 0);
          statsSectionToTime = DateTime(_selectedYear.year, 12, 31, 23, 59, 59);
          break;
        default:
          return;
      }

      var futures = List<Future>();

      futures.add(
          UserManager.getUserActivityByTimeWithSum(chartFromTime, chartToTime));
      futures.add(UserManager.getUserActivityByTimeWithSum(
          statsSectionFromTime, statsSectionToTime));

      await Future.wait(futures).then((resultList) {
        if (!mounted) return;
        
        dynamic chartListResult = resultList[0];
        dynamic statsSectionListResult = resultList[1];

        var newChartList = FormatProfileStats.formatChartObject(chartListResult);
        var newStatsSectionList = FormatProfileStats.formatStatsSectionObject(statsSectionListResult);

        setState(() {
          _chartItems = newChartList;
          _statsSectionItems = newStatsSectionList;
          _isLoading = !_isLoading;
        });
      });
    }
  }

  void _initSelectedWeek() {
    DateTime current = DateTime.now();
    _selectedWeek = WeekDateTime.getCurrentWeek(current);
  }

  _onSelectItem(int tabIndex) {
    if (_selectedTabIndex == tabIndex) return;
    setState(() {
      _selectedTabIndex = tabIndex;
      _getProfileStatsData();
      
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
        widget = ProfileStatsDay(
          dateTime: _selectedDay,
          items: _profileStatsDayList,
        );
        break;
      case 1: // Week
        widget = ProfileStatsWeek(
          weekDateTime: _selectedWeek,
          chartItems: _chartItems,
          statsSectionItems: _statsSectionItems,
        );
        break;
      case 2: // Month
        widget = ProfileStatsMonth(
          dateTime: _selectedMonth,
          chartItems: _chartItems,
          statsSectionItems: _statsSectionItems,
        );
        break;
      case 3: // Year
        widget = ProfileStatsYear(
          dateTime: _selectedYear,
          chartItems: _chartItems,
          statsSectionItems: _statsSectionItems,
        );
        break;
      default:
        widget = ProfileStatsDay(
          dateTime: _selectedDay,
          items: _profileStatsDayList,
        );
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
            _getProfileStatsData();
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
              _selectedWeek = datePick as WeekDateTime;
              _stringSelectedDate = _selectedWeek.getWeekString();
            });
            _getProfileStatsData();
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
            _getProfileStatsData();
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
            _getProfileStatsData();
          }
        }
        break;
      default:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        (_isLoading
            ? LoadingDotStyle02()
            : _getContentItemWidget(_selectedTabIndex)),
      ],
    );
  }
}
