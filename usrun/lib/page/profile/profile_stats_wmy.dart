import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/page/profile/week_date_time.dart';
import 'package:usrun/widget/my_info_box/simple_info_box.dart';
import 'package:usrun/widget/stats_section.dart';

/*
  ---------
  + WEEK
  ---------
*/
class ProfileStatsWeek extends StatefulWidget {
  final WeekDateTime weekDateTime;
  final List statsSectionItems;
  final List chartItems;

  ProfileStatsWeek({
    @required this.weekDateTime,
    @required this.statsSectionItems,
    @required this.chartItems,
  });

  @override
  _ProfileStatsWeekState createState() => _ProfileStatsWeekState();
}

class _ProfileStatsWeekState extends State<ProfileStatsWeek> {
  @override
  Widget build(BuildContext context) {
    // TODO: Code more here
    return _ProfileStatsBody(
      bodyType: 0,
      dateTime: widget.weekDateTime,
      statsSectionItems: widget.statsSectionItems,
      chartItems: widget.chartItems,
    );
  }
}

/*
  ---------
  + MONTH
  ---------
*/
class ProfileStatsMonth extends StatefulWidget {
  final DateTime dateTime;
  final List statsSectionItems;
  final List chartItems;

  ProfileStatsMonth({
    @required this.dateTime,
    @required this.statsSectionItems,
    @required this.chartItems,
  });

  @override
  _ProfileStatsMonthState createState() => _ProfileStatsMonthState();
}

class _ProfileStatsMonthState extends State<ProfileStatsMonth> {
  @override
  Widget build(BuildContext context) {
    // TODO: Code more here
    return _ProfileStatsBody(
      bodyType: 1,
      dateTime: widget.dateTime,
      statsSectionItems: widget.statsSectionItems,
      chartItems: widget.chartItems,
    );
  }
}

/*
  ---------
  + YEAR
  ---------
*/
class ProfileStatsYear extends StatefulWidget {
  final DateTime dateTime;
  final List statsSectionItems;
  final List chartItems;

  ProfileStatsYear({
    @required this.dateTime,
    @required this.statsSectionItems,
    @required this.chartItems,
  });

  @override
  _ProfileStatsYearState createState() => _ProfileStatsYearState();
}

class _ProfileStatsYearState extends State<ProfileStatsYear> {
  @override
  Widget build(BuildContext context) {
    // TODO: Code more here
    return _ProfileStatsBody(
      bodyType: 2,
      dateTime: widget.dateTime,
      statsSectionItems: widget.statsSectionItems,
      chartItems: widget.chartItems,
    );
  }
}

/*
  -----------------------------------------------------------------------
  + BODY CONTENT (This is used for "Week", "Month" and "Year" classes)
  -----------------------------------------------------------------------
*/
class _ProfileStatsBody extends StatefulWidget {
  final List chartItems;
  final List statsSectionItems;
  final int bodyType;
  final dynamic dateTime;

  /*
    + "bodyType" equals:
      -> 0: Week
      -> 1: Month
      -> 2: Year
  */

  _ProfileStatsBody({
    @required this.chartItems,
    @required this.statsSectionItems,
    @required this.bodyType,
    @required this.dateTime,
  }) : assert(bodyType >= 0 && bodyType <= 2);

  @override
  _ProfileStatsBodyState createState() => _ProfileStatsBodyState();
}

class _ProfileStatsBodyState extends State<_ProfileStatsBody> {
  /*
    + Structure of the "chartItems" variable: 
    [
      {
        "id": "0",                  ["id" is used for pressing box]
        "dataTitle": "15818",
        "subTitle": "Total Calories",
        "unitTitle": "kcal",
      }
      ...
    ]
  */

  /*
    + Structure of the "statsSectionItems" variable: 
    [
      {
        "title": "Activities",
        "data": "104",
        "unit": "",
        "iconURL": R.myIcons.activitiesStatsIconByTheme,
        "enableBottomBorder": true,
        "isSuffixIcon": true,
        "enableMarginBottom": true,
      }
      ...
    ]
  */

  String _chartLabelTitle = "";
  String _chartSubTitle = "";
  String _statsSectionLabelTitle = "";

  void _updateSubTitle(String content) {
    setState(() {
      _chartSubTitle = content;
    });
  }

  void _pressBox(boxID) {
    // TODO: Implement function here
    print("[SimpleBoxWidget] This box with id $boxID is pressed");
  }

  bool _isEmptyList(List items) {
    return ((items == null || items.length == 0) ? true : false);
  }

