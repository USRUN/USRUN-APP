import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';
import 'package:usrun/widget/line_button.dart';
import 'package:usrun/util/image_cache_manager.dart';

class PrivacyProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());

    Widget _buildElement = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: R.colors.appBackground,
      appBar: CustomGradientAppBar(title: R.strings.privacyProfile),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: R.appRatio.appSpacing20,
              ),
              /* 
                  HOW PEOPLE CAN FIND YOU
              */
              Padding(
                padding: EdgeInsets.only(
                  left: R.appRatio.appSpacing15,
                ),
                child: Text(
                  R.strings.privacyFindLabel,
                  textAlign: TextAlign.start,
                  style: R.styles.shadowLabelStyle,
                ),
              ),
              LineButton(
                mainText: R.strings.privacyFindEmailTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                resultText: R.strings.statusEveryone,
                resultTextFontSize: R.appRatio.appFontSize16,
                enableBottomUnderline: true,
                textPadding: EdgeInsets.all(15),
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
              LineButton(
                mainText: R.strings.privacyFindUserCodeTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                resultText: R.strings.statusEveryone,
                resultTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
              LineButton(
                mainText: R.strings.privacyFindNameTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                resultText: R.strings.statusEveryone,
                resultTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
              SizedBox(
                height: R.appRatio.appSpacing25,
              ),
              /*
                  PEOPLE FOLLOW YOU
              */
              Padding(
                padding: EdgeInsets.only(
                  left: R.appRatio.appSpacing15,
                ),
                child: Text(
                  R.strings.privacyFollowLabel,
                  textAlign: TextAlign.start,
                  style: R.styles.shadowLabelStyle,
                ),
              ),
              LineButton(
                mainText: R.strings.privacyFollowFeatureTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                subText: R.strings.privacyFollowFeatureSubtitle,
                subTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                enableSwitchButton: true,
                switchButtonOnTitle: "On",
                switchButtonOffTitle: "Off",
                initSwitchStatus: true,
                switchFunction: (state) {
                  // TODO: Implementing here
                  print('Current State of SWITCH IS: $state');
                },
              ),
              SizedBox(
                height: R.appRatio.appSpacing25,
              ),
              /*
                  ACTIVITIES
              */
              Padding(
                padding: EdgeInsets.only(
                  left: R.appRatio.appSpacing15,
                ),
                child: Text(
                  R.strings.privacyActLabel,
                  textAlign: TextAlign.start,
                  style: R.styles.shadowLabelStyle,
                ),
              ),
              LineButton(
                mainText: R.strings.privacyActLimitPeopleTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                subText: R.strings.privacyActLimitPeopleSubtitle,
                subTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
              SizedBox(
                height: R.appRatio.appSpacing25,
              ),
              /*
                  OTHER PERSONAL INFORMATION
              */
              Padding(
                padding: EdgeInsets.only(
                  left: R.appRatio.appSpacing15,
                ),
                child: Text(
                  R.strings.privacyOPILabel,
                  textAlign: TextAlign.start,
                  style: R.styles.shadowLabelStyle,
                ),
              ),
              LineButton(
                mainText: R.strings.privacyOPISeeUserCodeTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                resultText: R.strings.statusEveryone,
                resultTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
              LineButton(
                mainText: R.strings.privacyOPISeeDetailedInfoTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                subText: R.strings.privacyOPISeeDetailedInfoSubtitle,
                subTextFontSize: R.appRatio.appFontSize16,
                resultText: R.strings.statusEveryone,
                resultTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
              LineButton(
                mainText: R.strings.privacyOPISeeFollowersTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                resultText: R.strings.statusEveryone,
                resultTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
              LineButton(
                mainText: R.strings.privacyOPISeeFollowingTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                resultText: R.strings.statusEveryone,
                resultTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
              LineButton(
                mainText: R.strings.privacyOPISeePhotosTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                resultText: R.strings.statusEveryone,
                resultTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
              LineButton(
                mainText: R.strings.privacyOPISeeEventBadgesTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                resultText: R.strings.statusEveryone,
                resultTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
              LineButton(
                mainText: R.strings.privacyOPISeeEventsTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                resultText: R.strings.statusEveryone,
                resultTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
              LineButton(
                mainText: R.strings.privacyOPISeeStatsTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                resultText: R.strings.statusEveryone,
                resultTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
              LineButton(
                mainText: R.strings.privacyOPISeeTeamsTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                resultText: R.strings.statusEveryone,
                resultTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
              LineButton(
                mainText: R.strings.privacyOPISeeTeamPlansTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                resultText: R.strings.statusEveryone,
                resultTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: false,
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
            ],
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
