import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';

class HeaderRankLead extends StatelessWidget {
  static String firstTitle = R.strings.numberOrder.toUpperCase();
  static String secondTitle = R.strings.name.toUpperCase();
  static String thirdTitle = R.strings.distanceKm.toUpperCase();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: R.appRatio.appHeight50,
      padding: EdgeInsets.only(
        left: R.appRatio.appSpacing10,
        right: R.appRatio.appSpacing10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: R.appRatio.appWidth60,
            child: Text(
              firstTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: R.colors.majorOrange,
                fontSize: R.appRatio.appFontSize14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              secondTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: R.colors.majorOrange,
                fontSize: R.appRatio.appFontSize14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: R.appRatio.appWidth80,
            child: Text(
              thirdTitle,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: R.colors.majorOrange,
                fontSize: R.appRatio.appFontSize14,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
