import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';

class AboutUSRUN extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildElement = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: R.colors.appBackground,
      appBar: CustomGradientAppBar(title: R.strings.usrun),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: R.appRatio.appSpacing25,
            right: R.appRatio.appSpacing25,
          ),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                Text(
                  R.strings.aboutUSRUN_1,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: R.colors.contentText,
                    fontSize: R.appRatio.appFontSize18,
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing20,
                ),
                Text(
                  R.strings.aboutUSRUN_2,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: R.colors.contentText,
                    fontSize: R.appRatio.appFontSize18,
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing20,
                ),
                Text(
                  R.strings.aboutUSRUN_3,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: R.colors.contentText,
                    fontSize: R.appRatio.appFontSize18,
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing20,
                ),
                Text(
                  R.strings.aboutUSRUN_4,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: R.colors.contentText,
                    fontSize: R.appRatio.appFontSize18,
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing20,
                ),
                Text(
                  R.strings.aboutUSRUN_5,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: R.colors.contentText,
                    fontSize: R.appRatio.appFontSize18,
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing20,
                ),
                Text(
                  R.strings.aboutUSRUN_6,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: R.colors.contentText,
                    fontSize: R.appRatio.appFontSize18,
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing20,
                ),
                Text(
                  R.strings.aboutUSRUN_7,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: R.colors.contentText,
                    fontSize: R.appRatio.appFontSize18,
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
        child: _buildElement,
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return false;
        });
  }
}