  Widget _renderEmptyList() {
    String systemNoti = "Nothing to show";

    return Padding(
      padding: EdgeInsets.only(
        left: R.appRatio.appSpacing15,
      ),
      child: Text(
        systemNoti,
        style: TextStyle(
          fontSize: R.appRatio.appFontSize18,
          color: R.colors.normalNoteText,
        ),
      ),
    );
  }

  Widget _renderChartLabel() {
    switch (widget.bodyType) {
      case 0: // WEEK
        _chartLabelTitle = R.strings.selectedDay;
        _updateSubTitle(formatDate(
            widget.dateTime.getFromDateValue(), [dd, '/', mm, '/', yyyy]));
        _statsSectionLabelTitle = R.strings.currentWeek;
        break;
      case 1: // MONTH
        _chartLabelTitle = R.strings.selectedWeek;
        List<WeekDateTime> list =
            WeekDateTime.getWeekListOfMonth(widget.dateTime);
        _updateSubTitle(list[0].getWeekString());
        _statsSectionLabelTitle = R.strings.currentMonth;
        break;
      case 2: // YEAR
        _chartLabelTitle = R.strings.selectedMonth;
        _updateSubTitle(formatDate(widget.dateTime, [mm, '/', yyyy]));
        _statsSectionLabelTitle = R.strings.currentYear;
        break;
    }

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          (_chartLabelTitle.length != 0
              ? Container(
                  padding: EdgeInsets.only(
                    left: R.appRatio.appSpacing15,
                    bottom: (_chartSubTitle.length != 0
                        ? R.appRatio.appSpacing5
                        : R.appRatio.appSpacing15),
                  ),
                  child: Text(
                    _chartLabelTitle,
                    style: R.styles.shadowLabelStyle,
                  ),
                )
              : Container()),
          (_chartSubTitle.length != 0
              ? Container(
                  padding: EdgeInsets.only(
                    left: R.appRatio.appSpacing15,
                    bottom: R.appRatio.appSpacing15,
                  ),
                  child: Text(
                    _chartSubTitle,
                    style: R.styles.shadowSubTitleStyle,
                  ),
                )
              : Container()),
        ],
      ),
    );
  }

  Widget _renderChartHorizontalStats() {
    if (_isEmptyList(widget.chartItems)) {
      return _renderEmptyList();
    }

    return Container(
      color: R.colors.sectionBackgroundLayer,
      height: R.appRatio.appHeight130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: widget.chartItems.length,
        itemBuilder: (BuildContext ctxt, int index) {
          dynamic item = widget.chartItems[index];
          String id = (item.containsKey("id") ? item["id"] : index);
          String dataTitle =
              (item.containsKey("dataTitle") ? item["dataTitle"] : "N/A");
          String subTitle =
              (item.containsKey("subTitle") ? item["subTitle"] : "N/A");
          String unitTitle =
              (item.containsKey("unitTitle") ? item["unitTitle"] : "");

          return Container(
            padding: EdgeInsets.only(
              left: R.appRatio.appSpacing15,
              right: (index == widget.chartItems.length - 1
                  ? R.appRatio.appSpacing15
                  : 0),
            ),
            child: SimpleInfoBox(
              id: id,
              dataTitle: dataTitle,
              subTitle: subTitle,
              unitTitle: unitTitle,
              boxHeight: R.appRatio.appHeight90,
              boxWidth: R.appRatio.appWidth140,
              pressBox: _pressBox,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // [Chart] label
        _renderChartLabel(),
        // [Chart] Horizontal stats section
        _renderChartHorizontalStats(),
        SizedBox(
          height: R.appRatio.appSpacing25,
        ),
        // [Chart] Draw chart
        // TODO: Please don't forget drawing this chart :D
        Container(
          alignment: Alignment.center,
          child: Text(
            "--->  Here, there is a chart  <---",
            textAlign: TextAlign.center,
            style: TextStyle(
              backgroundColor: Colors.amber,
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: R.appRatio.appFontSize18,
            ),
          ),
        ),
        SizedBox(
          height: R.appRatio.appSpacing25,
        ),
        // [StatsSection] Draw stats section
        Container(
          padding: EdgeInsets.only(
            left: R.appRatio.appSpacing15,
          ),
          child: StatsSection(
            items: widget.statsSectionItems,
            labelTitle: _statsSectionLabelTitle,
            enableLabelShadow: true,
          ),
        ),
        SizedBox(
          height: R.appRatio.appSpacing25,
        ),
      ],
    );
  }
}
