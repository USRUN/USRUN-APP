import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/model/splits.dart';
import 'package:usrun/util/date_time_utils.dart';
import 'package:usrun/util/validator.dart';

class SplitsChart extends StatelessWidget {
  final EdgeInsets chartPadding;
  final Function onTouch;
  final List<SplitModel> splitModelArray;
  final String labelTitle;
  final EdgeInsets labelPadding;
  final bool enableLabelShadow;
  final Color headingColor;
  final Color dividerColor;
  final Color textColor;
  final Color paceBoxColor;

  static double _spacing = 10.0;
  static double _distanceBoxWidth = 40;
  static double _paceBoxWidth = 50;
  static double _chartBoxWidth = 0;
  static double _height = 20;

  const SplitsChart({
    this.chartPadding = const EdgeInsets.all(0.0),
    this.onTouch,
    @required this.splitModelArray,
    this.labelTitle = "",
    this.labelPadding = const EdgeInsets.all(0.0),
    this.enableLabelShadow = true,
    this.headingColor = Colors.black,
    this.dividerColor = Colors.black,
    this.textColor = Colors.black,
    this.paceBoxColor = Colors.redAccent,
  }) : assert(chartPadding != null &&
            labelTitle != null &&
            enableLabelShadow != null);

  Widget _renderHeading() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Distance in KM
        Container(
          width: _distanceBoxWidth,
          height: _height,
          alignment: Alignment.centerLeft,
          child: Text(
            R.strings.km.toUpperCase(),
            textScaleFactor: 1.0,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: headingColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: _spacing),
        // Pace
        Container(
          width: _paceBoxWidth,
          height: _height,
          alignment: Alignment.centerLeft,
          child: Text(
            R.strings.pace.toUpperCase(),
            textScaleFactor: 1.0,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: headingColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: _spacing),
        // Chart
        Container(
          width: _chartBoxWidth,
          height: _height,
          alignment: Alignment.centerLeft,
          child: Text(
            R.strings.paceChart.toUpperCase(),
            textScaleFactor: 1.0,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: headingColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderData() {
    Widget renderDataRow(SplitModel split) {
      String distanceKm = split.km.toString().toUpperCase();
      List<String> splitDot = distanceKm.split(".");

      if (splitDot[1].length > 1) {
        splitDot[1] = splitDot[1][0];
      }

      if (splitDot[1][0].compareTo("0") == 0) {
        distanceKm = splitDot[0];
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Distance
          Container(
            width: _distanceBoxWidth,
            height: _height,
            alignment: Alignment.centerLeft,
            child: Text(
              distanceKm,
              textScaleFactor: 1.0,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          SizedBox(width: _spacing),
          // Pace
          Container(
            width: _paceBoxWidth,
            height: _height,
            alignment: Alignment.centerLeft,
            child: Text(
              secondToMinFormat(split.pace),
              textScaleFactor: 1.0,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          SizedBox(width: _spacing),
          // Chart box
          Container(
            width: split.boxWidth,
            height: _height,
            decoration: BoxDecoration(
              color: paceBoxColor,
              borderRadius: BorderRadius.all(
                Radius.circular(2.5),
              ),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: splitModelArray.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: (index != splitModelArray.length - 1 ? 8 : 0),
          ),
          child: renderDataRow(splitModelArray[index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (splitModelArray.length == 0) return Container();

    double appWidth = MediaQuery.of(context).size.width;
    double chartWidth = appWidth - chartPadding.left - chartPadding.right;
    _chartBoxWidth =
        chartWidth - _distanceBoxWidth - _spacing - _paceBoxWidth - _spacing;

    SplitModel smallestSplit = splitModelArray
        .reduce((current, next) => current.pace < next.pace ? current : next);
    int smallestPace = smallestSplit.pace;

    for (int i = 0; i < splitModelArray.length; ++i) {
      SplitModel element = splitModelArray[i];
      element = element.computeWidthChart(
        smallestPace: smallestPace,
        availableChartWidth: _chartBoxWidth,
      );
      splitModelArray[i] = element;
    }

    return Container(
      width: appWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Title
          (!checkStringNullOrEmpty(this.labelTitle)
              ? Container(
                  margin: labelPadding,
                  child: Text(
                    this.labelTitle,
                    textScaleFactor: 1.0,
                    style: (this.enableLabelShadow
                        ? R.styles.shadowLabelStyle
                        : R.styles.labelStyle),
                  ),
                )
              : Container()),
          // Chart
          Container(
            margin: chartPadding,
            width: chartWidth,
            child: Column(
              children: <Widget>[
                // Heading
                _renderHeading(),
                // Divider
                Divider(
                  thickness: 1,
                  color: dividerColor,
                ),
                SizedBox(height: 4),
                // Data
                _renderData(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
